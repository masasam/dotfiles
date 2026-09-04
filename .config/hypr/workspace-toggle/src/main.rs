use serde::{Deserialize, Serialize, de::DeserializeOwned};
use std::env;
use std::fs::{self, OpenOptions};
use std::io::Write;
use std::os::unix::fs::{MetadataExt, OpenOptionsExt, PermissionsExt};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

const APP_NAME: &str = "hypr-ctl-alt-workspace";

type Result<T> = std::result::Result<T, String>;

#[derive(Debug, Deserialize)]
struct ActiveWorkspace {
    id: i64,
    name: String,
    windows: i64,
}

#[derive(Debug, Deserialize)]
struct Workspace {
    name: String,
}

#[derive(Debug, Deserialize)]
struct Client {
    address: String,
    pid: Option<i64>,
    workspace: Workspace,
    #[serde(default = "default_true")]
    mapped: bool,
}

#[derive(Debug, Deserialize, Serialize, PartialEq)]
struct State {
    address: String,
    pid: Option<i64>,
    workspace: String,
}

#[derive(Clone, Copy)]
enum Direction {
    Left,
    Right,
}

enum WorkspaceTarget<'a> {
    Id(i64),
    Named(&'a str),
}

fn default_true() -> bool {
    true
}

fn main() {
    let number = match parse_workspace() {
        Ok(number) => number,
        Err(message) => {
            eprintln!("{APP_NAME}: {message}");
            std::process::exit(2);
        }
    };
    if let Err(message) = toggle_workspace_window(number) {
        notify_error(&message);
        std::process::exit(1);
    }
}

fn parse_workspace() -> Result<u8> {
    let mut arguments = env::args_os();
    let program = arguments
        .next()
        .and_then(|value| PathBuf::from(value).file_name().map(|name| name.to_owned()))
        .unwrap_or_else(|| APP_NAME.into());
    let value = arguments
        .next()
        .ok_or_else(|| format!("usage: {} WORKSPACE", program.to_string_lossy()))?;
    if arguments.next().is_some() {
        return Err(format!("usage: {} WORKSPACE", program.to_string_lossy()));
    }
    let number = value
        .to_str()
        .ok_or_else(|| "workspace must be a number from 0 through 9".to_owned())?
        .parse::<u8>()
        .map_err(|_| "workspace must be a number from 0 through 9".to_owned())?;
    if number > 9 {
        return Err("workspace must be a number from 0 through 9".to_owned());
    }
    Ok(number)
}

fn run_hyprctl(arguments: &[&str]) -> Result<String> {
    let output = Command::new("hyprctl")
        .args(arguments)
        .output()
        .map_err(|error| format!("cannot run hyprctl: {error}"))?;
    if !output.status.success() {
        let detail = if output.stderr.is_empty() {
            String::from_utf8_lossy(&output.stdout)
        } else {
            String::from_utf8_lossy(&output.stderr)
        };
        return Err(format!(
            "hyprctl {} failed: {}",
            arguments.join(" "),
            detail.trim()
        ));
    }
    String::from_utf8(output.stdout)
        .map_err(|_| format!("hyprctl {} returned non-UTF-8 output", arguments.join(" ")))
}

fn query_json<T: DeserializeOwned>(command: &str) -> Result<T> {
    let output = run_hyprctl(&["-j", command])?;
    serde_json::from_str(&output)
        .map_err(|error| format!("hyprctl returned invalid JSON for {command}: {error}"))
}

fn dispatch(expression: &str) -> Result<()> {
    run_hyprctl(&["dispatch", expression]).map(|_| ())
}

fn move_expression(target: WorkspaceTarget<'_>, address: &str, follow: bool) -> Result<String> {
    if !valid_address(address) {
        return Err(format!("invalid window address: {address:?}"));
    }
    let workspace = match target {
        WorkspaceTarget::Id(id) => id.to_string(),
        WorkspaceTarget::Named(name) if valid_workspace(name) => format!("{name:?}"),
        WorkspaceTarget::Named(name) => {
            return Err(format!("invalid workspace selector: {name:?}"));
        }
    };
    Ok(format!(
        "hl.dsp.window.move({{ workspace = {workspace}, follow = {follow}, window = \"address:{address}\" }})"
    ))
}

fn move_window(target: WorkspaceTarget<'_>, address: &str, follow: bool) -> Result<()> {
    dispatch(&move_expression(target, address, follow)?)
}

fn swap_expression(direction: Direction) -> &'static str {
    match direction {
        Direction::Left => "hl.dsp.window.swap({ direction = \"left\" })",
        Direction::Right => "hl.dsp.window.swap({ direction = \"right\" })",
    }
}

fn swap_window(direction: Direction) -> Result<()> {
    dispatch(swap_expression(direction))
}

fn valid_address(address: &str) -> bool {
    address.strip_prefix("0x").is_some_and(|digits| {
        !digits.is_empty() && digits.bytes().all(|byte| byte.is_ascii_hexdigit())
    })
}

fn valid_workspace(workspace: &str) -> bool {
    let numeric = workspace
        .as_bytes()
        .first()
        .is_some_and(|first| first.is_ascii_digit() && *first != b'0')
        && workspace.bytes().all(|byte| byte.is_ascii_digit());
    let special = workspace
        .strip_prefix("special:")
        .is_some_and(|name| !name.is_empty() && name.bytes().all(valid_workspace_character));
    numeric || special
}

fn valid_workspace_character(byte: u8) -> bool {
    byte.is_ascii_alphanumeric() || matches!(byte, b'_' | b'.' | b'-')
}

fn state_directory() -> Result<PathBuf> {
    let runtime_root = match env::var_os("XDG_RUNTIME_DIR") {
        Some(path) => PathBuf::from(path),
        None => {
            let uid = fs::metadata("/proc/self")
                .map_err(|error| format!("cannot determine current UID: {error}"))?
                .uid();
            PathBuf::from(format!("/tmp/hypr-runtime-{uid}"))
        }
    };
    let directory = runtime_root.join(APP_NAME);
    fs::create_dir_all(&directory)
        .map_err(|error| format!("cannot create {}: {error}", directory.display()))?;
    fs::set_permissions(&directory, fs::Permissions::from_mode(0o700))
        .map_err(|error| format!("cannot secure {}: {error}", directory.display()))?;
    Ok(directory)
}

fn read_state(path: &Path) -> Result<Option<State>> {
    if !path.exists() {
        return Ok(None);
    }
    let result = fs::read_to_string(path)
        .map_err(|error| error.to_string())
        .and_then(|contents| serde_json::from_str(&contents).map_err(|error| error.to_string()));
    match result {
        Ok(state) => Ok(Some(state)),
        Err(error) => {
            let _ = fs::remove_file(path);
            Err(format!(
                "discarded invalid state in {}: {error}",
                path.display()
            ))
        }
    }
}

fn write_state(path: &Path, state: &State) -> Result<()> {
    let temporary = path.with_extension(format!("{}.tmp", std::process::id()));
    let result = (|| {
        let mut file = OpenOptions::new()
            .write(true)
            .create_new(true)
            .mode(0o600)
            .open(&temporary)
            .map_err(|error| format!("cannot create {}: {error}", temporary.display()))?;
        serde_json::to_writer(&mut file, state)
            .map_err(|error| format!("cannot write {}: {error}", temporary.display()))?;
        file.write_all(b"\n")
            .map_err(|error| format!("cannot write {}: {error}", temporary.display()))?;
        file.sync_all()
            .map_err(|error| format!("cannot sync {}: {error}", temporary.display()))?;
        fs::rename(&temporary, path).map_err(|error| {
            format!(
                "cannot rename {} to {}: {error}",
                temporary.display(),
                path.display()
            )
        })
    })();
    if result.is_err() {
        let _ = fs::remove_file(&temporary);
    }
    result
}

fn matching_clients<'a>(clients: &'a [Client], workspace: &str) -> Vec<&'a Client> {
    clients
        .iter()
        .filter(|client| client.mapped && client.workspace.name == workspace)
        .collect()
}

fn restore_window(state_path: &Path, state: State, clients: &[Client]) -> Result<()> {
    if !clients.iter().any(|client| client.address == state.address) {
        let _ = fs::remove_file(state_path);
        return Err("the borrowed window no longer exists; stale state removed".to_owned());
    }
    move_window(
        WorkspaceTarget::Named(&state.workspace),
        &state.address,
        false,
    )?;
    fs::remove_file(state_path)
        .map_err(|error| format!("cannot remove {}: {error}", state_path.display()))
}

fn borrow_window(
    number: u8,
    state_path: &Path,
    active: &ActiveWorkspace,
    clients: &[Client],
) -> Result<()> {
    let source = if number == 0 {
        "special:magic".to_owned()
    } else {
        number.to_string()
    };
    if number != 0 && active.name == source {
        return Ok(());
    }
    if active.windows != 1 {
        return Err(format!(
            "workspace {} must contain exactly one window, found {}",
            active.name, active.windows
        ));
    }

    let candidates = matching_clients(clients, &source);
    if candidates.len() != 1 {
        return Err(format!(
            "workspace {source} must contain exactly one window, found {}",
            candidates.len()
        ));
    }

    let client = candidates[0];
    let state = State {
        address: client.address.clone(),
        pid: client.pid,
        workspace: source,
    };
    write_state(state_path, &state)?;
    if let Err(error) = move_window(WorkspaceTarget::Id(active.id), &state.address, true) {
        let _ = fs::remove_file(state_path);
        return Err(error);
    }

    if number == 0 || active.id < i64::from(number) {
        swap_window(Direction::Right)?;
    } else if active.id > i64::from(number) {
        swap_window(Direction::Left)?;
    }
    Ok(())
}

fn toggle_workspace_window(number: u8) -> Result<()> {
    let directory = state_directory()?;
    let state_path = directory.join(format!("{number}.json"));
    let lock_path = directory.join(format!("{number}.lock"));
    let lock = OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .mode(0o600)
        .open(&lock_path)
        .map_err(|error| format!("cannot open {}: {error}", lock_path.display()))?;
    lock.lock()
        .map_err(|error| format!("cannot lock {}: {error}", lock_path.display()))?;

    let active: ActiveWorkspace = query_json("activeworkspace")?;
    let clients: Vec<Client> = query_json("clients")?;
    match read_state(&state_path)? {
        Some(state) => restore_window(&state_path, state, &clients),
        None => borrow_window(number, &state_path, &active, &clients),
    }
}

fn notify_error(message: &str) {
    eprintln!("{APP_NAME}: {message}");
    let _ = Command::new("notify-send")
        .args(["Hyprland window toggle", message])
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status();
}

#[cfg(test)]
mod tests {
    use super::*;

    fn client(address: &str, workspace: &str, mapped: bool) -> Client {
        Client {
            address: address.to_owned(),
            pid: Some(123),
            workspace: Workspace {
                name: workspace.to_owned(),
            },
            mapped,
        }
    }

    #[test]
    fn validates_selectors() {
        assert!(valid_address("0xabc123"));
        assert!(!valid_address("abc123"));
        assert!(valid_workspace("9"));
        assert!(valid_workspace("special:magic"));
        assert!(!valid_workspace("0"));
        assert!(!valid_workspace("special:bad name"));
    }

    #[test]
    fn builds_current_hyprland_lua_dispatchers() {
        assert_eq!(
            move_expression(WorkspaceTarget::Id(3), "0xabc123", true).unwrap(),
            "hl.dsp.window.move({ workspace = 3, follow = true, window = \"address:0xabc123\" })"
        );
        assert_eq!(
            swap_expression(Direction::Left),
            "hl.dsp.window.swap({ direction = \"left\" })"
        );
    }

    #[test]
    fn filters_mapped_workspace_clients() {
        let clients = vec![
            client("0x1", "2", true),
            client("0x2", "2", false),
            client("0x3", "3", true),
        ];
        let matches = matching_clients(&clients, "2");
        assert_eq!(matches.len(), 1);
        assert_eq!(matches[0].address, "0x1");
    }

    #[test]
    fn state_round_trips() {
        let state = State {
            address: "0xabc".to_owned(),
            pid: Some(42),
            workspace: "2".to_owned(),
        };
        let encoded = serde_json::to_string(&state).unwrap();
        assert_eq!(serde_json::from_str::<State>(&encoded).unwrap(), state);
    }
}

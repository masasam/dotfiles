use std::ffi::{OsStr, OsString};
use std::fs::{self, File};
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, ExitCode, Stdio};
use std::thread;
use std::time::Duration;

type Result<T> = std::result::Result<T, String>;

const USAGE: &str = "Usage:
  dotctl check-iso FILE BLAKE2_SUM
  dotctl dirsum DIRECTORY
  dotctl md2pdf FILE
  dotctl md2docx FILE
  dotctl optimize-jpg FILE
  dotctl optimize-png FILE
  dotctl blog-jpg FILE
  dotctl rec2gif FILE
  dotctl postgres-backup DATABASE
  dotctl timer MINUTES MESSAGE";

fn main() -> ExitCode {
    match run(std::env::args_os().skip(1).collect()) {
        Ok(()) => ExitCode::SUCCESS,
        Err(error) => {
            eprintln!("dotctl: {error}");
            ExitCode::FAILURE
        }
    }
}

fn run(arguments: Vec<OsString>) -> Result<()> {
    let Some(command) = arguments.first().and_then(|value| value.to_str()) else {
        return Err(USAGE.to_owned());
    };
    let args = &arguments[1..];
    match command {
        "help" | "--help" | "-h" if args.is_empty() => {
            println!("{USAGE}");
            Ok(())
        }
        "check-iso" => with_two(args, check_iso),
        "dirsum" => with_one(args, dirsum),
        "md2pdf" => with_one(args, md2pdf),
        "md2docx" => with_one(args, md2docx),
        "optimize-jpg" => with_one(args, optimize_jpg),
        "optimize-png" => with_one(args, optimize_png),
        "blog-jpg" => with_one(args, blog_jpg),
        "rec2gif" => with_one(args, rec2gif),
        "postgres-backup" => with_one(args, postgres_backup),
        "timer" => with_two(args, start_timer),
        "__timer-worker" => with_two(args, timer_worker),
        _ => Err(USAGE.to_owned()),
    }
}

fn with_one(args: &[OsString], function: fn(&OsStr) -> Result<()>) -> Result<()> {
    if let [argument] = args {
        function(argument)
    } else {
        Err(USAGE.to_owned())
    }
}

fn with_two(args: &[OsString], function: fn(&OsStr, &OsStr) -> Result<()>) -> Result<()> {
    if let [first, second] = args {
        function(first, second)
    } else {
        Err(USAGE.to_owned())
    }
}

fn run_status(command: &mut Command) -> Result<()> {
    let program = command.get_program().to_string_lossy().into_owned();
    let status = command
        .status()
        .map_err(|error| format!("cannot run {program}: {error}"))?;
    if status.success() {
        Ok(())
    } else {
        Err(format!("{program} exited with {status}"))
    }
}

fn run_output(command: &mut Command) -> Result<Vec<u8>> {
    let program = command.get_program().to_string_lossy().into_owned();
    let output = command
        .output()
        .map_err(|error| format!("cannot run {program}: {error}"))?;
    if output.status.success() {
        Ok(output.stdout)
    } else {
        let stderr = String::from_utf8_lossy(&output.stderr);
        Err(format!("{program} failed: {}", stderr.trim()))
    }
}

fn output_with_suffix(
    input: &Path,
    prefix: &str,
    suffix: &str,
    extension: &str,
) -> Result<PathBuf> {
    let stem = input
        .file_stem()
        .ok_or_else(|| format!("{} has no file name", input.display()))?;
    let mut name = OsString::from(prefix);
    name.push(stem);
    name.push(suffix);
    name.push(".");
    name.push(extension);
    Ok(input.with_file_name(name))
}

fn md2pdf(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = input.with_extension("pdf");
    run_status(
        Command::new("pandoc")
            .arg(input)
            .arg("-o")
            .arg(output)
            .args(["-V", "mainfont=IPAPGothic", "-V", "fontsize=16pt"])
            .arg("--pdf-engine=typst"),
    )
}

fn md2docx(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = input.with_extension("docx");
    run_status(
        Command::new("pandoc")
            .arg(input)
            .args(["-t", "docx", "-o"])
            .arg(output)
            .args(["-V", "mainfont=IPAPGothic", "-V", "fontsize=16pt"])
            .args(["--toc", "--syntax-highlighting=zenburn"]),
    )
}

fn optimize_jpg(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = output_with_suffix(input, "", "_converted", "jpg")?;
    run_status(
        Command::new("convert")
            .arg(input)
            .args(["-sampling-factor", "4:2:0", "-strip", "-quality", "85"])
            .args(["-interlace", "JPEG", "-colorspace", "sRGB"])
            .arg(output),
    )
}

fn optimize_png(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = output_with_suffix(input, "", "_converted", "png")?;
    run_status(Command::new("convert").arg(input).arg("-strip").arg(output))
}

fn blog_jpg(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = output_with_suffix(input, "zzz_", "", "jpg")?;
    run_status(
        Command::new("convert")
            .arg(input)
            .args(["-resize", "600x"])
            .arg(&output),
    )?;
    fs::remove_file(input).map_err(|error| {
        format!(
            "created {}, but cannot remove {}: {error}",
            output.display(),
            input.display()
        )
    })
}

fn rec2gif(input: &OsStr) -> Result<()> {
    let input = Path::new(input);
    let output = input.with_extension("gif");
    run_status(
        Command::new("ffmpeg")
            .arg("-i")
            .arg(input)
            .args(["-vf", "scale=1280:-1", "-r", "24"])
            .arg(output),
    )
}

fn checksum_from_output(output: &[u8]) -> Result<&str> {
    let output =
        std::str::from_utf8(output).map_err(|error| format!("invalid checksum output: {error}"))?;
    output
        .split_whitespace()
        .next()
        .ok_or_else(|| "checksum command produced no output".to_owned())
}

fn check_iso(input: &OsStr, expected: &OsStr) -> Result<()> {
    let output = run_output(Command::new("b2sum").arg("--").arg(input))?;
    let actual = checksum_from_output(&output)?;
    let expected = expected
        .to_str()
        .ok_or_else(|| "BLAKE2 checksum must be UTF-8".to_owned())?;
    if actual.eq_ignore_ascii_case(expected) {
        println!("Correct iso file");
    } else {
        println!("Incorrect iso file");
    }
    Ok(())
}

fn collect_files(directory: &Path, files: &mut Vec<PathBuf>) -> Result<()> {
    let entries = fs::read_dir(directory)
        .map_err(|error| format!("cannot read {}: {error}", directory.display()))?;
    for entry in entries {
        let entry =
            entry.map_err(|error| format!("cannot read {}: {error}", directory.display()))?;
        let file_type = entry
            .file_type()
            .map_err(|error| format!("cannot inspect {}: {error}", entry.path().display()))?;
        if file_type.is_dir() {
            collect_files(&entry.path(), files)?;
        } else if file_type.is_file() {
            files.push(entry.path());
        }
    }
    Ok(())
}

fn sha1_file(path: &Path) -> Result<String> {
    let output = run_output(Command::new("shasum").arg("--").arg(path))?;
    Ok(checksum_from_output(&output)?.to_owned())
}

fn sha1_bytes(bytes: &[u8]) -> Result<String> {
    let mut child = Command::new("shasum")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|error| format!("cannot run shasum: {error}"))?;
    child
        .stdin
        .take()
        .ok_or_else(|| "cannot open shasum stdin".to_owned())?
        .write_all(bytes)
        .map_err(|error| format!("cannot write to shasum: {error}"))?;
    let output = child
        .wait_with_output()
        .map_err(|error| format!("cannot wait for shasum: {error}"))?;
    if !output.status.success() {
        return Err(format!(
            "shasum failed: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    Ok(checksum_from_output(&output.stdout)?.to_owned())
}

fn dirsum(directory: &OsStr) -> Result<()> {
    let directory = Path::new(directory);
    if !directory.is_dir() {
        return Err(format!("{} is not a directory", directory.display()));
    }
    let mut files = Vec::new();
    collect_files(directory, &mut files)?;
    let mut digests = files
        .iter()
        .map(|path| sha1_file(path))
        .collect::<Result<Vec<_>>>()?;
    digests.sort_unstable();
    let mut manifest = digests.join("\n");
    if !manifest.is_empty() {
        manifest.push('\n');
    }
    println!("{}", sha1_bytes(manifest.as_bytes())?);
    Ok(())
}

fn timestamp() -> Result<String> {
    let output = run_output(Command::new("date").arg("+%Y%m%d%H%M%S"))?;
    let stamp = std::str::from_utf8(&output)
        .map_err(|error| format!("invalid date output: {error}"))?
        .trim();
    if stamp.len() == 14 && stamp.bytes().all(|byte| byte.is_ascii_digit()) {
        Ok(stamp.to_owned())
    } else {
        Err("date returned an unexpected timestamp".to_owned())
    }
}

fn postgres_backup(database: &OsStr) -> Result<()> {
    let home = std::env::var_os("HOME").ok_or_else(|| "HOME is not set".to_owned())?;
    let directory = Path::new(&home).join("backup/postgresql");
    fs::create_dir_all(&directory)
        .map_err(|error| format!("cannot create {}: {error}", directory.display()))?;
    let output = directory.join(timestamp()?);
    let file = File::create(&output)
        .map_err(|error| format!("cannot create {}: {error}", output.display()))?;
    let result = run_status(Command::new("pg_dump").arg(database).stdout(file));
    if result.is_err() {
        let _ = fs::remove_file(&output);
    }
    result?;
    println!("{}", output.display());
    Ok(())
}

fn parse_minutes(minutes: &OsStr) -> Result<u64> {
    let minutes = minutes
        .to_str()
        .ok_or_else(|| "minutes must be a positive integer".to_owned())?
        .parse::<u64>()
        .map_err(|_| "minutes must be a positive integer".to_owned())?;
    minutes
        .checked_mul(60)
        .ok_or_else(|| "timer duration is too large".to_owned())
}

fn start_timer(minutes: &OsStr, message: &OsStr) -> Result<()> {
    let seconds = parse_minutes(minutes)?;
    let executable = std::env::current_exe()
        .map_err(|error| format!("cannot locate dotctl executable: {error}"))?;
    Command::new(executable)
        .arg("__timer-worker")
        .arg(seconds.to_string())
        .arg(message)
        .stdin(Stdio::null())
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn()
        .map_err(|error| format!("cannot start timer: {error}"))?;
    Ok(())
}

fn timer_worker(seconds: &OsStr, message: &OsStr) -> Result<()> {
    let seconds = seconds
        .to_str()
        .and_then(|value| value.parse::<u64>().ok())
        .ok_or_else(|| "invalid internal timer duration".to_owned())?;
    thread::sleep(Duration::from_secs(seconds));
    run_status(
        Command::new("notify-send")
            .args(["-u", "critical"])
            .arg(message),
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn constructs_output_names_next_to_input() {
        assert_eq!(
            output_with_suffix(
                Path::new("/tmp/photo.original.jpg"),
                "",
                "_converted",
                "jpg"
            )
            .unwrap(),
            PathBuf::from("/tmp/photo.original_converted.jpg")
        );
        assert_eq!(
            output_with_suffix(Path::new("images/photo.png"), "zzz_", "", "jpg").unwrap(),
            PathBuf::from("images/zzz_photo.jpg")
        );
    }

    #[test]
    fn extracts_checksum() {
        assert_eq!(
            checksum_from_output(b"abc123  file name\n").unwrap(),
            "abc123"
        );
        assert!(checksum_from_output(b" \n").is_err());
    }

    #[test]
    fn validates_timer_minutes() {
        assert_eq!(parse_minutes(OsStr::new("5")).unwrap(), 300);
        assert!(parse_minutes(OsStr::new("1.5")).is_err());
    }

    #[test]
    fn rejects_incorrect_arity_without_running_commands() {
        assert!(run(vec![OsString::from("dirsum")]).is_err());
        assert!(run(vec![OsString::from("check-iso"), OsString::from("file")]).is_err());
    }
}

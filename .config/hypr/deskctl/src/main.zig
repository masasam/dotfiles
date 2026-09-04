const std = @import("std");

const AudioState = struct {
    percentage: u8,
    muted: bool,
};

const Action = enum {
    volume_up,
    volume_down,
    mute_output,
    mute_input,
    brightness_up,
    brightness_down,
};

const output_target = "@DEFAULT_AUDIO_SINK@";
const input_target = "@DEFAULT_AUDIO_SOURCE@";

pub fn main(init: std.process.Init) void {
    runMain(init) catch |err| {
        std.debug.print("deskctl: {s}\n", .{@errorName(err)});
        std.process.exit(1);
    };
}

fn runMain(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 3) {
        usage();
        std.process.exit(2);
    }

    const action = parseAction(args[1], args[2]) orelse {
        usage();
        std.process.exit(2);
    };
    const home = init.environ_map.get("HOME") orelse return error.HomeNotSet;

    switch (action) {
        .volume_up => try changeVolume(allocator, init.io, home, "5%+"),
        .volume_down => try changeVolume(allocator, init.io, home, "5%-"),
        .mute_output => try toggleMute(allocator, init.io, home, output_target, false),
        .mute_input => try toggleMute(allocator, init.io, home, input_target, true),
        .brightness_up => try changeBrightness(allocator, init.io, home, "5%+"),
        .brightness_down => try changeBrightness(allocator, init.io, home, "5%-"),
    }
}

fn usage() void {
    std.debug.print(
        \\Usage:
        \\  deskctl volume up|down|mute
        \\  deskctl microphone mute
        \\  deskctl brightness up|down
        \\
    , .{});
}

fn parseAction(group: []const u8, operation: []const u8) ?Action {
    if (std.mem.eql(u8, group, "volume")) {
        if (std.mem.eql(u8, operation, "up")) return .volume_up;
        if (std.mem.eql(u8, operation, "down")) return .volume_down;
        if (std.mem.eql(u8, operation, "mute")) return .mute_output;
    } else if (std.mem.eql(u8, group, "microphone")) {
        if (std.mem.eql(u8, operation, "mute")) return .mute_input;
    } else if (std.mem.eql(u8, group, "brightness")) {
        if (std.mem.eql(u8, operation, "up")) return .brightness_up;
        if (std.mem.eql(u8, operation, "down")) return .brightness_down;
    }
    return null;
}

fn runCommand(
    allocator: std.mem.Allocator,
    io: std.Io,
    argv: []const []const u8,
) ![]u8 {
    const result = try std.process.run(allocator, io, .{
        .argv = argv,
        .stdout_limit = .limited(64 * 1024),
        .stderr_limit = .limited(64 * 1024),
    });
    defer allocator.free(result.stderr);

    switch (result.term) {
        .exited => |code| if (code != 0) {
            std.debug.print("deskctl: command failed ({d}): {s}\n", .{
                code,
                std.mem.trim(u8, result.stderr, " \t\r\n"),
            });
            allocator.free(result.stdout);
            return error.CommandFailed;
        },
        else => {
            allocator.free(result.stdout);
            return error.CommandTerminated;
        },
    }
    return result.stdout;
}

fn getAudioState(
    allocator: std.mem.Allocator,
    io: std.Io,
    target: []const u8,
) !AudioState {
    const output = try runCommand(allocator, io, &.{ "wpctl", "get-volume", target });
    defer allocator.free(output);
    return parseAudioState(output);
}

fn parseAudioState(output: []const u8) !AudioState {
    const trimmed = std.mem.trim(u8, output, " \t\r\n");
    const prefix = "Volume:";
    if (!std.mem.startsWith(u8, trimmed, prefix)) return error.UnexpectedAudioOutput;

    const fields = std.mem.trimStart(u8, trimmed[prefix.len..], " \t");
    const value_end = std.mem.indexOfAny(u8, fields, " \t") orelse fields.len;
    const value = try std.fmt.parseFloat(f64, fields[0..value_end]);
    const scaled = std.math.clamp(@round(value * 100.0), 0.0, 100.0);
    return .{
        .percentage = @intFromFloat(scaled),
        .muted = std.mem.indexOf(u8, fields[value_end..], "[MUTED]") != null,
    };
}

fn changeVolume(
    allocator: std.mem.Allocator,
    io: std.Io,
    home: []const u8,
    delta: []const u8,
) !void {
    const output = try runCommand(
        allocator,
        io,
        &.{ "wpctl", "set-volume", "-l", "1", output_target, delta },
    );
    allocator.free(output);

    const state = try getAudioState(allocator, io, output_target);
    const icon = if (state.muted) "audio-volume-muted.png" else "audio-volume-high.png";
    const suffix = if (state.muted) " (muted)" else "";
    const summary = try std.fmt.allocPrint(
        allocator,
        "Volume: {d}%{s}",
        .{ state.percentage, suffix },
    );
    notify(allocator, io, home, summary, icon, state.percentage, "volume");
}

fn toggleMute(
    allocator: std.mem.Allocator,
    io: std.Io,
    home: []const u8,
    target: []const u8,
    microphone: bool,
) !void {
    const output = try runCommand(
        allocator,
        io,
        &.{ "wpctl", "set-mute", target, "toggle" },
    );
    allocator.free(output);

    const state = try getAudioState(allocator, io, target);
    const icon = if (microphone)
        (if (state.muted) "microphone-sensitivity-muted.png" else "microphone-sensitivity-high.png")
    else if (state.muted)
        "audio-volume-muted.png"
    else
        "audio-volume-high.png";
    const summary = if (microphone)
        (if (state.muted) "Microphone muted" else "Microphone unmuted")
    else if (state.muted)
        "Volume muted"
    else
        "Volume unmuted";
    notify(
        allocator,
        io,
        home,
        summary,
        icon,
        state.percentage,
        if (microphone) "microphone" else "volume",
    );
}

fn getBrightness(allocator: std.mem.Allocator, io: std.Io) !u8 {
    const output = try runCommand(
        allocator,
        io,
        &.{ "brightnessctl", "-m", "-c", "backlight" },
    );
    defer allocator.free(output);
    return parseBrightness(output);
}

fn parseBrightness(output: []const u8) !u8 {
    var lines = std.mem.tokenizeScalar(u8, output, '\n');
    const line = lines.next() orelse return error.UnexpectedBrightnessOutput;
    var fields = std.mem.splitScalar(u8, line, ',');
    _ = fields.next();
    _ = fields.next();
    _ = fields.next();
    const percentage = fields.next() orelse return error.UnexpectedBrightnessOutput;
    if (!std.mem.endsWith(u8, percentage, "%")) return error.UnexpectedBrightnessOutput;
    return std.fmt.parseInt(u8, percentage[0 .. percentage.len - 1], 10);
}

fn changeBrightness(
    allocator: std.mem.Allocator,
    io: std.Io,
    home: []const u8,
    delta: []const u8,
) !void {
    const output = try runCommand(
        allocator,
        io,
        &.{ "brightnessctl", "-e4", "-n2", "-c", "backlight", "set", delta },
    );
    allocator.free(output);

    const percentage = try getBrightness(allocator, io);
    const summary = try std.fmt.allocPrint(allocator, "Brightness: {d}%", .{percentage});
    notify(allocator, io, home, summary, "computer.png", percentage, "bright");
}

fn notify(
    allocator: std.mem.Allocator,
    io: std.Io,
    home: []const u8,
    summary: []const u8,
    icon_name: []const u8,
    percentage: u8,
    notification_id: []const u8,
) void {
    const icon = std.fmt.allocPrint(
        allocator,
        "{s}/.config/mako/icons/{s}",
        .{ home, icon_name },
    ) catch return;
    defer allocator.free(icon);
    const value_hint = std.fmt.allocPrint(allocator, "int:value:{d}", .{percentage}) catch return;
    defer allocator.free(value_hint);
    const sync_hint = std.fmt.allocPrint(
        allocator,
        "string:x-canonical-private-synchronous:{s}",
        .{notification_id},
    ) catch return;
    defer allocator.free(sync_hint);

    const output = runCommand(
        allocator,
        io,
        &.{
            "notify-send",
            "-i",
            icon,
            "-t",
            "1000",
            "-a",
            if (std.mem.eql(u8, notification_id, "bright")) "wp-bright" else "wp-vol",
            "-h",
            sync_hint,
            "-h",
            value_hint,
            summary,
        },
    ) catch return;
    allocator.free(output);
}

test "parse actions" {
    try std.testing.expectEqual(Action.volume_up, parseAction("volume", "up").?);
    try std.testing.expectEqual(Action.mute_input, parseAction("microphone", "mute").?);
    try std.testing.expectEqual(Action.brightness_down, parseAction("brightness", "down").?);
    try std.testing.expect(parseAction("volume", "invalid") == null);
}

test "parse audio state" {
    try std.testing.expectEqual(
        AudioState{ .percentage = 60, .muted = false },
        try parseAudioState("Volume: 0.60\n"),
    );
    try std.testing.expectEqual(
        AudioState{ .percentage = 42, .muted = true },
        try parseAudioState("Volume: 0.42 [MUTED]\n"),
    );
}

test "parse brightness" {
    try std.testing.expectEqual(
        @as(u8, 17),
        try parseBrightness("intel_backlight,backlight,3325,17%,19393\n"),
    );
}

const std = @import("std");

const Command = enum {
    ipsort,
    remove_exif,
    gitignore,
    mytldr,
    ide,
    topdf,
};

pub fn main(init: std.process.Init) void {
    runMain(init) catch |err| {
        std.debug.print("zshctl: {s}\n", .{@errorName(err)});
        std.process.exit(1);
    };
}

fn runMain(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len < 2) return usageError();

    const command = parseCommand(args[1]) orelse return usageError();
    switch (command) {
        .ipsort => {
            if (args.len != 3) return usageError();
            try runInteractive(init.io, &.{
                "sort", "-n", "-t.", "-k1,1", "-k2,2", "-k3,3", "-k4,4", args[2],
            });
        },
        .remove_exif => {
            if (args.len != 3) return usageError();
            try runInteractive(init.io, &.{ "jhead", "-purejpg", args[2] });
        },
        .gitignore => {
            if (args.len != 4) return usageError();
            const url = try std.fmt.allocPrint(
                allocator,
                "https://www.toptal.com/developers/gitignore/api/{s}",
                .{args[2]},
            );
            try runInteractive(init.io, &.{ "curl", "-LfsS", url, "-o", args[3] });
        },
        .mytldr => {
            if (args.len != 3) return usageError();
            try runPipeline(init.io, &.{ "unbuffer", "tldr", args[2] }, &.{ "less", "-SR" });
        },
        .ide => {
            if (args.len != 3) return usageError();
            try createIdeLayout(init.io, args[2]);
        },
        .topdf => {
            if (args.len > 3) return usageError();
            const orientation = if (args.len == 3) args[2] else "Portrait";
            if (!validOrientation(orientation)) return error.InvalidOrientation;
            try convertTreeToPdf(allocator, init.io, orientation);
        },
    }
}

fn usageError() error{InvalidArguments} {
    std.debug.print(
        \\Usage:
        \\  zshctl ipsort FILE
        \\  zshctl remove-exif FILE.jpg
        \\  zshctl gitignore TEMPLATE OUTPUT
        \\  zshctl mytldr TOPIC
        \\  zshctl ide 1|2|3|4
        \\  zshctl topdf [Portrait|Landscape]
        \\
    , .{});
    return error.InvalidArguments;
}

fn parseCommand(value: []const u8) ?Command {
    if (std.mem.eql(u8, value, "ipsort")) return .ipsort;
    if (std.mem.eql(u8, value, "remove-exif")) return .remove_exif;
    if (std.mem.eql(u8, value, "gitignore")) return .gitignore;
    if (std.mem.eql(u8, value, "mytldr")) return .mytldr;
    if (std.mem.eql(u8, value, "ide")) return .ide;
    if (std.mem.eql(u8, value, "topdf")) return .topdf;
    return null;
}

fn commandSucceeded(term: std.process.Child.Term) bool {
    return switch (term) {
        .exited => |code| code == 0,
        else => false,
    };
}

fn runInteractive(io: std.Io, argv: []const []const u8) !void {
    var child = try std.process.spawn(io, .{
        .argv = argv,
        .stdin = .inherit,
        .stdout = .inherit,
        .stderr = .inherit,
    });
    if (!commandSucceeded(try child.wait(io))) return error.CommandFailed;
}

fn runPipeline(
    io: std.Io,
    producer_argv: []const []const u8,
    consumer_argv: []const []const u8,
) !void {
    var producer = try std.process.spawn(io, .{
        .argv = producer_argv,
        .stdin = .inherit,
        .stdout = .pipe,
        .stderr = .inherit,
    });
    errdefer producer.kill(io);

    var consumer = std.process.spawn(io, .{
        .argv = consumer_argv,
        .stdin = .{ .file = producer.stdout.? },
        .stdout = .inherit,
        .stderr = .inherit,
    }) catch |err| {
        producer.stdout.?.close(io);
        return err;
    };
    producer.stdout.?.close(io);
    producer.stdout = null;
    errdefer consumer.kill(io);

    const producer_term = try producer.wait(io);
    const consumer_term = try consumer.wait(io);
    if (!commandSucceeded(producer_term) or !commandSucceeded(consumer_term)) {
        return error.CommandFailed;
    }
}

fn createIdeLayout(io: std.Io, layout: []const u8) !void {
    const vertical = &.{ "tmux", "split-window", "-v" };
    const horizontal = &.{ "tmux", "split-window", "-h" };
    const first = &.{ "tmux", "select-pane", "-t", "1" };

    if (std.mem.eql(u8, layout, "1")) {
        try runInteractive(io, vertical);
        try runInteractive(io, horizontal);
        try runInteractive(io, &.{ "tmux", "resize-pane", "-U", "7" });
        try runInteractive(io, first);
    } else if (std.mem.eql(u8, layout, "2")) {
        try runInteractive(io, horizontal);
        try runInteractive(io, vertical);
        try runInteractive(io, first);
    } else if (std.mem.eql(u8, layout, "3")) {
        try runInteractive(io, horizontal);
        try runInteractive(io, first);
        try runInteractive(io, vertical);
        try runInteractive(io, first);
    } else if (std.mem.eql(u8, layout, "4")) {
        try runInteractive(io, horizontal);
        try runInteractive(io, vertical);
        try runInteractive(io, first);
        try runInteractive(io, vertical);
        try runInteractive(io, first);
    } else {
        return error.InvalidLayout;
    }
}

fn runCaptured(
    allocator: std.mem.Allocator,
    io: std.Io,
    argv: []const []const u8,
) ![]u8 {
    const result = try std.process.run(allocator, io, .{
        .argv = argv,
        .stdout_limit = .unlimited,
        .stderr_limit = .limited(64 * 1024),
    });
    defer allocator.free(result.stderr);
    if (!commandSucceeded(result.term)) {
        std.debug.print("zshctl: command failed: {s}\n", .{
            std.mem.trim(u8, result.stderr, " \t\r\n"),
        });
        allocator.free(result.stdout);
        return error.CommandFailed;
    }
    return result.stdout;
}

fn validOrientation(value: []const u8) bool {
    return std.mem.eql(u8, value, "Portrait") or std.mem.eql(u8, value, "Landscape");
}

fn isConvertible(path: []const u8) bool {
    const extensions = [_][]const u8{ ".jpg", ".jpeg", ".png", ".gif", ".pdf", ".html" };
    for (extensions) |extension| {
        if (std.ascii.endsWithIgnoreCase(path, extension)) return false;
    }
    return true;
}

fn convertTreeToPdf(
    allocator: std.mem.Allocator,
    io: std.Io,
    orientation: []const u8,
) !void {
    const files = try runCaptured(allocator, io, &.{ "find", ".", "-type", "f", "-print0" });
    defer allocator.free(files);

    var paths = std.mem.splitScalar(u8, files, 0);
    while (paths.next()) |path| {
        if (path.len == 0 or !isConvertible(path)) continue;
        try convertFileToPdf(allocator, io, path, orientation);
    }
}

fn convertFileToPdf(
    allocator: std.mem.Allocator,
    io: std.Io,
    input: []const u8,
    orientation: []const u8,
) !void {
    const temp_output = try runCaptured(allocator, io, &.{ "mktemp", "--suffix=.html", "/tmp/zshctl-XXXXXX" });
    defer allocator.free(temp_output);
    const temp_path = std.mem.trim(u8, temp_output, " \t\r\n");
    defer std.Io.Dir.deleteFileAbsolute(io, temp_path) catch {};

    const vim_command = try std.fmt.allocPrint(
        allocator,
        "colorscheme default | set number | TOhtml | w! {s} | qa!",
        .{temp_path},
    );
    const output = try std.fmt.allocPrint(allocator, "{s}.pdf", .{input});
    const footer = try std.fmt.allocPrint(allocator, "[date] [time] {s}", .{input});

    try runInteractive(io, &.{ "vim", input, "-c", vim_command });
    try runInteractive(io, &.{
        "wkhtmltopdf",
        "--page-size", "B4",
        "-O", orientation,
        "--footer-left", footer,
        "--footer-right", "[page]/[topage]",
        "--no-background",
        "--margin-top", "4",
        "--margin-right", "3",
        "--margin-left", "4",
        "--margin-bottom", "10",
        temp_path,
        output,
    });
}

test "parse commands" {
    try std.testing.expectEqual(Command.ipsort, parseCommand("ipsort").?);
    try std.testing.expectEqual(Command.remove_exif, parseCommand("remove-exif").?);
    try std.testing.expectEqual(Command.topdf, parseCommand("topdf").?);
    try std.testing.expect(parseCommand("unknown") == null);
}

test "topdf filters generated and image files" {
    try std.testing.expect(isConvertible("./notes.md"));
    try std.testing.expect(!isConvertible("./photo.JPEG"));
    try std.testing.expect(!isConvertible("./notes.md.pdf"));
    try std.testing.expect(!isConvertible("./preview.html"));
}

test "valid PDF orientations" {
    try std.testing.expect(validOrientation("Portrait"));
    try std.testing.expect(validOrientation("Landscape"));
    try std.testing.expect(!validOrientation("portrait"));
}

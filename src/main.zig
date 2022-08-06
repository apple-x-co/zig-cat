const std = @import("std");

pub fn main() anyerror!void {
    const pageAllocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(pageAllocator);
    defer pageAllocator.free(args);

    const stdout = std.io.getStdOut();

    if (args.len == 1) {
        const stdin = std.io.getStdIn();
        cat(stdin, stdout) catch |err| {
            std.log.warn("error reading stdin : {}", .{err});
        };

        return;
    }

    const fs = std.fs;

    // std.debug.print("number of args: {}\n", .{args.len});
    for (args) |arg, index| {
        if (index == 0) {
            continue;
        }

        const file = try fs.cwd().openFile(arg, .{ .read = true, .write = false });
        defer file.close();
        cat(file, stdout) catch |err| {
            std.log.warn("error reading file '{s}': {}", .{ arg, err });
        };
    }
}

fn cat(in: std.fs.File, out: std.fs.File) anyerror!void {
    const reader = in.reader();
    const writer = out.writer();
    var buf: [std.mem.page_size]u8 = undefined;
    while (true) {
        const size = try reader.read(buf[0..]);
        if (size <= 0) {
            break;
        }

        try writer.writeAll(buf[0..size]);
    }
}

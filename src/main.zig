const std = @import("std");

pub fn main() anyerror!void {
    const pageAllocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(pageAllocator);
    defer pageAllocator.free(args);

    const stdout = std.io.getStdOut().writer();

    if (args.len == 1) {
        //try stdout.print("Missing filename\n", .{});

        const stdin = std.io.getStdIn().reader();

        out(stdin, stdout) catch |err| {
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

        // std.debug.print("{s}\n", .{arg}); // Output file name

        const file = try fs.cwd().openFile(arg, .{.read = true, .write = false});
        defer file.close();

        const fileReader = file.reader();

        out(fileReader, stdout) catch |err| {
            std.log.warn("error reading file '{s}': {}", .{arg, err});
        };
    }
}

fn out(reader: anytype, writer: anytype) anyerror!void {
    var buf: [std.mem.page_size]u8 = undefined;
    while (true) {
        const size = try reader.read(buf[0..]);
        if (size <= 0) {
            break;
        }

        try writer.writeAll(buf[0..size]);
    }
}
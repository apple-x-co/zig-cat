const std = @import("std");

pub fn main() anyerror!void {
    const pageAllocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(pageAllocator);
    defer pageAllocator.free(args);

    const stdout = std.io.getStdOut().writer();

    if (args.len == 1) {
        try stdout.print("Missing filename\n", .{});
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

        var buf: [std.mem.page_size]u8 = undefined;
        while (true) {
            const size = try file.read(buf[0..]);
            if (size <= 0) {
                break;
            }

            try stdout.writeAll(buf[0..size]);
        }
    }
}

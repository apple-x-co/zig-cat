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

    // std.debug.print("number of args: {}\n", .{args.len});
    for (args) |arg, index| {
        if (index == 0) {
            continue;
        }

        std.debug.print("{s}\n", .{arg});

        // var file = try std.fs.cwd().openFile(arg);
        // defer file.close();
        // std.debug.print("{s}\n", .{file.stat});
    }
}

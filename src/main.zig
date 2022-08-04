const std = @import("std");

pub fn main() anyerror!void {
    const pageAllocator = std.heap.page_allocator;

    const args = try std.process.argsAlloc(pageAllocator);
    defer pageAllocator.free(args);

    std.debug.print("number of args: {}\n", .{args.len});
    for (args) |arg| {
        std.debug.print("{s}\n", .{arg});
    }
}

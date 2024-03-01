const std = @import("std");

pub fn main() !void {
    const w = std.io.getStdOut().writer();
    const count = 500_000;
    _ = try w.print("{d} ", .{count});
    var rand = std.rand.DefaultPrng.init(0);
    for (0..count) |_| {
        const n: i32 = @bitCast(@as(u32, @truncate(rand.next())));
        _ = try w.print("{d} ", .{n});
    }
}

const std = @import("std");

pub fn main() !void {
    const nx: f32 = 200.0;
    const ny: f32 = 100.0;

    std.debug.print("P3\n{} {}\n255\n", .{ nx, ny });
    var j: f32 = ny - 1;

    while (j >= 0.0) : (j -= 1.0) {
        var i: f32 = 0.0;
        while (i < nx) : (i += 1.0) {
            const r: f32 = i / nx;
            const g: f32 = j / ny;
            const b = 0.2;
            const ir: i32 = @intFromFloat(255.99 * r);
            const ig: i32 = @intFromFloat(255.99 * g);
            const ib: i32 = @intFromFloat(255.99 * b);
            std.debug.print("{} {} {}\n", .{ ir, ig, ib });
        }
    }
}

const std = @import("std");
const frame_mod = @import("frame.zig");

// its using try so must return an error as well!
pub fn writePPM(name: []const u8, frame: *const frame_mod.Frame) !void {
    const file = try std.fs.cwd().createFile(name, .{});

    defer file.close();

    const writer = file.writer();

    try writer.print("P6 {} {} 255\n", .{ frame.width, frame.height });

    var row_index = frame.height;

    while (row_index > 0) : (row_index -= 1) {
        const row = frame.data[row_index - 1];
        for (row) |pixel| {
            const bytes = pixel.getBytes();
            // passing &bytes because writeALL expects a slice ([]const u8)!
            try writer.writeAll(&bytes);
        }
    }
}

const color_mod = @import("color.zig");
const std = @import("std");

pub const Frame = struct {
    width: usize,
    height: usize,
    data: [][]color_mod.Color,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator, width: usize, height: usize, color: *const color_mod.Color) !void {
        const data = try allocator.alloc([]color_mod.Color, height);
        for (data) |*row| {
            row.* = try allocator.alloc(color_mod.Color, width);
            for (row.*) |*pixel| {
                pixel.* = color;
            }
        }

        return Frame{
            .width = width,
            .height = height,
            .data = data,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Frame) void {
        for (self.data) |row| {
            self.allocator.free(row);
        }
        self.allocator.free(self.data);
    }

    pub fn clear(self: *Frame, color: color_mod.Color) void {
        for (self.data) |row| {
            for (row) |*pixel| {
                pixel.* = color;
            }
        }
    }
};

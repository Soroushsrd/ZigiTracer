const std = @import("std");
const testing = std.testing;

const Color = struct {
    r: f32,
    g: f32,
    b: f32,
    pub fn init(r: f32, g: f32, b: f32) Color {
        return Color{ .r = r, .g = g, .b = b };
    }
    pub fn getBytes(self: Color) [3]u8 {
        return [3]u8{
            @intFromFloat(@min(self.r * 255, 255)),
            @intFromFloat(@min(self.g * 255, 255)),
            @intFromFloat(@min(self.b * 255, 255)),
        };
    }
    pub fn add(self: *Color, col: f32) void {
        self.r = @min(self.r + col, 1.0);
        self.g = @min(self.g + col, 1.0);
        self.b = @min(self.b + col, 1.0);
    }

    pub fn sub(self: *Color, col: f32) void {
        self.r = @max(self.r - col, 0.0);
        self.g = @max(self.g - col, 0.0);
        self.b = @max(self.b - col, 0.0);
    }
    pub fn multColor(self: *Color, other: *const Color) void {
        self.r = @min(self.r * other.r, 1.0);
        self.g = @min(self.g * other.g, 1.0);
        self.b = @min(self.b * other.b, 1.0);
    }

    pub fn multScalar(self: *Color, scalar: f32) void {
        self.r = @min(self.r * scalar, 1.0);
        self.g = @min(self.g * scalar, 1.0);
        self.b = @min(self.b * scalar, 1.0);
    }
    pub fn divideColor(self: *Color, other: *const Color) void {
        if (other.r != 0.0) self.r = @min(self.r / other.r, 1.0);
        if (other.g != 0.0) self.g = @min(self.g / other.g, 1.0);
        if (other.b != 0.0) self.b = @min(self.b / other.b, 1.0);
    }

    pub fn divideScalar(self: *Color, scalar: f32) void {
        if (scalar != 0.0) {
            self.r = @min(self.r / scalar, 1.0);
            self.g = @min(self.g / scalar, 1.0);
            self.b = @min(self.b / scalar, 1.0);
        }
    }
    pub fn fromColorRange(color_range: ColorRange) Color {
        return switch (color_range) {
            .BLACK => Color{ .r = 0.0, .g = 0.0, .b = 0.0 },
            .WHITE => Color{ .r = 1.0, .g = 1.0, .b = 1.0 },
            .RED => Color{ .r = 1.0, .g = 0.0, .b = 0.0 },
            .GREEN => Color{ .r = 0.0, .g = 1.0, .b = 0.0 },
            .BLUE => Color{ .r = 0.0, .g = 0.0, .b = 1.0 },
            .YELLOW => Color{ .r = 1.0, .g = 1.0, .b = 0.0 },
            .MAGENTA => Color{ .r = 1.0, .g = 0.0, .b = 1.0 },
            .CYAN => Color{ .r = 0.0, .g = 1.0, .b = 1.0 },
        };
    }
};

pub const ColorRange = enum(u8) { BLACK, WHITE, RED, GREEN, BLUE, YELLOW, MAGENTA, CYAN };

test "Color initialization" {
    const c = Color.init(0.5, 0.6, 0.7);
    try testing.expectEqual(c.r, 0.5);
    try testing.expectEqual(c.g, 0.6);
    try testing.expectEqual(c.b, 0.7);
}

test "Color from type" {
    const red = Color.fromColorRange(.RED);
    try testing.expectEqual(red.r, 1.0);
    try testing.expectEqual(red.g, 0.0);
    try testing.expectEqual(red.b, 0.0);
}

test "Color getBytes" {
    const c = Color.init(0.5, 1.0, 0.0);
    const bytes = c.getBytes();
    try testing.expectEqual(bytes[0], 127);
    try testing.expectEqual(bytes[1], 255);
    try testing.expectEqual(bytes[2], 0);
}

test "Color add" {
    var c = Color.init(0.5, 0.6, 0.7);
    c.add(0.2);
    try testing.expectEqual(c.r, 0.7);
    try testing.expectEqual(c.g, 0.8);
    try testing.expectEqual(c.b, 0.9);

    // Test clamping
    c.add(0.5);
    try testing.expectEqual(c.r, 1.0);
    try testing.expectEqual(c.g, 1.0);
    try testing.expectEqual(c.b, 1.0);
}

test "Color subtract" {
    var c = Color.init(0.5, 0.6, 0.7);
    c.sub(0.2);
    try testing.expectEqual(c.r, 0.3);
    try testing.expectEqual(c.g, 0.4);
    try testing.expectEqual(c.b, 0.5);

    // Test clamping
    c.sub(1.0);
    try testing.expectEqual(c.r, 0.0);
    try testing.expectEqual(c.g, 0.0);
    try testing.expectEqual(c.b, 0.0);
}

test "Color multiply" {
    var c1 = Color.init(0.5, 0.6, 0.7);
    const c2 = Color.init(0.5, 0.5, 0.5);
    c1.multColor(&c2);
    try testing.expectEqual(c1.r, 0.25);
    try testing.expectEqual(c1.g, 0.3);
    try testing.expectEqual(c1.b, 0.35);
}

test "Color multiply scalar" {
    var c = Color.init(0.5, 0.6, 0.7);
    c.multScalar(2.0);
    try testing.expectEqual(c.r, 1.0); // Clamped
    try testing.expectEqual(c.g, 1.0); // Clamped
    try testing.expectEqual(c.b, 1.0); // Clamped
}

test "Color divide" {
    var c1 = Color.init(0.5, 0.6, 0.7);
    const c2 = Color.init(2.0, 2.0, 2.0);
    c1.divideColor(&c2);
    try testing.expectEqual(c1.r, 0.25);
    try testing.expectEqual(c1.g, 0.3);
    try testing.expectEqual(c1.b, 0.35);
}

test "Color divide scalar" {
    var c = Color.init(0.5, 0.6, 0.7);
    c.divideScalar(2.0);
    try testing.expectEqual(c.r, 0.25);
    try testing.expectEqual(c.g, 0.3);
    try testing.expectEqual(c.b, 0.35);

    // Test divide by zero
    c.divideScalar(0.0);
    try testing.expectEqual(c.r, 0.25); // Should remain unchanged
    try testing.expectEqual(c.g, 0.3); // Should remain unchanged
    try testing.expectEqual(c.b, 0.35); // Should remain unchanged
}

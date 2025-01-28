const std = @import("std");
const math = @import("std").math;
const expect_approx = std.testing.expectApproxEqAbs;
const expect = std.testing.expect;

pub const Vector = struct {
    x: f32,
    y: f32,
    z: f32,
    pub fn length(self: Vector) f32 {
        return @sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    }

    pub fn normalize(self: *Vector) void {
        const vec_length = self.length();
        if (vec_length != 0) {
            self.x /= vec_length;
            self.y /= vec_length;
            self.z /= vec_length;
        }
    }

    pub fn add(self: *Vector, vec: Vector) void {
        self.x += vec.x;
        self.y += vec.y;
        self.z += vec.z;
    }

    pub fn sub(self: *Vector, vec: Vector) void {
        self.x -= vec.x;
        self.y -= vec.y;
        self.z -= vec.z;
    }

    pub fn negative(self: *Vector) void {
        self.x *= -1;
        self.y *= -1;
        self.z *= -1;
    }

    pub fn multiply(self: *Vector, num: f32) void {
        self.x *= num;
        self.y *= num;
        self.z *= num;
    }
    pub fn trueDiv(self: *Vector, num: f32) void {
        if (num != 0) {
            self.x /= num;
            self.y /= num;
            self.z /= num;
        }
    }
    pub fn reflect(self: *Vector, vec: Vector) void {
        const self_dot = dot(self.*, self.*);
        const vec_dot = dot(self.*, vec);

        var mirror = self.*;
        mirror.multiply(vec_dot / self_dot);
        mirror.multiply(2);
        mirror.sub(vec);
        mirror.normalize();

        self.x = mirror.x;
        self.y = mirror.y;
        self.z = mirror.z;
    }
};

pub fn dot(a: Vector, b: Vector) f32 {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

test "multiply" {
    var vec = Vector{ .x = 10.1, .y = 2.0, .z = 1.0 };
    vec.multiply(2);
    try expect_approx(4.0, vec.y, 0.001);
}
test "reflect" {
    var vec = Vector{ .x = 1.0, .y = 0.0, .z = 0.0 };
    const normal = Vector{ .x = -1.0, .y = 0.0, .z = 0.0 };
    vec.reflect(normal);
    try expect_approx(-1.0, vec.x, 0.001);
    try expect_approx(0.0, vec.y, 0.001);
    try expect_approx(0.0, vec.z, 0.001);
}
test "normalize" {
    var vec = Vector{ .x = 10.0, .y = 2.0, .z = 1.0 };
    vec.normalize();
    try expect_approx(1, vec.length(), 0.001);
}

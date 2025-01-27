const std = @import("std");
const math = @import("std").math;
const expect = std.testing.expectApproxEqAbs;

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
};

test "normalize" {
    var vec = Vector{ .x = 10.0, .y = 2.0, .z = 1.0 };
    vec.normalize();
    try expect(1, vec.length(), 0.001);
}

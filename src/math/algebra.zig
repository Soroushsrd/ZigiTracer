const geometry = @import("geometry.zig");
const math = @import("std").math;

pub const Matrix = struct {
    rows: [4][4]f32,

    pub fn init(self: *Matrix, rows: [4][4]f32) void {
        self.rows = rows;
    }

    pub fn transform(self: *Matrix, vector: *const geometry.Vector) geometry.Vector {
        return geometry.Vector{
            .x = self.rows[0][0] * vector.x + self.rows[0][1] * vector.y + self.rows[0][2] * vector.z,
            .y = self.rows[1][0] * vector.x + self.rows[1][1] * vector.y + self.rows[1][2] * vector.z,
            .z = self.rows[2][0] * vector.x + self.rows[2][1] * vector.y + self.rows[2][2] * vector.z,
        };
    }
};

pub fn scale(factor: anytype) Matrix {
    switch (@TypeOf(factor)) {
        geometry.Vector => return Matrix{
            .rows = .{
                .{ factor.x, 0, 0, 0 },
                .{ 0, factor.y, 0, 0 },
                .{ 0, 0, factor.z, 0 },
                .{ 0, 0, 0, 1 },
            },
        },
        f32 => return Matrix{
            .rows = .{
                .{ factor, 0, 0, 0 },
                .{ 0, factor, 0, 0 },
                .{ 0, 0, factor, 0 },
                .{ 0, 0, 0, 1 },
            },
        },
        else => @compileError("Invalid type for scale factor"),
    }
}

pub fn translate(vector: *const geometry.Vector) Matrix {
    return Matrix{
        .rows = .{
            .{ 1, 0, 0, vector.x },
            .{ 0, 1, 0, vector.y },
            .{ 0, 0, 1, vector.z },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn rotateX(angle: f32) Matrix {
    return Matrix{
        .rows = .{
            .{ 1, 0, 0, 0 },
            .{ 0, math.cos(angle), -math.sin(angle), 0 },
            .{ 0, math.sin(angle), math.cos(angle), 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn rotateY(angle: f32) Matrix {
    return Matrix{
        .rows = .{
            .{ math.cos(angle), 0, math.sin(angle), 0 },
            .{ 0, 1, 0, 0 },
            .{ -math.sin(angle), 0, math.cos(angle), 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

pub fn rotateZ(angle: f32) Matrix {
    return Matrix{
        .rows = .{
            .{ math.cos(angle), -math.sin(angle), 0, 0 },
            .{ math.sin(angle), math.cos(angle), 0, 0 },
            .{ 0, 0, 1, 0 },
            .{ 0, 0, 0, 1 },
        },
    };
}

const algebra = @import("../math/algebra.zig");
const geometry = @import("../math/geometry.zig");
const Vector = geometry.Vector;
const Ray = geometry.Ray;
const math = @import("std").math;
const std = @import("std");

pub const Eye = struct {
    position: Vector,
    direction: Vector,
    up: Vector,
    aspect_ratio: f32,
    field_of_view: f32,

    // Private fields (in Zig we'll keep them as regular fields)
    height: f32,
    width: f32,
    rv: Vector, // right vector
    uv: Vector, // up vector
    ld: Vector, // left-down vector
    //

    pub fn init(position: Vector, direction: Vector, up: Vector, aspect_ratio: f32, field_of_view: f32) Eye {
        var self = Eye{
            .position = position,
            .direction = direction,
            .up = up,
            .aspect_ratio = aspect_ratio,
            .field_of_view = field_of_view,
            .height = 0,
            .width = 0,
            .rv = Vector{ .x = 0, .y = 0, .z = 0 },
            .uv = Vector{ .x = 0, .y = 0, .z = 0 },
            .ld = Vector{ .x = 0, .y = 0, .z = 0 },
        };

        self.height = @tan(self.field_of_view / 2) * 2;
        self.width = self.aspect_ratio * self.height;

        self.rv = geometry.cross(self.up, self.direction).normalize();
        self.uv = geometry.cross(self.direction, self.rv).normalize();

        self.ld = self.position + self.direction - self.rv * self.width / 2 - self.uv * self.height / 2;
        return self;
    }

    pub fn correspondingRay(self: *const Eye, frame_size: [2]usize, pixel: [2]usize) Ray {
        var pixel_pos = self.ld;

        var temp_rv = self.rv;
        temp_rv.multiply(@as(f32, @floatFromInt(pixel[0])) / @as(f32, @floatFromInt(frame_size[0])) * self.width);
        pixel_pos.add(temp_rv);

        var temp_uv = self.uv;
        temp_uv.multiply(@as(f32, @floatFromInt(pixel[1])) / @as(f32, @floatFromInt(frame_size[1])) * self.height);
        pixel_pos.add(temp_uv);

        var direction = pixel_pos;
        direction.sub(self.position);
        direction.normalize();

        return Ray{
            .position = self.position,
            .direction = direction,
        };
    }
};
pub fn createLookAt(position: Vector, target: Vector, up: Vector, aspect_ratio: f32, field_of_view: f32) Eye {
    var direction = target;
    direction.sub(position);
    direction.normalize();

    return Eye.init(position, direction, up, aspect_ratio, field_of_view);
}

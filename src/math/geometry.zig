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
pub fn cross(a: Vector, b: Vector) Vector {
    return Vector{
        .x = a.y * b.z - a.z * b.y,
        .y = a.z * b.x - a.x * b.z,
        .z = a.x * b.y - a.y * b.x,
    };
}

pub const Ray = struct {
    position: Vector,
    direction: Vector,

    pub fn init(self: *Ray, position: Vector, direction: Vector) void {
        self.position = position;
        self.direction = direction;
    }
};

pub const Plane = struct {
    normal: Vector,
    intercept: Vector,

    pub fn init(self: *Plane, normal: Vector, intercept: Vector) void {
        self.normal = normal;
        self.intercept = intercept;
    }

    pub fn intersection(self: *Plane, ray: Ray) ?f32 {
        const div = dot(ray.direction, self.normal);
        if (div == 0) return null;

        const temp = dot(ray.position, self.normal);
        const t = -(temp + self.intercept) / div;

        return if (t > 0) t else null;
    }
};

pub const Sphere = struct {
    position: Vector,
    radius: f32,

    pub fn init(self: *Sphere, position: Vector, radius: f32) void {
        self.position = position;
        self.radius = radius;
    }
    pub fn intersection(self: *Sphere, ray: Ray) ?f32 {
        self.position.sub(ray.position);
        const tca = dot(self.position, ray.direction);

        if (tca < 0) return null;

        var d2 = dot(self.position, self.position);
        d2 -= tca * tca;

        if (d2 > self.radius * self.radius) return null;

        const thc = @sqrt(self.radius * self.radius - d2);
        const ret = @min(tca - thc, tca + thc);

        return if (ret < 0) null else ret;
    }
};

pub const Triangle = struct {
    a: f32,
    b: f32,
    c: f32,

    pub fn init(self: *Triangle, a: f32, b: f32, c: f32) void {
        self.a = a;
        self.b = b;
        self.c = c;
    }
};
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
test "sphere intersection" {
    var sphere = Sphere{
        .position = Vector{ .x = 0, .y = 0, .z = 5 },
        .radius = 1.0,
    };

    // Ray that should hit the sphere
    const hit_ray = Ray{
        .position = Vector{ .x = 0, .y = 0, .z = 0 },
        .direction = Vector{ .x = 0, .y = 0, .z = 1 },
    };

    // Ray that should miss the sphere
    const miss_ray = Ray{
        .position = Vector{ .x = 2, .y = 0, .z = 0 },
        .direction = Vector{ .x = 0, .y = 0, .z = 1 },
    };

    if (sphere.intersection(hit_ray)) |t| {
        try expect_approx(t, 4.0, 0.001); // Should hit at z=4 (5-1)
    } else {
        try expect(false); // Should not reach here
    }

    try expect(sphere.intersection(miss_ray) == null);
}

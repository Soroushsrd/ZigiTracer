const Color = @import("../color.zig").Color;
const Vector = @import("../math/geometry.zig").Vector;
pub const Light = struct {
    color: Color,
    pub fn init(color: Color) Light {
        return Light{ .color = color };
    }
};

pub const AmbientLight = struct {
    base: Light,
    pub fn init(color: Color) AmbientLight {
        return AmbientLight{ .base = Light.init(color) };
    }
};

pub const DirectionalLight = struct {
    base: Light,
    direction: Vector,
    intensity: Vector,

    pub fn init(color: Color, direction: Vector, intenstiy: Vector) DirectionalLight {
        return DirectionalLight{
            .base = Light.init(color),
            .direction = direction,
            .intensity = intenstiy,
        };
    }
};

pub const PointLight = struct {
    base: Light,
    position: Vector,
    intensity: Vector,
    atten_factors: Vector,

    pub fn init(color: Color, position: Vector, intensity: Vector, atten_factors: Vector) PointLight {
        return PointLight{
            .base = Light.init(color),
            .position = position,
            .intensity = intensity,
            .atten_factors = atten_factors,
        };
    }
};

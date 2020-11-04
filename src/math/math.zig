const std = @import("std");

pub const pi = std.math.pi;
pub const pi_over_2 = std.math.pi / 2.0;

// 3 row, 2 col 2D matrix
//  m[0] m[2] m[4]
//  m[1] m[3] m[5]
//
//  0: scaleX    2: sin       4: transX
//  1: cos       3: scaleY    5: transY
//
pub const Mat32 = struct {
    data: [6]f32 = undefined,

    pub fn initOrthoInverted(width: f32, height: f32) Mat32 {
        var result = Mat32{};
        result.data[0] = 2 / width;
        result.data[3] = -2 / height;
        result.data[4] = -1;
        result.data[5] = 1;
        return result;
    }

    pub fn initOrtho(width: f32, height: f32) Mat32 {
        var result = Mat32{};
        result.data[0] = 2 / width;
        result.data[3] = 2 / height;
        result.data[4] = -1;
        result.data[5] = -1;
        return result;
    }
};

pub const Vec2 = extern struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const Color = extern union {
    value: u32,
    comps: packed struct {
        r: u8,
        g: u8,
        b: u8,
        a: u8,
    },

    pub fn asArray(self: Color) [4]f32 {
        return [_]f32{
            @intToFloat(f32, self.comps.r) / 255,
            @intToFloat(f32, self.comps.g) / 255,
            @intToFloat(f32, self.comps.b) / 255,
            @intToFloat(f32, self.comps.a) / 255,
        };
    }

    pub const white = Color{ .value = 0xFFFFFFFF };
    pub const black = Color{ .value = 0xFF000000 };
    pub const transparent = Color{ .comps = .{ .r = 0, .g = 0, .b = 0, .a = 0 } };
    pub const aya = Color{ .comps = .{ .r = 204, .g = 51, .b = 77, .a = 255 } };
    pub const light_gray = Color{ .comps = .{ .r = 200, .g = 200, .b = 200, .a = 255 } };
    pub const gray = Color{ .comps = .{ .r = 130, .g = 130, .b = 130, .a = 255 } };
    pub const dark_gray = Color{ .comps = .{ .r = 80, .g = 80, .b = 80, .a = 255 } };
    pub const yellow = Color{ .comps = .{ .r = 253, .g = 249, .b = 0, .a = 255 } };
    pub const gold = Color{ .comps = .{ .r = 255, .g = 203, .b = 0, .a = 255 } };
    pub const orange = Color{ .comps = .{ .r = 255, .g = 161, .b = 0, .a = 255 } };
    pub const pink = Color{ .comps = .{ .r = 255, .g = 109, .b = 194, .a = 255 } };
    pub const red = Color{ .comps = .{ .r = 230, .g = 41, .b = 55, .a = 255 } };
    pub const maroon = Color{ .comps = .{ .r = 190, .g = 33, .b = 55, .a = 255 } };
    pub const green = Color{ .comps = .{ .r = 0, .g = 228, .b = 48, .a = 255 } };
    pub const lime = Color{ .comps = .{ .r = 0, .g = 158, .b = 47, .a = 255 } };
    pub const dark_green = Color{ .comps = .{ .r = 0, .g = 117, .b = 44, .a = 255 } };
    pub const sky_blue = Color{ .comps = .{ .r = 102, .g = 191, .b = 255, .a = 255 } };
    pub const blue = Color{ .comps = .{ .r = 0, .g = 121, .b = 241, .a = 255 } };
    pub const dark_blue = Color{ .comps = .{ .r = 0, .g = 82, .b = 172, .a = 255 } };
    pub const purple = Color{ .comps = .{ .r = 200, .g = 122, .b = 255, .a = 255 } };
    pub const voilet = Color{ .comps = .{ .r = 135, .g = 60, .b = 190, .a = 255 } };
    pub const dark_purple = Color{ .comps = .{ .r = 112, .g = 31, .b = 126, .a = 255 } };
    pub const beige = Color{ .comps = .{ .r = 211, .g = 176, .b = 131, .a = 255 } };
    pub const brown = Color{ .comps = .{ .r = 127, .g = 106, .b = 79, .a = 255 } };
    pub const dark_brown = Color{ .comps = .{ .r = 76, .g = 63, .b = 47, .a = 255 } };
    pub const magenta = Color{ .comps = .{ .r = 255, .g = 0, .b = 255, .a = 255 } };
};

const std = @import("std");
const gfx = @import("../gfx.zig");

// api that isnt renderer specific can be put here then "imported" into the per-renderer types

pub const Texture = struct {
    pub fn initWithColorData(pixels: []u32, width: i32, height: i32) gfx.Texture {
        var texture = gfx.Texture.init();
        texture.setColorData(width, height, pixels.ptr);
        return texture;
    }

    pub fn initCheckerTexture() gfx.Texture {
        var pixels = [_]u32{
            0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
            0xFF000000, 0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF,
            0xFFFFFFFF, 0xFF000000, 0xFFFFFFFF, 0xFF000000,
            0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF,
        };

        return initWithColorData(&pixels, 4, 4);
    }

    pub fn initSingleColor(color: u32) gfx.Texture {
        var pixels: [16]u32 = undefined;
        std.mem.set(u32, &pixels, color);
        return initWithColorData(pixels[0..], 4, 4);
    }
};

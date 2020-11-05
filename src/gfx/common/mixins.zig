const std = @import("std");
const fs = @import("../fs.zig");
const gfx = @import("../gfx.zig");
const stb_image = @import("stb_image");

// api that isnt renderer specific can be put here then "imported" into the per-renderer types

pub const Texture = struct {
    pub fn initFromFile(allocator: *std.mem.Allocator, file: []const u8, filter: gfx.TextureFilter) !gfx.Texture {
        const image_contents = try fs.read(allocator, file);
        errdefer allocator.free(image_contents);

        var w: c_int = undefined;
        var h: c_int = undefined;
        var channels: c_int = undefined;
        const load_res = stb_image.stbi_load_from_memory(image_contents.ptr, @intCast(c_int, image_contents.len), &w, &h, &channels, 4);
        if (load_res == null) return error.ImageLoadFailed;
        defer stb_image.stbi_image_free(load_res);

        var tex = gfx.Texture.initWithOptions(filter, .clamp);
        tex.setData(w, h, load_res[0..@intCast(usize, w * h * channels)]);
        return tex;
    }

    pub fn initWithColorData(pixels: []u32, width: i32, height: i32) gfx.Texture {
        var texture = gfx.Texture.init();
        texture.setColorData(width, height, pixels);
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

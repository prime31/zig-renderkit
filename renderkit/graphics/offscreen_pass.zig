const std = @import("std");
const renderkit = @import("../renderkit.zig");
const renderer = renderkit.renderer;

pub const OffscreenPass = struct {
    pass: renderkit.Pass,
    color_texture: renderkit.Texture,
    depth_stencil_texture: ?renderkit.Texture = null,

    pub fn init(width: i32, height: i32) OffscreenPass {
        return initWithOptions(width, height, .nearest, .clamp);
    }

    pub fn initWithOptions(width: i32, height: i32, filter: renderkit.TextureFilter, wrap: renderkit.TextureWrap) OffscreenPass {
        const color_tex = renderkit.Texture.initOffscreen(width, height, filter, wrap);

        const pass = renderer.createPass(.{
            .color_img = color_tex.img,
        });
        return .{ .pass = pass, .color_texture = color_tex };
    }

    pub fn initWithStencil(width: i32, height: i32, filter: renderkit.TextureFilter, wrap: renderkit.TextureWrap) OffscreenPass {
        const color_tex = renderkit.Texture.initOffscreen(width, height, filter, wrap);
        const depth_stencil_img = renderkit.Texture.initStencil(width, height, filter, wrap);

        const pass = renderer.createPass(.{
            .color_img = color_tex.img,
            .depth_stencil_img = depth_stencil_img.img,
        });
        return .{ .pass = pass, .color_texture = color_tex, .depth_stencil_texture = depth_stencil_img };
    }

    pub fn deinit(self: *const OffscreenPass) void {
        // Pass MUST be destroyed first! It relies on the Textures being present.
        renderer.destroyPass(self.pass);
        self.color_texture.deinit();
        if (self.depth_stencil_texture) |depth_stencil| {
            depth_stencil.deinit();
        }
    }
};

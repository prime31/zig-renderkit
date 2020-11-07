const std = @import("std");
const backend = @import("backend");
const gfx = @import("../gfx.zig");

pub const RenderTexture = struct {
    pass: backend.OffscreenPass,
    color_texture: gfx.Texture,
    depth_stencil_texture: ?gfx.Texture = null,

    pub fn init(width: i32, height: i32) RenderTexture {
        return initWithOptions(width, height, .nearest, .clamp);
    }

    pub fn initWithOptions(width: i32, height: i32, filter: gfx.TextureFilter, wrap: gfx.TextureWrap) RenderTexture {
        const color_tex = gfx.Texture.initOffscreen(width, height, filter, wrap);

        const pass = backend.createOffscreenPass(.{
            .color_img = color_tex.img,
        });
        return .{ .pass = pass, .color_texture = color_tex };
    }

    pub fn initWithStencil(width: i32, height: i32, filter: gfx.TextureFilter, wrap: gfx.TextureWrap) RenderTexture {
        const color_tex = gfx.Texture.initOffscreen(width, height, filter, wrap);
        const depth_stencil_img = gfx.Texture.initStencil(width, height, filter, wrap);

        const pass = backend.createOffscreenPass(.{
            .color_img = color_tex.img,
            .depth_stencil_img = depth_stencil_img.img,
        });
        return .{ .pass = pass, .color_texture = color_tex, .depth_stencil_texture = depth_stencil_img };
    }

    pub fn deinit(self: *const RenderTexture) void {
        // OffscreenPass MUST be destroyed first! It relies on the Textures being present.
        backend.destroyOffscreenPass(self.pass);
        self.color_texture.deinit();
        if (self.depth_stencil_texture) |depth_stencil| {
            depth_stencil.deinit();
        }
    }

    pub fn bind(self: *RenderTexture) void {
        backend.beginOffscreenPass(self.pass);
    }

    pub fn unbind(self: *RenderTexture) void {
        backend.endOffscreenPass(self.pass);
    }
};

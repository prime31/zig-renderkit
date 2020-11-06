const std = @import("std");
const backend = @import("backend");
const gfx = @import("../gfx.zig");

pub const RenderTexture = struct {
    pass: backend.OffscreenPass,
    texture: gfx.Texture,

    pub fn init(width: i32, height: i32) RenderTexture {
        return initWithOptions(width, height, .nearest, .clamp);
    }

    pub fn initWithOptions(width: i32, height: i32, filter: gfx.TextureFilter, wrap: gfx.TextureWrap) RenderTexture {
        const color_tex = gfx.Texture.initOffscreen(width, height, filter, wrap);

        const pass = backend.createOffscreenPass(.{
            .color_img = color_tex.img,
        });
        return .{ .pass = pass, .texture = color_tex };
    }

    pub fn initWithStencil(width: i32, height: i32, filter: gfx.TextureFilter, wrap: gfx.TextureWrap) RenderTexture {
        const color_tex = gfx.Texture.initOffscreen(width, height, filter, wrap);
        const depth_stencil_img = gfx.Texture.initStencil(width, height, filter, wrap);

        const pass = backend.createOffscreenPass(.{
            .color_img = color_tex.img,
            .depth_stencil_img = depth_stencil_img,
        });
        return .{ .pass = pass, .texture = color_tex };
    }

    pub fn deinit(self: *const RenderTexture) void {
        backend.destroyImage(self.pass.color_img);
        if (self.pass.depth_stencil_img) |depth_stencil_img| backend.destroyImage(depth_stencil_img);
        backend.destroyOffscreenPass(self.pass);
    }

    pub fn bind(self: *RenderTexture) void {
        backend.beginOffscreenPass(self.pass);
    }

    pub fn unbind(self: *RenderTexture) void {
        backend.endOffscreenPass(self.pass);
    }
};

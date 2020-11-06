const std = @import("std");
const gfx = @import("types.zig");
const backend = @import("backend.zig");

pub const RendererDesc = struct {
    gl_loader: ?fn ([*c]const u8) callconv(.C) ?*c_void = null,
};

pub const ImageDesc = struct {
    render_target: bool = false,
    width: i32,
    height: i32,
    usage: gfx.Usage = .immutable,
    pixel_format: gfx.PixelFormat = .rgba,
    min_filter: gfx.TextureFilter = .nearest,
    mag_filter: gfx.TextureFilter = .nearest,
    wrap_u: gfx.TextureWrap = .clamp,
    wrap_v: gfx.TextureWrap = .clamp,
    content: ?[]const u8 = null,
};

pub const OffscreenPassDesc = struct {
    color_img: backend.Image,
    depth_stencil_img: ?backend.Image = null,
};

pub fn BufferDesc(comptime T: type) type {
    return struct {
        size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
        type: gfx.BufferType = .vertex,
        usage: gfx.Usage = .immutable,
        content: ?[]const T = null,

        pub fn getSize(self: @This()) c_long {
            std.debug.assert(self.usage != .immutable or self.content != null);
            std.debug.assert(self.size > 0 or self.content != null);

            if (self.content) |con| return @intCast(c_long, con.len * @sizeOf(T));
            return self.size;
        }
    };
}

pub const ShaderDesc = struct {
    vs: [:0]const u8,
    fs: [:0]const u8,
    images: []const [:0]const u8,
};

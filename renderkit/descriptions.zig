const std = @import("std");
const renderkit = @import("types.zig");

pub const RendererDesc = struct {
    const PoolSizes = extern struct {
        texture: u8 = 64,
        offscreen_pass: u8 = 8,
        buffers: u8 = 16,
        shaders: u8 = 16,
    };

    gl_loader: ?*const fn ([*c]const u8) callconv(.C) ?*anyopaque = null,
    disable_vsync: bool = false,
    pool_sizes: PoolSizes = .{},
};

pub const ImageDesc = extern struct {
    render_target: bool = false,
    width: i32,
    height: i32,
    usage: renderkit.Usage = .immutable,
    pixel_format: renderkit.PixelFormat = .rgba8,
    min_filter: renderkit.TextureFilter = .nearest,
    mag_filter: renderkit.TextureFilter = .nearest,
    wrap_u: renderkit.TextureWrap = .clamp,
    wrap_v: renderkit.TextureWrap = .clamp,
    content: ?*const anyopaque = null,
};

pub const PassDesc = struct {
    color_img: renderkit.Image,
    color_img2: ?renderkit.Image = null,
    color_img3: ?renderkit.Image = null,
    color_img4: ?renderkit.Image = null,
    depth_stencil_img: ?renderkit.Image = null,
};

/// whether the pointer is advanced "per vertex" or "per instance". The latter is used for instanced rendering.
pub const VertexStep = enum(c_int) {
    per_vertex,
    per_instance,
};

pub fn BufferDesc(comptime T: type) type {
    return struct {
        size: c_long = 0, // either size (for stream buffers) or content (for static/dynamic) must be set
        type: renderkit.BufferType = .vertex,
        usage: renderkit.Usage = .immutable,
        content: ?[]const T = null,
        step_func: VertexStep = .per_vertex, // step function used for instanced drawing

        pub fn getSize(self: @This()) c_long {
            std.debug.assert(self.usage != .immutable or self.content != null);
            std.debug.assert(self.size > 0 or self.content != null);

            if (self.content) |con| return @as(c_long, @intCast(con.len * @sizeOf(T)));
            return self.size;
        }
    };
}

pub const ShaderDesc = struct {
    vs: [:0]const u8,
    fs: [:0]const u8,
};

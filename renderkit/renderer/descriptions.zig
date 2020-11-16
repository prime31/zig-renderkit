const std = @import("std");
const renderkit = @import("types.zig");

pub const MetalSetup = extern struct {
    ca_layer: ?*const c_void = null,
};

pub const RendererDesc = extern struct {
    const PoolSizes = extern struct {
        texture: u8 = 64,
        offscreen_pass: u8 = 8,
        buffers: u8 = 16,
        shaders: u8 = 16,
    };

    allocator: *std.mem.Allocator,
    gl_loader: ?fn ([*c]const u8) callconv(.C) ?*c_void = null,
    pool_sizes: PoolSizes = .{},
    metal: MetalSetup = .{},
};

pub const ImageDesc = extern struct {
    render_target: bool = false,
    width: i32,
    height: i32,
    usage: renderkit.Usage = .immutable,
    pixel_format: renderkit.PixelFormat = .rgba,
    min_filter: renderkit.TextureFilter = .nearest,
    mag_filter: renderkit.TextureFilter = .nearest,
    wrap_u: renderkit.TextureWrap = .clamp,
    wrap_v: renderkit.TextureWrap = .clamp,
    content: ?*const c_void = null,
};

pub const PassDesc = struct {
    color_img: renderkit.Image,
    depth_stencil_img: ?renderkit.Image = null,
};

/// whether the pointer is advanced "per vertex" or "per instance". The latter is used for instanced rendering.
pub const VertexStep = enum {
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

            if (self.content) |con| return @intCast(c_long, con.len * @sizeOf(T));
            return self.size;
        }
    };
}

pub const ShaderDesc = struct {
    vs: [:0]const u8,
    fs: [:0]const u8,
    images: []const [:0]const u8 = &[_][:0]const u8{},
};

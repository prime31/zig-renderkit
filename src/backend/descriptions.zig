const gfx = @import("types.zig");

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
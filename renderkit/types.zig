const std = @import("std");

/// all resources are guaranteed to never have a handle of 0
pub const invalid_resource_id: u16 = 0;

pub const Image = u16;
pub const ShaderProgram = u16;
pub const Pass = u16;
pub const Buffer = u16;

pub const UniformType = enum(c_int) {
    float,
    float2,
    float3,
    float4,
};

pub const TextureFilter = enum(c_int) {
    nearest,
    linear,
};

pub const TextureWrap = enum(c_int) {
    clamp,
    repeat,
};

pub const PixelFormat = enum(c_int) {
    rgba8,
    stencil,
    depth_stencil,
};

pub const Usage = enum(c_int) {
    immutable,
    dynamic,
    stream,
};

pub const BufferType = enum(c_int) {
    vertex,
    index,
};

pub const ShaderStage = enum(c_int) {
    fs,
    vs,
};

pub const PrimitiveType = enum(c_int) {
    points,
    line_strip,
    lines,
    triangle_strip,
    triangles,
};

pub const ElementType = enum(c_int) {
    u8,
    u16,
    u32,
};

pub const CompareFunc = enum(c_int) {
    never,
    less,
    equal,
    less_equal,
    greater,
    not_equal,
    greater_equal,
    always,
};

pub const StencilOp = enum(c_int) {
    keep,
    zero,
    replace,
    incr_clamp,
    decr_clamp,
    invert,
    incr_wrap,
    decr_wrap,
};

pub const BlendFactor = enum(c_int) {
    zero,
    one,
    src_color,
    one_minus_src_color,
    src_alpha,
    one_minus_src_alpha,
    dst_color,
    one_minus_dst_color,
    dst_alpha,
    one_minus_dst_alpha,
    src_alpha_saturated,
    blend_color,
    one_minus_blend_color,
    blend_alpha,
    one_minus_blend_alpha,
};

pub const CullMode = enum(c_int) {
    none,
    front,
    back,
};

pub const FaceWinding = enum(c_int) {
    ccw,
    cw,
};

pub const BlendOp = enum(c_int) {
    add,
    subtract,
    reverse_subtract,
};

pub const ColorMask = enum(u32) {
    none,
    r = (1 << 0),
    g = (1 << 1),
    b = (1 << 2),
    a = (1 << 3),
    rgb = 0x7,
    rgba = 0xF,
    force_u32 = 0x7FFFFFFF,
};

pub const RenderState = extern struct {
    const Depth = extern struct {
        enabled: bool = false,
        compare_func: CompareFunc = .always,
    };
    const Stencil = extern struct {
        enabled: bool = true,
        write_mask: u8 = 0xFF, // glStencilMask
        fail_op: StencilOp = .keep, // glStencilOp
        depth_fail_op: StencilOp = .keep, // glStencilOp
        pass_op: StencilOp = .replace, // glStencilOp
        compare_func: CompareFunc = .always, // glStencilFunc
        ref: u8 = 0, // glStencilFunc
        read_mask: u8 = 0xFF, // glStencilFunc
    };
    const Blend = extern struct {
        enabled: bool = true,
        src_factor_rgb: BlendFactor = .src_alpha,
        dst_factor_rgb: BlendFactor = .one_minus_src_alpha,
        op_rgb: BlendOp = .add,
        src_factor_alpha: BlendFactor = .one,
        dst_factor_alpha: BlendFactor = .one_minus_src_alpha,
        op_alpha: BlendOp = .add,
        color_write_mask: ColorMask = .rgba,
        color: [4]f32 = [_]f32{ 0, 0, 0, 0 },
    };

    depth: Depth = .{},
    stencil: Stencil = .{},
    blend: Blend = .{},
    scissor: bool = false,
    cull_mode: CullMode = .none,
    face_winding: FaceWinding = .ccw,
};

pub const ClearCommand = extern struct {
    pub const ColorAttachmentAction = extern struct {
        clear: bool = true,
        color: [4]f32 = [_]f32{ 0.8, 0.2, 0.3, 1.0 },
    };

    colors: [4]ColorAttachmentAction = [_]ColorAttachmentAction{.{}} ** 4,
    clear_stencil: bool = false,
    stencil: u8 = 0,
    clear_depth: bool = false,
    depth: f64 = 1,
};

pub const BufferBindings = struct {
    index_buffer: Buffer,
    vert_buffers: [4]Buffer,
    index_buffer_offset: u32 = 0,
    vertex_buffer_offsets: [4]u32 = [_]u32{0} ** 4,
    images: [8]Image = [_]Image{0} ** 8,

    pub fn init(index_buffer: Buffer, vert_buffers: []Buffer) BufferBindings {
        var vbuffers: [4]Buffer = [_]Buffer{0} ** 4;
        for (vert_buffers, 0..) |vb, i| vbuffers[i] = vb;

        return .{
            .index_buffer = index_buffer,
            .vert_buffers = vbuffers,
        };
    }

    pub fn bindImage(self: *BufferBindings, image: Image, slot: c_uint) void {
        self.images[slot] = image;
    }

    pub fn eq(self: BufferBindings, other: BufferBindings) bool {
        return self.index_buffer == other.index_buffer and
            std.mem.eql(Buffer, &self.vert_buffers, &other.vert_buffers) and
            std.mem.eql(u32, &self.vertex_buffer_offsets, &other.vertex_buffer_offsets) and
            std.mem.eql(Image, &self.images, &other.images);
    }
};

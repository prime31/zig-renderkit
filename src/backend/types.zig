const Color = @import("../math/math.zig").Color;

pub const TextureFilter = enum {
    nearest,
    linear,
};

pub const TextureWrap = enum {
    clamp,
    repeat,
};

pub const VertexBufferUsage = enum {
    stream_draw,
    static_draw,
    dynamic_draw,
};

pub const PrimitiveType = enum {
    points,
    line_strip,
    lines,
    triangle_strip,
    triangles,
};

pub const ElementType = enum {
    u8,
    u16,
    u32,
};

pub const CompareFunc = enum {
    never,
    less,
    equal,
    less_equal,
    greater,
    not_equal,
    greater_equal,
    always,
};

pub const StencilOp = enum {
    keep,
    zero,
    replace,
    incr_clamp,
    decr_clamp,
    invert,
    incr_wrap,
    decr_wrap,
};

pub const BlendFactor = enum {
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

pub const BlendOp = enum {
    add,
    subtract,
    reverse_subtract,
};

pub const ClearAction = enum {
    clear,
    dontcare,
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

pub const RenderState = struct {
    depth: struct {
        enabled: bool = false,
        compare_func: CompareFunc = .always,
    } = .{},
    stencil: struct {
        enabled: bool = false,
        fail_op: StencilOp = .keep,
        depth_fail_op: StencilOp = .keep,
        pass_op: StencilOp = .keep,
        compare_func: CompareFunc = .always,
        read_mask: u8 = 0,
        write_mask: u8 = 0,
        ref: u8 = 0,
    } = .{},
    blend: struct {
        enabled: bool = true,
        src_factor_rgb: BlendFactor = .src_alpha,
        dst_factor_rgb: BlendFactor = .one_minus_src_alpha,
        op_rgb: BlendOp = .add,
        src_factor_alpha: BlendFactor = .one,
        dst_factor_alpha: BlendFactor = .one_minus_src_alpha,
        op_alpha: BlendOp = .add,
        color_write_mask: ColorMask = .rgba,
        color: struct { r: f32 = 0, g: f32 = 0, b: f32 = 0, a: f32 = 0 } = .{},
    } = .{},
    scissor: bool = false,
};

pub const ClearCommand = struct {
    color_action: ClearAction = .clear,
    color: Color = Color.aya,
    stencil_action: ClearAction = .dontcare,
    stencil: u8 = 0,
    depth_action: ClearAction = .dontcare,
    depth: f64 = 0,
};
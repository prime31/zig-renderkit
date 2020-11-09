pub const Image = u16;
pub const ShaderProgram = u16;
pub const BufferBindings = u16;
pub const Pass = u16;
pub const Buffer = u16;

pub const TextureFilter = extern enum {
    nearest,
    linear,
};

pub const TextureWrap = extern enum {
    clamp,
    repeat,
};

pub const PixelFormat = extern enum {
    rgba,
    stencil,
    depth_stencil,
};

pub const Usage = extern enum {
    immutable,
    dynamic,
    stream,
};

pub const BufferType = extern enum {
    vertex,
    index,
};

pub const VertexBufferUsage = extern enum {
    stream_draw,
    static_draw,
    dynamic_draw,
};

pub const PrimitiveType = extern enum {
    points,
    line_strip,
    lines,
    triangle_strip,
    triangles,
};

pub const ElementType = extern enum {
    u8,
    u16,
    u32,
};

pub const CompareFunc = extern enum {
    never,
    less,
    equal,
    less_equal,
    greater,
    not_equal,
    greater_equal,
    always,
};

pub const StencilOp = extern enum {
    keep,
    zero,
    replace,
    incr_clamp,
    decr_clamp,
    invert,
    incr_wrap,
    decr_wrap,
};

pub const BlendFactor = extern enum {
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

pub const BlendOp = extern enum {
    add,
    subtract,
    reverse_subtract,
};

pub const ClearAction = extern enum {
    clear,
    dont_care, // if all the render target pixels are rendered to, choose the DontCare action
    load, // if the previous contents of the render target need to be preserved and only some of its pixels are rendered to, choose the load action
};

pub const ColorMask = extern enum(u32) {
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
        enabled: bool = false,
        fail_op: StencilOp = .keep,
        depth_fail_op: StencilOp = .keep,
        pass_op: StencilOp = .keep,
        compare_func: CompareFunc = .always,
        read_mask: u8 = 0,
        write_mask: u8 = 0,
        ref: u8 = 0,
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
};

pub const ClearCommand = extern struct {
    color_action: ClearAction = .clear,
    color: [4]f32 = [_]f32{ 0.8, 0.2, 0.3, 1.0 },
    stencil_action: ClearAction = .dont_care,
    stencil: u8 = 0,
    depth_action: ClearAction = .dont_care,
    depth: f64 = 0,
};

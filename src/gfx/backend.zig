

pub const VertexBufferUsage = enum {
    stream_draw,
    static_draw,
    dynamic_draw,
};

pub const PrimitiveType = enum {
    points,
    line_strip,
    line_loop,
    lines,
    triangle_strip,
    triangle_fan,
    triangles,
};

pub const ElementType = enum {
    u8,
    u16,
    u32,
};

pub const Capabilities = enum {
    blend,
    cull_face,
    depth_test,
    dither,
    polygon_offset_fill,
    sample_alpha_to_coverage,
    sample_coverage,
    scissor_test,
    stencil_test,
};

pub const Renderer = enum {
    dummy,
    opengl,
    metal,
    directx11,
};

// pub const backend = @import(@tagName(aya.renderer) ++ "/backend.zig"); // zls cant auto-complete these
pub const backend = @import("opengl/backend.zig"); // hardcoded for now to zls can complete it

// the backend must provide all of the following types/funcs
pub fn init() void {
    backend.init();
}

pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {
    backend.initWithLoader(loader);
}

pub fn enableState(state: Capabilities) void {
    backend.enableState(state);
}

pub fn disableState(state: Capabilities) void {
    backend.disableState(state);
}

pub const TextureId = backend.TextureId;
pub const Texture = backend.Texture;
pub const RenderTexture = backend.RenderTexture;

pub const VertexBuffer = backend.VertexBuffer;
pub const IndexBuffer = backend.IndexBuffer;

pub const Mesh = backend.Mesh;
pub const DynamicMesh = backend.DynamicMesh;

pub const Shader = backend.Shader;
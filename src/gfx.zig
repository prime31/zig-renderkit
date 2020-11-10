// export all the types and descriptors for ease of use
pub const renderer = @import("renderer/renderer.zig");
pub usingnamespace renderer.gfx_types;
pub usingnamespace renderer.descriptions;

// search path: root.build_options, root.renderer, default
pub const current_renderer: Renderer = if (@hasDecl(@import("root"), "build_options")) blk: {
    break :blk @field(@import("root"), "build_options").renderer;
} else if (@hasDecl(@import("root"), "renderer")) blk: {
    break :blk @field(@import("root"), "renderer");
} else blk: {
    break :blk Renderer.opengl;
};

// search path: root.build_options, root.enable_imgui, default
pub const has_imgui: bool = if (@hasDecl(@import("root"), "build_options")) blk: {
    break :blk @field(@import("root"), "build_options").enable_imgui;
} else if (@hasDecl(@import("root"), "enable_imgui")) blk: {
    break :blk @field(@import("root"), "enable_imgui");
} else blk: {
    break :blk false;
};


// export the backend only explicitly (leaving gfx object methods only accessible via renderer.METHOD)
// and some select, higher level types and methods
pub const Renderer = renderer.Renderer;
pub const setRenderState = renderer.setRenderState;
pub const viewport = renderer.viewport;
pub const scissor = renderer.scissor;
pub const beginDefaultPass = renderer.beginDefaultPass;
pub const beginPass = renderer.beginPass;
pub const endPass = renderer.endPass;
pub const commitFrame = renderer.commitFrame;
pub const bindImage = renderer.bindImage;

pub const math = @import("math/math.zig");
pub const fs = @import("fs.zig");

// high level wrapper objects that use the low-level backend api
pub const Texture = @import("gfx/texture.zig").Texture;
pub const OffscreenPass = @import("gfx/offscreen_pass.zig").OffscreenPass;
pub const Shader = @import("gfx/shader.zig").Shader;

//
pub const Mesh = @import("gfx/mesh.zig").Mesh;
pub const DynamicMesh = @import("gfx/mesh.zig").DynamicMesh;

pub const Batcher = @import("gfx/batcher.zig").Batcher;
pub const MultiBatcher = @import("gfx/multi_batcher.zig").MultiBatcher;
pub const TriangleBatcher = @import("gfx/triangle_batcher.zig").TriangleBatcher;

pub const Vertex = extern struct {
    pos: math.Vec2 = .{ .x = 0, .y = 0 },
    uv: math.Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};
// export all the types and descriptors for ease of use
pub const renderer = @import("renderer/renderer.zig");
pub usingnamespace renderer.renderkit_types;
pub usingnamespace renderer.descriptions;

// search path: root.build_options, root.renderer, default
pub const current_renderer: Renderer = if (@hasDecl(@import("root"), "build_options")) blk: {
    break :blk @field(@import("root"), "build_options").renderer;
} else if (@hasDecl(@import("root"), "renderer")) blk: {
    break :blk @field(@import("root"), "renderer");
} else blk: {
    break :blk Renderer.opengl;
};

// export the backend only explicitly (leaving gfx object methods only accessible via renderer.METHOD)
// and some select, higher level types and methods
pub const Renderer = renderer.Renderer;
pub const setRenderState = renderer.setRenderState;
pub const viewport = renderer.viewport;
pub const scissor = renderer.scissor;

/// returns the file extension for shaders as provided by the shader compiler for the current renderer.
/// The extension includes the "."
pub fn shaderFileExtension() []const u8 {
    return switch(current_renderer) {
        .opengl => ".glsl",
        .metal => ".metal",
        else => @panic("Not implemented yet"),
    };
}
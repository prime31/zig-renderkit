const std = @import("std");
const aya = @import("../../runner.zig");
const gfx = aya.gfx;
usingnamespace @import("gl_decls.zig");

usingnamespace @import("buffers.zig");
usingnamespace @import("shader.zig");
usingnamespace @import("textures.zig");

fn capabilitiesToGl(state: gfx.Capabilities) GLenum {
    return switch (state) {
        .blend => GL_BLEND,
        .cull_face => GL_CULL_FACE,
        .depth_test => GL_DEPTH_TEST,
        .dither => GL_DITHER,
        .polygon_offset_fill => GL_POLYGON_OFFSET_FILL,
        .sample_alpha_to_coverage => GL_SAMPLE_ALPHA_TO_COVERAGE,
        .sample_coverage => GL_SAMPLE_COVERAGE,
        .scissor_test => GL_SCISSOR_TEST,
        .stencil_test => GL_STENCIL_TEST,
    };
}

pub fn init() void {
    loadFunctionsZig();
}

pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {
    loadFunctions(loader);
}

pub fn enableState(state: gfx.Capabilities) void {
    glEnable(capabilitiesToGl(state));
}

pub fn disableState(state: gfx.Capabilities) void {
    glDisable(capabilitiesToGl(state));
}

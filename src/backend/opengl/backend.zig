const std = @import("std");
const gfx = @import("../types.zig");
usingnamespace @import("gl_decls.zig");

usingnamespace @import("api.zig");

const RendererDesc = @import("../descriptions.zig").RendererDesc;

var pip_cache: gfx.RenderState = undefined;

pub fn setup(desc: RendererDesc) void {
    if (desc.gl_loader) |loader| {
        loadFunctions(loader);
    } else {
        loadFunctionsZig();
    }
}

pub fn setRenderState(state: gfx.RenderState) void {
    // depth
    if (state.depth.enabled != pip_cache.depth.enabled) {
        glDepthMask(if (state.depth.enabled) 1 else 0);
        pip_cache.depth.enabled = state.depth.enabled;
    }

    if (state.depth.compare_func != pip_cache.depth.compare_func) {
        glDepthFunc(compareFuncToGl(state.depth.compare_func));
        pip_cache.depth.compare_func = state.depth.compare_func;
    }

    // stencil
    if (state.stencil.enabled != pip_cache.stencil.enabled) {
        if (state.stencil.enabled) glEnable(GL_STENCIL_TEST) else glDisable(GL_STENCIL_TEST);
        pip_cache.stencil.enabled = state.stencil.enabled;
    }

    // TODO: fix these when Zig can compile them and remove the full copy at the end of this method

    // if (state.stencil.write_mask != pip_cache.stencil.write_mask) {
    glStencilMask(@intCast(GLuint, state.stencil.write_mask));
    pip_cache.stencil = state.stencil;
    // pip_cache.stencil.write_mask = state.stencil.write_mask;
    // }

    // if (state.stencil.compare_func != pip_cache.stencil.compare_func or
    //     state.stencil.read_mask != pip_cache.stencil.read_mask or
    //     state.stencil.ref != pip_cache.stencil.ref) {
    glStencilFuncSeparate(GL_FRONT, compareFuncToGl(state.stencil.compare_func), @intCast(GLint, state.stencil.ref), @intCast(GLuint, state.stencil.read_mask));
    // }

    // if (state.stencil.fail_op != pip_cache.stencil.fail_op or
    //     state.stencil.depth_fail_op != pip_cache.stencil.depth_fail_op or
    //     state.stencil.pass_op != pip_cache.stencil.pass_op) {
    glStencilOpSeparate(GL_FRONT, stencilOpToGl(state.stencil.fail_op), stencilOpToGl(state.stencil.depth_fail_op), stencilOpToGl(state.stencil.pass_op));
    pip_cache.stencil.fail_op = state.stencil.fail_op;
    // pip_cache.stencil.depth_fail_op = state.stencil.depth_fail_op;
    // pip_cache.stencil.pass_op = state.stencil.pass_op;
    // }

    // // blend
    if (state.blend.enabled != pip_cache.blend.enabled) {
        if (state.blend.enabled) glEnable(GL_BLEND) else glDisable(GL_BLEND);
        pip_cache.blend.enabled = state.blend.enabled;
    }

    if (state.blend.src_factor_rgb != pip_cache.blend.src_factor_rgb or
        state.blend.dst_factor_rgb != pip_cache.blend.dst_factor_rgb or
        state.blend.src_factor_alpha != pip_cache.blend.src_factor_alpha or
        state.blend.dst_factor_alpha != pip_cache.blend.dst_factor_alpha)
    {
        glBlendFuncSeparate(blendFactorToGl(state.blend.src_factor_rgb), blendFactorToGl(state.blend.dst_factor_rgb), blendFactorToGl(state.blend.src_factor_alpha), blendFactorToGl(state.blend.dst_factor_alpha));
        pip_cache.blend.src_factor_rgb = state.blend.src_factor_rgb;
        pip_cache.blend.dst_factor_rgb = state.blend.dst_factor_rgb;
        pip_cache.blend.src_factor_alpha = state.blend.src_factor_alpha;
        pip_cache.blend.dst_factor_alpha = state.blend.dst_factor_alpha;
    }

    if (state.blend.op_rgb != pip_cache.blend.op_rgb or state.blend.op_alpha != pip_cache.blend.op_alpha) {
        glBlendEquationSeparate(blendOpToGl(state.blend.op_rgb), blendOpToGl(state.blend.op_alpha));
        pip_cache.blend.op_rgb = state.blend.op_rgb;
        pip_cache.blend.op_alpha = state.blend.op_alpha;
    }

    if (state.blend.color_write_mask != pip_cache.blend.color_write_mask) {
        const r = (@enumToInt(state.blend.color_write_mask) & @enumToInt(gfx.ColorMask.r)) != 0;
        const g = (@enumToInt(state.blend.color_write_mask) & @enumToInt(gfx.ColorMask.g)) != 0;
        const b = (@enumToInt(state.blend.color_write_mask) & @enumToInt(gfx.ColorMask.b)) != 0;
        const a = (@enumToInt(state.blend.color_write_mask) & @enumToInt(gfx.ColorMask.a)) != 0;
        glColorMask(if (r) 1 else 0, if (g) 1 else 0, if (b) 1 else 0, if (a) 1 else 0);
        pip_cache.blend.color_write_mask = state.blend.color_write_mask;
    }

    if (std.math.approxEq(f32, state.blend.color[0], pip_cache.blend.color[0], 0.0001) or
        std.math.approxEq(f32, state.blend.color[1], pip_cache.blend.color[1], 0.0001) or
        std.math.approxEq(f32, state.blend.color[2], pip_cache.blend.color[2], 0.0001) or
        std.math.approxEq(f32, state.blend.color[3], pip_cache.blend.color[3], 0.0001))
    {
        glBlendColor(state.blend.color[0], state.blend.color[1], state.blend.color[2], state.blend.color[3]);
        pip_cache.blend.color = state.blend.color;
    }

    // scissor
    if (state.scissor != pip_cache.scissor) {
        if (state.scissor) glEnable(GL_SCISSOR_TEST) else glDisable(GL_SCISSOR_TEST);
        pip_cache.scissor = state.scissor;
    }

    pip_cache = state;
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    glViewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    glScissor(x, y, width, height);
}

// translations from our enumsm to OpenGL
fn blendFactorToGl(state: gfx.BlendFactor) GLenum {
    return switch (state) {
        .zero => GL_ZERO,
        .one => GL_ONE,
        .src_color => GL_SRC_COLOR,
        .one_minus_src_color => GL_ONE_MINUS_SRC_COLOR,
        .src_alpha => GL_SRC_ALPHA,
        .one_minus_src_alpha => GL_ONE_MINUS_SRC_ALPHA,
        .dst_color => GL_DST_COLOR,
        .one_minus_dst_color => GL_ONE_MINUS_DST_COLOR,
        .dst_alpha => GL_ALPHA,
        .one_minus_dst_alpha => GL_ONE_MINUS_DST_ALPHA,
        .src_alpha_saturated => GL_SRC_ALPHA_SATURATE,
        .blend_color => GL_CONSTANT_COLOR,
        .one_minus_blend_color => GL_ONE_MINUS_CONSTANT_COLOR,
        .blend_alpha => GL_CONSTANT_ALPHA,
        .one_minus_blend_alpha => GL_ONE_MINUS_CONSTANT_ALPHA,
    };
}

fn compareFuncToGl(state: gfx.CompareFunc) GLenum {
    return switch (state) {
        .never => GL_NEVER,
        .less => GL_LESS,
        .equal => GL_EQUAL,
        .less_equal => GL_LEQUAL,
        .greater => GL_GREATER,
        .not_equal => GL_NOTEQUAL,
        .greater_equal => GL_GEQUAL,
        .always => GL_ALWAYS,
    };
}

fn stencilOpToGl(state: gfx.StencilOp) GLenum {
    return switch (state) {
        .keep => GL_KEEP,
        .zero => GL_ZERO,
        .replace => GL_REPLACE,
        .incr_clamp => GL_INCR,
        .decr_clamp => GL_DECR,
        .invert => GL_INVERT,
        .incr_wrap => GL_INCR_WRAP,
        .decr_wrap => GL_DECR_WRAP,
    };
}

fn blendOpToGl(state: gfx.BlendOp) GLenum {
    return switch (state) {
        .add => GL_FUNC_ADD,
        .subtract => GL_FUNC_SUBTRACT,
        .reverse_subtract => GL_FUNC_REVERSE_SUBTRACT,
    };
}

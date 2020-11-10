const renderkit = @import("../types.zig");
usingnamespace @import("gl_decls.zig");

// translations from our enums to OpenGL
pub fn blendFactorToGl(state: renderkit.BlendFactor) GLenum {
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

pub fn compareFuncToGl(state: renderkit.CompareFunc) GLenum {
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

pub fn stencilOpToGl(state: renderkit.StencilOp) GLenum {
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

pub fn blendOpToGl(state: renderkit.BlendOp) GLenum {
    return switch (state) {
        .add => GL_FUNC_ADD,
        .subtract => GL_FUNC_SUBTRACT,
        .reverse_subtract => GL_FUNC_REVERSE_SUBTRACT,
    };
}

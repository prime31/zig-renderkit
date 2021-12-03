const renderkit = @import("../types.zig");
const decls = @import("gl_decls.zig");
const GLenum = decls.GLenum;
const GLint = decls.GLint;
const GLuint = decls.GLuint;

// translations from our enums to OpenGL
pub fn blendFactorToGl(state: renderkit.BlendFactor) GLenum {
    return switch (state) {
        .zero => decls.GL_ZERO,
        .one => decls.GL_ONE,
        .src_color => decls.GL_SRC_COLOR,
        .one_minus_src_color => decls.GL_ONE_MINUS_SRC_COLOR,
        .src_alpha => decls.GL_SRC_ALPHA,
        .one_minus_src_alpha => decls.GL_ONE_MINUS_SRC_ALPHA,
        .dst_color => decls.GL_DST_COLOR,
        .one_minus_dst_color => decls.GL_ONE_MINUS_DST_COLOR,
        .dst_alpha => decls.GL_ALPHA,
        .one_minus_dst_alpha => decls.GL_ONE_MINUS_DST_ALPHA,
        .src_alpha_saturated => decls.GL_SRC_ALPHA_SATURATE,
        .blend_color => decls.GL_CONSTANT_COLOR,
        .one_minus_blend_color => decls.GL_ONE_MINUS_CONSTANT_COLOR,
        .blend_alpha => decls.GL_CONSTANT_ALPHA,
        .one_minus_blend_alpha => decls.GL_ONE_MINUS_CONSTANT_ALPHA,
    };
}

pub fn compareFuncToGl(state: renderkit.CompareFunc) GLenum {
    return switch (state) {
        .never => decls.GL_NEVER,
        .less => decls.GL_LESS,
        .equal => decls.GL_EQUAL,
        .less_equal => decls.GL_LEQUAL,
        .greater => decls.GL_GREATER,
        .not_equal => decls.GL_NOTEQUAL,
        .greater_equal => decls.GL_GEQUAL,
        .always => decls.GL_ALWAYS,
    };
}

pub fn stencilOpToGl(state: renderkit.StencilOp) GLenum {
    return switch (state) {
        .keep => decls.GL_KEEP,
        .zero => decls.GL_ZERO,
        .replace => decls.GL_REPLACE,
        .incr_clamp => decls.GL_INCR,
        .decr_clamp => decls.GL_DECR,
        .invert => decls.GL_INVERT,
        .incr_wrap => decls.GL_INCR_WRAP,
        .decr_wrap => decls.GL_DECR_WRAP,
    };
}

pub fn blendOpToGl(state: renderkit.BlendOp) GLenum {
    return switch (state) {
        .add => decls.GL_FUNC_ADD,
        .subtract => decls.GL_FUNC_SUBTRACT,
        .reverse_subtract => decls.GL_FUNC_REVERSE_SUBTRACT,
    };
}

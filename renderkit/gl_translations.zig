const renderkit = @import("types.zig");
const gl = @import("zopengl.zig").gl;

const GLenum = gl.Enum;
const GLint = gl.Int;
const GLuint = gl.Uint;

// translations from our enums to OpenGL
pub fn blendFactorToGl(state: renderkit.BlendFactor) GLenum {
    return switch (state) {
        .zero => gl.ZERO,
        .one => gl.ONE,
        .src_color => gl.SRC_COLOR,
        .one_minus_src_color => gl.ONE_MINUS_SRC_COLOR,
        .src_alpha => gl.SRC_ALPHA,
        .one_minus_src_alpha => gl.ONE_MINUS_SRC_ALPHA,
        .dst_color => gl.DST_COLOR,
        .one_minus_dst_color => gl.ONE_MINUS_DST_COLOR,
        .dst_alpha => gl.ALPHA,
        .one_minus_dst_alpha => gl.ONE_MINUS_DST_ALPHA,
        .src_alpha_saturated => gl.SRC_ALPHA_SATURATE,
        .blend_color => gl.CONSTANT_COLOR,
        .one_minus_blend_color => gl.ONE_MINUS_CONSTANT_COLOR,
        .blend_alpha => gl.CONSTANT_ALPHA,
        .one_minus_blend_alpha => gl.ONE_MINUS_CONSTANT_ALPHA,
    };
}

pub fn compareFuncToGl(state: renderkit.CompareFunc) GLenum {
    return switch (state) {
        .never => gl.NEVER,
        .less => gl.LESS,
        .equal => gl.EQUAL,
        .less_equal => gl.LEQUAL,
        .greater => gl.GREATER,
        .not_equal => gl.NOTEQUAL,
        .greater_equal => gl.GEQUAL,
        .always => gl.ALWAYS,
    };
}

pub fn stencilOpToGl(state: renderkit.StencilOp) GLenum {
    return switch (state) {
        .keep => gl.KEEP,
        .zero => gl.ZERO,
        .replace => gl.REPLACE,
        .incr_clamp => gl.INCR,
        .decr_clamp => gl.DECR,
        .invert => gl.INVERT,
        .incr_wrap => gl.INCR_WRAP,
        .decr_wrap => gl.DECR_WRAP,
    };
}

pub fn blendOpToGl(state: renderkit.BlendOp) GLenum {
    return switch (state) {
        .add => gl.FUNC_ADD,
        .subtract => gl.FUNC_SUBTRACT,
        .reverse_subtract => gl.FUNC_REVERSE_SUBTRACT,
    };
}

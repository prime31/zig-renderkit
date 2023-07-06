const std = @import("std");
const assert = std.debug.assert;

const options = @import("zopengl_options");

pub const gl = @import("bindings.zig");
pub usingnamespace gl;

//--------------------------------------------------------------------------------------------------
//
// Functions for loading OpenGL function pointers
//
//--------------------------------------------------------------------------------------------------
pub const LoaderFn = *const fn ([*c]const u8) callconv(.C) ?*anyopaque;

pub const Extension = enum {
    OES_vertex_array_object,
    NV_bindless_texture,
    NV_shader_buffer_load,
};

pub fn loadCoreProfile(loader: LoaderFn, major: u32, minor: u32) !void {
    const ver = 10 * major + minor;

    assert(major >= 1 and major <= 4);
    assert(minor >= 0 and minor <= 6);
    assert(ver >= 10 and ver <= 46);

    loaderFunc = loader;

    // OpenGL 1.0
    if (ver >= 10) {
        gl.cullFace = try getProcAddress(@TypeOf(gl.cullFace), "glCullFace");
        gl.frontFace = try getProcAddress(@TypeOf(gl.frontFace), "glFrontFace");
        gl.hint = try getProcAddress(@TypeOf(gl.hint), "glHint");
        gl.lineWidth = try getProcAddress(@TypeOf(gl.lineWidth), "glLineWidth");
        gl.pointSize = try getProcAddress(@TypeOf(gl.pointSize), "glPointSize");
        gl.polygonMode = try getProcAddress(@TypeOf(gl.polygonMode), "glPolygonMode");
        gl.scissor = try getProcAddress(@TypeOf(gl.scissor), "glScissor");
        gl.texParameterf = try getProcAddress(@TypeOf(gl.texParameterf), "glTexParameterf");
        gl.texParameterfv = try getProcAddress(@TypeOf(gl.texParameterfv), "glTexParameterfv");
        gl.texParameteri = try getProcAddress(@TypeOf(gl.texParameteri), "glTexParameteri");
        gl.texParameteriv = try getProcAddress(@TypeOf(gl.texParameteriv), "glTexParameteriv");
        gl.texImage1D = try getProcAddress(@TypeOf(gl.texImage1D), "glTexImage1D");
        gl.texImage2D = try getProcAddress(@TypeOf(gl.texImage2D), "glTexImage2D");
        gl.drawBuffer = try getProcAddress(@TypeOf(gl.drawBuffer), "glDrawBuffer");
        gl.clear = try getProcAddress(@TypeOf(gl.clear), "glClear");
        gl.clearColor = try getProcAddress(@TypeOf(gl.clearColor), "glClearColor");
        gl.clearStencil = try getProcAddress(@TypeOf(gl.clearStencil), "glClearStencil");
        gl.clearDepth = try getProcAddress(@TypeOf(gl.clearDepth), "glClearDepth");
        gl.stencilMask = try getProcAddress(@TypeOf(gl.stencilMask), "glStencilMask");
        gl.colorMask = try getProcAddress(@TypeOf(gl.colorMask), "glColorMask");
        gl.depthMask = try getProcAddress(@TypeOf(gl.depthMask), "glDepthMask");
        gl.disable = try getProcAddress(@TypeOf(gl.disable), "glDisable");
        gl.enable = try getProcAddress(@TypeOf(gl.enable), "glEnable");
        gl.finish = try getProcAddress(@TypeOf(gl.finish), "glFinish");
        gl.flush = try getProcAddress(@TypeOf(gl.flush), "glFlush");
        gl.blendFunc = try getProcAddress(@TypeOf(gl.blendFunc), "glBlendFunc");
        gl.logicOp = try getProcAddress(@TypeOf(gl.logicOp), "glLogicOp");
        gl.stencilFunc = try getProcAddress(@TypeOf(gl.stencilFunc), "glStencilFunc");
        gl.stencilOp = try getProcAddress(@TypeOf(gl.stencilOp), "glStencilOp");
        gl.depthFunc = try getProcAddress(@TypeOf(gl.depthFunc), "glDepthFunc");
        gl.pixelStoref = try getProcAddress(@TypeOf(gl.pixelStoref), "glPixelStoref");
        gl.pixelStorei = try getProcAddress(@TypeOf(gl.pixelStorei), "glPixelStorei");
        gl.readBuffer = try getProcAddress(@TypeOf(gl.readBuffer), "glReadBuffer");
        gl.readPixels = try getProcAddress(@TypeOf(gl.readPixels), "glReadPixels");
        gl.getBooleanv = try getProcAddress(@TypeOf(gl.getBooleanv), "glGetBooleanv");
        gl.getDoublev = try getProcAddress(@TypeOf(gl.getDoublev), "glGetDoublev");
        gl.getError = try getProcAddress(@TypeOf(gl.getError), "glGetError");
        gl.getFloatv = try getProcAddress(@TypeOf(gl.getFloatv), "glGetFloatv");
        gl.getIntegerv = try getProcAddress(@TypeOf(gl.getIntegerv), "glGetIntegerv");
        gl.getString = try getProcAddress(@TypeOf(gl.getString), "glGetString");
        gl.getTexImage = try getProcAddress(@TypeOf(gl.getTexImage), "glGetTexImage");
        gl.getTexParameterfv = try getProcAddress(@TypeOf(gl.getTexParameterfv), "glGetTexParameterfv");
        gl.getTexParameteriv = try getProcAddress(@TypeOf(gl.getTexParameteriv), "glGetTexParameteriv");
        gl.getTexLevelParameterfv = try getProcAddress(
            @TypeOf(gl.getTexLevelParameterfv),
            "glGetTexLevelParameterfv",
        );
        gl.getTexLevelParameteriv = try getProcAddress(
            @TypeOf(gl.getTexLevelParameteriv),
            "glGetTexLevelParameteriv",
        );
        gl.isEnabled = try getProcAddress(@TypeOf(gl.isEnabled), "glIsEnabled");
        gl.depthRange = try getProcAddress(@TypeOf(gl.depthRange), "glDepthRange");
        gl.viewport = try getProcAddress(@TypeOf(gl.viewport), "glViewport");
    }

    // OpenGL 1.1
    if (ver >= 11) {
        gl.drawArrays = try getProcAddress(@TypeOf(gl.drawArrays), "glDrawArrays");
        gl.drawElements = try getProcAddress(@TypeOf(gl.drawElements), "glDrawElements");
        gl.polygonOffset = try getProcAddress(@TypeOf(gl.polygonOffset), "glPolygonOffset");
        gl.copyTexImage1D = try getProcAddress(@TypeOf(gl.copyTexImage1D), "glCopyTexImage1D");
        gl.copyTexImage2D = try getProcAddress(@TypeOf(gl.copyTexImage2D), "glCopyTexImage2D");
        gl.copyTexSubImage1D = try getProcAddress(@TypeOf(gl.copyTexSubImage1D), "glCopyTexSubImage1D");
        gl.copyTexSubImage2D = try getProcAddress(@TypeOf(gl.copyTexSubImage2D), "glCopyTexSubImage2D");
        gl.texSubImage1D = try getProcAddress(@TypeOf(gl.texSubImage1D), "glTexSubImage1D");
        gl.texSubImage2D = try getProcAddress(@TypeOf(gl.texSubImage2D), "glTexSubImage2D");
        gl.bindTexture = try getProcAddress(@TypeOf(gl.bindTexture), "glBindTexture");
        gl.deleteTextures = try getProcAddress(@TypeOf(gl.deleteTextures), "glDeleteTextures");
        gl.genTextures = try getProcAddress(@TypeOf(gl.genTextures), "glGenTextures");
        gl.isTexture = try getProcAddress(@TypeOf(gl.isTexture), "glIsTexture");
    }

    // OpenGL 1.2
    if (ver >= 12) {
        gl.drawRangeElements = try getProcAddress(@TypeOf(gl.drawRangeElements), "glDrawRangeElements");
        gl.texImage3D = try getProcAddress(@TypeOf(gl.texImage3D), "glTexImage3D");
        gl.texSubImage3D = try getProcAddress(@TypeOf(gl.texSubImage3D), "glTexSubImage3D");
        gl.copyTexSubImage3D = try getProcAddress(@TypeOf(gl.copyTexSubImage3D), "glCopyTexSubImage3D");
    }

    // OpenGL 1.3
    if (ver >= 13) {
        gl.activeTexture = try getProcAddress(@TypeOf(gl.activeTexture), "glActiveTexture");
        gl.sampleCoverage = try getProcAddress(@TypeOf(gl.sampleCoverage), "glSampleCoverage");
        gl.compressedTexImage3D = try getProcAddress(
            @TypeOf(gl.compressedTexImage3D),
            "glCompressedTexImage3D",
        );
        gl.compressedTexImage2D = try getProcAddress(
            @TypeOf(gl.compressedTexImage2D),
            "glCompressedTexImage2D",
        );
        gl.compressedTexImage1D = try getProcAddress(
            @TypeOf(gl.compressedTexImage1D),
            "glCompressedTexImage1D",
        );
        gl.compressedTexSubImage3D = try getProcAddress(
            @TypeOf(gl.compressedTexSubImage3D),
            "glCompressedTexSubImage3D",
        );
        gl.compressedTexSubImage2D = try getProcAddress(
            @TypeOf(gl.compressedTexSubImage2D),
            "glCompressedTexSubImage2D",
        );
        gl.compressedTexSubImage1D = try getProcAddress(
            @TypeOf(gl.compressedTexSubImage1D),
            "glCompressedTexSubImage1D",
        );
        gl.getCompressedTexImage = try getProcAddress(
            @TypeOf(gl.getCompressedTexImage),
            "glGetCompressedTexImage",
        );
    }

    // OpenGL 1.4
    if (ver >= 14) {
        gl.blendFuncSeparate = try getProcAddress(@TypeOf(gl.blendFuncSeparate), "glBlendFuncSeparate");
        gl.multiDrawArrays = try getProcAddress(@TypeOf(gl.multiDrawArrays), "glMultiDrawArrays");
        gl.multiDrawElements = try getProcAddress(@TypeOf(gl.multiDrawElements), "glMultiDrawElements");
        gl.pointParameterf = try getProcAddress(@TypeOf(gl.pointParameterf), "glPointParameterf");
        gl.pointParameterfv = try getProcAddress(@TypeOf(gl.pointParameterfv), "glPointParameterfv");
        gl.pointParameteri = try getProcAddress(@TypeOf(gl.pointParameteri), "glPointParameteri");
        gl.pointParameteriv = try getProcAddress(@TypeOf(gl.pointParameteriv), "glPointParameteriv");
        gl.blendColor = try getProcAddress(@TypeOf(gl.blendColor), "glBlendColor");
        gl.blendEquation = try getProcAddress(@TypeOf(gl.blendEquation), "glBlendEquation");
    }

    // OpenGL 1.5
    if (ver >= 15) {
        gl.genQueries = try getProcAddress(@TypeOf(gl.genQueries), "glGenQueries");
        gl.deleteQueries = try getProcAddress(@TypeOf(gl.deleteQueries), "glDeleteQueries");
        gl.isQuery = try getProcAddress(@TypeOf(gl.isQuery), "glIsQuery");
        gl.beginQuery = try getProcAddress(@TypeOf(gl.beginQuery), "glBeginQuery");
        gl.endQuery = try getProcAddress(@TypeOf(gl.endQuery), "glEndQuery");
        gl.getQueryiv = try getProcAddress(@TypeOf(gl.getQueryiv), "glGetQueryiv");
        gl.getQueryObjectiv = try getProcAddress(@TypeOf(gl.getQueryObjectiv), "glGetQueryObjectiv");
        gl.getQueryObjectuiv = try getProcAddress(@TypeOf(gl.getQueryObjectuiv), "glGetQueryObjectuiv");
        gl.bindBuffer = try getProcAddress(@TypeOf(gl.bindBuffer), "glBindBuffer");
        gl.deleteBuffers = try getProcAddress(@TypeOf(gl.deleteBuffers), "glDeleteBuffers");
        gl.genBuffers = try getProcAddress(@TypeOf(gl.genBuffers), "glGenBuffers");
        gl.isBuffer = try getProcAddress(@TypeOf(gl.isBuffer), "glIsBuffer");
        gl.bufferData = try getProcAddress(@TypeOf(gl.bufferData), "glBufferData");
        gl.bufferSubData = try getProcAddress(@TypeOf(gl.bufferSubData), "glBufferSubData");
        gl.getBufferSubData = try getProcAddress(@TypeOf(gl.getBufferSubData), "glGetBufferSubData");
        gl.mapBuffer = try getProcAddress(@TypeOf(gl.mapBuffer), "glMapBuffer");
        gl.unmapBuffer = try getProcAddress(@TypeOf(gl.unmapBuffer), "glUnmapBuffer");
        gl.getBufferParameteriv = try getProcAddress(
            @TypeOf(gl.getBufferParameteriv),
            "glGetBufferParameteriv",
        );
        gl.getBufferPointerv = try getProcAddress(@TypeOf(gl.getBufferPointerv), "glGetBufferPointerv");
    }

    // OpenGL 2.0
    if (ver >= 20) {
        gl.blendEquationSeparate = try getProcAddress(
            @TypeOf(gl.blendEquationSeparate),
            "glBlendEquationSeparate",
        );
        gl.drawBuffers = try getProcAddress(@TypeOf(gl.drawBuffers), "glDrawBuffers");
        gl.stencilOpSeparate = try getProcAddress(@TypeOf(gl.stencilOpSeparate), "glStencilOpSeparate");
        gl.stencilFuncSeparate = try getProcAddress(
            @TypeOf(gl.stencilFuncSeparate),
            "glStencilFuncSeparate",
        );
        gl.stencilMaskSeparate = try getProcAddress(
            @TypeOf(gl.stencilMaskSeparate),
            "glStencilMaskSeparate",
        );
        gl.attachShader = try getProcAddress(@TypeOf(gl.attachShader), "glAttachShader");
        gl.bindAttribLocation = try getProcAddress(
            @TypeOf(gl.bindAttribLocation),
            "glBindAttribLocation",
        );
        gl.compileShader = try getProcAddress(@TypeOf(gl.compileShader), "glCompileShader");
        gl.createProgram = try getProcAddress(@TypeOf(gl.createProgram), "glCreateProgram");
        gl.createShader = try getProcAddress(@TypeOf(gl.createShader), "glCreateShader");
        gl.deleteProgram = try getProcAddress(@TypeOf(gl.deleteProgram), "glDeleteProgram");
        gl.deleteShader = try getProcAddress(@TypeOf(gl.deleteShader), "glDeleteShader");
        gl.detachShader = try getProcAddress(@TypeOf(gl.detachShader), "glDetachShader");
        gl.disableVertexAttribArray = try getProcAddress(
            @TypeOf(gl.disableVertexAttribArray),
            "glDisableVertexAttribArray",
        );
        gl.enableVertexAttribArray = try getProcAddress(
            @TypeOf(gl.enableVertexAttribArray),
            "glEnableVertexAttribArray",
        );
        gl.getActiveAttrib = try getProcAddress(@TypeOf(gl.getActiveAttrib), "glGetActiveAttrib");
        gl.getActiveUniform = try getProcAddress(@TypeOf(gl.getActiveUniform), "glGetActiveUniform");
        gl.getAttachedShaders = try getProcAddress(
            @TypeOf(gl.getAttachedShaders),
            "glGetAttachedShaders",
        );
        gl.getAttribLocation = try getProcAddress(@TypeOf(gl.getAttribLocation), "glGetAttribLocation");
        gl.getProgramiv = try getProcAddress(@TypeOf(gl.getProgramiv), "glGetProgramiv");
        gl.getProgramInfoLog = try getProcAddress(@TypeOf(gl.getProgramInfoLog), "glGetProgramInfoLog");
        gl.getShaderiv = try getProcAddress(@TypeOf(gl.getShaderiv), "glGetShaderiv");
        gl.getShaderInfoLog = try getProcAddress(@TypeOf(gl.getShaderInfoLog), "glGetShaderInfoLog");
        gl.getShaderSource = try getProcAddress(@TypeOf(gl.getShaderSource), "glGetShaderSource");
        gl.getUniformLocation = try getProcAddress(
            @TypeOf(gl.getUniformLocation),
            "glGetUniformLocation",
        );
        gl.getUniformfv = try getProcAddress(@TypeOf(gl.getUniformfv), "glGetUniformfv");
        gl.getUniformiv = try getProcAddress(@TypeOf(gl.getUniformiv), "glGetUniformiv");
        gl.getVertexAttribdv = try getProcAddress(@TypeOf(gl.getVertexAttribdv), "glGetVertexAttribdv");
        gl.getVertexAttribfv = try getProcAddress(@TypeOf(gl.getVertexAttribfv), "glGetVertexAttribfv");
        gl.getVertexAttribiv = try getProcAddress(@TypeOf(gl.getVertexAttribiv), "glGetVertexAttribiv");
        gl.getVertexAttribPointerv = try getProcAddress(
            @TypeOf(gl.getVertexAttribPointerv),
            "glGetVertexAttribPointerv",
        );
        gl.isProgram = try getProcAddress(@TypeOf(gl.isProgram), "glIsProgram");
        gl.isShader = try getProcAddress(@TypeOf(gl.isShader), "glIsShader");
        gl.linkProgram = try getProcAddress(@TypeOf(gl.linkProgram), "glLinkProgram");
        gl.shaderSource = try getProcAddress(@TypeOf(gl.shaderSource), "glShaderSource");
        gl.useProgram = try getProcAddress(@TypeOf(gl.useProgram), "glUseProgram");
        gl.uniform1f = try getProcAddress(@TypeOf(gl.uniform1f), "glUniform1f");
        gl.uniform2f = try getProcAddress(@TypeOf(gl.uniform2f), "glUniform2f");
        gl.uniform3f = try getProcAddress(@TypeOf(gl.uniform3f), "glUniform3f");
        gl.uniform4f = try getProcAddress(@TypeOf(gl.uniform4f), "glUniform4f");
        gl.uniform1i = try getProcAddress(@TypeOf(gl.uniform1i), "glUniform1i");
        gl.uniform2i = try getProcAddress(@TypeOf(gl.uniform2i), "glUniform2i");
        gl.uniform3i = try getProcAddress(@TypeOf(gl.uniform3i), "glUniform3i");
        gl.uniform4i = try getProcAddress(@TypeOf(gl.uniform4i), "glUniform4i");
        gl.uniform1fv = try getProcAddress(@TypeOf(gl.uniform1fv), "glUniform1fv");
        gl.uniform2fv = try getProcAddress(@TypeOf(gl.uniform2fv), "glUniform2fv");
        gl.uniform3fv = try getProcAddress(@TypeOf(gl.uniform3fv), "glUniform3fv");
        gl.uniform4fv = try getProcAddress(@TypeOf(gl.uniform4fv), "glUniform4fv");
        gl.uniform1iv = try getProcAddress(@TypeOf(gl.uniform1iv), "glUniform1iv");
        gl.uniform2iv = try getProcAddress(@TypeOf(gl.uniform2iv), "glUniform2iv");
        gl.uniform3iv = try getProcAddress(@TypeOf(gl.uniform3iv), "glUniform3iv");
        gl.uniform4iv = try getProcAddress(@TypeOf(gl.uniform4iv), "glUniform4iv");
        gl.uniformMatrix2fv = try getProcAddress(@TypeOf(gl.uniformMatrix2fv), "glUniformMatrix2fv");
        gl.uniformMatrix3fv = try getProcAddress(@TypeOf(gl.uniformMatrix3fv), "glUniformMatrix3fv");
        gl.uniformMatrix4fv = try getProcAddress(@TypeOf(gl.uniformMatrix4fv), "glUniformMatrix4fv");
        gl.validateProgram = try getProcAddress(@TypeOf(gl.validateProgram), "glValidateProgram");
        gl.vertexAttrib1d = try getProcAddress(@TypeOf(gl.vertexAttrib1d), "glVertexAttrib1d");
        gl.vertexAttrib1dv = try getProcAddress(@TypeOf(gl.vertexAttrib1dv), "glVertexAttrib1dv");
        gl.vertexAttrib1f = try getProcAddress(@TypeOf(gl.vertexAttrib1f), "glVertexAttrib1f");
        gl.vertexAttrib1fv = try getProcAddress(@TypeOf(gl.vertexAttrib1fv), "glVertexAttrib1fv");
        gl.vertexAttrib1s = try getProcAddress(@TypeOf(gl.vertexAttrib1s), "glVertexAttrib1s");
        gl.vertexAttrib1sv = try getProcAddress(@TypeOf(gl.vertexAttrib1sv), "glVertexAttrib1sv");
        gl.vertexAttrib2d = try getProcAddress(@TypeOf(gl.vertexAttrib2d), "glVertexAttrib2d");
        gl.vertexAttrib2dv = try getProcAddress(@TypeOf(gl.vertexAttrib2dv), "glVertexAttrib2dv");
        gl.vertexAttrib2f = try getProcAddress(@TypeOf(gl.vertexAttrib2f), "glVertexAttrib2f");
        gl.vertexAttrib2fv = try getProcAddress(@TypeOf(gl.vertexAttrib2fv), "glVertexAttrib2fv");
        gl.vertexAttrib2s = try getProcAddress(@TypeOf(gl.vertexAttrib2s), "glVertexAttrib2s");
        gl.vertexAttrib2sv = try getProcAddress(@TypeOf(gl.vertexAttrib2sv), "glVertexAttrib2sv");
        gl.vertexAttrib3d = try getProcAddress(@TypeOf(gl.vertexAttrib3d), "glVertexAttrib3d");
        gl.vertexAttrib3dv = try getProcAddress(@TypeOf(gl.vertexAttrib3dv), "glVertexAttrib3dv");
        gl.vertexAttrib3f = try getProcAddress(@TypeOf(gl.vertexAttrib3f), "glVertexAttrib3f");
        gl.vertexAttrib3fv = try getProcAddress(@TypeOf(gl.vertexAttrib3fv), "glVertexAttrib3fv");
        gl.vertexAttrib3s = try getProcAddress(@TypeOf(gl.vertexAttrib3s), "glVertexAttrib3s");
        gl.vertexAttrib3sv = try getProcAddress(@TypeOf(gl.vertexAttrib3sv), "glVertexAttrib3sv");
        gl.vertexAttrib4Nbv = try getProcAddress(@TypeOf(gl.vertexAttrib4Nbv), "glVertexAttrib4Nbv");
        gl.vertexAttrib4Niv = try getProcAddress(@TypeOf(gl.vertexAttrib4Niv), "glVertexAttrib4Niv");
        gl.vertexAttrib4Nsv = try getProcAddress(@TypeOf(gl.vertexAttrib4Nsv), "glVertexAttrib4Nsv");
        gl.vertexAttrib4Nub = try getProcAddress(@TypeOf(gl.vertexAttrib4Nub), "glVertexAttrib4Nub");
        gl.vertexAttrib4Nubv = try getProcAddress(@TypeOf(gl.vertexAttrib4Nubv), "glVertexAttrib4Nubv");
        gl.vertexAttrib4Nuiv = try getProcAddress(@TypeOf(gl.vertexAttrib4Nuiv), "glVertexAttrib4Nuiv");
        gl.vertexAttrib4Nusv = try getProcAddress(@TypeOf(gl.vertexAttrib4Nusv), "glVertexAttrib4Nusv");
        gl.vertexAttrib4bv = try getProcAddress(@TypeOf(gl.vertexAttrib4bv), "glVertexAttrib4bv");
        gl.vertexAttrib4d = try getProcAddress(@TypeOf(gl.vertexAttrib4d), "glVertexAttrib4d");
        gl.vertexAttrib4dv = try getProcAddress(@TypeOf(gl.vertexAttrib4dv), "glVertexAttrib4dv");
        gl.vertexAttrib4f = try getProcAddress(@TypeOf(gl.vertexAttrib4f), "glVertexAttrib4f");
        gl.vertexAttrib4fv = try getProcAddress(@TypeOf(gl.vertexAttrib4fv), "glVertexAttrib4fv");
        gl.vertexAttrib4iv = try getProcAddress(@TypeOf(gl.vertexAttrib4iv), "glVertexAttrib4iv");
        gl.vertexAttrib4s = try getProcAddress(@TypeOf(gl.vertexAttrib4s), "glVertexAttrib4s");
        gl.vertexAttrib4sv = try getProcAddress(@TypeOf(gl.vertexAttrib4sv), "glVertexAttrib4sv");
        gl.vertexAttrib4ubv = try getProcAddress(@TypeOf(gl.vertexAttrib4ubv), "glVertexAttrib4ubv");
        gl.vertexAttrib4uiv = try getProcAddress(@TypeOf(gl.vertexAttrib4uiv), "glVertexAttrib4uiv");
        gl.vertexAttrib4usv = try getProcAddress(@TypeOf(gl.vertexAttrib4usv), "glVertexAttrib4usv");
        gl.vertexAttribPointer = try getProcAddress(
            @TypeOf(gl.vertexAttribPointer),
            "glVertexAttribPointer",
        );
    }

    // OpenGL 2.1
    if (ver >= 21) {
        gl.uniformMatrix2x3fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix2x3fv),
            "glUniformMatrix2x3fv",
        );
        gl.uniformMatrix3x2fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix3x2fv),
            "glUniformMatrix3x2fv",
        );
        gl.uniformMatrix2x4fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix2x4fv),
            "glUniformMatrix2x4fv",
        );
        gl.uniformMatrix4x2fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix4x2fv),
            "glUniformMatrix4x2fv",
        );
        gl.uniformMatrix3x4fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix3x4fv),
            "glUniformMatrix3x4fv",
        );
        gl.uniformMatrix4x3fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix4x3fv),
            "glUniformMatrix4x3fv",
        );
    }

    // OpenGL 3.0
    if (ver >= 30) {
        gl.colorMaski = try getProcAddress(@TypeOf(gl.colorMaski), "glColorMaski");
        gl.getBooleani_v = try getProcAddress(@TypeOf(gl.getBooleani_v), "glGetBooleani_v");
        gl.getIntegeri_v = try getProcAddress(@TypeOf(gl.getIntegeri_v), "glGetIntegeri_v");
        gl.enablei = try getProcAddress(@TypeOf(gl.enablei), "glEnablei");
        gl.disablei = try getProcAddress(@TypeOf(gl.disablei), "glDisablei");
        gl.isEnabledi = try getProcAddress(@TypeOf(gl.isEnabledi), "glIsEnabledi");
        gl.beginTransformFeedback = try getProcAddress(
            @TypeOf(gl.beginTransformFeedback),
            "glBeginTransformFeedback",
        );
        gl.endTransformFeedback = try getProcAddress(
            @TypeOf(gl.endTransformFeedback),
            "glEndTransformFeedback",
        );
        gl.bindBufferRange = try getProcAddress(@TypeOf(gl.bindBufferRange), "glBindBufferRange");
        gl.bindBufferBase = try getProcAddress(@TypeOf(gl.bindBufferBase), "glBindBufferBase");
        gl.transformFeedbackVaryings = try getProcAddress(
            @TypeOf(gl.transformFeedbackVaryings),
            "glTransformFeedbackVaryings",
        );
        gl.getTransformFeedbackVarying = try getProcAddress(
            @TypeOf(gl.getTransformFeedbackVarying),
            "glGetTransformFeedbackVarying",
        );
        gl.clampColor = try getProcAddress(@TypeOf(gl.clampColor), "glClampColor");
        gl.beginConditionalRender = try getProcAddress(
            @TypeOf(gl.beginConditionalRender),
            "glBeginConditionalRender",
        );
        gl.endConditionalRender = try getProcAddress(
            @TypeOf(gl.endConditionalRender),
            "glEndConditionalRender",
        );
        gl.vertexAttribIPointer = try getProcAddress(
            @TypeOf(gl.vertexAttribIPointer),
            "glVertexAttribIPointer",
        );
        gl.getVertexAttribIiv = try getProcAddress(
            @TypeOf(gl.getVertexAttribIiv),
            "glGetVertexAttribIiv",
        );
        gl.getVertexAttribIuiv = try getProcAddress(
            @TypeOf(gl.getVertexAttribIuiv),
            "glGetVertexAttribIuiv",
        );
        gl.vertexAttribI1i = try getProcAddress(@TypeOf(gl.vertexAttribI1i), "glVertexAttribI1i");
        gl.vertexAttribI2i = try getProcAddress(@TypeOf(gl.vertexAttribI2i), "glVertexAttribI2i");
        gl.vertexAttribI3i = try getProcAddress(@TypeOf(gl.vertexAttribI3i), "glVertexAttribI3i");
        gl.vertexAttribI4i = try getProcAddress(@TypeOf(gl.vertexAttribI4i), "glVertexAttribI4i");
        gl.vertexAttribI1ui = try getProcAddress(@TypeOf(gl.vertexAttribI1ui), "glVertexAttribI1ui");
        gl.vertexAttribI2ui = try getProcAddress(@TypeOf(gl.vertexAttribI2ui), "glVertexAttribI2ui");
        gl.vertexAttribI3ui = try getProcAddress(@TypeOf(gl.vertexAttribI3ui), "glVertexAttribI3ui");
        gl.vertexAttribI4ui = try getProcAddress(@TypeOf(gl.vertexAttribI4ui), "glVertexAttribI4ui");
        gl.vertexAttribI1iv = try getProcAddress(@TypeOf(gl.vertexAttribI1iv), "glVertexAttribI1iv");
        gl.vertexAttribI2iv = try getProcAddress(@TypeOf(gl.vertexAttribI2iv), "glVertexAttribI2iv");
        gl.vertexAttribI3iv = try getProcAddress(@TypeOf(gl.vertexAttribI3iv), "glVertexAttribI3iv");
        gl.vertexAttribI4iv = try getProcAddress(@TypeOf(gl.vertexAttribI4iv), "glVertexAttribI4iv");
        gl.vertexAttribI1uiv = try getProcAddress(@TypeOf(gl.vertexAttribI1uiv), "glVertexAttribI1uiv");
        gl.vertexAttribI2uiv = try getProcAddress(@TypeOf(gl.vertexAttribI2uiv), "glVertexAttribI2uiv");
        gl.vertexAttribI3uiv = try getProcAddress(@TypeOf(gl.vertexAttribI3uiv), "glVertexAttribI3uiv");
        gl.vertexAttribI4uiv = try getProcAddress(@TypeOf(gl.vertexAttribI4uiv), "glVertexAttribI4uiv");
        gl.vertexAttribI4bv = try getProcAddress(@TypeOf(gl.vertexAttribI4bv), "glVertexAttribI4bv");
        gl.vertexAttribI4sv = try getProcAddress(@TypeOf(gl.vertexAttribI4sv), "glVertexAttribI4sv");
        gl.vertexAttribI4ubv = try getProcAddress(@TypeOf(gl.vertexAttribI4ubv), "glVertexAttribI4ubv");
        gl.vertexAttribI4usv = try getProcAddress(@TypeOf(gl.vertexAttribI4usv), "glVertexAttribI4usv");
        gl.getUniformuiv = try getProcAddress(@TypeOf(gl.getUniformuiv), "glGetUniformuiv");
        gl.bindFragDataLocation = try getProcAddress(
            @TypeOf(gl.bindFragDataLocation),
            "glBindFragDataLocation",
        );
        gl.getFragDataLocation = try getProcAddress(
            @TypeOf(gl.getFragDataLocation),
            "glGetFragDataLocation",
        );
        gl.uniform1ui = try getProcAddress(@TypeOf(gl.uniform1ui), "glUniform1ui");
        gl.uniform2ui = try getProcAddress(@TypeOf(gl.uniform2ui), "glUniform2ui");
        gl.uniform3ui = try getProcAddress(@TypeOf(gl.uniform3ui), "glUniform3ui");
        gl.uniform4ui = try getProcAddress(@TypeOf(gl.uniform4ui), "glUniform4ui");
        gl.uniform1uiv = try getProcAddress(@TypeOf(gl.uniform1uiv), "glUniform1uiv");
        gl.uniform2uiv = try getProcAddress(@TypeOf(gl.uniform2uiv), "glUniform2uiv");
        gl.uniform3uiv = try getProcAddress(@TypeOf(gl.uniform3uiv), "glUniform3uiv");
        gl.uniform4uiv = try getProcAddress(@TypeOf(gl.uniform4uiv), "glUniform4uiv");
        gl.texParameterIiv = try getProcAddress(@TypeOf(gl.texParameterIiv), "glTexParameterIiv");
        gl.texParameterIuiv = try getProcAddress(@TypeOf(gl.texParameterIuiv), "glTexParameterIuiv");
        gl.getTexParameterIiv = try getProcAddress(
            @TypeOf(gl.getTexParameterIiv),
            "glGetTexParameterIiv",
        );
        gl.getTexParameterIuiv = try getProcAddress(
            @TypeOf(gl.getTexParameterIuiv),
            "glGetTexParameterIuiv",
        );
        gl.clearBufferiv = try getProcAddress(@TypeOf(gl.clearBufferiv), "glClearBufferiv");
        gl.clearBufferuiv = try getProcAddress(@TypeOf(gl.clearBufferuiv), "glClearBufferuiv");
        gl.clearBufferfv = try getProcAddress(@TypeOf(gl.clearBufferfv), "glClearBufferfv");
        gl.clearBufferfi = try getProcAddress(@TypeOf(gl.clearBufferfi), "glClearBufferfi");
        gl.getStringi = try getProcAddress(@TypeOf(gl.getStringi), "glGetStringi");
        gl.isRenderbuffer = try getProcAddress(@TypeOf(gl.isRenderbuffer), "glIsRenderbuffer");
        gl.bindRenderbuffer = try getProcAddress(@TypeOf(gl.bindRenderbuffer), "glBindRenderbuffer");
        gl.deleteRenderbuffers = try getProcAddress(
            @TypeOf(gl.deleteRenderbuffers),
            "glDeleteRenderbuffers",
        );
        gl.genRenderbuffers = try getProcAddress(@TypeOf(gl.genRenderbuffers), "glGenRenderbuffers");
        gl.renderbufferStorage = try getProcAddress(
            @TypeOf(gl.renderbufferStorage),
            "glRenderbufferStorage",
        );
        gl.getRenderbufferParameteriv = try getProcAddress(
            @TypeOf(gl.getRenderbufferParameteriv),
            "glGetRenderbufferParameteriv",
        );
        gl.isFramebuffer = try getProcAddress(@TypeOf(gl.isFramebuffer), "glIsFramebuffer");
        gl.bindFramebuffer = try getProcAddress(@TypeOf(gl.bindFramebuffer), "glBindFramebuffer");
        gl.deleteFramebuffers = try getProcAddress(
            @TypeOf(gl.deleteFramebuffers),
            "glDeleteFramebuffers",
        );
        gl.genFramebuffers = try getProcAddress(@TypeOf(gl.genFramebuffers), "glGenFramebuffers");
        gl.checkFramebufferStatus = try getProcAddress(
            @TypeOf(gl.checkFramebufferStatus),
            "glCheckFramebufferStatus",
        );
        gl.framebufferTexture1D = try getProcAddress(
            @TypeOf(gl.framebufferTexture1D),
            "glFramebufferTexture1D",
        );
        gl.framebufferTexture2D = try getProcAddress(
            @TypeOf(gl.framebufferTexture2D),
            "glFramebufferTexture2D",
        );
        gl.framebufferTexture3D = try getProcAddress(
            @TypeOf(gl.framebufferTexture3D),
            "glFramebufferTexture3D",
        );
        gl.framebufferRenderbuffer = try getProcAddress(
            @TypeOf(gl.framebufferRenderbuffer),
            "glFramebufferRenderbuffer",
        );
        gl.getFramebufferAttachmentParameteriv = try getProcAddress(
            @TypeOf(gl.getFramebufferAttachmentParameteriv),
            "glGetFramebufferAttachmentParameteriv",
        );
        gl.generateMipmap = try getProcAddress(@TypeOf(gl.generateMipmap), "glGenerateMipmap");
        gl.blitFramebuffer = try getProcAddress(@TypeOf(gl.blitFramebuffer), "glBlitFramebuffer");
        gl.renderbufferStorageMultisample = try getProcAddress(
            @TypeOf(gl.renderbufferStorageMultisample),
            "glRenderbufferStorageMultisample",
        );
        gl.framebufferTextureLayer = try getProcAddress(
            @TypeOf(gl.framebufferTextureLayer),
            "glFramebufferTextureLayer",
        );
        gl.mapBufferRange = try getProcAddress(@TypeOf(gl.mapBufferRange), "glMapBufferRange");
        gl.flushMappedBufferRange = try getProcAddress(
            @TypeOf(gl.flushMappedBufferRange),
            "glFlushMappedBufferRange",
        );
        gl.bindVertexArray = try getProcAddress(@TypeOf(gl.bindVertexArray), "glBindVertexArray");
        gl.deleteVertexArrays = try getProcAddress(
            @TypeOf(gl.deleteVertexArrays),
            "glDeleteVertexArrays",
        );
        gl.genVertexArrays = try getProcAddress(@TypeOf(gl.genVertexArrays), "glGenVertexArrays");
        gl.isVertexArray = try getProcAddress(@TypeOf(gl.isVertexArray), "glIsVertexArray");
    }

    // OpenGL 3.1
    if (ver >= 31) {
        gl.drawArraysInstanced = try getProcAddress(
            @TypeOf(gl.drawArraysInstanced),
            "glDrawArraysInstanced",
        );
        gl.drawElementsInstanced = try getProcAddress(
            @TypeOf(gl.drawElementsInstanced),
            "glDrawElementsInstanced",
        );
        gl.texBuffer = try getProcAddress(@TypeOf(gl.texBuffer), "glTexBuffer");
        gl.primitiveRestartIndex = try getProcAddress(
            @TypeOf(gl.primitiveRestartIndex),
            "glPrimitiveRestartIndex",
        );
        gl.copyBufferSubData = try getProcAddress(@TypeOf(gl.copyBufferSubData), "glCopyBufferSubData");
        gl.getUniformIndices = try getProcAddress(@TypeOf(gl.getUniformIndices), "glGetUniformIndices");
        gl.getActiveUniformsiv = try getProcAddress(
            @TypeOf(gl.getActiveUniformsiv),
            "glGetActiveUniformsiv",
        );
        gl.getActiveUniformName = try getProcAddress(
            @TypeOf(gl.getActiveUniformName),
            "glGetActiveUniformName",
        );
        gl.getUniformBlockIndex = try getProcAddress(
            @TypeOf(gl.getUniformBlockIndex),
            "glGetUniformBlockIndex",
        );
        gl.getActiveUniformBlockiv = try getProcAddress(
            @TypeOf(gl.getActiveUniformBlockiv),
            "glGetActiveUniformBlockiv",
        );
        gl.getActiveUniformBlockName = try getProcAddress(
            @TypeOf(gl.getActiveUniformBlockName),
            "glGetActiveUniformBlockName",
        );
        gl.uniformBlockBinding = try getProcAddress(
            @TypeOf(gl.uniformBlockBinding),
            "glUniformBlockBinding",
        );
    }

    // OpenGL 3.2
    if (ver >= 32) {
        gl.drawElementsBaseVertex = try getProcAddress(
            @TypeOf(gl.drawElementsBaseVertex),
            "glDrawElementsBaseVertex",
        );
        gl.drawRangeElementsBaseVertex = try getProcAddress(
            @TypeOf(gl.drawRangeElementsBaseVertex),
            "glDrawRangeElementsBaseVertex",
        );
        gl.drawElementsInstancedBaseVertex = try getProcAddress(
            @TypeOf(gl.drawElementsInstancedBaseVertex),
            "glDrawElementsInstancedBaseVertex",
        );
        gl.multiDrawElementsBaseVertex = try getProcAddress(
            @TypeOf(gl.multiDrawElementsBaseVertex),
            "glMultiDrawElementsBaseVertex",
        );
        gl.provokingVertex = try getProcAddress(@TypeOf(gl.provokingVertex), "glProvokingVertex");
        gl.fenceSync = try getProcAddress(@TypeOf(gl.fenceSync), "glFenceSync");
        gl.isSync = try getProcAddress(@TypeOf(gl.isSync), "glIsSync");
        gl.deleteSync = try getProcAddress(@TypeOf(gl.deleteSync), "glDeleteSync");
        gl.clientWaitSync = try getProcAddress(@TypeOf(gl.clientWaitSync), "glClientWaitSync");
        gl.waitSync = try getProcAddress(@TypeOf(gl.waitSync), "glWaitSync");
        gl.getInteger64v = try getProcAddress(@TypeOf(gl.getInteger64v), "glGetInteger64v");
        gl.getSynciv = try getProcAddress(@TypeOf(gl.getSynciv), "glGetSynciv");
        gl.getInteger64i_v = try getProcAddress(@TypeOf(gl.getInteger64i_v), "glGetInteger64i_v");
        gl.getBufferParameteri64v = try getProcAddress(
            @TypeOf(gl.getBufferParameteri64v),
            "glGetBufferParameteri64v",
        );
        gl.framebufferTexture = try getProcAddress(
            @TypeOf(gl.framebufferTexture),
            "glFramebufferTexture",
        );
        gl.texImage2DMultisample = try getProcAddress(
            @TypeOf(gl.texImage2DMultisample),
            "glTexImage2DMultisample",
        );
        gl.texImage3DMultisample = try getProcAddress(
            @TypeOf(gl.texImage3DMultisample),
            "glTexImage3DMultisample",
        );
        gl.getMultisamplefv = try getProcAddress(@TypeOf(gl.getMultisamplefv), "glGetMultisamplefv");
        gl.sampleMaski = try getProcAddress(@TypeOf(gl.sampleMaski), "glSampleMaski");
    }

    // OpenGL 3.3
    if (ver >= 33) {
        gl.bindFragDataLocationIndexed = try getProcAddress(
            @TypeOf(gl.bindFragDataLocationIndexed),
            "glBindFragDataLocationIndexed",
        );
        gl.getFragDataIndex = try getProcAddress(@TypeOf(gl.getFragDataIndex), "glGetFragDataIndex");
        gl.genSamplers = try getProcAddress(@TypeOf(gl.genSamplers), "glGenSamplers");
        gl.deleteSamplers = try getProcAddress(@TypeOf(gl.deleteSamplers), "glDeleteSamplers");
        gl.isSampler = try getProcAddress(@TypeOf(gl.isSampler), "glIsSampler");
        gl.bindSampler = try getProcAddress(@TypeOf(gl.bindSampler), "glBindSampler");
        gl.samplerParameteri = try getProcAddress(@TypeOf(gl.samplerParameteri), "glSamplerParameteri");
        gl.samplerParameteriv = try getProcAddress(
            @TypeOf(gl.samplerParameteriv),
            "glSamplerParameteriv",
        );
        gl.samplerParameterf = try getProcAddress(@TypeOf(gl.samplerParameterf), "glSamplerParameterf");
        gl.samplerParameterfv = try getProcAddress(
            @TypeOf(gl.samplerParameterfv),
            "glSamplerParameterfv",
        );
        gl.samplerParameterIiv = try getProcAddress(
            @TypeOf(gl.samplerParameterIiv),
            "glSamplerParameterIiv",
        );
        gl.samplerParameterIuiv = try getProcAddress(
            @TypeOf(gl.samplerParameterIuiv),
            "glSamplerParameterIuiv",
        );
        gl.getSamplerParameteriv = try getProcAddress(
            @TypeOf(gl.getSamplerParameteriv),
            "glGetSamplerParameteriv",
        );
        gl.getSamplerParameterIiv = try getProcAddress(
            @TypeOf(gl.getSamplerParameterIiv),
            "glGetSamplerParameterIiv",
        );
        gl.getSamplerParameterfv = try getProcAddress(
            @TypeOf(gl.getSamplerParameterfv),
            "glGetSamplerParameterfv",
        );
        gl.getSamplerParameterIuiv = try getProcAddress(
            @TypeOf(gl.getSamplerParameterIuiv),
            "glGetSamplerParameterIuiv",
        );
        gl.queryCounter = try getProcAddress(@TypeOf(gl.queryCounter), "glQueryCounter");
        gl.getQueryObjecti64v = try getProcAddress(
            @TypeOf(gl.getQueryObjecti64v),
            "glGetQueryObjecti64v",
        );
        gl.getQueryObjectui64v = try getProcAddress(
            @TypeOf(gl.getQueryObjectui64v),
            "glGetQueryObjectui64v",
        );
        gl.vertexAttribDivisor = try getProcAddress(
            @TypeOf(gl.vertexAttribDivisor),
            "glVertexAttribDivisor",
        );
        gl.vertexAttribP1ui = try getProcAddress(@TypeOf(gl.vertexAttribP1ui), "glVertexAttribP1ui");
        gl.vertexAttribP1uiv = try getProcAddress(@TypeOf(gl.vertexAttribP1uiv), "glVertexAttribP1uiv");
        gl.vertexAttribP2ui = try getProcAddress(@TypeOf(gl.vertexAttribP2ui), "glVertexAttribP2ui");
        gl.vertexAttribP2uiv = try getProcAddress(@TypeOf(gl.vertexAttribP2uiv), "glVertexAttribP2uiv");
        gl.vertexAttribP3ui = try getProcAddress(@TypeOf(gl.vertexAttribP3ui), "glVertexAttribP3ui");
        gl.vertexAttribP3uiv = try getProcAddress(@TypeOf(gl.vertexAttribP3uiv), "glVertexAttribP3uiv");
        gl.vertexAttribP4ui = try getProcAddress(@TypeOf(gl.vertexAttribP4ui), "glVertexAttribP4ui");
        gl.vertexAttribP4uiv = try getProcAddress(@TypeOf(gl.vertexAttribP4uiv), "glVertexAttribP4uiv");
    }

    // OpenGL 4.0
    if (ver >= 40) {
        // TODO
    }

    // OpenGL 4.1
    if (ver >= 41) {
        gl.createShaderProgramv = try getProcAddress(
            @TypeOf(gl.createShaderProgramv),
            "glCreateShaderProgramv",
        );
        // TODO
    }

    // OpenGL 4.2
    if (ver >= 42) {
        gl.bindImageTexture = try getProcAddress(@TypeOf(gl.bindImageTexture), "glBindImageTexture");
        gl.memoryBarrier = try getProcAddress(@TypeOf(gl.memoryBarrier), "glMemoryBarrier");
        // TODO
    }

    // OpenGL 4.3
    if (ver >= 43) {
        // TODO
    }

    // OpenGL 4.4
    if (ver >= 44) {
        gl.clearTexImage = try getProcAddress(@TypeOf(gl.clearTexImage), "glClearTexImage");
        // TODO
    }

    // OpenGL 4.5
    if (ver >= 45) {
        gl.textureStorage2D = try getProcAddress(@TypeOf(gl.textureStorage2D), "glTextureStorage2D");
        gl.textureStorage2DMultisample = try getProcAddress(
            @TypeOf(gl.textureStorage2DMultisample),
            "glTextureStorage2DMultisample",
        );
        gl.createTextures = try getProcAddress(@TypeOf(gl.createTextures), "glCreateTextures");
        gl.createFramebuffers = try getProcAddress(
            @TypeOf(gl.createFramebuffers),
            "glCreateFramebuffers",
        );
        gl.namedFramebufferTexture = try getProcAddress(
            @TypeOf(gl.namedFramebufferTexture),
            "glNamedFramebufferTexture",
        );
        gl.blitNamedFramebuffer = try getProcAddress(
            @TypeOf(gl.blitNamedFramebuffer),
            "glBlitNamedFramebuffer",
        );
        gl.createBuffers = try getProcAddress(@TypeOf(gl.createBuffers), "glCreateBuffers");
        gl.clearNamedFramebufferfv = try getProcAddress(
            @TypeOf(gl.clearNamedFramebufferfv),
            "glClearNamedFramebufferfv",
        );
        gl.namedBufferStorage = try getProcAddress(
            @TypeOf(gl.namedBufferStorage),
            "glNamedBufferStorage",
        );
        gl.bindTextureUnit = try getProcAddress(@TypeOf(gl.bindTextureUnit), "glBindTextureUnit");
        gl.textureBarrier = try getProcAddress(@TypeOf(gl.textureBarrier), "glTextureBarrier");
        // TODO
    }

    // OpenGL 4.6
    if (ver >= 46) {
        // TODO
    }
}

/// Loads a subset of OpenGL 4.6 (Compatibility Profile) + some useful, multivendor (NVIDIA, AMD) extensions.
pub fn loadCompatProfileExt(loader: LoaderFn) !void {
    try loadCoreProfile(loader, 4, 6);

    gl.begin = try getProcAddress(@TypeOf(gl.begin), "glBegin");
    gl.end = try getProcAddress(@TypeOf(gl.end), "glEnd");
    gl.newList = try getProcAddress(@TypeOf(gl.newList), "glNewList");
    gl.callList = try getProcAddress(@TypeOf(gl.callList), "glCallList");
    gl.endList = try getProcAddress(@TypeOf(gl.endList), "glEndList");
    gl.loadIdentity = try getProcAddress(@TypeOf(gl.loadIdentity), "glLoadIdentity");
    gl.vertex2fv = try getProcAddress(@TypeOf(gl.vertex2fv), "glVertex2fv");
    gl.vertex3fv = try getProcAddress(@TypeOf(gl.vertex3fv), "glVertex3fv");
    gl.vertex4fv = try getProcAddress(@TypeOf(gl.vertex4fv), "glVertex4fv");
    gl.color3fv = try getProcAddress(@TypeOf(gl.color3fv), "glColor3fv");
    gl.color4fv = try getProcAddress(@TypeOf(gl.color4fv), "glColor4fv");
    gl.rectf = try getProcAddress(@TypeOf(gl.rectf), "glRectf");
    gl.matrixMode = try getProcAddress(@TypeOf(gl.matrixMode), "glMatrixMode");
    gl.vertex2f = try getProcAddress(@TypeOf(gl.vertex2f), "glVertex2f");
    gl.vertex2d = try getProcAddress(@TypeOf(gl.vertex2d), "glVertex2d");
    gl.vertex2i = try getProcAddress(@TypeOf(gl.vertex2i), "glVertex2i");
    gl.color3f = try getProcAddress(@TypeOf(gl.color3f), "glColor3f");
    gl.color4f = try getProcAddress(@TypeOf(gl.color4f), "glColor4f");
    gl.color4ub = try getProcAddress(@TypeOf(gl.color4ub), "glColor4ub");
    gl.pushMatrix = try getProcAddress(@TypeOf(gl.pushMatrix), "glPushMatrix");
    gl.popMatrix = try getProcAddress(@TypeOf(gl.popMatrix), "glPopMatrix");
    gl.rotatef = try getProcAddress(@TypeOf(gl.rotatef), "glRotatef");
    gl.scalef = try getProcAddress(@TypeOf(gl.scalef), "glScalef");
    gl.translatef = try getProcAddress(@TypeOf(gl.translatef), "glTranslatef");
    gl.matrixLoadIdentityEXT = try getProcAddress(
        @TypeOf(gl.matrixLoadIdentityEXT),
        "glMatrixLoadIdentityEXT",
    );
    gl.matrixOrthoEXT = try getProcAddress(@TypeOf(gl.matrixOrthoEXT), "glMatrixOrthoEXT");
}

pub fn loadEsProfile(loader: LoaderFn, major: u32, minor: u32) !void {
    const ver = 10 * major + minor;

    assert(major >= 1 and major <= 3);
    assert(minor >= 0 and minor <= 2);
    assert(ver >= 10 and ver <= 32);

    loaderFunc = loader;

    // OpenGL ES 1.0
    if (ver >= 10) {
        gl.cullFace = try getProcAddress(@TypeOf(gl.cullFace), "glCullFace");
        gl.frontFace = try getProcAddress(@TypeOf(gl.frontFace), "glFrontFace");
        gl.hint = try getProcAddress(@TypeOf(gl.hint), "glHint");
        gl.lineWidth = try getProcAddress(@TypeOf(gl.lineWidth), "glLineWidth");
        gl.scissor = try getProcAddress(@TypeOf(gl.scissor), "glScissor");
        gl.texParameterf = try getProcAddress(@TypeOf(gl.texParameterf), "glTexParameterf");
        gl.texParameterfv = try getProcAddress(@TypeOf(gl.texParameterfv), "glTexParameterfv");
        gl.texParameteri = try getProcAddress(@TypeOf(gl.texParameteri), "glTexParameteri");
        gl.texParameteriv = try getProcAddress(@TypeOf(gl.texParameteriv), "glTexParameteriv");
        gl.texImage2D = try getProcAddress(@TypeOf(gl.texImage2D), "glTexImage2D");
        gl.clear = try getProcAddress(@TypeOf(gl.clear), "glClear");
        gl.clearColor = try getProcAddress(@TypeOf(gl.clearColor), "glClearColor");
        gl.clearStencil = try getProcAddress(@TypeOf(gl.clearStencil), "glClearStencil");
        gl.clearDepthf = try getProcAddress(@TypeOf(gl.clearDepthf), "glClearDepthf");
        gl.stencilMask = try getProcAddress(@TypeOf(gl.stencilMask), "glStencilMask");
        gl.colorMask = try getProcAddress(@TypeOf(gl.colorMask), "glColorMask");
        gl.depthMask = try getProcAddress(@TypeOf(gl.depthMask), "glDepthMask");
        gl.disable = try getProcAddress(@TypeOf(gl.disable), "glDisable");
        gl.enable = try getProcAddress(@TypeOf(gl.enable), "glEnable");
        gl.finish = try getProcAddress(@TypeOf(gl.finish), "glFinish");
        gl.flush = try getProcAddress(@TypeOf(gl.flush), "glFlush");
        gl.blendFunc = try getProcAddress(@TypeOf(gl.blendFunc), "glBlendFunc");
        gl.stencilFunc = try getProcAddress(@TypeOf(gl.stencilFunc), "glStencilFunc");
        gl.stencilOp = try getProcAddress(@TypeOf(gl.stencilOp), "glStencilOp");
        gl.depthFunc = try getProcAddress(@TypeOf(gl.depthFunc), "glDepthFunc");
        gl.pixelStorei = try getProcAddress(@TypeOf(gl.pixelStorei), "glPixelStorei");
        gl.readPixels = try getProcAddress(@TypeOf(gl.readPixels), "glReadPixels");
        gl.getBooleanv = try getProcAddress(@TypeOf(gl.getBooleanv), "glGetBooleanv");
        gl.getError = try getProcAddress(@TypeOf(gl.getError), "glGetError");
        gl.getFloatv = try getProcAddress(@TypeOf(gl.getFloatv), "glGetFloatv");
        gl.getIntegerv = try getProcAddress(@TypeOf(gl.getIntegerv), "glGetIntegerv");
        gl.getString = try getProcAddress(@TypeOf(gl.getString), "glGetString");
        gl.isEnabled = try getProcAddress(@TypeOf(gl.isEnabled), "glIsEnabled");
        gl.depthRangef = try getProcAddress(@TypeOf(gl.depthRangef), "glDepthRangef");
        gl.viewport = try getProcAddress(@TypeOf(gl.viewport), "glViewport");
        gl.drawArrays = try getProcAddress(@TypeOf(gl.drawArrays), "glDrawArrays");
        gl.drawElements = try getProcAddress(@TypeOf(gl.drawElements), "glDrawElements");
        gl.polygonOffset = try getProcAddress(@TypeOf(gl.polygonOffset), "glPolygonOffset");
        gl.copyTexImage2D = try getProcAddress(@TypeOf(gl.copyTexImage2D), "glCopyTexImage2D");
        gl.copyTexSubImage2D = try getProcAddress(@TypeOf(gl.copyTexSubImage2D), "glCopyTexSubImage2D");
        gl.texSubImage2D = try getProcAddress(@TypeOf(gl.texSubImage2D), "glTexSubImage2D");
        gl.bindTexture = try getProcAddress(@TypeOf(gl.bindTexture), "glBindTexture");
        gl.deleteTextures = try getProcAddress(@TypeOf(gl.deleteTextures), "glDeleteTextures");
        gl.genTextures = try getProcAddress(@TypeOf(gl.genTextures), "glGenTextures");
        gl.isTexture = try getProcAddress(@TypeOf(gl.isTexture), "glIsTexture");
        gl.activeTexture = try getProcAddress(@TypeOf(gl.activeTexture), "glActiveTexture");
        gl.sampleCoverage = try getProcAddress(@TypeOf(gl.sampleCoverage), "glSampleCoverage");
        gl.compressedTexImage2D = try getProcAddress(
            @TypeOf(gl.compressedTexImage2D),
            "glCompressedTexImage2D",
        );
        gl.compressedTexSubImage2D = try getProcAddress(
            @TypeOf(gl.compressedTexSubImage2D),
            "glCompressedTexSubImage2D",
        );
    }

    // OpenGL ES 1.1
    if (ver >= 11) {
        gl.blendFuncSeparate = try getProcAddress(@TypeOf(gl.blendFuncSeparate), "glBlendFuncSeparate");
        gl.blendColor = try getProcAddress(@TypeOf(gl.blendColor), "glBlendColor");
        gl.blendEquation = try getProcAddress(@TypeOf(gl.blendEquation), "glBlendEquation");
        gl.bindBuffer = try getProcAddress(@TypeOf(gl.bindBuffer), "glBindBuffer");
        gl.deleteBuffers = try getProcAddress(@TypeOf(gl.deleteBuffers), "glDeleteBuffers");
        gl.genBuffers = try getProcAddress(@TypeOf(gl.genBuffers), "glGenBuffers");
        gl.isBuffer = try getProcAddress(@TypeOf(gl.isBuffer), "glIsBuffer");
        gl.bufferData = try getProcAddress(@TypeOf(gl.bufferData), "glBufferData");
        gl.bufferSubData = try getProcAddress(@TypeOf(gl.bufferSubData), "glBufferSubData");
        gl.getBufferParameteriv = try getProcAddress(
            @TypeOf(gl.getBufferParameteriv),
            "glGetBufferParameteriv",
        );
    }

    // OpenGL ES 2.0
    if (ver >= 20) {
        gl.blendEquationSeparate = try getProcAddress(
            @TypeOf(gl.blendEquationSeparate),
            "glBlendEquationSeparate",
        );
        gl.stencilOpSeparate = try getProcAddress(@TypeOf(gl.stencilOpSeparate), "glStencilOpSeparate");
        gl.stencilFuncSeparate = try getProcAddress(
            @TypeOf(gl.stencilFuncSeparate),
            "glStencilFuncSeparate",
        );
        gl.stencilMaskSeparate = try getProcAddress(
            @TypeOf(gl.stencilMaskSeparate),
            "glStencilMaskSeparate",
        );
        gl.attachShader = try getProcAddress(@TypeOf(gl.attachShader), "glAttachShader");
        gl.bindAttribLocation = try getProcAddress(
            @TypeOf(gl.bindAttribLocation),
            "glBindAttribLocation",
        );
        gl.compileShader = try getProcAddress(@TypeOf(gl.compileShader), "glCompileShader");
        gl.createProgram = try getProcAddress(@TypeOf(gl.createProgram), "glCreateProgram");
        gl.createShader = try getProcAddress(@TypeOf(gl.createShader), "glCreateShader");
        gl.deleteProgram = try getProcAddress(@TypeOf(gl.deleteProgram), "glDeleteProgram");
        gl.deleteShader = try getProcAddress(@TypeOf(gl.deleteShader), "glDeleteShader");
        gl.detachShader = try getProcAddress(@TypeOf(gl.detachShader), "glDetachShader");
        gl.disableVertexAttribArray = try getProcAddress(
            @TypeOf(gl.disableVertexAttribArray),
            "glDisableVertexAttribArray",
        );
        gl.enableVertexAttribArray = try getProcAddress(
            @TypeOf(gl.enableVertexAttribArray),
            "glEnableVertexAttribArray",
        );
        gl.getActiveAttrib = try getProcAddress(@TypeOf(gl.getActiveAttrib), "glGetActiveAttrib");
        gl.getActiveUniform = try getProcAddress(@TypeOf(gl.getActiveUniform), "glGetActiveUniform");
        gl.getAttachedShaders = try getProcAddress(
            @TypeOf(gl.getAttachedShaders),
            "glGetAttachedShaders",
        );
        gl.getAttribLocation = try getProcAddress(@TypeOf(gl.getAttribLocation), "glGetAttribLocation");
        gl.getProgramiv = try getProcAddress(@TypeOf(gl.getProgramiv), "glGetProgramiv");
        gl.getProgramInfoLog = try getProcAddress(@TypeOf(gl.getProgramInfoLog), "glGetProgramInfoLog");
        gl.getShaderiv = try getProcAddress(@TypeOf(gl.getShaderiv), "glGetShaderiv");
        gl.getShaderInfoLog = try getProcAddress(@TypeOf(gl.getShaderInfoLog), "glGetShaderInfoLog");
        gl.getShaderSource = try getProcAddress(@TypeOf(gl.getShaderSource), "glGetShaderSource");
        gl.getUniformLocation = try getProcAddress(
            @TypeOf(gl.getUniformLocation),
            "glGetUniformLocation",
        );
        gl.getUniformfv = try getProcAddress(@TypeOf(gl.getUniformfv), "glGetUniformfv");
        gl.getUniformiv = try getProcAddress(@TypeOf(gl.getUniformiv), "glGetUniformiv");
        gl.getVertexAttribPointerv = try getProcAddress(
            @TypeOf(gl.getVertexAttribPointerv),
            "glGetVertexAttribPointerv",
        );
        gl.isProgram = try getProcAddress(@TypeOf(gl.isProgram), "glIsProgram");
        gl.isShader = try getProcAddress(@TypeOf(gl.isShader), "glIsShader");
        gl.linkProgram = try getProcAddress(@TypeOf(gl.linkProgram), "glLinkProgram");
        gl.shaderSource = try getProcAddress(@TypeOf(gl.shaderSource), "glShaderSource");
        gl.useProgram = try getProcAddress(@TypeOf(gl.useProgram), "glUseProgram");
        gl.uniform1f = try getProcAddress(@TypeOf(gl.uniform1f), "glUniform1f");
        gl.uniform2f = try getProcAddress(@TypeOf(gl.uniform2f), "glUniform2f");
        gl.uniform3f = try getProcAddress(@TypeOf(gl.uniform3f), "glUniform3f");
        gl.uniform4f = try getProcAddress(@TypeOf(gl.uniform4f), "glUniform4f");
        gl.uniform1i = try getProcAddress(@TypeOf(gl.uniform1i), "glUniform1i");
        gl.uniform2i = try getProcAddress(@TypeOf(gl.uniform2i), "glUniform2i");
        gl.uniform3i = try getProcAddress(@TypeOf(gl.uniform3i), "glUniform3i");
        gl.uniform4i = try getProcAddress(@TypeOf(gl.uniform4i), "glUniform4i");
        gl.uniform1fv = try getProcAddress(@TypeOf(gl.uniform1fv), "glUniform1fv");
        gl.uniform2fv = try getProcAddress(@TypeOf(gl.uniform2fv), "glUniform2fv");
        gl.uniform3fv = try getProcAddress(@TypeOf(gl.uniform3fv), "glUniform3fv");
        gl.uniform4fv = try getProcAddress(@TypeOf(gl.uniform4fv), "glUniform4fv");
        gl.uniform1iv = try getProcAddress(@TypeOf(gl.uniform1iv), "glUniform1iv");
        gl.uniform2iv = try getProcAddress(@TypeOf(gl.uniform2iv), "glUniform2iv");
        gl.uniform3iv = try getProcAddress(@TypeOf(gl.uniform3iv), "glUniform3iv");
        gl.uniform4iv = try getProcAddress(@TypeOf(gl.uniform4iv), "glUniform4iv");
        gl.uniformMatrix2fv = try getProcAddress(@TypeOf(gl.uniformMatrix2fv), "glUniformMatrix2fv");
        gl.uniformMatrix3fv = try getProcAddress(@TypeOf(gl.uniformMatrix3fv), "glUniformMatrix3fv");
        gl.uniformMatrix4fv = try getProcAddress(@TypeOf(gl.uniformMatrix4fv), "glUniformMatrix4fv");
        gl.validateProgram = try getProcAddress(@TypeOf(gl.validateProgram), "glValidateProgram");
        gl.vertexAttribPointer = try getProcAddress(
            @TypeOf(gl.vertexAttribPointer),
            "glVertexAttribPointer",
        );
        gl.isRenderbuffer = try getProcAddress(@TypeOf(gl.isRenderbuffer), "glIsRenderbuffer");
        gl.bindRenderbuffer = try getProcAddress(@TypeOf(gl.bindRenderbuffer), "glBindRenderbuffer");
        gl.deleteRenderbuffers = try getProcAddress(
            @TypeOf(gl.deleteRenderbuffers),
            "glDeleteRenderbuffers",
        );
        gl.genRenderbuffers = try getProcAddress(@TypeOf(gl.genRenderbuffers), "glGenRenderbuffers");
        gl.renderbufferStorage = try getProcAddress(
            @TypeOf(gl.renderbufferStorage),
            "glRenderbufferStorage",
        );
        gl.getRenderbufferParameteriv = try getProcAddress(
            @TypeOf(gl.getRenderbufferParameteriv),
            "glGetRenderbufferParameteriv",
        );
        gl.isFramebuffer = try getProcAddress(@TypeOf(gl.isFramebuffer), "glIsFramebuffer");
        gl.bindFramebuffer = try getProcAddress(@TypeOf(gl.bindFramebuffer), "glBindFramebuffer");
        gl.deleteFramebuffers = try getProcAddress(
            @TypeOf(gl.deleteFramebuffers),
            "glDeleteFramebuffers",
        );
        gl.genFramebuffers = try getProcAddress(@TypeOf(gl.genFramebuffers), "glGenFramebuffers");
        gl.checkFramebufferStatus = try getProcAddress(
            @TypeOf(gl.checkFramebufferStatus),
            "glCheckFramebufferStatus",
        );
        gl.framebufferTexture2D = try getProcAddress(
            @TypeOf(gl.framebufferTexture2D),
            "glFramebufferTexture2D",
        );
        gl.framebufferRenderbuffer = try getProcAddress(
            @TypeOf(gl.framebufferRenderbuffer),
            "glFramebufferRenderbuffer",
        );
        gl.getFramebufferAttachmentParameteriv = try getProcAddress(
            @TypeOf(gl.getFramebufferAttachmentParameteriv),
            "glGetFramebufferAttachmentParameteriv",
        );
        gl.generateMipmap = try getProcAddress(@TypeOf(gl.generateMipmap), "glGenerateMipmap");
    }

    // OpenGL ES 3.0
    if (ver >= 30) {
        gl.uniformMatrix2x3fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix2x3fv),
            "glUniformMatrix2x3fv",
        );
        gl.uniformMatrix3x2fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix3x2fv),
            "glUniformMatrix3x2fv",
        );
        gl.uniformMatrix2x4fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix2x4fv),
            "glUniformMatrix2x4fv",
        );
        gl.uniformMatrix4x2fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix4x2fv),
            "glUniformMatrix4x2fv",
        );
        gl.uniformMatrix3x4fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix3x4fv),
            "glUniformMatrix3x4fv",
        );
        gl.uniformMatrix4x3fv = try getProcAddress(
            @TypeOf(gl.uniformMatrix4x3fv),
            "glUniformMatrix4x3fv",
        );
        gl.getBooleani_v = try getProcAddress(@TypeOf(gl.getBooleani_v), "glGetBooleani_v");
        gl.getIntegeri_v = try getProcAddress(@TypeOf(gl.getIntegeri_v), "glGetIntegeri_v");
        gl.beginTransformFeedback = try getProcAddress(
            @TypeOf(gl.beginTransformFeedback),
            "glBeginTransformFeedback",
        );
        gl.endTransformFeedback = try getProcAddress(
            @TypeOf(gl.endTransformFeedback),
            "glEndTransformFeedback",
        );
        gl.bindBufferRange = try getProcAddress(@TypeOf(gl.bindBufferRange), "glBindBufferRange");
        gl.bindBufferBase = try getProcAddress(@TypeOf(gl.bindBufferBase), "glBindBufferBase");
        gl.transformFeedbackVaryings = try getProcAddress(
            @TypeOf(gl.transformFeedbackVaryings),
            "glTransformFeedbackVaryings",
        );
        gl.getTransformFeedbackVarying = try getProcAddress(
            @TypeOf(gl.getTransformFeedbackVarying),
            "glGetTransformFeedbackVarying",
        );
        gl.vertexAttribIPointer = try getProcAddress(
            @TypeOf(gl.vertexAttribIPointer),
            "glVertexAttribIPointer",
        );
        gl.getVertexAttribIiv = try getProcAddress(
            @TypeOf(gl.getVertexAttribIiv),
            "glGetVertexAttribIiv",
        );
        gl.getVertexAttribIuiv = try getProcAddress(
            @TypeOf(gl.getVertexAttribIuiv),
            "glGetVertexAttribIuiv",
        );
        gl.getUniformuiv = try getProcAddress(@TypeOf(gl.getUniformuiv), "glGetUniformuiv");
        gl.getFragDataLocation = try getProcAddress(
            @TypeOf(gl.getFragDataLocation),
            "glGetFragDataLocation",
        );
        gl.uniform1ui = try getProcAddress(@TypeOf(gl.uniform1ui), "glUniform1ui");
        gl.uniform2ui = try getProcAddress(@TypeOf(gl.uniform2ui), "glUniform2ui");
        gl.uniform3ui = try getProcAddress(@TypeOf(gl.uniform3ui), "glUniform3ui");
        gl.uniform4ui = try getProcAddress(@TypeOf(gl.uniform4ui), "glUniform4ui");
        gl.uniform1uiv = try getProcAddress(@TypeOf(gl.uniform1uiv), "glUniform1uiv");
        gl.uniform2uiv = try getProcAddress(@TypeOf(gl.uniform2uiv), "glUniform2uiv");
        gl.uniform3uiv = try getProcAddress(@TypeOf(gl.uniform3uiv), "glUniform3uiv");
        gl.uniform4uiv = try getProcAddress(@TypeOf(gl.uniform4uiv), "glUniform4uiv");
        gl.clearBufferiv = try getProcAddress(@TypeOf(gl.clearBufferiv), "glClearBufferiv");
        gl.clearBufferuiv = try getProcAddress(@TypeOf(gl.clearBufferuiv), "glClearBufferuiv");
        gl.clearBufferfv = try getProcAddress(@TypeOf(gl.clearBufferfv), "glClearBufferfv");
        gl.clearBufferfi = try getProcAddress(@TypeOf(gl.clearBufferfi), "glClearBufferfi");
        gl.getStringi = try getProcAddress(@TypeOf(gl.getStringi), "glGetStringi");
        gl.blitFramebuffer = try getProcAddress(@TypeOf(gl.blitFramebuffer), "glBlitFramebuffer");
        gl.renderbufferStorageMultisample = try getProcAddress(
            @TypeOf(gl.renderbufferStorageMultisample),
            "glRenderbufferStorageMultisample",
        );
        gl.framebufferTextureLayer = try getProcAddress(
            @TypeOf(gl.framebufferTextureLayer),
            "glFramebufferTextureLayer",
        );
        gl.mapBufferRange = try getProcAddress(@TypeOf(gl.mapBufferRange), "glMapBufferRange");
        gl.flushMappedBufferRange = try getProcAddress(
            @TypeOf(gl.flushMappedBufferRange),
            "glFlushMappedBufferRange",
        );
        gl.bindVertexArray = try getProcAddress(@TypeOf(gl.bindVertexArray), "glBindVertexArray");
        gl.deleteVertexArrays = try getProcAddress(
            @TypeOf(gl.deleteVertexArrays),
            "glDeleteVertexArrays",
        );
        gl.genVertexArrays = try getProcAddress(@TypeOf(gl.genVertexArrays), "glGenVertexArrays");
        gl.isVertexArray = try getProcAddress(@TypeOf(gl.isVertexArray), "glIsVertexArray");
        gl.drawArraysInstanced = try getProcAddress(
            @TypeOf(gl.drawArraysInstanced),
            "glDrawArraysInstanced",
        );
        gl.drawElementsInstanced = try getProcAddress(
            @TypeOf(gl.drawElementsInstanced),
            "glDrawElementsInstanced",
        );
        gl.copyBufferSubData = try getProcAddress(@TypeOf(gl.copyBufferSubData), "glCopyBufferSubData");
        gl.getUniformIndices = try getProcAddress(@TypeOf(gl.getUniformIndices), "glGetUniformIndices");
        gl.getActiveUniformsiv = try getProcAddress(
            @TypeOf(gl.getActiveUniformsiv),
            "glGetActiveUniformsiv",
        );
        gl.getUniformBlockIndex = try getProcAddress(
            @TypeOf(gl.getUniformBlockIndex),
            "glGetUniformBlockIndex",
        );
        gl.getActiveUniformBlockiv = try getProcAddress(
            @TypeOf(gl.getActiveUniformBlockiv),
            "glGetActiveUniformBlockiv",
        );
        gl.getActiveUniformBlockName = try getProcAddress(
            @TypeOf(gl.getActiveUniformBlockName),
            "glGetActiveUniformBlockName",
        );
        gl.uniformBlockBinding = try getProcAddress(
            @TypeOf(gl.uniformBlockBinding),
            "glUniformBlockBinding",
        );
        gl.fenceSync = try getProcAddress(@TypeOf(gl.fenceSync), "glFenceSync");
        gl.isSync = try getProcAddress(@TypeOf(gl.isSync), "glIsSync");
        gl.deleteSync = try getProcAddress(@TypeOf(gl.deleteSync), "glDeleteSync");
        gl.clientWaitSync = try getProcAddress(@TypeOf(gl.clientWaitSync), "glClientWaitSync");
        gl.waitSync = try getProcAddress(@TypeOf(gl.waitSync), "glWaitSync");
        gl.getInteger64v = try getProcAddress(@TypeOf(gl.getInteger64v), "glGetInteger64v");
        gl.getSynciv = try getProcAddress(@TypeOf(gl.getSynciv), "glGetSynciv");
        gl.getInteger64i_v = try getProcAddress(@TypeOf(gl.getInteger64i_v), "glGetInteger64i_v");
        gl.getBufferParameteri64v = try getProcAddress(
            @TypeOf(gl.getBufferParameteri64v),
            "glGetBufferParameteri64v",
        );
        gl.getMultisamplefv = try getProcAddress(@TypeOf(gl.getMultisamplefv), "glGetMultisamplefv");
        gl.sampleMaski = try getProcAddress(@TypeOf(gl.sampleMaski), "glSampleMaski");
        gl.genSamplers = try getProcAddress(@TypeOf(gl.genSamplers), "glGenSamplers");
        gl.deleteSamplers = try getProcAddress(@TypeOf(gl.deleteSamplers), "glDeleteSamplers");
        gl.isSampler = try getProcAddress(@TypeOf(gl.isSampler), "glIsSampler");
        gl.bindSampler = try getProcAddress(@TypeOf(gl.bindSampler), "glBindSampler");
        gl.samplerParameteri = try getProcAddress(@TypeOf(gl.samplerParameteri), "glSamplerParameteri");
        gl.samplerParameteriv = try getProcAddress(
            @TypeOf(gl.samplerParameteriv),
            "glSamplerParameteriv",
        );
        gl.samplerParameterf = try getProcAddress(@TypeOf(gl.samplerParameterf), "glSamplerParameterf");
        gl.samplerParameterfv = try getProcAddress(
            @TypeOf(gl.samplerParameterfv),
            "glSamplerParameterfv",
        );
        gl.samplerParameterIiv = try getProcAddress(
            @TypeOf(gl.samplerParameterIiv),
            "glSamplerParameterIiv",
        );
        gl.samplerParameterIuiv = try getProcAddress(
            @TypeOf(gl.samplerParameterIuiv),
            "glSamplerParameterIuiv",
        );
        gl.getSamplerParameteriv = try getProcAddress(
            @TypeOf(gl.getSamplerParameteriv),
            "glGetSamplerParameteriv",
        );
        gl.getSamplerParameterIiv = try getProcAddress(
            @TypeOf(gl.getSamplerParameterIiv),
            "glGetSamplerParameterIiv",
        );
        gl.getSamplerParameterfv = try getProcAddress(
            @TypeOf(gl.getSamplerParameterfv),
            "glGetSamplerParameterfv",
        );
        gl.vertexAttribDivisor = try getProcAddress(
            @TypeOf(gl.vertexAttribDivisor),
            "glVertexAttribDivisor",
        );
        // TODO: from opengl 4.0 to 4.3 *subset*
    }
}

pub fn loadExtension(loader: LoaderFn, extension: Extension) !void {
    loaderFunc = loader;

    switch (extension) {
        .OES_vertex_array_object => {
            gl.bindVertexArrayOES = try getProcAddress(
                @TypeOf(gl.bindVertexArrayOES),
                "glBindVertexArrayOES",
            );
            gl.deleteVertexArraysOES = try getProcAddress(
                @TypeOf(gl.deleteVertexArraysOES),
                "glDeleteVertexArraysOES",
            );
            gl.genVertexArraysOES = try getProcAddress(
                @TypeOf(gl.genVertexArraysOES),
                "glGenVertexArraysOES",
            );
            gl.isVertexArrayOES = try getProcAddress(
                @TypeOf(gl.isVertexArrayOES),
                "glIsVertexArrayOES",
            );
        },
        .NV_bindless_texture => {
            gl.getTextureHandleNV = try getProcAddress(
                @TypeOf(gl.getTextureHandleNV),
                "glGetTextureHandleNV",
            );
            gl.makeTextureHandleResidentNV = try getProcAddress(
                @TypeOf(gl.makeTextureHandleResidentNV),
                "glMakeTextureHandleResidentNV",
            );
            gl.programUniformHandleui64NV = try getProcAddress(
                @TypeOf(gl.programUniformHandleui64NV),
                "glProgramUniformHandleui64NV",
            );
        },
        .NV_shader_buffer_load => {
            gl.makeNamedBufferResidentNV = try getProcAddress(
                @TypeOf(gl.makeNamedBufferResidentNV),
                "glMakeNamedBufferResidentNV",
            );
            gl.getNamedBufferParameterui64vNV = try getProcAddress(
                @TypeOf(gl.getNamedBufferParameterui64vNV),
                "glGetNamedBufferParameterui64vNV",
            );
            gl.programUniformui64NV = try getProcAddress(
                @TypeOf(gl.programUniformui64NV),
                "glProgramUniformui64vNV",
            );
        },
    }
}
//--------------------------------------------------------------------------------------------------
var loaderFunc: LoaderFn = undefined;

fn getProcAddress(comptime T: type, name: [:0]const u8) !T {
    if (loaderFunc(name)) |addr| {
        return @as(T, @ptrFromInt(@intFromPtr(addr)));
    }
    std.log.debug("zopengl: {s} not found", .{name});
    return error.OpenGL_FunctionNotFound;
}
//--------------------------------------------------------------------------------------------------
//
// C exports
//
//--------------------------------------------------------------------------------------------------
const linkage: @import("std").builtin.GlobalLinkage = .Strong;
comptime {
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.0 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.cullFace, .{ .name = "glCullFace", .linkage = linkage });
    @export(gl.frontFace, .{ .name = "glFrontFace", .linkage = linkage });
    @export(gl.hint, .{ .name = "glHint", .linkage = linkage });
    @export(gl.lineWidth, .{ .name = "glLineWidth", .linkage = linkage });
    @export(gl.pointSize, .{ .name = "glPointSize", .linkage = linkage });
    @export(gl.polygonMode, .{ .name = "glPolygonMode", .linkage = linkage });
    @export(gl.scissor, .{ .name = "glScissor", .linkage = linkage });
    @export(gl.texParameterf, .{ .name = "glTexParameterf", .linkage = linkage });
    @export(gl.texParameterfv, .{ .name = "glTexParameterfv", .linkage = linkage });
    @export(gl.texParameteri, .{ .name = "glTexParameteri", .linkage = linkage });
    @export(gl.texParameteriv, .{ .name = "glTexParameteriv", .linkage = linkage });
    @export(gl.texImage1D, .{ .name = "glTexImage1D", .linkage = linkage });
    @export(gl.texImage2D, .{ .name = "glTexImage2D", .linkage = linkage });
    @export(gl.drawBuffer, .{ .name = "glDrawBuffer", .linkage = linkage });
    @export(gl.clear, .{ .name = "glClear", .linkage = linkage });
    @export(gl.clearColor, .{ .name = "glClearColor", .linkage = linkage });
    @export(gl.clearStencil, .{ .name = "glClearStencil", .linkage = linkage });
    @export(gl.stencilMask, .{ .name = "glStencilMask", .linkage = linkage });
    @export(gl.colorMask, .{ .name = "glColorMask", .linkage = linkage });
    @export(gl.depthMask, .{ .name = "glDepthMask", .linkage = linkage });
    @export(gl.disable, .{ .name = "glDisable", .linkage = linkage });
    @export(gl.enable, .{ .name = "glEnable", .linkage = linkage });
    @export(gl.finish, .{ .name = "glFinish", .linkage = linkage });
    @export(gl.flush, .{ .name = "glFlush", .linkage = linkage });
    @export(gl.blendFunc, .{ .name = "glBlendFunc", .linkage = linkage });
    @export(gl.logicOp, .{ .name = "glLogicOp", .linkage = linkage });
    @export(gl.stencilFunc, .{ .name = "glStencilFunc", .linkage = linkage });
    @export(gl.stencilOp, .{ .name = "glStencilOp", .linkage = linkage });
    @export(gl.depthFunc, .{ .name = "glDepthFunc", .linkage = linkage });
    @export(gl.pixelStoref, .{ .name = "glPixelStoref", .linkage = linkage });
    @export(gl.pixelStorei, .{ .name = "glPixelStorei", .linkage = linkage });
    @export(gl.readBuffer, .{ .name = "glReadBuffer", .linkage = linkage });
    @export(gl.readPixels, .{ .name = "glReadPixels", .linkage = linkage });
    @export(gl.getBooleanv, .{ .name = "glGetBooleanv", .linkage = linkage });
    @export(gl.getDoublev, .{ .name = "glGetDoublev", .linkage = linkage });
    @export(gl.getError, .{ .name = "glGetError", .linkage = linkage });
    @export(gl.getFloatv, .{ .name = "glGetFloatv", .linkage = linkage });
    @export(gl.getIntegerv, .{ .name = "glGetIntegerv", .linkage = linkage });
    @export(gl.getString, .{ .name = "glGetString", .linkage = linkage });
    @export(gl.getTexImage, .{ .name = "glGetTexImage", .linkage = linkage });
    @export(gl.getTexParameterfv, .{ .name = "glGetTexParameterfv", .linkage = linkage });
    @export(gl.getTexParameteriv, .{ .name = "glGetTexParameteriv", .linkage = linkage });
    @export(gl.getTexLevelParameterfv, .{ .name = "glGetTexLevelParameterfv", .linkage = linkage });
    @export(gl.getTexLevelParameteriv, .{ .name = "glGetTexLevelParameteriv", .linkage = linkage });
    @export(gl.isEnabled, .{ .name = "glIsEnabled", .linkage = linkage });
    @export(gl.depthRange, .{ .name = "glDepthRange", .linkage = linkage });
    @export(gl.viewport, .{ .name = "glViewport", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.1 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.drawArrays, .{ .name = "glDrawArrays", .linkage = linkage });
    @export(gl.drawElements, .{ .name = "glDrawElements", .linkage = linkage });
    @export(gl.polygonOffset, .{ .name = "glPolygonOffset", .linkage = linkage });
    @export(gl.copyTexImage1D, .{ .name = "glCopyTexImage1D", .linkage = linkage });
    @export(gl.copyTexImage2D, .{ .name = "glCopyTexImage2D", .linkage = linkage });
    @export(gl.copyTexSubImage1D, .{ .name = "glCopyTexSubImage1D", .linkage = linkage });
    @export(gl.copyTexSubImage2D, .{ .name = "glCopyTexSubImage2D", .linkage = linkage });
    @export(gl.texSubImage1D, .{ .name = "glTexSubImage1D", .linkage = linkage });
    @export(gl.texSubImage2D, .{ .name = "glTexSubImage2D", .linkage = linkage });
    @export(gl.bindTexture, .{ .name = "glBindTexture", .linkage = linkage });
    @export(gl.deleteTextures, .{ .name = "glDeleteTextures", .linkage = linkage });
    @export(gl.genTextures, .{ .name = "glGenTextures", .linkage = linkage });
    @export(gl.isTexture, .{ .name = "glIsTexture", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.2 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.drawRangeElements, .{ .name = "glDrawRangeElements", .linkage = linkage });
    @export(gl.texImage3D, .{ .name = "glTexImage3D", .linkage = linkage });
    @export(gl.texSubImage3D, .{ .name = "glTexSubImage3D", .linkage = linkage });
    @export(gl.copyTexSubImage3D, .{ .name = "glCopyTexSubImage3D", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.3 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.activeTexture, .{ .name = "glActiveTexture", .linkage = linkage });
    @export(gl.sampleCoverage, .{ .name = "glSampleCoverage", .linkage = linkage });
    @export(gl.compressedTexImage3D, .{ .name = "glCompressedTexImage3D", .linkage = linkage });
    @export(gl.compressedTexImage2D, .{ .name = "glCompressedTexImage2D", .linkage = linkage });
    @export(gl.compressedTexImage1D, .{ .name = "glCompressedTexImage1D", .linkage = linkage });
    @export(gl.compressedTexSubImage3D, .{ .name = "glCompressedTexSubImage3D", .linkage = linkage });
    @export(gl.compressedTexSubImage2D, .{ .name = "glCompressedTexSubImage2D", .linkage = linkage });
    @export(gl.compressedTexSubImage1D, .{ .name = "glCompressedTexSubImage1D", .linkage = linkage });
    @export(gl.getCompressedTexImage, .{ .name = "glGetCompressedTexImage", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.4 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.pointParameterf, .{ .name = "glPointParameterf", .linkage = linkage });
    @export(gl.pointParameterfv, .{ .name = "glPointParameterfv", .linkage = linkage });
    @export(gl.pointParameteri, .{ .name = "glPointParameteri", .linkage = linkage });
    @export(gl.pointParameteriv, .{ .name = "glPointParameteriv", .linkage = linkage });
    @export(gl.blendColor, .{ .name = "glBlendColor", .linkage = linkage });
    @export(gl.blendEquation, .{ .name = "glBlendEquation", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 1.5 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.genQueries, .{ .name = "glGenQueries", .linkage = linkage });
    @export(gl.deleteQueries, .{ .name = "glDeleteQueries", .linkage = linkage });
    @export(gl.isQuery, .{ .name = "glIsQuery", .linkage = linkage });
    @export(gl.beginQuery, .{ .name = "glBeginQuery", .linkage = linkage });
    @export(gl.endQuery, .{ .name = "glEndQuery", .linkage = linkage });
    @export(gl.getQueryiv, .{ .name = "glGetQueryiv", .linkage = linkage });
    @export(gl.getQueryObjectiv, .{ .name = "glGetQueryObjectiv", .linkage = linkage });
    @export(gl.getQueryObjectuiv, .{ .name = "glGetQueryObjectuiv", .linkage = linkage });
    @export(gl.bindBuffer, .{ .name = "glBindBuffer", .linkage = linkage });
    @export(gl.deleteBuffers, .{ .name = "glDeleteBuffers", .linkage = linkage });
    @export(gl.genBuffers, .{ .name = "glGenBuffers", .linkage = linkage });
    @export(gl.isBuffer, .{ .name = "glIsBuffer", .linkage = linkage });
    @export(gl.bufferData, .{ .name = "glBufferData", .linkage = linkage });
    @export(gl.bufferSubData, .{ .name = "glBufferSubData", .linkage = linkage });
    @export(gl.getBufferSubData, .{ .name = "glGetBufferSubData", .linkage = linkage });
    @export(gl.mapBuffer, .{ .name = "glMapBuffer", .linkage = linkage });
    @export(gl.unmapBuffer, .{ .name = "glUnmapBuffer", .linkage = linkage });
    @export(gl.getBufferParameteriv, .{ .name = "glGetBufferParameteriv", .linkage = linkage });
    @export(gl.getBufferPointerv, .{ .name = "glGetBufferPointerv", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 2.0 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.blendEquationSeparate, .{ .name = "glBlendEquationSeparate", .linkage = linkage });
    @export(gl.drawBuffers, .{ .name = "glDrawBuffers", .linkage = linkage });
    @export(gl.stencilOpSeparate, .{ .name = "glStencilOpSeparate", .linkage = linkage });
    @export(gl.stencilFuncSeparate, .{ .name = "glStencilFuncSeparate", .linkage = linkage });
    @export(gl.stencilMaskSeparate, .{ .name = "glStencilMaskSeparate", .linkage = linkage });
    @export(gl.attachShader, .{ .name = "glAttachShader", .linkage = linkage });
    @export(gl.bindAttribLocation, .{ .name = "glBindAttribLocation", .linkage = linkage });
    @export(gl.compileShader, .{ .name = "glCompileShader", .linkage = linkage });
    @export(gl.createProgram, .{ .name = "glCreateProgram", .linkage = linkage });
    @export(gl.createShader, .{ .name = "glCreateShader", .linkage = linkage });
    @export(gl.deleteProgram, .{ .name = "glDeleteProgram", .linkage = linkage });
    @export(gl.deleteShader, .{ .name = "glDeleteShader", .linkage = linkage });
    @export(gl.detachShader, .{ .name = "glDetachShader", .linkage = linkage });
    @export(gl.disableVertexAttribArray, .{ .name = "glDisableVertexAttribArray", .linkage = linkage });
    @export(gl.enableVertexAttribArray, .{ .name = "glEnableVertexAttribArray", .linkage = linkage });
    @export(gl.getActiveAttrib, .{ .name = "glGetActiveAttrib", .linkage = linkage });
    @export(gl.getActiveUniform, .{ .name = "glGetActiveUniform", .linkage = linkage });
    @export(gl.getAttachedShaders, .{ .name = "glGetAttachedShaders", .linkage = linkage });
    @export(gl.getAttribLocation, .{ .name = "glGetAttribLocation", .linkage = linkage });
    @export(gl.getProgramiv, .{ .name = "glGetProgramiv", .linkage = linkage });
    @export(gl.getProgramInfoLog, .{ .name = "glGetProgramInfoLog", .linkage = linkage });
    @export(gl.getShaderiv, .{ .name = "glGetShaderiv", .linkage = linkage });
    @export(gl.getShaderInfoLog, .{ .name = "glGetShaderInfoLog", .linkage = linkage });
    @export(gl.getShaderSource, .{ .name = "glGetShaderSource", .linkage = linkage });
    @export(gl.getUniformLocation, .{ .name = "glGetUniformLocation", .linkage = linkage });
    @export(gl.getUniformfv, .{ .name = "glGetUniformfv", .linkage = linkage });
    @export(gl.getUniformiv, .{ .name = "glGetUniformiv", .linkage = linkage });
    @export(gl.getVertexAttribdv, .{ .name = "glGetVertexAttribdv", .linkage = linkage });
    @export(gl.getVertexAttribfv, .{ .name = "glGetVertexAttribfv", .linkage = linkage });
    @export(gl.getVertexAttribiv, .{ .name = "glGetVertexAttribiv", .linkage = linkage });
    @export(gl.getVertexAttribPointerv, .{ .name = "glGetVertexAttribPointerv", .linkage = linkage });
    @export(gl.isProgram, .{ .name = "glIsProgram", .linkage = linkage });
    @export(gl.isShader, .{ .name = "glIsShader", .linkage = linkage });
    @export(gl.linkProgram, .{ .name = "glLinkProgram", .linkage = linkage });
    @export(gl.shaderSource, .{ .name = "glShaderSource", .linkage = linkage });
    @export(gl.useProgram, .{ .name = "glUseProgram", .linkage = linkage });
    @export(gl.uniform1f, .{ .name = "glUniform1f", .linkage = linkage });
    @export(gl.uniform2f, .{ .name = "glUniform2f", .linkage = linkage });
    @export(gl.uniform3f, .{ .name = "glUniform3f", .linkage = linkage });
    @export(gl.uniform4f, .{ .name = "glUniform4f", .linkage = linkage });
    @export(gl.uniform1i, .{ .name = "glUniform1i", .linkage = linkage });
    @export(gl.uniform2i, .{ .name = "glUniform2i", .linkage = linkage });
    @export(gl.uniform3i, .{ .name = "glUniform3i", .linkage = linkage });
    @export(gl.uniform4i, .{ .name = "glUniform4i", .linkage = linkage });
    @export(gl.uniform1fv, .{ .name = "glUniform1fv", .linkage = linkage });
    @export(gl.uniform2fv, .{ .name = "glUniform2fv", .linkage = linkage });
    @export(gl.uniform3fv, .{ .name = "glUniform3fv", .linkage = linkage });
    @export(gl.uniform4fv, .{ .name = "glUniform4fv", .linkage = linkage });
    @export(gl.uniform1iv, .{ .name = "glUniform1iv", .linkage = linkage });
    @export(gl.uniform2iv, .{ .name = "glUniform2iv", .linkage = linkage });
    @export(gl.uniform3iv, .{ .name = "glUniform3iv", .linkage = linkage });
    @export(gl.uniform4iv, .{ .name = "glUniform4iv", .linkage = linkage });
    @export(gl.uniformMatrix2fv, .{ .name = "glUniformMatrix2fv", .linkage = linkage });
    @export(gl.uniformMatrix3fv, .{ .name = "glUniformMatrix3fv", .linkage = linkage });
    @export(gl.uniformMatrix4fv, .{ .name = "glUniformMatrix4fv", .linkage = linkage });
    @export(gl.validateProgram, .{ .name = "glValidateProgram", .linkage = linkage });
    @export(gl.vertexAttrib1d, .{ .name = "glVertexAttrib1d", .linkage = linkage });
    @export(gl.vertexAttrib1dv, .{ .name = "glVertexAttrib1dv", .linkage = linkage });
    @export(gl.vertexAttrib1f, .{ .name = "glVertexAttrib1f", .linkage = linkage });
    @export(gl.vertexAttrib1fv, .{ .name = "glVertexAttrib1fv", .linkage = linkage });
    @export(gl.vertexAttrib1s, .{ .name = "glVertexAttrib1s", .linkage = linkage });
    @export(gl.vertexAttrib1sv, .{ .name = "glVertexAttrib1sv", .linkage = linkage });
    @export(gl.vertexAttrib2d, .{ .name = "glVertexAttrib2d", .linkage = linkage });
    @export(gl.vertexAttrib2dv, .{ .name = "glVertexAttrib2dv", .linkage = linkage });
    @export(gl.vertexAttrib2f, .{ .name = "glVertexAttrib2f", .linkage = linkage });
    @export(gl.vertexAttrib2fv, .{ .name = "glVertexAttrib2fv", .linkage = linkage });
    @export(gl.vertexAttrib2s, .{ .name = "glVertexAttrib2s", .linkage = linkage });
    @export(gl.vertexAttrib2sv, .{ .name = "glVertexAttrib2sv", .linkage = linkage });
    @export(gl.vertexAttrib3d, .{ .name = "glVertexAttrib3d", .linkage = linkage });
    @export(gl.vertexAttrib3dv, .{ .name = "glVertexAttrib3dv", .linkage = linkage });
    @export(gl.vertexAttrib3f, .{ .name = "glVertexAttrib3f", .linkage = linkage });
    @export(gl.vertexAttrib3fv, .{ .name = "glVertexAttrib3fv", .linkage = linkage });
    @export(gl.vertexAttrib3s, .{ .name = "glVertexAttrib3s", .linkage = linkage });
    @export(gl.vertexAttrib3sv, .{ .name = "glVertexAttrib3sv", .linkage = linkage });
    @export(gl.vertexAttrib4Nbv, .{ .name = "glVertexAttrib4Nbv", .linkage = linkage });
    @export(gl.vertexAttrib4Niv, .{ .name = "glVertexAttrib4Niv", .linkage = linkage });
    @export(gl.vertexAttrib4Nsv, .{ .name = "glVertexAttrib4Nsv", .linkage = linkage });
    @export(gl.vertexAttrib4Nub, .{ .name = "glVertexAttrib4Nub", .linkage = linkage });
    @export(gl.vertexAttrib4Nubv, .{ .name = "glVertexAttrib4Nubv", .linkage = linkage });
    @export(gl.vertexAttrib4Nuiv, .{ .name = "glVertexAttrib4Nuiv", .linkage = linkage });
    @export(gl.vertexAttrib4Nusv, .{ .name = "glVertexAttrib4Nusv", .linkage = linkage });
    @export(gl.vertexAttrib4bv, .{ .name = "glVertexAttrib4bv", .linkage = linkage });
    @export(gl.vertexAttrib4d, .{ .name = "glVertexAttrib4d", .linkage = linkage });
    @export(gl.vertexAttrib4dv, .{ .name = "glVertexAttrib4dv", .linkage = linkage });
    @export(gl.vertexAttrib4f, .{ .name = "glVertexAttrib4f", .linkage = linkage });
    @export(gl.vertexAttrib4fv, .{ .name = "glVertexAttrib4fv", .linkage = linkage });
    @export(gl.vertexAttrib4iv, .{ .name = "glVertexAttrib4iv", .linkage = linkage });
    @export(gl.vertexAttrib4s, .{ .name = "glVertexAttrib4s", .linkage = linkage });
    @export(gl.vertexAttrib4sv, .{ .name = "glVertexAttrib4sv", .linkage = linkage });
    @export(gl.vertexAttrib4ubv, .{ .name = "glVertexAttrib4ubv", .linkage = linkage });
    @export(gl.vertexAttrib4uiv, .{ .name = "glVertexAttrib4uiv", .linkage = linkage });
    @export(gl.vertexAttrib4usv, .{ .name = "glVertexAttrib4usv", .linkage = linkage });
    @export(gl.vertexAttribPointer, .{ .name = "glVertexAttribPointer", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 2.1 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.uniformMatrix2x3fv, .{ .name = "glUniformMatrix2x3fv", .linkage = linkage });
    @export(gl.uniformMatrix3x2fv, .{ .name = "glUniformMatrix3x2fv", .linkage = linkage });
    @export(gl.uniformMatrix2x4fv, .{ .name = "glUniformMatrix2x4fv", .linkage = linkage });
    @export(gl.uniformMatrix4x2fv, .{ .name = "glUniformMatrix4x2fv", .linkage = linkage });
    @export(gl.uniformMatrix3x4fv, .{ .name = "glUniformMatrix3x4fv", .linkage = linkage });
    @export(gl.uniformMatrix4x3fv, .{ .name = "glUniformMatrix4x3fv", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 3.0 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.colorMaski, .{ .name = "glColorMaski", .linkage = linkage });
    @export(gl.getBooleani_v, .{ .name = "glGetBooleani_v", .linkage = linkage });
    @export(gl.getIntegeri_v, .{ .name = "glGetIntegeri_v", .linkage = linkage });
    @export(gl.enablei, .{ .name = "glEnablei", .linkage = linkage });
    @export(gl.disablei, .{ .name = "glDisablei", .linkage = linkage });
    @export(gl.isEnabledi, .{ .name = "glIsEnabledi", .linkage = linkage });
    @export(gl.beginTransformFeedback, .{ .name = "glBeginTransformFeedback", .linkage = linkage });
    @export(gl.endTransformFeedback, .{ .name = "glEndTransformFeedback", .linkage = linkage });
    @export(gl.bindBufferRange, .{ .name = "glBindBufferRange", .linkage = linkage });
    @export(gl.bindBufferBase, .{ .name = "glBindBufferBase", .linkage = linkage });
    @export(gl.transformFeedbackVaryings, .{ .name = "glTransformFeedbackVaryings", .linkage = linkage });
    @export(gl.getTransformFeedbackVarying, .{ .name = "glGetTransformFeedbackVarying", .linkage = linkage });
    @export(gl.beginConditionalRender, .{ .name = "glBeginConditionalRender", .linkage = linkage });
    @export(gl.endConditionalRender, .{ .name = "glEndConditionalRender", .linkage = linkage });
    @export(gl.vertexAttribIPointer, .{ .name = "glVertexAttribIPointer", .linkage = linkage });
    @export(gl.getVertexAttribIiv, .{ .name = "glGetVertexAttribIiv", .linkage = linkage });
    @export(gl.getVertexAttribIuiv, .{ .name = "glGetVertexAttribIuiv", .linkage = linkage });
    @export(gl.vertexAttribI1i, .{ .name = "glVertexAttribI1i", .linkage = linkage });
    @export(gl.vertexAttribI2i, .{ .name = "glVertexAttribI2i", .linkage = linkage });
    @export(gl.vertexAttribI3i, .{ .name = "glVertexAttribI3i", .linkage = linkage });
    @export(gl.vertexAttribI4i, .{ .name = "glVertexAttribI4i", .linkage = linkage });
    @export(gl.vertexAttribI1ui, .{ .name = "glVertexAttribI1ui", .linkage = linkage });
    @export(gl.vertexAttribI2ui, .{ .name = "glVertexAttribI2ui", .linkage = linkage });
    @export(gl.vertexAttribI3ui, .{ .name = "glVertexAttribI3ui", .linkage = linkage });
    @export(gl.vertexAttribI4ui, .{ .name = "glVertexAttribI4ui", .linkage = linkage });
    @export(gl.vertexAttribI1iv, .{ .name = "glVertexAttribI1iv", .linkage = linkage });
    @export(gl.vertexAttribI2iv, .{ .name = "glVertexAttribI2iv", .linkage = linkage });
    @export(gl.vertexAttribI3iv, .{ .name = "glVertexAttribI3iv", .linkage = linkage });
    @export(gl.vertexAttribI4iv, .{ .name = "glVertexAttribI4iv", .linkage = linkage });
    @export(gl.vertexAttribI1uiv, .{ .name = "glVertexAttribI1uiv", .linkage = linkage });
    @export(gl.vertexAttribI2uiv, .{ .name = "glVertexAttribI2uiv", .linkage = linkage });
    @export(gl.vertexAttribI3uiv, .{ .name = "glVertexAttribI3uiv", .linkage = linkage });
    @export(gl.vertexAttribI4uiv, .{ .name = "glVertexAttribI4uiv", .linkage = linkage });
    @export(gl.vertexAttribI4bv, .{ .name = "glVertexAttribI4bv", .linkage = linkage });
    @export(gl.vertexAttribI4sv, .{ .name = "glVertexAttribI4sv", .linkage = linkage });
    @export(gl.vertexAttribI4ubv, .{ .name = "glVertexAttribI4ubv", .linkage = linkage });
    @export(gl.vertexAttribI4usv, .{ .name = "glVertexAttribI4usv", .linkage = linkage });
    @export(gl.getUniformuiv, .{ .name = "glGetUniformuiv", .linkage = linkage });
    @export(gl.bindFragDataLocation, .{ .name = "glBindFragDataLocation", .linkage = linkage });
    @export(gl.getFragDataLocation, .{ .name = "glGetFragDataLocation", .linkage = linkage });
    @export(gl.uniform1ui, .{ .name = "glUniform1ui", .linkage = linkage });
    @export(gl.uniform2ui, .{ .name = "glUniform2ui", .linkage = linkage });
    @export(gl.uniform3ui, .{ .name = "glUniform3ui", .linkage = linkage });
    @export(gl.uniform4ui, .{ .name = "glUniform4ui", .linkage = linkage });
    @export(gl.uniform1uiv, .{ .name = "glUniform1uiv", .linkage = linkage });
    @export(gl.uniform2uiv, .{ .name = "glUniform2uiv", .linkage = linkage });
    @export(gl.uniform3uiv, .{ .name = "glUniform3uiv", .linkage = linkage });
    @export(gl.uniform4uiv, .{ .name = "glUniform4uiv", .linkage = linkage });
    @export(gl.texParameterIiv, .{ .name = "glTexParameterIiv", .linkage = linkage });
    @export(gl.texParameterIuiv, .{ .name = "glTexParameterIuiv", .linkage = linkage });
    @export(gl.getTexParameterIiv, .{ .name = "glGetTexParameterIiv", .linkage = linkage });
    @export(gl.getTexParameterIuiv, .{ .name = "glGetTexParameterIuiv", .linkage = linkage });
    @export(gl.clearBufferiv, .{ .name = "glClearBufferiv", .linkage = linkage });
    @export(gl.clearBufferuiv, .{ .name = "glClearBufferuiv", .linkage = linkage });
    @export(gl.clearBufferfv, .{ .name = "glClearBufferfv", .linkage = linkage });
    @export(gl.clearBufferfi, .{ .name = "glClearBufferfi", .linkage = linkage });
    @export(gl.getStringi, .{ .name = "glGetStringi", .linkage = linkage });
    @export(gl.isRenderbuffer, .{ .name = "glIsRenderbuffer", .linkage = linkage });
    @export(gl.bindRenderbuffer, .{ .name = "glBindRenderbuffer", .linkage = linkage });
    @export(gl.deleteRenderbuffers, .{ .name = "glDeleteRenderbuffers", .linkage = linkage });
    @export(gl.genRenderbuffers, .{ .name = "glGenRenderbuffers", .linkage = linkage });
    @export(gl.renderbufferStorage, .{ .name = "glRenderbufferStorage", .linkage = linkage });
    @export(gl.getRenderbufferParameteriv, .{ .name = "glGetRenderbufferParameteriv", .linkage = linkage });
    @export(gl.isFramebuffer, .{ .name = "glIsFramebuffer", .linkage = linkage });
    @export(gl.bindFramebuffer, .{ .name = "glBindFramebuffer", .linkage = linkage });
    @export(gl.deleteFramebuffers, .{ .name = "glDeleteFramebuffers", .linkage = linkage });
    @export(gl.genFramebuffers, .{ .name = "glGenFramebuffers", .linkage = linkage });
    @export(gl.checkFramebufferStatus, .{ .name = "glCheckFramebufferStatus", .linkage = linkage });
    @export(gl.framebufferTexture1D, .{ .name = "glFramebufferTexture1D", .linkage = linkage });
    @export(gl.framebufferTexture2D, .{ .name = "glFramebufferTexture2D", .linkage = linkage });
    @export(gl.framebufferTexture3D, .{ .name = "glFramebufferTexture3D", .linkage = linkage });
    @export(gl.framebufferRenderbuffer, .{ .name = "glFramebufferRenderbuffer", .linkage = linkage });
    @export(
        gl.getFramebufferAttachmentParameteriv,
        .{ .name = "glGetFramebufferAttachmentParameteriv", .linkage = linkage },
    );
    @export(gl.generateMipmap, .{ .name = "glGenerateMipmap", .linkage = linkage });
    @export(gl.blitFramebuffer, .{ .name = "glBlitFramebuffer", .linkage = linkage });
    @export(
        gl.renderbufferStorageMultisample,
        .{ .name = "glRenderbufferStorageMultisample", .linkage = linkage },
    );
    @export(gl.framebufferTextureLayer, .{ .name = "glFramebufferTextureLayer", .linkage = linkage });
    @export(gl.mapBufferRange, .{ .name = "glMapBufferRange", .linkage = linkage });
    @export(gl.flushMappedBufferRange, .{ .name = "glFlushMappedBufferRange", .linkage = linkage });
    @export(gl.bindVertexArray, .{ .name = "glBindVertexArray", .linkage = linkage });
    @export(gl.deleteVertexArrays, .{ .name = "glDeleteVertexArrays", .linkage = linkage });
    @export(gl.genVertexArrays, .{ .name = "glGenVertexArrays", .linkage = linkage });
    @export(gl.isVertexArray, .{ .name = "glIsVertexArray", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 3.1 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.drawArraysInstanced, .{ .name = "glDrawArraysInstanced", .linkage = linkage });
    @export(gl.drawElementsInstanced, .{ .name = "glDrawElementsInstanced", .linkage = linkage });
    @export(gl.texBuffer, .{ .name = "glTexBuffer", .linkage = linkage });
    @export(gl.primitiveRestartIndex, .{ .name = "glPrimitiveRestartIndex", .linkage = linkage });
    @export(gl.copyBufferSubData, .{ .name = "glCopyBufferSubData", .linkage = linkage });
    @export(gl.getUniformIndices, .{ .name = "glGetUniformIndices", .linkage = linkage });
    @export(gl.getActiveUniformsiv, .{ .name = "glGetActiveUniformsiv", .linkage = linkage });
    @export(gl.getActiveUniformName, .{ .name = "glGetActiveUniformName", .linkage = linkage });
    @export(gl.getUniformBlockIndex, .{ .name = "glGetUniformBlockIndex", .linkage = linkage });
    @export(gl.getActiveUniformBlockiv, .{ .name = "glGetActiveUniformBlockiv", .linkage = linkage });
    @export(gl.getActiveUniformBlockName, .{ .name = "glGetActiveUniformBlockName", .linkage = linkage });
    @export(gl.uniformBlockBinding, .{ .name = "glUniformBlockBinding", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 3.2 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.drawElementsBaseVertex, .{ .name = "glDrawElementsBaseVertex", .linkage = linkage });
    @export(gl.drawRangeElementsBaseVertex, .{ .name = "glDrawRangeElementsBaseVertex", .linkage = linkage });
    @export(
        gl.drawElementsInstancedBaseVertex,
        .{ .name = "glDrawElementsInstancedBaseVertex", .linkage = linkage },
    );
    @export(gl.multiDrawElementsBaseVertex, .{ .name = "glMultiDrawElementsBaseVertex", .linkage = linkage });
    @export(gl.provokingVertex, .{ .name = "glProvokingVertex", .linkage = linkage });
    @export(gl.fenceSync, .{ .name = "glFenceSync", .linkage = linkage });
    @export(gl.isSync, .{ .name = "glIsSync", .linkage = linkage });
    @export(gl.deleteSync, .{ .name = "glDeleteSync", .linkage = linkage });
    @export(gl.clientWaitSync, .{ .name = "glClientWaitSync", .linkage = linkage });
    @export(gl.waitSync, .{ .name = "glWaitSync", .linkage = linkage });
    @export(gl.getInteger64v, .{ .name = "glGetInteger64v", .linkage = linkage });
    @export(gl.getSynciv, .{ .name = "glGetSynciv", .linkage = linkage });
    @export(gl.getInteger64i_v, .{ .name = "glGetInteger64i_v", .linkage = linkage });
    @export(gl.getBufferParameteri64v, .{ .name = "glGetBufferParameteri64v", .linkage = linkage });
    @export(gl.framebufferTexture, .{ .name = "glFramebufferTexture", .linkage = linkage });
    @export(gl.texImage2DMultisample, .{ .name = "glTexImage2DMultisample", .linkage = linkage });
    @export(gl.texImage3DMultisample, .{ .name = "glTexImage3DMultisample", .linkage = linkage });
    @export(gl.getMultisamplefv, .{ .name = "glGetMultisamplefv", .linkage = linkage });
    @export(gl.sampleMaski, .{ .name = "glSampleMaski", .linkage = linkage });
    //----------------------------------------------------------------------------------------------
    // OpenGL 3.3 (Core Profile)
    //----------------------------------------------------------------------------------------------
    @export(gl.bindFragDataLocationIndexed, .{ .name = "glBindFragDataLocationIndexed", .linkage = linkage });
    @export(gl.getFragDataIndex, .{ .name = "glGetFragDataIndex", .linkage = linkage });
    @export(gl.genSamplers, .{ .name = "glGenSamplers", .linkage = linkage });
    @export(gl.deleteSamplers, .{ .name = "glDeleteSamplers", .linkage = linkage });
    @export(gl.isSampler, .{ .name = "glIsSampler", .linkage = linkage });
    @export(gl.bindSampler, .{ .name = "glBindSampler", .linkage = linkage });
    @export(gl.samplerParameteri, .{ .name = "glSamplerParameteri", .linkage = linkage });
    @export(gl.samplerParameteriv, .{ .name = "glSamplerParameteriv", .linkage = linkage });
    @export(gl.samplerParameterf, .{ .name = "glSamplerParameterf", .linkage = linkage });
    @export(gl.samplerParameterfv, .{ .name = "glSamplerParameterfv", .linkage = linkage });
    @export(gl.samplerParameterIiv, .{ .name = "glSamplerParameterIiv", .linkage = linkage });
    @export(gl.samplerParameterIuiv, .{ .name = "glSamplerParameterIuiv", .linkage = linkage });
    @export(gl.getSamplerParameteriv, .{ .name = "glGetSamplerParameteriv", .linkage = linkage });
    @export(gl.getSamplerParameterIiv, .{ .name = "glGetSamplerParameterIiv", .linkage = linkage });
    @export(gl.getSamplerParameterfv, .{ .name = "glGetSamplerParameterfv", .linkage = linkage });
    @export(gl.getSamplerParameterIuiv, .{ .name = "glGetSamplerParameterIuiv", .linkage = linkage });
    @export(gl.queryCounter, .{ .name = "glQueryCounter", .linkage = linkage });
    @export(gl.getQueryObjecti64v, .{ .name = "glGetQueryObjecti64v", .linkage = linkage });
    @export(gl.getQueryObjectui64v, .{ .name = "glGetQueryObjectui64v", .linkage = linkage });
    @export(gl.vertexAttribDivisor, .{ .name = "glVertexAttribDivisor", .linkage = linkage });
    @export(gl.vertexAttribP1ui, .{ .name = "glVertexAttribP1ui", .linkage = linkage });
    @export(gl.vertexAttribP1uiv, .{ .name = "glVertexAttribP1uiv", .linkage = linkage });
    @export(gl.vertexAttribP2ui, .{ .name = "glVertexAttribP2ui", .linkage = linkage });
    @export(gl.vertexAttribP2uiv, .{ .name = "glVertexAttribP2uiv", .linkage = linkage });
    @export(gl.vertexAttribP3ui, .{ .name = "glVertexAttribP3ui", .linkage = linkage });
    @export(gl.vertexAttribP3uiv, .{ .name = "glVertexAttribP3uiv", .linkage = linkage });
    @export(gl.vertexAttribP4ui, .{ .name = "glVertexAttribP4ui", .linkage = linkage });
    @export(gl.vertexAttribP4uiv, .{ .name = "glVertexAttribP4uiv", .linkage = linkage });
}

const std = @import("std");
pub usingnamespace @import("gl_enums.zig");

pub const GLbyte = i8;
pub const GLclampf = f32;
pub const GLfixed = i32;
pub const GLshort = c_short;
pub const GLushort = c_ushort;
pub const GLvoid = c_void;
pub const GLsync = ?*opaque {};
pub const GLint64 = i64;
pub const GLuint64 = u64;
pub const GLenum = c_uint;
pub const GLchar = u8;
pub const GLfloat = f32;
pub const GLsizeiptr = c_long;
pub const GLintptr = c_long;
pub const GLbitfield = c_uint;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLboolean = u8;
pub const GLsizei = c_int;
pub const GLubyte = u8;
pub const GLint64EXT = i64;
pub const GLuint64EXT = u64;
pub const GLdouble = f64;

const Funcs = struct {
    glEnable: fn (GLenum) void,
    glDisable: fn (GLenum) void,
    glBlendFunc: fn (GLenum, GLenum) void,
    glBlendFuncSeparate: fn (GLenum, GLenum, GLenum, GLenum) void,
    glBlendEquationSeparate: fn (GLenum, GLenum) void,
    glBlendColor: fn (GLfloat, GLfloat, GLfloat, GLfloat) void,
    glPolygonMode: fn (GLenum, GLenum) void,
    glDepthMask: fn (GLboolean) void,
    glDepthFunc: fn (GLenum) void,
    glStencilFunc: fn (GLenum, GLint, GLuint) void,
    glStencilFuncSeparate: fn (GLenum, GLenum, GLint, GLuint) void,
    glStencilMask: fn (GLuint) void,
    glStencilMaskSeparate: fn (GLenum, GLuint) void,
    glStencilOp: fn (GLenum, GLenum, GLenum) void,
    glStencilOpSeparate: fn (GLenum, GLenum, GLenum, GLenum) void,
    glColorMask: fn (GLboolean, GLboolean, GLboolean, GLboolean) void,

    glViewport: fn (GLint, GLint, GLsizei, GLsizei) void,
    glScissor: fn (GLint, GLint, GLsizei, GLsizei) void,
    glGetString: fn (GLenum) [*c]const GLubyte,
    glGetError: fn () GLenum,
    glGetIntegerv: fn (GLenum, [*c]GLint) void,
    glClearColor: fn (GLfloat, GLfloat, GLfloat, GLfloat) void,
    glClearStencil: fn (GLint) void,
    glClearDepth: fn (GLdouble) void,
    glClear: fn (GLbitfield) void,
    glGenBuffers: fn (n: GLsizei, buffers: [*c]GLuint) void,
    glDeleteVertexArrays: fn (n: GLsizei, arrays: [*c]GLuint) void,
    glDeleteBuffers: fn (n: GLsizei, buffers: [*]GLuint) void,
    glGenVertexArrays: fn (n: GLsizei, arrays: [*c]GLuint) void,
    glBindBuffer: fn (target: GLenum, buffer: GLuint) void,
    glBufferData: fn (target: GLenum, size: GLsizeiptr, data: ?*const c_void, usage: GLenum) void,
    glBufferSubData: fn (GLenum, GLintptr, GLsizeiptr, ?*const c_void) void,

    glCreateShader: fn (shader: GLenum) GLuint,
    glShaderSource: fn (shader: GLuint, count: GLsizei, string: *[:0]const GLchar, length: ?*c_int) void,
    glCompileShader: fn (shader: GLuint) void,
    glDeleteShader: fn (GLuint) void,

    glCreateProgram: fn () GLuint,
    glDeleteProgram: fn (GLuint) void,
    glAttachShader: fn (program: GLuint, shader: GLuint) void,
    glLinkProgram: fn (program: GLuint) void,
    glGetProgramiv: fn (GLuint, GLenum, [*c]GLint) void,
    glGetProgramInfoLog: fn (GLuint, GLsizei, [*c]GLsizei, [*c]GLchar) void,
    glUseProgram: fn (program: GLuint) void,
    glGetAttribLocation: fn (program: GLuint, name: [*:0]const GLchar) GLint,
    glBindFragDataLocation: fn (program: GLuint, colorNumber: GLuint, name: [*:0]const GLchar) void,
    glVertexAttribPointer: fn (index: GLuint, size: GLint, type: GLenum, normalized: GLboolean, stride: GLsizei, offset: ?*const c_void) void,
    glBindVertexArray: fn (array: GLuint) void,

    glGetShaderiv: fn (shader: GLuint, pname: GLenum, params: *GLint) void,
    glEnableVertexAttribArray: fn (index: GLuint) void,
    glGetShaderInfoLog: fn (shader: GLuint, maxLength: GLsizei, length: *GLsizei, infoLog: [*]GLchar) void,

    glGetUniformLocation: fn (shader: GLuint, name: [*:0]const GLchar) GLint,
    glUniform1i: fn (location: GLint, v0: GLint) void,
    glUniform1iv: fn (GLint, GLsizei, [*c]const GLint) void,
    glUniform1f: fn (location: GLint, v0: GLfloat) void,
    glUniform1fv: fn (GLint, GLsizei, [*c]const GLfloat) void,
    glUniform2fv: fn (GLint, GLsizei, [*c]const GLfloat) void,
    glUniform3fv: fn (GLint, GLsizei, [*c]const GLfloat) void,
    glUniform4fv: fn (GLint, GLsizei, [*c]const GLfloat) void,
    glUniform3f: fn (location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat) void,
    glUniformMatrix3fv: fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) void,
    glUniformMatrix4fv: fn (location: GLint, count: GLsizei, transpose: GLboolean, value: *const GLfloat) void,
    glUniformMatrix3x2fv: fn (GLint, GLsizei, GLboolean, [*c]const GLfloat) void,

    glDrawElements: fn (GLenum, GLsizei, GLenum, ?*const c_void) void,
    glDrawElementsInstanced: fn (GLenum, GLsizei, GLenum, ?*const c_void, GLsizei) void,
    glDrawArrays: fn (GLenum, GLint, GLsizei) void,

    glGenFramebuffers: fn (GLsizei, [*c]GLuint) void,
    glDeleteFramebuffers: fn (GLsizei, [*c]const GLuint) void,
    glBindFramebuffer: fn (GLenum, GLuint) void,
    glFramebufferTexture: fn (GLenum, GLenum, GLuint, GLint) void,
    glDrawBuffers: fn (GLsizei, [*c]const GLenum) void,
    glCheckFramebufferStatus: fn (GLenum) GLenum,

    glGenRenderbuffers: fn (GLsizei, [*c]GLuint) void,
    glDeleteRenderbuffers: fn (GLsizei, [*c]const GLuint) void,
    glBindRenderbuffer: fn (GLenum, GLuint) void,
    glRenderbufferStorage: fn (GLenum, GLenum, GLsizei, GLsizei) void,
    glFramebufferRenderbuffer: fn (GLenum, GLenum, GLenum, GLuint) void,

    glGenTextures: fn (GLsizei, [*c]GLuint) void,
    glDeleteTextures: fn (GLsizei, [*c]const GLuint) void,
    glBindTexture: fn (GLenum, GLuint) void,
    glTexParameteri: fn (GLenum, GLenum, GLint) void,
    glTexParameteriv: fn (GLenum, GLenum, [*c]const GLint) void,
    glTexImage1D: fn (GLenum, GLint, GLint, GLsizei, GLint, GLenum, GLenum, ?*const c_void) void,
    glTexImage2D: fn (GLenum, GLint, GLint, GLsizei, GLsizei, GLint, GLenum, GLenum, ?*const c_void) void,
    glGenerateMipmap: fn (GLenum) void,
    glActiveTexture: fn (GLenum) void,
};

var gl: Funcs = undefined;

pub fn loadFunctionsZig() void {
    const lib = switch (std.builtin.os.tag) {
        .linux, .freebsd, .openbsd => "libOpenGL.so.0",
        .windows => "OPENGL32",
        .macos, .tvos, .watchos, .ios => "/System/Library/Frameworks/OpenGL.framework/Versions/Current/OpenGL",
        else => unreachable,
    };

    var dynlib = std.DynLib.openZ(lib) catch |err| {
        std.debug.print("could not open gl dylib: {}\n", .{err});
        unreachable;
    };
    defer dynlib.close();

    inline for (@typeInfo(Funcs).Struct.fields) |field, i| {
        @field(gl, field.name) = dynlib.lookup(field.field_type, field.name ++ &[_:0]u8{0}).?;
    }
}

/// loader is a GL function loader, for example SDL_GL_GetProcAddress or glfwGetProcAddress
pub fn loadFunctions(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {
    inline for (@typeInfo(Funcs).Struct.fields) |field, i| {
        @field(gl, field.name) = @ptrCast(field.field_type, loader(field.name ++ &[_]u8{0}));
    }
}

pub fn glEnable(state: GLenum) void {
    gl.glEnable(state);
}

pub fn glDisable(state: GLenum) void {
    gl.glDisable(state);
}

pub fn glBlendFunc(src: GLenum, dst: GLenum) void {
    gl.glBlendFunc(src, dst);
}

pub fn glBlendFuncSeparate(src_rgb: GLenum, dst_rgb: GLenum, src_alpha: GLenum, dst_alpha: GLenum) void {
    gl.glBlendFuncSeparate(src_rgb, dst_rgb, src_alpha, dst_alpha);
}

pub fn glBlendEquationSeparate(mode_rgb: GLenum, mode_alpha: GLenum) void {
    gl.glBlendEquationSeparate(mode_rgb, mode_alpha);
}

pub fn glBlendColor(r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat) void {
    gl.glBlendColor(r, g, b, a);
}

pub fn glPolygonMode(face: GLenum, mode: GLenum) void {
    gl.glPolygonMode(face, mode);
}

pub fn glDepthMask(enable: GLboolean) void {
    gl.glDepthMask(enable);
}

pub fn glDepthFunc(func: GLenum) void {
    gl.glDepthFunc(func);
}

pub fn glStencilFunc(func: GLenum, ref: GLint, mask: GLuint) void {
    gl.glStencilFunc(func, ref, mask);
}

pub fn glStencilFuncSeparate(face: GLenum, func: GLenum, ref: GLint, mask: GLuint) void {
    gl.glStencilFuncSeparate(face, func, ref, mask);
}

pub fn glStencilMask(mask: GLuint) void {
    gl.glStencilMask(mask);
}

pub fn glStencilMaskSeparate(face: GLenum, mask: GLuint) void {
    gl.glStencilMaskSeparate(face, mask);
}

pub fn glStencilOp(sfail: GLenum, dpfail: GLenum, dppass: GLenum) void {
    gl.glStencilOp(sfail, dpfail, dppass);
}

pub fn glStencilOpSeparate(face: GLenum, sfail: GLenum, dpfail: GLenum, dppass: GLenum) void {
    gl.glStencilOpSeparate(face, sfail, dpfail, dppass);
}

pub fn glColorMask(r: GLboolean, g: GLboolean, b: GLboolean, a: GLboolean) void {
    gl.glColorMask(r, g, b, a);
}

pub fn glViewport(x: GLint, y: GLint, w: GLsizei, h: GLsizei) void {
    gl.glViewport(x, y, w, h);
}

pub fn glScissor(x: GLint, y: GLint, w: GLsizei, h: GLsizei) void {
    gl.glScissor(x, y, w, h);
}

pub fn glGetString(which: GLenum) [*c]const GLubyte {
    return gl.glGetString(which);
}

pub fn glGetError() GLenum {
    return gl.glGetError();
}

pub fn glGetIntegerv(name: GLenum, data: [*c]GLint) void {
    gl.glGetIntegerv(name, data);
}

pub fn glClearColor(r: GLfloat, g: GLfloat, b: GLfloat, a: GLfloat) void {
    gl.glClearColor(r, g, b, a);
}

pub fn glClearStencil(stencil: GLint) void {
    gl.glClearStencil(stencil);
}

pub fn glClearDepth(depth: GLdouble) void {
    gl.glClearDepth(depth);
}

pub fn glClear(which: GLbitfield) void {
    gl.glClear(which);
}

pub fn glGenBuffers(n: GLsizei, buffers: [*c]GLuint) void {
    gl.glGenBuffers(n, buffers);
}

pub fn glDeleteVertexArrays(n: GLsizei, arrays: [*c]GLuint) void {
    gl.glDeleteVertexArrays(n, arrays);
}

pub fn glDeleteBuffers(n: GLsizei, buffers: [*c]GLuint) void {
    gl.glDeleteBuffers(n, buffers);
}

pub fn glGenVertexArrays(n: GLsizei, arrays: [*c]GLuint) void {
    gl.glGenVertexArrays(n, arrays);
}

pub fn glBindBuffer(target: GLenum, buffer: GLuint) void {
    gl.glBindBuffer(target, buffer);
}

pub fn glBufferData(target: GLenum, size: GLsizeiptr, data: ?*const c_void, usage: GLenum) void {
    gl.glBufferData(target, size, data, usage);
}

pub fn glBufferSubData(target: GLenum, offset: GLintptr, size: GLsizeiptr, data: ?*const c_void) void {
    gl.glBufferSubData(target, offset, size, data);
}

pub fn glCreateShader(shader: GLenum) GLuint {
    return gl.glCreateShader(shader);
}

pub fn glShaderSource(shader: GLuint, count: GLsizei, string: *[:0]const GLchar, length: ?*c_int) void {
    gl.glShaderSource(shader, count, string, length);
}

pub fn glCompileShader(shader: GLuint) void {
    gl.glCompileShader(shader);
}

pub fn glDeleteShader(shader: GLuint) void {
    gl.glDeleteShader(shader);
}

pub fn glCreateProgram() GLuint {
    return gl.glCreateProgram();
}

pub fn glDeleteProgram(program: GLuint) void {
    gl.glDeleteProgram(program);
}

pub fn glAttachShader(program: GLuint, shader: GLuint) void {
    gl.glAttachShader(program, shader);
}

pub fn glLinkProgram(program: GLuint) void {
    gl.glLinkProgram(program);
}

pub fn glGetProgramiv(program: GLuint, pname: GLenum, params: [*c]GLint) void {
    gl.glGetProgramiv(program, pname, params);
}

pub fn glGetProgramInfoLog(program: GLuint, max_length: GLsizei, length: [*c]GLsizei, info_log: [*c]GLchar) void {
    gl.glGetProgramInfoLog(program, max_length, length, info_log);
}

pub fn glUseProgram(program: GLuint) void {
    gl.glUseProgram(program);
}

pub fn glGetAttribLocation(program: GLuint, name: [*:0]const GLchar) GLint {
    return gl.glGetAttribLocation(program, name);
}

pub fn glBindFragDataLocation(program: GLuint, colorNumber: GLuint, name: [*:0]const GLchar) void {
    gl.glBindFragDataLocation(program, colorNumber, name);
}

pub fn glVertexAttribPointer(index: GLuint, size: GLint, kind: GLenum, normalized: GLboolean, stride: GLsizei, offset: ?usize) void {
    const off = if (offset) |o| @intToPtr(*c_void, o) else null;
    gl.glVertexAttribPointer(index, size, kind, normalized, stride, off);
}

pub fn glBindVertexArray(array: GLuint) void {
    gl.glBindVertexArray(array);
}

pub fn glGetShaderiv(shader: GLuint, pname: GLenum, params: *GLint) void {
    gl.glGetShaderiv(shader, pname, params);
}

pub fn glEnableVertexAttribArray(index: GLuint) void {
    gl.glEnableVertexAttribArray(index);
}

pub fn glGetShaderInfoLog(shader: GLuint, maxLength: GLsizei, length: *GLsizei, infoLog: [*]GLchar) void {
    gl.glGetShaderInfoLog(shader, maxLength, length, infoLog);
}

pub fn glGetUniformLocation(shader: GLuint, name: [*:0]const GLchar) GLint {
    return gl.glGetUniformLocation(shader, name);
}

pub fn glUniform1i(location: GLint, value: GLint) void {
    gl.glUniform1i(location, value);
}

pub fn glUniform1iv(location: GLint, count: GLsizei, value: [*c]const GLint) void {
    gl.glUniform1iv(location, count, value);
}

pub fn glUniform1f(location: GLint, v0: GLfloat) void {
    gl.glUniform1f(location, v0);
}

pub fn glUniform1fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    gl.glUniform1fv(location, count, value);
}

pub fn glUniform2fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    gl.glUniform2fv(location, count, value);
}

pub fn glUniform3fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    gl.glUniform3fv(location, count, value);
}

pub fn glUniform4fv(location: GLint, count: GLsizei, value: [*c]const GLfloat) void {
    gl.glUniform4fv(location, count, value);
}

pub fn glUniform3f(location: GLint, v0: GLfloat, v1: GLfloat, v2: GLfloat) void {
    gl.glUniform3f(location, v0, v1, v2);
}

pub fn glUniformMatrix3fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    gl.glUniformMatrix3fv(location, count, transpose, value);
}

pub fn glUniformMatrix4fv(location: GLint, count: GLsizei, transpose: GLboolean, value: *const GLfloat) void {
    gl.glUniformMatrix4fv(location, count, transpose, value);
}

pub fn glUniformMatrix3x2fv(location: GLint, count: GLsizei, transpose: GLboolean, value: [*c]const GLfloat) void {
    gl.glUniformMatrix3x2fv(location, count, transpose, value);
}

pub fn glDrawElements(mode: GLenum, count: GLsizei, kind: GLenum, indices: ?*const c_void) void {
    gl.glDrawElements(mode, count, kind, indices);
}

pub fn glDrawElementsInstanced(mode: GLenum, count: GLsizei, kind: GLenum, indices: ?*const c_void, instance_count: GLsizei) void {
    gl.glDrawElementsInstanced(mode, count, kind, indices, instance_count);
}

pub fn glDrawArrays(mode: GLenum, first: GLint, count: GLsizei) void {
    gl.glDrawArrays(mode, first, count);
}

pub fn glGenFramebuffers(n: GLsizei, framebuffers: [*c]GLuint) void {
    gl.glGenFramebuffers(n, framebuffers);
}

pub fn glDeleteFramebuffers(n: GLsizei, framebuffers: [*c]GLuint) void {
    gl.glDeleteFramebuffers(n, framebuffers);
}

pub fn glBindFramebuffer(target: GLenum, framebuffer: GLuint) void {
    gl.glBindFramebuffer(target, framebuffer);
}

pub fn glCheckFramebufferStatus(target: GLenum) GLenum {
    return gl.glCheckFramebufferStatus(target);
}

pub fn glGenRenderbuffers(n: GLsizei, buffers: [*c]GLuint) void {
    gl.glGenRenderbuffers(n, buffers);
}

pub fn glDeleteRenderbuffers(n: GLsizei, buffers: [*c]const GLuint) void {
    gl.glDeleteRenderbuffers(n, buffers);
}

pub fn glBindRenderbuffer(target: GLenum, buffer: GLuint) void {
    gl.glBindRenderbuffer(target, buffer);
}

pub fn glRenderbufferStorage(target: GLenum, format: GLenum, width: GLsizei, height: GLsizei) void {
    gl.glRenderbufferStorage(target, format, width, height);
}

pub fn glFramebufferRenderbuffer(target: GLenum, attachment: GLenum, render_buffer_target: GLenum, buffer: GLuint) void {
    gl.glFramebufferRenderbuffer(target, attachment, render_buffer_target, buffer);
}

pub fn glFramebufferTexture(target: GLenum, attachment: GLenum, texture: GLuint, level: GLint) void {
    gl.glFramebufferTexture(target, attachment, texture, level);
}

pub fn glDrawBuffers(n: GLsizei, bufs: [*c]const GLenum) void {
    gl.glDrawBuffers(n, bufs);
}

pub fn glGenTextures(n: GLsizei, textures: [*c]GLuint) void {
    gl.glGenTextures(n, textures);
}

pub fn glDeleteTextures(n: GLsizei, textures: [*c]const GLuint) void {
    gl.glDeleteTextures(n, textures);
}

pub fn glBindTexture(target: GLenum, texture: GLuint) void {
    gl.glBindTexture(target, texture);
}

pub fn glTexParameteri(target: GLenum, pname: GLenum, param: GLint) void {
    gl.glTexParameteri(target, pname, param);
}

pub fn glTexParameteriv(target: GLenum, pname: GLenum, param: [*c]const GLint) void {
    gl.glTexParameteriv(target, pname, param);
}

pub fn glTexImage1D(target: GLenum, level: GLint, internal_format: GLint, width: GLsizei, border: GLint, format: GLenum, kind: GLenum, data: ?*const c_void) void {
    gl.glTexImage1D(target, level, internal_format, width, border, format, kind, data);
}

pub fn glTexImage2D(target: GLenum, level: GLint, internal_format: GLint, width: GLsizei, height: GLsizei, border: GLint, format: GLenum, kind: GLenum, data: ?*const c_void) void {
    gl.glTexImage2D(target, level, internal_format, width, height, border, format, kind, data);
}

pub fn glGenerateMipmap(target: GLenum) void {
    gl.glGenerateMipmap(target);
}

pub fn glActiveTexture(target: GLenum) void {
    gl.glActiveTexture(target);
}

comptime {
    @import("std").testing.refAllDecls(@This());
}

const std = @import("std");
const decls = @import("gl_decls.zig");
// usingnamespace decls;
const GLuint = decls.GLuint;
const GLenum = decls.GLenum;

pub const RenderCache = struct {
    vao: GLuint = 0,
    vbo: GLuint = 0,
    ebo: GLuint = 0,
    shader: GLuint = 0,
    textures: [8]c_uint = [_]c_uint{0} ** 8,

    pub fn init() RenderCache {
        return .{};
    }

    pub fn bindVertexArray(self: *@This(), vao: GLuint) void {
        if (self.vao != vao) {
            self.vao = vao;
            decls.glBindVertexArray(vao);
        }
    }

    pub fn invalidateVertexArray(self: *@This(), vao: GLuint) void {
        if (self.vao == vao) {
            self.vao = 0;
            decls.glBindVertexArray(0);
        }
    }

    pub fn bindBuffer(self: *@This(), target: GLenum, buffer: GLuint) void {
        std.debug.assert(target == decls.GL_ELEMENT_ARRAY_BUFFER or target == decls.GL_ARRAY_BUFFER);

        if (target == decls.GL_ELEMENT_ARRAY_BUFFER) {
            if (self.ebo != buffer) {
                self.ebo = buffer;
                decls.glBindBuffer(target, buffer);
            }
        } else {
            if (self.vbo != buffer) {
                self.vbo = buffer;
                decls.glBindBuffer(target, buffer);
            }
        }
    }

    /// forces a bind whether bound or not. Needed for creating Vertex Array Objects
    pub fn forceBindBuffer(self: *@This(), target: GLenum, buffer: GLuint) void {
        std.debug.assert(target == decls.GL_ELEMENT_ARRAY_BUFFER or target == decls.GL_ARRAY_BUFFER);

        if (target == decls.GL_ELEMENT_ARRAY_BUFFER) {
            self.ebo = buffer;
            decls.glBindBuffer(target, buffer);
        } else {
            self.vbo = buffer;
            decls.glBindBuffer(target, buffer);
        }
    }

    pub fn invalidateBuffer(self: *@This(), buffer: GLuint) void {
        if (self.ebo == buffer) {
            self.ebo = 0;
            decls.glBindBuffer(decls.GL_ELEMENT_ARRAY_BUFFER, 0);
        }
        if (self.vbo == buffer) {
            self.vbo = 0;
            decls.glBindBuffer(decls.GL_ARRAY_BUFFER, 0);
        }
    }

    pub fn bindImage(self: *@This(), tid: c_uint, slot: c_uint) void {
        if (self.textures[slot] != tid) {
            self.textures[slot] = tid;
            decls.glActiveTexture(decls.GL_TEXTURE0 + slot);
            decls.glBindTexture(decls.GL_TEXTURE_2D, tid);
        }
    }

    pub fn invalidateTexture(self: *@This(), tid: c_uint) void {
        for (self.textures) |*tex, i| {
            if (tex.* == tid) {
                tex.* = 0;
                decls.glActiveTexture(decls.GL_TEXTURE0 + @intCast(c_uint, i));
                decls.glBindTexture(decls.GL_TEXTURE_2D, tid);
            }
        }
    }

    pub fn useShaderProgram(self: *@This(), program: GLuint) void {
        if (self.shader != program) {
            self.shader = program;
            decls.glUseProgram(program);
        }
    }

    pub fn invalidateProgram(self: *@This(), program: GLuint) void {
        if (self.shader == program) {
            self.shader = 0;
            decls.glUseProgram(0);
        }
    }
};

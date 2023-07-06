const std = @import("std");
const gl = @import("zopengl.zig").gl; //@import("gl_4v1.zig");

const GLuint = gl.Uint;
const GLenum = gl.Enum;

const Rect = struct {
    x: c_int = 0,
    y: c_int = 0,
    w: c_int = 0,
    h: c_int = 0,

    pub fn changed(self: *@This(), x: c_int, y: c_int, w: c_int, h: c_int) bool {
        if (self.w != w or self.h != h or self.x != x or self.y != y) {
            self.x = x;
            self.y = y;
            self.w = w;
            self.h = h;
            return true;
        }
        return false;
    }
};

pub const RenderCache = struct {
    vao: GLuint = 0,
    vbo: GLuint = 0,
    ebo: GLuint = 0,
    shader: GLuint = 0,
    viewport_rect: Rect = .{},
    scissor_rect: Rect = .{},
    textures: [8]c_uint = [_]c_uint{0} ** 8,

    pub fn init() RenderCache {
        return .{};
    }

    pub fn bindVertexArray(self: *@This(), vao: GLuint) void {
        if (self.vao != vao) {
            self.vao = vao;
            gl.bindVertexArray(vao);
        }
    }

    pub fn invalidateVertexArray(self: *@This(), vao: GLuint) void {
        if (self.vao == vao) {
            self.vao = 0;
            gl.bindVertexArray(0);
        }
    }

    pub fn bindBuffer(self: *@This(), target: GLenum, buffer: GLuint) void {
        std.debug.assert(target == gl.ELEMENT_ARRAY_BUFFER or target == gl.ARRAY_BUFFER);

        if (target == gl.ELEMENT_ARRAY_BUFFER) {
            if (self.ebo != buffer) {
                self.ebo = buffer;
                gl.bindBuffer(target, buffer);
            }
        } else {
            if (self.vbo != buffer) {
                self.vbo = buffer;
                gl.bindBuffer(target, buffer);
            }
        }
    }

    /// forces a bind whether bound or not. Needed for creating Vertex Array Objects
    pub fn forceBindBuffer(self: *@This(), target: GLenum, buffer: GLuint) void {
        std.debug.assert(target == gl.ELEMENT_ARRAY_BUFFER or target == gl.ARRAY_BUFFER);

        if (target == gl.ELEMENT_ARRAY_BUFFER) {
            self.ebo = buffer;
            gl.bindBuffer(target, buffer);
        } else {
            self.vbo = buffer;
            gl.bindBuffer(target, buffer);
        }
    }

    pub fn invalidateBuffer(self: *@This(), buffer: GLuint) void {
        if (self.ebo == buffer) {
            self.ebo = 0;
            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0);
        }
        if (self.vbo == buffer) {
            self.vbo = 0;
            gl.bindBuffer(gl.ARRAY_BUFFER, 0);
        }
    }

    pub fn bindImage(self: *@This(), tid: c_uint, slot: c_uint) void {
        if (self.textures[slot] != tid) {
            self.textures[slot] = tid;
            gl.activeTexture(gl.TEXTURE0 + slot);
            gl.bindTexture(gl.TEXTURE_2D, tid);
        }
    }

    pub fn invalidateTexture(self: *@This(), tid: c_uint) void {
        for (self.textures, 0..) |_, i| {
            if (self.textures[i] == tid) {
                self.textures[i] = 0;
                gl.activeTexture(gl.TEXTURE0 + @as(c_uint, @intCast(i)));
                gl.bindTexture(gl.TEXTURE_2D, tid);
            }
        }
    }

    pub fn useShaderProgram(self: *@This(), program: GLuint) void {
        if (self.shader != program) {
            self.shader = program;
            gl.useProgram(program);
        }
    }

    pub fn invalidateProgram(self: *@This(), program: GLuint) void {
        if (self.shader == program) {
            self.shader = 0;
            gl.useProgram(0);
        }
    }

    pub fn viewport(self: *@This(), x: c_int, y: c_int, width: c_int, height: c_int) void {
        if (self.viewport_rect.changed(x, y, width, height))
            gl.viewport(x, y, width, height);
    }

    pub fn scissor(self: *@This(), x: c_int, y: c_int, width: c_int, height: c_int, cur_pass_h: c_int) void {
        if (self.scissor_rect.changed(x, y, width, height)) {
            var y_tl = cur_pass_h - (y + height);
            gl.scissor(x, y_tl, width, height);
        }
    }
};

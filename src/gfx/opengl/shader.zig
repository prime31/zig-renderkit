const std = @import("std");
const aya = @import("../../aya.zig");
const math = aya.math;
usingnamespace @import("gl_decls.zig");

pub const Shader = struct {
    id: GLuint,
    vertex: GLuint,
    fragment: GLuint,

    pub fn initFromFile(vert_path: []const u8, frag_path: []const u8) !Shader {
        var vert = try aya.fs.readZ(aya.mem.tmp_allocator, vert_path);
        var frag = try aya.fs.readZ(aya.mem.tmp_allocator, frag_path);

        return try Shader.init(vert, frag);
    }

    pub fn init(vert: [:0]const u8, frag: [:0]const u8) !Shader {
        const vertex_shader = glCreateShader(GL_VERTEX_SHADER);
        var v = vert;
        glShaderSource(vertex_shader, 1, &v, null);
        glCompileShader(vertex_shader);
        errdefer glDeleteShader(vertex_shader);
        try checkError(vertex_shader);

        const frag_shader = glCreateShader(GL_FRAGMENT_SHADER);
        var f = frag;
        glShaderSource(frag_shader, 1, &f, null);
        glCompileShader(frag_shader);
        errdefer glDeleteShader(frag_shader);
        try checkError(frag_shader);

        const id = glCreateProgram();
        glAttachShader(id, vertex_shader);
        glAttachShader(id, frag_shader);

        glLinkProgram(id);
        errdefer glDeleteProgram(id);
        try checkProgramError(id);

        return Shader{
            .id = id,
            .vertex = vertex_shader,
            .fragment = frag_shader,
        };
    }

    pub fn deinit(self: Shader) void {
        glDeleteProgram(self.id);
        glDeleteShader(self.vertex);
        glDeleteShader(self.fragment);
    }

    pub fn bind(self: *const Shader) void {
        glUseProgram(self.id);
    }

    pub fn setIntArray(self: *Shader, name: [:0]const u8, value: []const c_int) void {
        glUniform1iv(glGetUniformLocation(self.id, name), @intCast(c_int, value.len), value.ptr);
    }

    pub fn setInt(self: *Shader, name: [:0]const u8, val: c_int) void {
        glUniform1i(glGetUniformLocation(self.id, name), val);
    }

    pub fn setVec2(self: *Shader, name: [:0]const u8, val: Vec2) void {
        glUniform2f(glGetUniformLocation(self.id, name), val.vals[0], val.vals[1]);
    }

    pub fn setMat3x2(self: *Shader, name: [:0]const u8, val: math.Mat32) void {
        glUniformMatrix3x2fv(glGetUniformLocation(self.id, name), 1, GL_FALSE, &val.data[0]);
    }

    pub fn checkError(shader: GLuint) !void {
        var status: GLint = undefined;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
        if (status != GL_TRUE) {
            var buf: [2048]u8 = undefined;
            var total_len: GLsizei = -1;
            glGetShaderInfoLog(shader, 2048, &total_len, buf[0..]);
            if (total_len == -1) {
                // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
                return error.InvalidGLContextError;
            }

            std.debug.print("shader compilation errror:\n{}", .{buf[0..@intCast(usize, total_len)]});
            return error.ShaderCompileError;
        }
    }

    pub fn checkProgramError(shader: GLuint) !void {
        var status: GLint = undefined;
        glGetProgramiv(shader, GL_LINK_STATUS, &status);
        if (status != GL_TRUE) {
            var buf: [2048]u8 = undefined;
            var total_len: GLsizei = -1;
            glGetProgramInfoLog(shader, 2048, &total_len, buf[0..]);
            if (total_len == -1) {
                // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
                return error.ProgramInfoLogLengthNegative;
            }

            std.debug.print("program link errror:\n{}", .{buf[0..@intCast(usize, total_len)]});
            return error.ProgramLinkError;
        }
    }
};
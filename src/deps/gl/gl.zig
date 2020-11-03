pub usingnamespace @import("decls.zig");
const std = @import("std");

const Allocator = std.mem.Allocator;
const FixedList = @import("fixed_list.zig").FixedList;

pub usingnamespace @import("textures.zig");


pub const Vertex = extern struct {
    pos: Vec2,
    uv: Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
};

pub const MultiVertex = extern struct {
    pos: Vec2,
    uv: Vec2 = .{ .x = 0, .y = 0 },
    col: u32 = 0xFFFFFFFF,
    tid: f32 = 1,
};

pub const Shader = struct {
    id: GLuint,
    vertex: GLuint,
    fragment: GLuint,

    pub fn initFromFile(allocator: *Allocator, vert_path: []const u8, frag_path: []const u8) !Shader {
        const vert_file = try std.fs.cwd().openFile(vert_path, .{ .read = true });
        defer vert_file.close();

        var vert_array_list = std.ArrayList(u8).init(allocator);
        defer vert_array_list.deinit();
        try vert_file.reader().readAllArrayList(&vert_array_list, std.math.maxInt(u64));
        try vert_array_list.append(0);

        const frag_file = try std.fs.cwd().openFile(frag_path, .{ .read = true });
        defer frag_file.close();

        var frag_array_list = std.ArrayList(u8).init(allocator);
        defer frag_array_list.deinit();
        try frag_file.reader().readAllArrayList(&frag_array_list, std.math.maxInt(u64));
        try frag_array_list.append(0);

        return try Shader.init(vert_array_list.items[0 .. vert_array_list.items.len - 1 :0], frag_array_list.items[0 .. frag_array_list.items.len - 1 :0]);
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

    pub fn setBool(self: *Shader, name: [:0]const u8, val: bool) void {
        var uniform = glGetUniformLocation(self.id, name);
        var v: GLint = if (val) 1 else 0;
        glUniform1i(uniform, v);
    }

    pub fn setInt(self: *Shader, name: [:0]const u8, val: c_int) void {
        glUniform1i(glGetUniformLocation(self.id, name), val);
    }

    pub fn setFloat(self: *Shader, name: [:0]const u8, val: f32) void {
        glUniform1f(glGetUniformLocation(self.id, name), val);
    }

    pub fn setMat4(self: *Shader, name: [:0]const u8, val: Mat4) void {
        glUniformMatrix4fv(glGetUniformLocation(self.id, name), 1, GL_FALSE, &val.vals[0][0]);
    }

    pub fn setMat3x2(self: *Shader, name: [:0]const u8, val: Mat32) void {
        glUniformMatrix3x2fv(glGetUniformLocation(self.id, name), 1, GL_FALSE, &val.data[0]);
    }

    pub fn setVec2(self: *Shader, name: [:0]const u8, val: Vec2) void {
        glUniform2f(glGetUniformLocation(self.id, name), val.vals[0], val.vals[1]);
    }

    pub fn setIntArray(self: *Shader, name: [:0]const u8, value: []const c_int) void {
        glUniform1iv(glGetUniformLocation(self.id, name), @intCast(c_int, value.len), value.ptr);
    }

    pub fn checkError(shader: GLuint) !void {
        var status: GLint = undefined;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
        if (status != GL_TRUE) {
            var buf: [2048]u8 = undefined;
            var totalLen: GLsizei = -1;
            glGetShaderInfoLog(shader, 2048, &totalLen, buf[0..]);
            if (totalLen == -1) {
                // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
                return error.InvalidGLContextError;
            }

            var totalSize: usize = @intCast(usize, totalLen);
            std.debug.print("shader compilation errror:\n{}", .{buf[0..totalSize]});
            return error.ShaderCompileError;
        }
    }

    pub fn checkProgramError(shader: GLuint) !void {
        var status: GLint = undefined;
        glGetProgramiv(shader, GL_LINK_STATUS, &status);
        if (status != GL_TRUE) {
            var buf: [2048]u8 = undefined;
            var totalLen: GLsizei = -1;
            glGetProgramInfoLog(shader, 2048, &totalLen, buf[0..]);
            if (totalLen == -1) {
                // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
                return error.ProgramInfoLogLengthNegative;
            }

            var totalSize: usize = @intCast(usize, totalLen);
            std.debug.print("program link errror:\n{}", .{buf[0..totalSize]});
            return error.ProgramLinkError;
        }
    }
};

pub const IndexBuffer = struct {
    id: GLuint,

    pub fn init(indices: []const u32) IndexBuffer {
        var ebo: GLuint = undefined;
        glGenBuffers(1, &ebo);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, @intCast(c_long, indices.len * @sizeOf(u32)), indices.ptr, GL_STATIC_DRAW);

        return .{ .id = ebo };
    }

    pub fn deinit(self: *IndexBuffer) void {
        glDeleteBuffers(1, &self.id);
    }

    pub fn bind(self: IndexBuffer) void {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.id);
    }

    pub fn unbind(self: IndexBuffer) void {
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }
};

pub const VertexBufferUsage = enum(GLenum) {
    stream_draw = GL_STREAM_DRAW,
    static_draw = GL_STATIC_DRAW,
    dynamic_draw = GL_DYNAMIC_DRAW,
};

pub const VertexBuffer = struct {
    vbo: GLuint,
    stream: bool,

    pub fn init(comptime T: type, verts: []const T, usage: VertexBufferUsage) VertexBuffer {
        var vbo: GLuint = undefined;
        glGenBuffers(1, &vbo);

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, @intCast(c_long, verts.len * @sizeOf(T)), if (usage == .static_draw) verts.ptr else null, @enumToInt(usage));

        inline for (@typeInfo(T).Struct.fields) |field, i| {
            const offset: ?usize = if (i == 0) null else @byteOffsetOf(T, field.name);

            switch (@typeInfo(field.field_type)) {
                .Int => |type_info| {
                    if (type_info.is_signed) {
                        unreachable;
                    } else {
                        switch (type_info.bits) {
                            32 => {
                                glVertexAttribPointer(i, 4, GL_UNSIGNED_BYTE, GL_TRUE, @sizeOf(T), offset);
                                glEnableVertexAttribArray(i);
                            },
                            else => unreachable,
                        }
                    }
                },
                .Float => {
                    glVertexAttribPointer(i, 1, GL_FLOAT, GL_FALSE, @sizeOf(T), offset);
                    glEnableVertexAttribArray(i);
                },
                .Struct => |StructT| {
                    const field_type = StructT.fields[0].field_type;
                    std.debug.assert(@sizeOf(field_type) == 4);

                    switch (@typeInfo(field_type)) {
                        .Float => {
                            switch (StructT.fields.len) {
                                2 => {
                                    glVertexAttribPointer(i, 2, GL_FLOAT, GL_FALSE, @sizeOf(T), offset);
                                    glEnableVertexAttribArray(i);
                                },
                                else => unreachable,
                            }
                        },
                        else => unreachable,
                    }
                },
                else => unreachable,
            }
        }

        return .{ .vbo = vbo, .stream = usage == .stream_draw };
    }

    pub fn deinit(self: *VertexBuffer) void {
        glDeleteBuffers(1, &self.vbo);
    }

    pub fn bind(self: VertexBuffer) void {
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo);
    }

    pub fn unbind(self: VertexBuffer) void {
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }

    pub fn setData(self: VertexBuffer, comptime T: type, verts: []const T) void {
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo);

        // orphan the buffer for streamed
        if (self.stream) glBufferData(GL_ARRAY_BUFFER, @intCast(c_long, verts.len * @sizeOf(T)), null, GL_STREAM_DRAW);
        glBufferSubData(GL_ARRAY_BUFFER, 0, @intCast(c_long, verts.len * @sizeOf(T)), verts.ptr);
    }
};

pub const PrimitiveType = enum(GLenum) {
    points = GL_POINTS,
    line_strip = GL_LINE_STRIP,
    line_loop = GL_LINE_LOOP,
    lines = GL_LINES,
    triangle_strip = GL_TRIANGLE_STRIP,
    triangle_fan = GL_TRIANGLE_FAN,
    triangles = GL_TRIANGLES,
    patches = GL_PATCHES,
};

pub const ElementType = enum(GLenum) {
    u8 = GL_UNSIGNED_BYTE,
    u16 = GL_UNSIGNED_SHORT,
    u32 = GL_UNSIGNED_INT,
};

pub const Capabilities = enum(GLenum) {
    blend = GL_BLEND,
    cull_face = GL_CULL_FACE,
    depth_test = GL_DEPTH_TEST,
    dither = GL_DITHER,
    polygon_offset_fill = GL_POLYGON_OFFSET_FILL,
    sample_alpha_to_coverage = GL_SAMPLE_ALPHA_TO_COVERAGE,
    sample_coverage = GL_SAMPLE_COVERAGE,
    scissor_test = GL_SCISSOR_TEST,
    stencil_test = GL_STENCIL_TEST,
};

pub fn enable(cap: Capabilities) void {
    glEnable(@enumToInt(cap));
}

pub fn disable(cap: Capabilities) void {
    glDisable(@enumToInt(cap));
}

pub const DepthFunc = enum(GLenum) {
    never = GL_NEVER,
    less = GL_LESS,
    equal = GL_EQUAL,
    less_or_equal = GL_LEQUAL,
    greater = GL_GREATER,
    not_equal = GL_NOTEQUAL,
    greator_or_equal = GL_GEQUAL,
    always = GL_ALWAYS,
};

pub fn depthFunc(func: DepthFunc) void {
    glDepthFunc(@enumToInt(func));
}
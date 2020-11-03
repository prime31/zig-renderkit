pub usingnamespace @import("c.zig");
const std = @import("std");

const Allocator = std.mem.Allocator;
const FixedList = @import("fixed_list.zig").FixedList;

pub usingnamespace @import("textures.zig");

// 3 row, 2 col 2D matrix
//  m[0] m[2] m[4]
//  m[1] m[3] m[5]
//
//  0: scaleX    2: sin       4: transX
//  1: cos       3: scaleY    5: transY
//
pub const Mat32 = struct {
    data: [6]f32 = undefined,

    pub fn initOrthoInverted(width: f32, height: f32) Mat32 {
        var result = Mat32{};
        result.data[0] = 2 / width;
        result.data[3] = -2 / height;
        result.data[4] = -1;
        result.data[5] = 1;
        return result;
    }

    pub fn initOrtho(width: f32, height: f32) Mat32 {
        var result = Mat32{};
        result.data[0] = 2 / width;
        result.data[3] = 2 / height;
        result.data[4] = -1;
        result.data[5] = -1;
        return result;
    }
};

pub const Vec2 = extern struct {
    x: f32 = 0,
    y: f32 = 0,
};

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

pub const ShaderProgram = struct {
    id: GLuint,
    vertex: GLuint,
    fragment: GLuint,

    pub fn createFromFile(allocator: *Allocator, vert_path: []const u8, frag_path: []const u8) !ShaderProgram {
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

        return try ShaderProgram.create(vert_array_list.items[0 .. vert_array_list.items.len - 1 :0], frag_array_list.items[0 .. frag_array_list.items.len - 1 :0]);
    }

    pub fn create(vert: [:0]const u8, frag: [:0]const u8) !ShaderProgram {
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

        const shaderProgramId = glCreateProgram();
        glAttachShader(shaderProgramId, vertex_shader);
        glAttachShader(shaderProgramId, frag_shader);

        glLinkProgram(shaderProgramId);
        errdefer glDeleteProgram(shaderProgramId);
        try checkProgramError(shaderProgramId);

        return ShaderProgram{
            .id = shaderProgramId,
            .vertex = vertex_shader,
            .fragment = frag_shader,
        };
    }

    pub fn deinit(self: ShaderProgram) void {
        glDeleteProgram(self.id);
        glDeleteShader(self.vertex);
        glDeleteShader(self.fragment);
    }

    pub fn bind(self: *const ShaderProgram) void {
        glUseProgram(self.id);
    }

    pub fn setBool(self: *ShaderProgram, name: [:0]const u8, val: bool) void {
        var uniform = glGetUniformLocation(self.id, name);
        var v: GLint = if (val) 1 else 0;
        glUniform1i(uniform, v);
    }

    pub fn setInt(self: *ShaderProgram, name: [:0]const u8, val: c_int) void {
        glUniform1i(glGetUniformLocation(self.id, name), val);
    }

    pub fn setFloat(self: *ShaderProgram, name: [:0]const u8, val: f32) void {
        glUniform1f(glGetUniformLocation(self.id, name), val);
    }

    pub fn setMat4(self: *ShaderProgram, name: [:0]const u8, val: Mat4) void {
        glUniformMatrix4fv(glGetUniformLocation(self.id, name), 1, GL_FALSE, &val.vals[0][0]);
    }

    pub fn setMat3x2(self: *ShaderProgram, name: [:0]const u8, val: Mat32) void {
        glUniformMatrix3x2fv(glGetUniformLocation(self.id, name), 1, GL_FALSE, &val.data[0]);
    }

    pub fn setVec2(self: *ShaderProgram, name: [:0]const u8, val: Vec2) void {
        glUniform2f(glGetUniformLocation(self.id, name), val.vals[0], val.vals[1]);
    }

    pub fn setIntArray(self: *ShaderProgram, name: [:0]const u8, value: []const c_int) void {
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

pub const Batcher = struct {
    vao: GLuint,
    index_buffer: IndexBuffer,
    vertex_buffer: VertexBuffer,
    verts: []Vertex,
    vert_index: usize = 0, // current index into the vertex array
    texture: GLuint = std.math.maxInt(GLuint),

    pub fn init(max_sprites: usize) Batcher {
        var vao: GLuint = undefined;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        var verts = std.testing.allocator.alloc(Vertex, max_sprites) catch unreachable;
        std.mem.set(Vertex, verts, Vertex{ .pos = .{} });

        var indices = std.testing.allocator.alloc(u32, max_sprites * 6) catch unreachable;
        defer std.testing.allocator.free(indices);
        var i: usize = 0;
        while (i < max_sprites) : (i += 1) {
            indices[i * 3 * 2 + 0] = @intCast(u32, i) * 4 + 0;
            indices[i * 3 * 2 + 1] = @intCast(u32, i) * 4 + 1;
            indices[i * 3 * 2 + 2] = @intCast(u32, i) * 4 + 2;
            indices[i * 3 * 2 + 3] = @intCast(u32, i) * 4 + 2;
            indices[i * 3 * 2 + 4] = @intCast(u32, i) * 4 + 3;
            indices[i * 3 * 2 + 5] = @intCast(u32, i) * 4 + 0;
        }

        return .{
            .vao = vao,
            .index_buffer = IndexBuffer.init(indices),
            .vertex_buffer = VertexBuffer.init(Vertex, verts, .stream_draw),
            .verts = verts,
        };
    }

    pub fn deinit(self: *Batcher) void {
        glDeleteVertexArrays(1, &self.vao);
        self.index_buffer.deinit();
        self.vertex_buffer.deinit();
    }

    pub fn begin(self: *Batcher) void {
        self.vert_index = 0;
    }

    pub fn end(self: *Batcher) void {
        self.flush();
    }

    pub fn flush(self: *Batcher) void {
        if (self.vert_index == 0) return;

        // send data
        self.vertex_buffer.setData(Vertex, self.verts[0..self.vert_index]);

        // bind textures
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, self.texture);

        // draw
        const quads = self.vert_index / 4;
        glBindVertexArray(self.vao);
        glDrawElements(@enumToInt(PrimitiveType.triangles), @intCast(c_int, quads * 6), @enumToInt(ElementType.u32), null);

        // reset
        self.vert_index = 0;
    }

    pub fn drawPoint(self: *Batcher, texture: Texture, pos: Vec2, size: f32, col: u32) void {
        if (self.vert_index >= self.verts.len or self.texture != texture.id) {
            self.flush();
        }

        self.texture = texture.id;
        const offset = if (size == 1) 0 else size * 0.5;
        const tl: Vec2 = .{ .x = pos.x - offset, .y = pos.y - offset };

        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = tl; // bl
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = col;

        verts[1].pos = .{ .x = tl.x + size, .y = tl.y }; // br
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = col;

        verts[2].pos = .{ .x = tl.x + size, .y = tl.y + size }; // tr
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = 0xFFFFFFFF;

        verts[3].pos = .{ .x = tl.x, .y = tl.y + size }; // tl
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = 0xFFFFFFFF;

        self.vert_index += 4;
    }

    pub fn drawRect(self: *Batcher, texture: Texture, pos: Vec2, size: Vec2) void {
        if (self.vert_index >= self.verts.len or self.texture != texture.id) {
            self.flush();
        }

        self.texture = texture.id;

        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = pos; // bl
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = 0xFFFFFFFF;

        verts[1].pos = .{ .x = pos.x + size.x, .y = pos.y }; // br
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = 0xFFFFFFFF;

        verts[2].pos = .{ .x = pos.x + size.x, .y = pos.y + size.y }; // tr
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = 0xFFFFFFFF;

        verts[3].pos = .{ .x = pos.x, .y = pos.y + size.y }; // tl
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = 0xFFFFFFFF;

        self.vert_index += 4;
    }

    pub fn drawBigRect(self: *Batcher) void {
        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = .{ .x = 20, .y = 90 };
        verts[0].uv = .{ .x = 0, .y = 1 };

        verts[1].pos = .{ .x = 100, .y = 90 };
        verts[1].uv = .{ .x = 1, .y = 1 };

        verts[2].pos = .{ .x = 100, .y = 10 };
        verts[2].uv = .{ .x = 1, .y = 0 };

        verts[3].pos = .{ .x = 20, .y = 10 };
        verts[3].uv = .{ .x = 0, .y = 0 };

        self.vert_index += 4;
    }

    pub fn drawTex(self: *Batcher, pos: Vec2, col: u32, texture: Texture) void {
        if (self.vert_index >= self.verts.len or self.texture != texture.id) {
            self.flush();
        }

        self.texture = texture.id;

        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = pos; // bl
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = col;

        verts[1].pos = .{ .x = pos.x + texture.width, .y = pos.y }; // br
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = col;

        verts[2].pos = .{ .x = pos.x + texture.width, .y = pos.y + texture.height }; // tr
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = col;

        verts[3].pos = .{ .x = pos.x, .y = pos.y + texture.height }; // tl
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = col;

        self.vert_index += 4;
    }
};

pub const MultiBatcher = struct {
    vao: GLuint,
    index_buffer: IndexBuffer,
    vertex_buffer: VertexBuffer,
    verts: []MultiVertex,
    vert_index: usize = 0, // current index into the vertex array
    texture: GLuint = std.math.maxInt(GLuint),
    textures: FixedList(GLuint, 8),

    pub fn init(max_sprites: usize) MultiBatcher {
        var vao: GLuint = undefined;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        var verts = std.testing.allocator.alloc(MultiVertex, max_sprites) catch unreachable;
        std.mem.set(MultiVertex, verts, MultiVertex{ .pos = .{} });

        var indices = std.testing.allocator.alloc(u32, max_sprites * 6) catch unreachable;
        defer std.testing.allocator.free(indices);
        var i: usize = 0;
        while (i < max_sprites) : (i += 1) {
            indices[i * 3 * 2 + 0] = @intCast(u32, i) * 4 + 0;
            indices[i * 3 * 2 + 1] = @intCast(u32, i) * 4 + 1;
            indices[i * 3 * 2 + 2] = @intCast(u32, i) * 4 + 2;
            indices[i * 3 * 2 + 3] = @intCast(u32, i) * 4 + 0;
            indices[i * 3 * 2 + 4] = @intCast(u32, i) * 4 + 2;
            indices[i * 3 * 2 + 5] = @intCast(u32, i) * 4 + 3;
        }

        return .{
            .vao = vao,
            .index_buffer = IndexBuffer.init(indices),
            .vertex_buffer = VertexBuffer.init(MultiVertex, verts, .stream),
            .verts = verts,
            .textures = FixedList(GLuint, 8).init(),
        };
    }

    pub fn deinit(self: *MultiBatcher) void {
        glDeleteVertexArrays(1, &self.vao);
        self.index_buffer.deinit();
        self.vertex_buffer.deinit();
    }

    pub fn begin(self: *MultiBatcher) void {
        self.vert_index = 0;
    }

    pub fn end(self: *MultiBatcher) void {
        self.flush();
    }

    pub fn flush(self: *MultiBatcher) void {
        if (self.vert_index == 0) return;

        // send data to gpu
        self.vertex_buffer.setData(MultiVertex, self.verts[0..self.vert_index]);

        // bind textures
        var iter = self.textures.iter();
        var i: c_uint = 0;
        while (iter.next()) |tid| {
            glActiveTexture(GL_TEXTURE0 + i);
            glBindTexture(GL_TEXTURE_2D, tid);
            i += 1;
        }

        // draw
        const quads = self.vert_index / 4;
        glBindVertexArray(self.vao);
        glDrawElements(@enumToInt(PrimitiveType.triangles), @intCast(c_int, quads * 6), @enumToInt(ElementType.u32), null);

        // reset state
        iter = self.textures.iter();
        i = 0;
        while (iter.next()) |tid| {
            glActiveTexture(GL_TEXTURE0 + i);
            glBindTexture(GL_TEXTURE_2D, 0);
            i += 1;
        }

        self.vert_index = 0;
        self.textures.clear();
    }

    inline fn submitTexture(self: *MultiBatcher, tid: GLuint) f32 {
        if (self.textures.indexOf(tid)) |index| return @intToFloat(f32, index);

        self.textures.append(tid);
        return @intToFloat(f32, self.textures.len - 1);
    }

    pub fn drawTex(self: *MultiBatcher, pos: Vec2, col: u32, texture: Texture) void {
        if (self.vert_index >= self.verts.len) {
            self.flush();
        }

        const tid = self.submitTexture(texture.id);

        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = pos; // bl
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = col;

        verts[1].pos = .{ .x = pos.x + texture.width, .y = pos.y }; // br
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = col;

        verts[2].pos = .{ .x = pos.x + texture.width, .y = pos.y + texture.height }; // tr
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = col;

        verts[3].pos = .{ .x = pos.x, .y = pos.y + texture.height }; // tl
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = col;

        self.vert_index += 4;
    }
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
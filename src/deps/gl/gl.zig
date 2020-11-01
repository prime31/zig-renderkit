pub usingnamespace @import("c.zig");
const std = @import("std");

const Allocator = std.mem.Allocator;
const FixedList = @import("fixed_list.zig").FixedList;

pub const ShaderError = error{ ShaderCompileError, InvalidGLContextError };

pub const ShaderProgram = struct {
    id: GLuint,
    vertex: GLuint,
    fragment: GLuint,

    pub fn createFromFile(allocator: *Allocator, vertPath: []const u8, fragPath: []const u8) !ShaderProgram {
        const vertFile = try std.fs.cwd().openFile(vertPath, .{ .read = true });
        const vert = try vertFile.reader().readAllAlloc(allocator, std.math.maxInt(u64));
        const nullVert = try allocator.dupeZ(u8, vert); // null-terminated string
        allocator.free(vert);
        defer allocator.free(nullVert);
        vertFile.close();

        const fragFile = try std.fs.cwd().openFile(fragPath, .{ .read = true });
        const frag = try fragFile.reader().readAllAlloc(allocator, std.math.maxInt(u64));
        const nullFrag = try allocator.dupeZ(u8, frag);
        allocator.free(frag);
        defer allocator.free(nullFrag);
        fragFile.close();

        return try ShaderProgram.create(nullVert, nullFrag);
    }

    pub fn create(vert: [:0]const u8, frag: [:0]const u8) !ShaderProgram {
        const vertexShader = glCreateShader(GL_VERTEX_SHADER);
        var v = vert;
        glShaderSource(vertexShader, 1, &v, null);
        glCompileShader(vertexShader);
        errdefer glDeleteShader(vertexShader);
        try checkError(vertexShader);

        const fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        var f = frag;
        glShaderSource(fragmentShader, 1, &f, null);
        glCompileShader(fragmentShader);
        errdefer glDeleteShader(fragmentShader);
        try checkError(fragmentShader);

        const shaderProgramId = glCreateProgram();
        glAttachShader(shaderProgramId, vertexShader);
        glAttachShader(shaderProgramId, fragmentShader);
        // glBindFragDataLocation(shaderProgramId, 0, "outColor");
        glLinkProgram(shaderProgramId);
        errdefer glDeleteProgram(shaderProgramId);
        try checkProgramError(shaderProgramId);

        // glUseProgram(shaderProgramId);

        // var vao: GLuint = 0;
        // glGenVertexArrays(1, &vao);
        // glBindVertexArray(vao);

        // const stride = 5 * @sizeOf(f32);
        // const posAttrib = glGetAttribLocation(shaderProgramId, "position");
        // glVertexAttribPointer(@bitCast(GLuint, posAttrib), 3, GL_FLOAT, GL_FALSE, stride, null);
        // glEnableVertexAttribArray(@bitCast(GLuint, posAttrib));

        // const texAttrib = glGetAttribLocation(shaderProgramId, "texcoord");
        // glVertexAttribPointer(@bitCast(GLuint, texAttrib), 2, GL_FLOAT, GL_FALSE, stride, 3 * @sizeOf(f32));
        // glEnableVertexAttribArray(@bitCast(GLuint, texAttrib));

        return ShaderProgram{
            .id = shaderProgramId,
            .vertex = vertexShader,
            .fragment = fragmentShader,
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

    pub fn checkError(shader: GLuint) ShaderError!void {
        var status: GLint = undefined;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
        if (status != GL_TRUE) {
            var buf: [2048]u8 = undefined;
            var totalLen: GLsizei = -1;
            glGetShaderInfoLog(shader, 2048, &totalLen, buf[0..]);
            if (totalLen == -1) {
                // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
                return ShaderError.InvalidGLContextError;
            }

            var totalSize: usize = @intCast(usize, totalLen);
            std.debug.print("shader compilation errror:\n{}", .{buf[0..totalSize]});
            return ShaderError.ShaderCompileError;
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

pub const Texture = struct {
    id: GLuint,
    width: f32 = 0,
    height: f32 = 0,

    pub fn init() Texture {
        var id: GLuint = undefined;
        glGenTextures(1, &id);
        glBindTexture(GL_TEXTURE_2D, id);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); // set texture wrapping to GL_REPEAT (default wrapping method)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        return Texture{ .id = id };
    }

    pub fn initWithData(width: c_int, height: c_int, data: []const u8) Texture {
        var tex = init();
        tex.setData(width, height, data);
        return tex;
    }

    pub fn deinit(self: *const Texture) void {
        glDeleteTextures(1, &self.id);
    }

    pub fn bind(self: *const Texture) void {
        glBindTexture(GL_TEXTURE_2D, self.id);
    }

    pub fn setData(self: *Texture, width: c_int, height: c_int, data: [*c]const u8) void {
        self.width = @intToFloat(f32, width);
        self.height = @intToFloat(f32, height);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
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

pub const Mat32 = struct {
    data: [6]f32 = undefined,

    pub fn initOrtho(width: f32, height: f32) Mat32 {
        var result = Mat32{};
        result.data[0] = 2 / width;
        result.data[3] = -2 / height;
        result.data[4] = -1;
        result.data[5] = 1;
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

pub const VertexBuffer = struct {
    id: GLuint,

    pub fn init(comptime T: type, verts: []const T, dynamic: bool) VertexBuffer {
        var vbo: GLuint = undefined;
        glGenBuffers(1, &vbo);

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, @intCast(c_long, verts.len * @sizeOf(T)), if (dynamic) null else verts.ptr, if (dynamic) GL_DYNAMIC_DRAW else GL_STATIC_DRAW);

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

        return .{ .id = vbo };
    }

    pub fn deinit(self: *VertexBuffer) void {
        glDeleteBuffers(1, &self.id);
    }

    pub fn bind(self: VertexBuffer) void {
        glBindBuffer(GL_ARRAY_BUFFER, self.id);
    }

    pub fn unbind(self: VertexBuffer) void {
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }

    pub fn setData(self: VertexBuffer, comptime T: type, verts: []const T) void {
        glBindBuffer(GL_ARRAY_BUFFER, self.id);
        glBufferSubData(GL_ARRAY_BUFFER, 0, @intCast(c_long, verts.len * @sizeOf(T)), verts.ptr);
    }
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
            .vertex_buffer = VertexBuffer.init(Vertex, verts, true),
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
        glDrawElements(GL_TRIANGLES, @intCast(c_int, quads * 6), GL_UNSIGNED_INT, null);

        // reset
        self.vert_index = 0;
    }

    pub fn drawRect(self: *Batcher) void {
        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = .{ .x = -0.5, .y = 0.5 }; // tl
        verts[0].uv = .{ .x = 0, .y = 1 };

        verts[1].pos = .{ .x = 0.5, .y = 0.5 }; // tr
        verts[1].uv = .{ .x = 1, .y = 1 };

        verts[2].pos = .{ .x = 0.5, .y = -0.5 }; // br
        verts[2].uv = .{ .x = 1, .y = 0 };

        verts[3].pos = .{ .x = -0.5, .y = -0.5 }; // bl
        verts[3].uv = .{ .x = 0, .y = 0 };

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
        verts[0].pos = .{ .x = pos.x, .y = pos.y + texture.height };
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = col;

        verts[1].pos = .{ .x = pos.x + texture.width, .y = pos.y + texture.height };
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = col;

        verts[2].pos = .{ .x = pos.x + texture.width, .y = pos.y };
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = col;

        verts[3].pos = .{ .x = pos.x, .y = pos.y };
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = col;

        self.vert_index += 4;
    }
};

const single_texture_mode = true;
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
            .vertex_buffer = VertexBuffer.init(MultiVertex, verts, true),
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

        if (single_texture_mode) {
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, self.textures.items[0]);
        } else {
            // bind textures
            var iter = self.textures.iter();
            var i: c_uint = 0;
            while (iter.next()) |tid| {
                glActiveTexture(GL_TEXTURE0 + i);
                glBindTexture(GL_TEXTURE_2D, tid);
                i += 1;
            }
        }

        // draw
        const quads = self.vert_index / 4;
        glBindVertexArray(self.vao);
        glDrawElements(GL_TRIANGLES, @intCast(c_int, quads * 6), GL_UNSIGNED_INT, null);

        // reset state
        if (!single_texture_mode) {
            var iter = self.textures.iter();
            var i: c_uint = 0;
            while (iter.next()) |tid| {
                glActiveTexture(GL_TEXTURE0 + i);
                glBindTexture(GL_TEXTURE_2D, 0);
                i += 1;
            }
        }

        self.vert_index = 0;
        self.textures.clear();
    }

    inline fn submitTexture(self: *MultiBatcher, tid: GLuint) f32 {
        if (single_texture_mode) {
            self.textures.len = 1;
            self.textures.items[0] = tid;
            return 0;
        }

        if (self.textures.indexOf(tid)) |index| return @intToFloat(f32, index);

        self.textures.append(tid);
        return @intToFloat(f32, self.textures.len - 1);
    }

    pub fn drawTex(self: *MultiBatcher, pos: Vec2, col: u32, texture: Texture) void {
        if (self.vert_index >= self.verts.len) {
            self.flush();
        }

        const tid = self.submitTexture(texture.id);
        // std.debug.print("tid: {d}, orig: {d}\n", .{tid, texture.id});

        var verts = self.verts[self.vert_index .. self.vert_index + 4];
        verts[0].pos = .{ .x = pos.x, .y = pos.y + texture.height };
        verts[0].uv = .{ .x = 0, .y = 1 };
        verts[0].col = col;
        verts[0].tid = tid;

        verts[1].pos = .{ .x = pos.x + texture.width, .y = pos.y + texture.height };
        verts[1].uv = .{ .x = 1, .y = 1 };
        verts[1].col = col;
        verts[1].tid = tid;

        verts[2].pos = .{ .x = pos.x + texture.width, .y = pos.y };
        verts[2].uv = .{ .x = 1, .y = 0 };
        verts[2].col = col;
        verts[2].tid = tid;

        verts[3].pos = .{ .x = pos.x, .y = pos.y };
        verts[3].uv = .{ .x = 0, .y = 0 };
        verts[3].col = col;
        verts[3].tid = tid;

        self.vert_index += 4;
    }
};

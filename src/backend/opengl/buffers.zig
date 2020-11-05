const std = @import("std");
const gfx = @import("../../gfx.zig");
usingnamespace @import("gl_decls.zig");

fn vertexBufferUsageToGl(usage: gfx.VertexBufferUsage) GLenum {
    return switch (usage) {
        .stream_draw => GL_STREAM_DRAW,
        .static_draw => GL_STATIC_DRAW,
        .dynamic_draw => GL_DYNAMIC_DRAW,
    };
}

pub const BufferBindings = struct {
    vao: GLuint,
    index_buffer: IndexBuffer = undefined,
    vertex_buffer: VertexBuffer = undefined,

    pub fn init() BufferBindings {
        var vao: GLuint = undefined;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        return .{ .vao = vao };
    }

    pub fn deinit(self: *BufferBindings) void {
        glDeleteVertexArrays(1, &self.vao);
        self.index_buffer.deinit();
        self.vertex_buffer.deinit();
    }

    pub fn bindTexture(self: BufferBindings, tid: gfx.TextureId, slot: c_uint) void {
        glActiveTexture(GL_TEXTURE0 + slot);
        glBindTexture(GL_TEXTURE_2D, tid);
    }

    pub fn draw(self: BufferBindings, element_count: c_int) void {
        glBindVertexArray(self.vao);
        glDrawElements(GL_TRIANGLES, element_count, self.index_buffer.buffer_type, null);
    }
};

pub const VertexBuffer = struct {
    vbo: GLuint,
    stream: bool,

    pub fn init(comptime T: type, verts: []const T, usage: gfx.VertexBufferUsage) VertexBuffer {
        var vbo: GLuint = undefined;
        glGenBuffers(1, &vbo);

        glBindBuffer(GL_ARRAY_BUFFER, vbo);
        glBufferData(GL_ARRAY_BUFFER, @intCast(c_long, verts.len * @sizeOf(T)), if (usage == .static_draw) verts.ptr else null, vertexBufferUsageToGl(usage));

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

pub const IndexBuffer = struct {
    id: GLuint,
    buffer_type: GLenum,

    pub fn init(comptime T: type, indices: []T) IndexBuffer {
        std.debug.assert(T == u16 or T == u32);
        var ebo: GLuint = undefined;
        glGenBuffers(1, &ebo);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, @intCast(c_long, indices.len * @sizeOf(T)), indices.ptr, GL_STATIC_DRAW);

        return .{ .id = ebo, .buffer_type = if (T == u16) GL_UNSIGNED_SHORT else GL_UNSIGNED_INT };
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

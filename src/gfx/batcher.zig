const std = @import("std");
const aya = @import("../runner.zig");
pub usingnamespace @import("opengl/gl_decls.zig"); // TODO: kill this when Mesh is done

const gfx = aya.gfx;
const math = aya.math;

const IndexBuffer = gfx.IndexBuffer;
const VertexBuffer = gfx.VertexBuffer;
const Vertex = gfx.Vertex;

const Allocator = std.mem.Allocator;
const FixedList = @import("../deps/gl/fixed_list.zig").FixedList;

fn primitiveTypeToGl(usage: gfx.PrimitiveType) GLenum {
    return switch (usage) {
        .points => GL_POINTS,
        .line_strip => GL_LINE_STRIP,
        .line_loop => GL_LINE_LOOP,
        .lines => GL_LINES,
        .triangle_strip => GL_TRIANGLE_STRIP,
        .triangle_fan => GL_TRIANGLE_FAN,
        .triangles => GL_TRIANGLES,
    };
}

fn elementTypeToGl(usage: gfx.ElementType) GLenum {
    return switch (usage) {
        .u8 => GL_UNSIGNED_BYTE,
        .u16 => GL_UNSIGNED_SHORT,
        .u32 => GL_UNSIGNED_INT,
    };
}

pub const Batcher = struct {
    vao: GLuint,
    index_buffer: IndexBuffer,
    vertex_buffer: VertexBuffer,
    verts: []Vertex,
    vert_index: usize = 0, // current index into the vertex array
    texture: GLuint = std.math.maxInt(GLuint),

    pub fn init(max_sprites: usize) Batcher {
        // if (max_sprites * 6 > std.math.maxInt(u16)) @panic("max_sprites exceeds u16 index buffer size");
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
            .index_buffer = gfx.IndexBuffer.init(indices),
            .vertex_buffer = gfx.VertexBuffer.init(Vertex, verts, .stream_draw),
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
        glDrawElements(primitiveTypeToGl(gfx.PrimitiveType.triangles), @intCast(c_int, quads * 6), elementTypeToGl(gfx.ElementType.u32), null);

        // reset
        self.vert_index = 0;
    }

    pub fn drawPoint(self: *Batcher, texture: gfx.Texture, pos: math.Vec2, size: f32, col: u32) void {
        if (self.vert_index >= self.verts.len or self.texture != texture.id) {
            self.flush();
        }

        self.texture = texture.id;
        const offset = if (size == 1) 0 else size * 0.5;
        const tl: math.Vec2 = .{ .x = pos.x - offset, .y = pos.y - offset };

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

    pub fn drawRect(self: *Batcher, texture: gfx.Texture, pos: math.Vec2, size: math.Vec2) void {
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

    pub fn drawTex(self: *Batcher, pos: math.Vec2, col: u32, texture: gfx.Texture) void {
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
    verts: []gfx.MultiVertex,
    vert_index: usize = 0, // current index into the vertex array
    texture: GLuint = std.math.maxInt(GLuint),
    textures: FixedList(gfx.TextureId, 8),

    pub fn init(max_sprites: usize) MultiBatcher {
        // if (max_sprites * 6 > std.math.maxInt(u16)) @panic("max_sprites exceeds u16 index buffer size");
        var vao: GLuint = undefined;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        var verts = std.testing.allocator.alloc(gfx.MultiVertex, max_sprites) catch unreachable;
        std.mem.set(gfx.MultiVertex, verts, gfx.MultiVertex{ .pos = .{} });

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
            .vertex_buffer = VertexBuffer.init(gfx.MultiVertex, verts, .stream_draw),
            .verts = verts,
            .textures = FixedList(gfx.TextureId, 8).init(),
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
        self.vertex_buffer.setData(gfx.MultiVertex, self.verts[0..self.vert_index]);

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
        glDrawElements(primitiveTypeToGl(gfx.PrimitiveType.triangles), @intCast(c_int, quads * 6), elementTypeToGl(gfx.ElementType.u32), null);

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

    pub fn drawTex(self: *MultiBatcher, pos: math.Vec2, col: u32, texture: gfx.Texture) void {
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

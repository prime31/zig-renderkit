const std = @import("std");
const gfx = @import("../gfx.zig");
const math = gfx.math;

const IndexBuffer = gfx.IndexBuffer;
const VertexBuffer = gfx.VertexBuffer;
const Vertex = gfx.Vertex;

pub const Batcher = struct {
    mesh: gfx.DynamicMesh(Vertex, u16),
    vert_index: usize = 0, // current index into the vertex array
    texture: gfx.backend.ImageId = std.math.maxInt(gfx.backend.ImageId),

    pub fn init(allocator: *std.mem.Allocator, max_sprites: usize) Batcher {
        if (max_sprites * 6 > std.math.maxInt(u16)) @panic("max_sprites exceeds u16 index buffer size");

        var indices = allocator.alloc(u16, max_sprites * 6) catch unreachable;
        defer allocator.free(indices);
        var i: usize = 0;
        while (i < max_sprites) : (i += 1) {
            indices[i * 3 * 2 + 0] = @intCast(u16, i) * 4 + 0;
            indices[i * 3 * 2 + 1] = @intCast(u16, i) * 4 + 1;
            indices[i * 3 * 2 + 2] = @intCast(u16, i) * 4 + 2;
            indices[i * 3 * 2 + 3] = @intCast(u16, i) * 4 + 2;
            indices[i * 3 * 2 + 4] = @intCast(u16, i) * 4 + 3;
            indices[i * 3 * 2 + 5] = @intCast(u16, i) * 4 + 0;
        }

        return .{
            .mesh = gfx.DynamicMesh(Vertex, u16).init(allocator, max_sprites * 4, indices) catch unreachable,
        };
    }

    pub fn deinit(self: *Batcher) void {
        self.mesh.deinit();
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
        self.mesh.updateVertSlice(0, self.vert_index);

        // bind textures
        gfx.bindTexture(self.texture, 0);

        // draw
        const quads = self.vert_index / 4;
        self.mesh.draw(@intCast(c_int, quads * 6));

        // reset
        self.vert_index = 0;
    }

    pub fn drawPoint(self: *Batcher, texture: gfx.Texture, pos: math.Vec2, size: f32, col: u32) void {
        if (self.vert_index >= self.mesh.verts.len or self.texture != texture.img.tid) {
            self.flush();
        }

        self.texture = texture.img.tid;
        const offset = if (size == 1) 0 else size * 0.5;
        const tl: math.Vec2 = .{ .x = pos.x - offset, .y = pos.y - offset };

        var verts = self.mesh.verts[self.vert_index .. self.vert_index + 4];
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
        if (self.vert_index >= self.mesh.verts.len or self.texture != texture.img.tid) {
            self.flush();
        }

        self.texture = texture.img.tid;

        var verts = self.mesh.verts[self.vert_index .. self.vert_index + 4];
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
        if (self.vert_index >= self.mesh.verts.len or self.texture != texture.img.tid) {
            self.flush();
        }

        self.texture = texture.img.tid;

        var verts = self.mesh.verts[self.vert_index .. self.vert_index + 4];
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

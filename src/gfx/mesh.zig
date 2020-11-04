const std = @import("std");
const aya = @import("../runner.zig");

const gfx = aya.gfx;
const math = aya.math;

pub const Mesh = struct {
    bindings: gfx.BufferBindings,
    element_count: c_int,

    pub fn init(comptime VertT: type, verts: []VertT, comptime IndexT: type, indices: []IndexT) Mesh {
        var bindings = gfx.BufferBindings.init();
        bindings.vertex_buffer = gfx.VertexBuffer.init(VertT, verts, .static_draw);
        bindings.index_buffer = gfx.IndexBuffer.init(IndexT, indices);

        return .{
            .bindings = bindings,
            .element_count = @intCast(c_int, indices.len),
        };
    }

    pub fn deinit(self: Mesh) void {
        self.bindings.deinit();
    }

    pub fn draw(self: Mesh) void {
        self.bindings.draw(self.element_count);
    }
};

/// Contains a dynamic vert buffer and a slice of verts
pub fn DynamicMesh(comptime VertT: type, comptime IndexT: type) type {
    return struct {
        const Self = @This();

        bindings: gfx.BufferBindings,
        verts: []VertT,
        allocator: *std.mem.Allocator,

        pub fn init(allocator: ?*std.mem.Allocator, vertex_count: usize, indices: []IndexT) !Self {
            const alloc = allocator orelse std.testing.allocator;

            var bindings = gfx.BufferBindings.init();
            bindings.vertex_buffer = gfx.VertexBuffer.init(VertT, &[_]VertT{}, .stream_draw);
            bindings.index_buffer = gfx.IndexBuffer.init(IndexT, indices);

            return Self{
                .bindings = bindings,
                .verts = try alloc.alloc(VertT, vertex_count),
                .allocator = alloc,
            };
        }

        pub fn deinit(self: *Self) void {
            self.bindings.deinit();
            self.allocator.free(self.verts);
        }

        pub fn updateAllVerts(self: *Self) void {
            self.bindings.vertex_buffer.setData(VertT, self.verts);
        }

        /// uploads to the GPU the slice from start_index with num_verts
        pub fn updateVertSlice(self: *Self, start_index: usize, num_verts: usize) void {
            std.debug.assert(start_index + num_verts <= self.verts.len);
            const vert_slice = self.verts[start_index..start_index + num_verts];
            self.bindings.vertex_buffer.setData(VertT, vert_slice);
        }

        pub fn draw(self: Self, element_count: c_int) void {
            self.bindings.draw(element_count);
        }

        pub fn drawAllVerts(self: Self) void {
            self.draw(@intCast(c_int, self.verts.len / 4 * 6));
        }
    };
}

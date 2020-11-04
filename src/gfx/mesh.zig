const std = @import("std");
const aya = @import("../runner.zig");
pub usingnamespace @import("opengl/gl_decls.zig"); // TODO: kill this when Mesh is done

const gfx = aya.gfx;
const math = aya.math;


pub const Mesh = struct {
    vao: GLuint,
    vertex_buffer: gfx.VertexBuffer,
    index_buffer: gfx.IndexBuffer,
    element_count: c_int,

    pub fn init(comptime T: type, verts: []T, indices: []u32) Mesh {
        var vao: GLuint = undefined;
        glGenVertexArrays(1, &vao);
        glBindVertexArray(vao);

        const vertex_buffer = gfx.VertexBuffer.init(T, verts, .static_draw);
        const index_buffer = gfx.IndexBuffer.init(indices);
        return .{
            .vao = vao,
            .vertex_buffer = vertex_buffer,
            .index_buffer = index_buffer,
            .element_count = @intCast(c_int, indices.len),
        };
    }

    pub fn deinit(self: Mesh) void {
        sg_destroy_buffer(self.bindings.vertex_buffers[0]);
        sg_destroy_buffer(self.bindings.index_buffer);
    }

    pub fn draw(self: *Mesh) void {
        // self.vertex_buffer.bind();
        // self.index_buffer.bind();

        glBindVertexArray(self.vao);
        glDrawElements(GL_TRIANGLES, self.element_count, GL_UNSIGNED_INT, null);
    }
};

pub const DynamicMesh = struct {};

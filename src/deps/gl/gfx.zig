// the backend must provide all of the following types
pub const Texture = @import("texture.zig").Texture;
pub const OffscreenPass = @import("offscreen_pass.zig").OffscreenPass;

pub const Vertex = @import("buffers.zig").Vertex;
pub const VertexBuffer = @import("buffers.zig").VertexBuffer;
pub const IndexBuffer = @import("buffers.zig").IndexBuffer;

pub const Mesh = @import("mesh.zig").Mesh;
pub const DynamicMesh = @import("mesh.zig").DynamicMesh;

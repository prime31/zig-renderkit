const std = @import("std");
const aya = @import("../../runner.zig");
const math = aya.math;
const gfx = aya.gfx;

// the dummy backend defines the interface that all other backends need to implement for renderer compliance

pub fn init() void {}
pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {}
pub fn enableState(state: gfx.Capabilities) void {}
pub fn disableState(state: gfx.Capabilities) void {}

pub const TextureId = u32;

pub const Texture = struct {
    id: TextureId,
    width: f32 = 0,
    height: f32 = 0,

    usingnamespace @import("../common/mixins.zig").Texture;

    pub fn init() Texture {
        return .{ .id = 0 };
    }
    pub fn initWithOptions(filter: gfx.TextureFilter, wrap: gfx.TextureWrap) Texture {
        return .{ .id = 0 };
    }
    pub fn deinit(self: Texture) void {}
    pub fn bind(self: Texture) void {}
    pub fn setData(self: *Texture, width: c_int, height: c_int, data: [*c]const u8) void {}
    pub fn setColorData(self: *Texture, width: c_int, height: c_int, data: [*c]const u32) void {}
};

pub const RenderTexture = struct {
    pub fn deinit(self: RenderTexture) void {}
};

pub const BufferBindings = struct {
    pub fn init() BufferBindings {}
    pub fn deinit(self: BufferBindings) void {}
    pub fn draw(self: BufferBindings, element_count: c_int) void {}
};

pub const VertexBuffer = struct {
    pub fn init(comptime T: type, verts: []const T, usage: gfx.VertexBufferUsage) VertexBuffer {
        return .{};
    }
    pub fn deinit(self: VertexBuffer) void {}
    pub fn setData(self: VertexBuffer, comptime T: type, verts: []const T) void {}
};

pub const IndexBuffer = struct {
    pub fn init(indices: []const u32) IndexBuffer {
        return .{};
    }
    pub fn deinit(self: IndexBuffer) void {}
};

pub const Shader = struct {
    pub fn initFromFile(allocator: *std.mem.Allocator, vert_path: []const u8, frag_path: []const u8) !Shader {
        return Shader{};
    }
    pub fn init(vert: [:0]const u8, frag: [:0]const u8) !Shader {
        return Shader{};
    }
    pub fn deinit(self: Shader) void {}
    pub fn bind(self: Shader) void {}
    pub fn setIntArray(self: *Shader, name: [:0]const u8, value: []const c_int) void {}
    pub fn setInt(self: *Shader, name: [:0]const u8, val: c_int) void {}
    pub fn setVec2(self: *Shader, name: [:0]const u8, val: Vec2) void {}
    pub fn setMat3x2(self: *Shader, name: [:0]const u8, val: math.Mat32) void {}
};

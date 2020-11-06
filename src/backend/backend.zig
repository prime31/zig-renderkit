const std = @import("std");
pub const gfx_types = @import("types.zig");
pub usingnamespace @import("descriptions.zig");

// this is the entrypoint for all renderer specific types. They are loaded based on the chosen Renderer
// and exposed via this interface.

pub const Renderer = enum {
    dummy,
    opengl,
    metal,
    directx,
    vulkan,
};

// pub const backend = @import(@tagName(aya.renderer) ++ "/backend.zig"); // zls cant auto-complete these
pub const backend = @import("opengl/backend.zig"); // hardcoded for now to zls can auto-complete it

// textures
pub const ImageId = backend.ImageId;
pub const Image = backend.Image;

pub fn createImage(desc: ImageDesc) Image {
    return backend.createImage(desc);
}

pub fn destroyImage(image: Image) void {
    backend.destroyImage(image);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    std.debug.assert(T == u8 or T == u32);
    backend.updateImage(T, image, content);
}


// passes
pub const OffscreenPass = backend.OffscreenPass;

pub fn createOffscreenPass(desc: OffscreenPassDesc) OffscreenPass {
    return backend.createOffscreenPass(desc);
}

pub fn destroyOffscreenPass(pass: OffscreenPass) void {
    backend.destroyOffscreenPass(pass);
}

pub fn beginOffscreenPass(pass: OffscreenPass) void {
    backend.beginOffscreenPass(pass);
}

pub fn endOffscreenPass(pass: OffscreenPass) void {
    backend.endOffscreenPass(pass);
}


// buffers
pub const Buffer = backend.Buffer;
pub const Bindings = backend.Bindings;

pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer {
    return backend.createBuffer(T, desc);
}

pub fn destroyBuffer(buffer: Buffer) void {
    backend.destroyBuffer(buffer);
}

pub fn createBufferBindings(index_buffer: Buffer, vert_buffer: Buffer) Bindings {
    return backend.createBufferBindings(index_buffer, vert_buffer);
}

pub fn destroyBufferBindings(bindings: Bindings) void {
    return backend.destroyBufferBindings(bindings);
}

pub fn drawBufferBindings(bindings: Bindings, element_count: c_int) void {
    return backend.drawBufferBindings(bindings, element_count);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    backend.updateBuffer(T, buffer, verts);
}

// sg_shader sg_make_shader(const sg_shader_desc* desc);
// void sg_destroy_shader(sg_shader shd);


// rendering functions
// void sg_apply_pipeline(sg_pipeline pip);
// void sg_apply_bindings(const sg_bindings* bindings);
// void sg_apply_uniforms(sg_shader_stage stage, int ub_index, const void* data, int num_bytes);
// void sg_draw(int base_element, int num_elements, int num_instances);
// void sg_commit(void);



// the backend must provide all of the following types/funcs
pub fn init() void {
    backend.init();
    backend.setRenderState(.{});
}

pub fn initWithLoader(loader: fn ([*c]const u8) callconv(.C) ?*c_void) void {
    backend.initWithLoader(loader);
    backend.setRenderState(.{});
}

pub fn setRenderState(state: gfx_types.RenderState) void {
    backend.setRenderState(state);
}

pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.viewport(x, y, width, height);
}

pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void {
    backend.scissor(x, y, width, height);
}

pub fn clear(action: gfx_types.ClearCommand) void {
    backend.clear(action);
}

pub const Shader = backend.Shader;

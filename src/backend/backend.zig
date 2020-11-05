const std = @import("std");
const gfx_types = @import("types.zig");
usingnamespace @import("descriptions.zig");

// this is the entrypoint for all renderer specific types. They are loaded based on the chosen Renderer
// and exposed via this interface.

pub const Renderer = enum {
    dummy,
    opengl,
    metal,
    directx,
    vulkan,
};

// textures
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

pub fn bindImage(image: Image, slot: c_uint) void {
    backend.bindImage(image, slot);
}

// sg_image sg_make_image(const sg_image_desc* desc);
// void sg_destroy_image(sg_image img);
// void sg_update_image(sg_image img, const sg_image_content* data);

// resource creation, destruction and updating */
// sg_buffer sg_make_buffer(const sg_buffer_desc* desc);
// sg_shader sg_make_shader(const sg_shader_desc* desc);
// sg_pipeline sg_make_pipeline(const sg_pipeline_desc* desc);
// sg_pass sg_make_pass(const sg_pass_desc* desc);
// void sg_destroy_buffer(sg_buffer buf);
// void sg_destroy_shader(sg_shader shd);
// void sg_destroy_pipeline(sg_pipeline pip);
// void sg_destroy_pass(sg_pass pass);
// void sg_update_buffer(sg_buffer buf, const void* data_ptr, int data_size);
// int sg_append_buffer(sg_buffer buf, const void* data_ptr, int data_size);
// bool sg_query_buffer_overflow(sg_buffer buf);

// rendering functions
// void sg_begin_default_pass(const sg_pass_action* pass_action, int width, int height);
// void sg_begin_pass(sg_pass pass, const sg_pass_action* pass_action);
// void sg_apply_viewport(int x, int y, int width, int height, bool origin_top_left);
// void sg_apply_scissor_rect(int x, int y, int width, int height, bool origin_top_left);
// void sg_apply_pipeline(sg_pipeline pip);
// void sg_apply_bindings(const sg_bindings* bindings);
// void sg_apply_uniforms(sg_shader_stage stage, int ub_index, const void* data, int num_bytes);
// void sg_draw(int base_element, int num_elements, int num_instances);
// void sg_end_pass(void);
// void sg_commit(void);




// pub const backend = @import(@tagName(aya.renderer) ++ "/backend.zig"); // zls cant auto-complete these
pub const backend = @import("opengl/backend.zig"); // hardcoded for now to zls can auto-complete it

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

pub const BufferBindings = backend.BufferBindings;
pub const VertexBuffer = backend.VertexBuffer;
pub const IndexBuffer = backend.IndexBuffer;

pub const Shader = backend.Shader;

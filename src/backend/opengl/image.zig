const std = @import("std");
usingnamespace @import("gl_decls.zig");
usingnamespace @import("../descriptions.zig");

pub const Image = *GLImage;

pub const GLImage = struct {
    tid: GLuint,
    width: i32,
    height: i32,
};

pub fn createImage(desc: ImageDesc) Image {
    var img = @ptrCast(*GLImage, @alignCast(@alignOf(*GLImage), std.c.malloc(@sizeOf(GLImage)).?));
    img.* = std.mem.zeroes(GLImage);
    img.width = desc.width;
    img.height = desc.height;

    if (desc.pixel_format == .depth_stencil) {
        std.debug.assert(desc.usage == .immutable);
        glGenRenderbuffers(1, &img.tid);
        glBindRenderbuffer(GL_RENDERBUFFER, img.tid);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, desc.width, desc.height);
    } else if (desc.pixel_format == .stencil) {
        std.debug.assert(desc.usage == .immutable);
        glGenRenderbuffers(1, &img.tid);
        glBindRenderbuffer(GL_RENDERBUFFER, img.tid);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, desc.width, desc.height);
    } else {
        std.debug.assert(!desc.render_target);
        glGenTextures(1, &img.tid);
        glBindTexture(GL_TEXTURE_2D, img.tid);

        const wrap_u: GLint = if (desc.wrap_u == .clamp) GL_CLAMP_TO_EDGE else GL_REPEAT;
        const wrap_v: GLint = if (desc.wrap_v == .clamp) GL_CLAMP_TO_EDGE else GL_REPEAT;
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrap_u);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrap_v);

        const filter_min: GLint = if (desc.min_filter == .nearest) GL_NEAREST else GL_LINEAR;
        const filter_mag: GLint = if (desc.mag_filter == .nearest) GL_NEAREST else GL_LINEAR;
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter_min);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter_mag);

        if (desc.content) |content| {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, desc.width, desc.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, content.ptr);
        }

        glBindTexture(GL_TEXTURE_2D, 0);
    }

    return img;
}

pub fn destroyImage(image: Image) void {
    glDeleteTextures(1, &image.tid);
    std.c.free(image);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    std.debug.assert(@sizeOf(T) == image.width * image.height);
    glBindTexture(GL_TEXTURE_2D, image.tid);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.width, image.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, content.ptr);
    glBindTexture(GL_TEXTURE_2D, 0);
}

pub fn bindImage(image: Image, slot: c_uint) void {
    glActiveTexture(GL_TEXTURE0 + slot);
    glBindTexture(GL_TEXTURE_2D, image.tid);
}

// reference for Pass
// pub const RenderTexture = struct {
//     id: TextureId,
//     depth_stencil_id: GLuint = 0,
//     texture: Texture,

//     pub fn init(width: c_int, height: c_int) !RenderTexture {
//         return initWithOptions(width, height, false, false);
//     }

//     pub fn initWithOptions(width: c_int, height: c_int, depth: bool, stencil: bool) !RenderTexture {
//         // we allow neither, both or stencil but not just depth
//         std.debug.assert(!(depth and !stencil));

//         var id: GLuint = undefined;
//         glGenFramebuffers(1, &id);
//         glBindFramebuffer(GL_FRAMEBUFFER, id);
//         errdefer glDeleteFramebuffers(1, &id);
//         defer glBindFramebuffer(GL_FRAMEBUFFER, 0);

//         var texture = Texture.init();
//         texture.setData(width, height, &[_]u8{});
//         errdefer texture.deinit();

//         // The depth/stencil or stencil buffer
//         var depth_stencil_id: GLuint = 0;
//         if (depth or stencil) {
//             glGenRenderbuffers(1, &depth_stencil_id);
//             glBindRenderbuffer(GL_RENDERBUFFER, depth_stencil_id);
//             if (depth and stencil) {
//                 glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, width, height);
//             } else {
//                 glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, width, height);
//             }
//             glBindRenderbuffer(GL_RENDERBUFFER, 0);

//             if (depth) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depth_stencil_id);
//             if (stencil) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, depth_stencil_id);
//         }

//         // Set "render texture" as our colour attachement #0
//         glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, texture.id, 0);

//         // Set the list of draw buffers.
//         var draw_buffers: [1]GLenum = [_]GLenum{GL_COLOR_ATTACHMENT0};
//         glDrawBuffers(1, &draw_buffers);

//         if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) return error.FrameBufferFailed;

//         return RenderTexture{
//             .id = id,
//             .depth_stencil_id = depth_stencil_id,
//             .texture = texture,
//         };
//     }

//     pub fn deinit(self: *RenderTexture) void {
//         self.texture.deinit();
//         glDeleteFramebuffers(1, &self.id);
//         if (self.depth_stencil_id > 0) glDeleteRenderbuffers(1, &self.depth_stencil_id);
//     }

//     pub fn bind(self: *const RenderTexture) void {
//         glBindFramebuffer(GL_FRAMEBUFFER, self.id);
//         gfx.viewport(0, 0, @floatToInt(c_int, self.texture.width), @floatToInt(c_int, self.texture.height));
//     }

//     pub fn unbind(self: *const RenderTexture) void {
//         glBindFramebuffer(GL_FRAMEBUFFER, 0);
//     }
// };
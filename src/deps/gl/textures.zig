pub usingnamespace @import("c.zig");
const std = @import("std");

pub const Texture = struct {
    id: GLuint,
    width: f32 = 0,
    height: f32 = 0,

    pub fn init() Texture {
        var id: GLuint = undefined;
        glGenTextures(1, &id);
        glBindTexture(GL_TEXTURE_2D, id);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); // set texture wrapping to GL_REPEAT (default wrapping method)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        return Texture{ .id = id };
    }

    pub fn initWithData(width: c_int, height: c_int, data: []const u8) Texture {
        var tex = init();
        tex.setData(width, height, data);
        return tex;
    }

    pub fn deinit(self: *const Texture) void {
        glDeleteTextures(1, &self.id);
    }

    pub fn bind(self: *const Texture) void {
        glBindTexture(GL_TEXTURE_2D, self.id);
    }

    pub fn setData(self: *Texture, width: c_int, height: c_int, data: [*c]const u8) void {
        self.width = @intToFloat(f32, width);
        self.height = @intToFloat(f32, height);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    }
};

pub const RenderTexture = struct {
    id: GLuint,
    depth_stencil_id: GLuint = 0,
    texture: Texture,

    pub fn init(width: c_int, height: c_int) !RenderTexture {
        return initWithOptions(width, height, false, false);
    }

    pub fn initWithOptions(width: c_int, height: c_int, depth: bool, stencil: bool) !RenderTexture {
        // we allow neither, both or stencil but not just depth
        std.debug.assert(!(depth and !stencil));

        var id: GLuint = undefined;
        glGenFramebuffers(1, &id);
        glBindFramebuffer(GL_FRAMEBUFFER, id);
        errdefer glDeleteFramebuffers(1, &id);
        defer glBindFramebuffer(GL_FRAMEBUFFER, 0);

        var texture = Texture.init();
        texture.setData(width, height, null);
        errdefer texture.deinit();

        // The depth/stencil or stencil buffer
        var depth_stencil_id: GLuint = 0;
        if (depth or stencil) {
            glGenRenderbuffers(1, &depth_stencil_id);
            glBindRenderbuffer(GL_RENDERBUFFER, depth_stencil_id);
            if (depth and stencil) {
                glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH24_STENCIL8_OES, width, height);
            } else {
                glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, width, height);
            }
            glBindRenderbuffer(GL_RENDERBUFFER, 0);

            if (depth) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depth_stencil_id);
            if (stencil) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, depth_stencil_id);
        }

        // Set "render texture" as our colour attachement #0
        glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, texture.id, 0);

        // Set the list of draw buffers.
        var draw_buffers: [1]GLenum = [_]GLenum{GL_COLOR_ATTACHMENT0};
        glDrawBuffers(1, &draw_buffers);

        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) return error.FrameBufferFailed;

        return RenderTexture{
            .id = id,
            .depth_stencil_id = depth_stencil_id,
            .texture = texture,
        };
    }

    pub fn deinit(self: *RenderTexture) void {
        self.texture.deinit();
        glDeleteFramebuffers(1, &self.id);
        if (self.depth_stencil_id > 0) glDeleteRenderbuffers(1, &self.depth_stencil_id);
    }

    pub fn bind(self: *const RenderTexture) void {
        glBindFramebuffer(GL_FRAMEBUFFER, self.id);
        glViewport(0, 0, @floatToInt(c_int, self.texture.width), @floatToInt(c_int, self.texture.height));
    }

    pub fn unbind(self: *const RenderTexture) void {
        glBindFramebuffer(GL_FRAMEBUFFER, 0);
        // TODO: fix viewport?
        glViewport(0, 0, 800, 600);
    }
};
const std = @import("std");
usingnamespace @import("gl_decls.zig");
usingnamespace @import("../descriptions.zig");
usingnamespace @import("../types.zig");

const RenderCache = @import("render_cache.zig").RenderCache;
var cache = RenderCache.init();

fn checkError(src: std.builtin.SourceLocation) void {
    var err_code: GLenum = glGetError();
    while (err_code != GL_NO_ERROR) {
        var error_name = switch (err_code) {
            GL_INVALID_ENUM => "GL_INVALID_ENUM",
            GL_INVALID_VALUE => "GL_INVALID_VALUE",
            GL_INVALID_OPERATION => "GL_INVALID_OPERATION",
            GL_STACK_OVERFLOW_KHR => "GL_STACK_OVERFLOW_KHR",
            GL_STACK_UNDERFLOW_KHR => "GL_STACK_UNDERFLOW_KHR",
            GL_OUT_OF_MEMORY => "GL_OUT_OF_MEMORY",
            GL_INVALID_FRAMEBUFFER_OPERATION => "GL_INVALID_FRAMEBUFFER_OPERATION",
            else => "Unknown Error Enum",
        };

        std.debug.print("error: {}, file: {}, func: {}, line: {}\n", .{ error_name, src.file, src.fn_name, src.line });
        err_code = glGetError();
    }
}

fn checkShaderError(shader: GLuint) bool {
    var status: GLint = undefined;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status != GL_TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        glGetShaderInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("shader compilation errror:\n{}", .{buf[0..@intCast(usize, total_len)]});
        return false;
    }
    return true;
}

fn checkProgramError(shader: GLuint) bool {
    var status: GLint = undefined;
    glGetProgramiv(shader, GL_LINK_STATUS, &status);
    if (status != GL_TRUE) {
        var buf: [2048]u8 = undefined;
        var total_len: GLsizei = -1;
        glGetProgramInfoLog(shader, 2048, &total_len, buf[0..]);
        if (total_len == -1) {
            // the length of the infolog seems to not be set when a GL context isn't set (so when the window isn't created)
            unreachable;
        }

        std.debug.print("program link errror:\n{}", .{buf[0..@intCast(usize, total_len)]});
        return false;
    }
    return true;
}

pub const ImageId = GLuint;
pub const Image = *GLImage;
pub const GLImage = struct {
    tid: ImageId,
    width: i32,
    height: i32,
    depth: bool,
    stencil: bool,
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
        img.depth = true;
        img.stencil = true;
    } else if (desc.pixel_format == .stencil) {
        std.debug.assert(desc.usage == .immutable);
        glGenRenderbuffers(1, &img.tid);
        glBindRenderbuffer(GL_RENDERBUFFER, img.tid);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_STENCIL_INDEX8, desc.width, desc.height);
        img.stencil = true;
    } else {
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
        } else {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, desc.width, desc.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
        }

        glBindTexture(GL_TEXTURE_2D, 0);
    }

    return img;
}

pub fn destroyImage(image: Image) void {
    cache.invalidateTexture(image.tid);
    glDeleteTextures(1, &image.tid);
    std.c.free(image);
}

pub fn updateImage(comptime T: type, image: Image, content: []const T) void {
    std.debug.assert(@sizeOf(T) == image.width * image.height);
    glBindTexture(GL_TEXTURE_2D, image.tid);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.width, image.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, content.ptr);
    glBindTexture(GL_TEXTURE_2D, 0);
}

pub const OffscreenPass = *GLOffscreenPass;
pub const GLOffscreenPass = struct {
    framebuffer_tid: GLuint,
    color_img: Image,
    depth_stencil_img: ?Image,
};

pub fn createOffscreenPass(desc: OffscreenPassDesc) OffscreenPass {
    var pass = @ptrCast(*GLOffscreenPass, @alignCast(@alignOf(*GLOffscreenPass), std.c.malloc(@sizeOf(GLOffscreenPass)).?));
    pass.depth_stencil_img = null;

    var orig_fb: GLint = undefined;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &orig_fb);
    defer glBindFramebuffer(GL_FRAMEBUFFER, @intCast(GLuint, orig_fb));

    pass.color_img = desc.color_img;

    // create a framebuffer object
    glGenFramebuffers(1, &pass.framebuffer_tid);
    glBindFramebuffer(GL_FRAMEBUFFER, pass.framebuffer_tid);
    defer glBindFramebuffer(GL_FRAMEBUFFER, 0);

    // bind depth-stencil
    if (desc.depth_stencil_img) |depth_stencil| {
        if (depth_stencil.depth) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depth_stencil.tid);
        if (depth_stencil.stencil) glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, depth_stencil.tid);
    }

    // Set color_img as our colour attachement #0
    glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, desc.color_img.tid, 0);

    // Set the list of draw buffers.
    var draw_buffers: [4]GLenum = [_]GLenum{ GL_COLOR_ATTACHMENT0, GL_COLOR_ATTACHMENT1_EXT, GL_COLOR_ATTACHMENT2_EXT, GL_COLOR_ATTACHMENT3_EXT };
    glDrawBuffers(1, &draw_buffers);

    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) std.debug.print("framebuffer failed\n", .{});

    return pass;
}

pub fn destroyOffscreenPass(pass: OffscreenPass) void {
    glDeleteFramebuffers(1, &pass.framebuffer_tid);
    if (pass.depth_stencil_img != null) glDeleteRenderbuffers(1, &pass.depth_stencil_img.?.tid);
    std.c.free(pass);
}

pub fn beginOffscreenPass(pass: OffscreenPass) void {
    glBindFramebuffer(GL_FRAMEBUFFER, pass.framebuffer_tid);
    glViewport(0, 0, pass.color_img.width, pass.color_img.height);
}

pub fn endOffscreenPass(pass: OffscreenPass) void {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

pub const Buffer = *GLBuffer;
pub const GLBuffer = struct {
    vbo: GLuint,
    stream: bool,
    buffer_type: GLenum,
    setVertexAttributes: ?fn () void,
};

pub const Bindings = *GLBufferBindings;
pub const GLBufferBindings = struct {
    vao: GLuint,
    index_buffer: Buffer,
    vert_buffer: Buffer,

    pub fn bindTexture(self: GLBufferBindings, tid: c_uint, slot: c_uint) void {
        cache.bindTexture(tid, slot);
    }
};

pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer {
    var buffer = @ptrCast(*GLBuffer, @alignCast(@alignOf(*GLBuffer), std.c.malloc(@sizeOf(GLBuffer)).?));
    buffer.* = std.mem.zeroes(GLBuffer);
    buffer.stream = desc.usage == .stream;

    if (@typeInfo(T) == .Struct) {
        buffer.setVertexAttributes = struct {
            fn cb() void {
                inline for (@typeInfo(T).Struct.fields) |field, i| {
                    const offset: ?usize = if (i == 0) null else @byteOffsetOf(T, field.name);

                    switch (@typeInfo(field.field_type)) {
                        .Int => |type_info| {
                            if (type_info.is_signed) {
                                unreachable;
                            } else {
                                switch (type_info.bits) {
                                    32 => {
                                        // u32 is color
                                        glVertexAttribPointer(i, 4, GL_UNSIGNED_BYTE, GL_TRUE, @sizeOf(T), offset);
                                        glEnableVertexAttribArray(i);
                                    },
                                    else => unreachable,
                                }
                            }
                        },
                        .Float => {
                            glVertexAttribPointer(i, 1, GL_FLOAT, GL_FALSE, @sizeOf(T), offset);
                            glEnableVertexAttribArray(i);
                        },
                        .Struct => |type_info| {
                            const field_type = type_info.fields[0].field_type;
                            std.debug.assert(@sizeOf(field_type) == 4);

                            switch (@typeInfo(field_type)) {
                                .Float => {
                                    switch (type_info.fields.len) {
                                        2 => {
                                            glVertexAttribPointer(i, 2, GL_FLOAT, GL_FALSE, @sizeOf(T), offset);
                                            glEnableVertexAttribArray(i);
                                        },
                                        else => unreachable,
                                    }
                                },
                                else => unreachable,
                            }
                        },
                        else => unreachable,
                    }
                }
            }
        }.cb;
    } else {
        buffer.buffer_type = if (T == u16) GL_UNSIGNED_SHORT else GL_UNSIGNED_INT;
    }

    const buffer_type: GLenum = if (desc.type == .index) GL_ELEMENT_ARRAY_BUFFER else GL_ARRAY_BUFFER;
    glGenBuffers(1, &buffer.vbo);
    cache.bindBuffer(buffer_type, buffer.vbo);

    const usage: GLenum = switch (desc.usage) {
        .stream => GL_STREAM_DRAW,
        .immutable => GL_STATIC_DRAW,
        .dynamic => GL_DYNAMIC_DRAW,
    };
    glBufferData(buffer_type, desc.getSize(), if (desc.usage == .immutable) desc.content.?.ptr else null, usage);

    return buffer;
}

pub fn destroyBuffer(buffer: Buffer) void {
    cache.invalidateBuffer(buffer.vbo);
    glDeleteBuffers(1, &buffer.vbo);
    std.c.free(buffer);
}

pub fn createBufferBindings(index_buffer: Buffer, vert_buffer: Buffer) Bindings {
    var buffer = @ptrCast(*GLBufferBindings, @alignCast(@alignOf(*GLBufferBindings), std.c.malloc(@sizeOf(GLBufferBindings)).?));
    buffer.index_buffer = index_buffer;
    buffer.vert_buffer = vert_buffer;

    glGenVertexArrays(1, &buffer.vao);
    cache.bindVertexArray(buffer.vao);

    // vao needs us to issue binds here
    cache.forceBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index_buffer.vbo);

    if (vert_buffer.setVertexAttributes) |setter| {
        cache.forceBindBuffer(GL_ARRAY_BUFFER, vert_buffer.vbo);
        setter();
    }

    return buffer;
}

pub fn destroyBufferBindings(bindings: Bindings) void {
    cache.invalidateVertexArray(bindings.vao);
    glDeleteVertexArrays(1, &bindings.vao);
    destroyBuffer(bindings.index_buffer);
    destroyBuffer(bindings.vert_buffer);
    std.c.free(bindings);
}

pub fn drawBufferBindings(bindings: Bindings, element_count: c_int) void {
    cache.bindVertexArray(bindings.vao);
    glDrawElements(GL_TRIANGLES, element_count, bindings.index_buffer.buffer_type, null);
}

pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void {
    cache.bindBuffer(GL_ARRAY_BUFFER, buffer.vbo);

    // orphan the buffer for streamed
    if (buffer.stream) glBufferData(GL_ARRAY_BUFFER, @intCast(c_long, verts.len * @sizeOf(T)), null, GL_STREAM_DRAW);
    glBufferSubData(GL_ARRAY_BUFFER, 0, @intCast(c_long, verts.len * @sizeOf(T)), verts.ptr);
}

pub const ShaderProgram = *GLShaderProgram;
pub const GLShaderProgram = struct {
    program: GLuint,
};

fn compileShader(stage: GLenum, src: [:0]const u8) GLuint {
    const shader = glCreateShader(stage);
    var shader_src = src;
    glShaderSource(shader, 1, &shader_src, null);
    glCompileShader(shader);
    if (!checkShaderError(shader)) {
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

pub fn createShaderProgram(desc: ShaderDesc) ShaderProgram {
    var shader = @ptrCast(*GLShaderProgram, @alignCast(@alignOf(*GLShaderProgram), std.c.malloc(@sizeOf(GLShaderProgram)).?));
    shader.* = std.mem.zeroes(GLShaderProgram);

    const vertex_shader = compileShader(GL_VERTEX_SHADER, desc.vs);
    const frag_shader = compileShader(GL_FRAGMENT_SHADER, desc.fs);

    if (vertex_shader == 0 and frag_shader == 0) return shader;

    const id = glCreateProgram();
    glAttachShader(id, vertex_shader);
    glAttachShader(id, frag_shader);
    glLinkProgram(id);
    glDeleteShader(vertex_shader);
    glDeleteShader(frag_shader);

    if (!checkProgramError(id)) {
        glDeleteProgram(id);
        return shader;
    }

    shader.program = id;

    // resolve images
    var cur_prog: GLint = 0;
    glGetIntegerv(GL_CURRENT_PROGRAM, &cur_prog);
    glUseProgram(id);

    for (desc.images) |image, i| {
        const loc = glGetUniformLocation(id, image);
        if (loc != -1) {
            glUniform1i(loc, @intCast(GLint, i));
        }
    }

    glUseProgram(@intCast(GLuint, cur_prog));

    return shader;
}

pub fn destroyShaderProgram(shader: ShaderProgram) void {
    cache.invalidateProgram(shader.program);
    glDeleteProgram(shader.program);
    std.c.free(shader);
}

pub fn useShaderProgram(shader: ShaderProgram) void {
    cache.useShaderProgram(shader.program);
}

pub fn setShaderProgramUniform(comptime T: type, shader: ShaderProgram, name: [:0]const u8, value: T) void {
    const location = glGetUniformLocation(shader.program, name);
    if (location == -1) {
        std.debug.print("could not location uniform {}\n", .{name});
        return;
    }

    const ti = @typeInfo(T);
    const type_name = @typeName(T);

    // cover common cases before we go down the rabbit hold
    if (ti == .Struct and std.mem.eql(u8, type_name, "Mat32") and ti.Struct.fields.len == 1 and std.mem.eql(u8, ti.Struct.fields[0].name, "data")) {
        var data = @field(value, ti.Struct.fields[0].name);
        glUniformMatrix3x2fv(glGetUniformLocation(shader.program, name), 1, GL_FALSE, &data);
    } else if (ti == .Struct and std.mem.eql(u8, type_name, "Vec2")) {
        var val = @field(value, ti.Struct.fields[0].name);
        glUniform1fv(location, 2, &val);
    } else if (ti == .Int) {
        glUniform1i(location, value);
    } else if (ti == .Float) {
        glUniform1f(glGetUniformLocation(shader.program, name), value);
    } else if (ti == .Array) {
        switch (@typeInfo(ti.Array.child)) {
            .Int => |type_info| {
                std.debug.assert(type_info.bits == 32);
                glUniform1iv(location, @intCast(c_int, ti.Array.len), &value);
            },
            .Float => |type_info| {
                std.debug.assert(type_info.bits == 32);
                glUniform1fv(location, @intCast(c_int, ti.Array.len), &value);
            },
            .Struct => |type_info| {
                std.debug.print("type_info: {}, type_info: {}\n", .{ ti, type_info });
                @panic("add support for array of struct");
            },
            else => unreachable,
        }
    } else if (ti == .Struct) {
        // the rabbit hole
        inline for (ti.Struct.fields) |field, i| {
            switch (@typeInfo(field.field_type)) {
                .Float => |type_info| {
                    std.debug.print("----- float: {}, field: {}\n", .{ type_info, field.name });
                },
                .Struct => |type_info| {
                    const field_type = type_info.fields[0].field_type;
                    std.debug.print("struct: {}, field: {}, len: {}\n", .{ type_info, field.name, type_info.fields.len });

                    switch (@typeInfo(field_type)) {
                        .Float => {
                            switch (type_info.fields.len) {
                                2 => {
                                    std.debug.print("float2: {}\n", .{type_info});
                                },
                                else => unreachable,
                            }
                        },
                        else => unreachable,
                    }
                },
                else => unreachable,
            }
        }
    } else if (ti == .Pointer) {
        switch (ti.Pointer.size) {
            .Slice, .Many, .C => {
                switch (@typeInfo(ti.Pointer.child)) {
                    .Int => |info| {
                        std.debug.assert(info.bits == 32);
                        glUniform1iv(location, @intCast(c_int, value.len), value.ptr);
                    },
                    .Float => |info| {
                        std.debug.assert(info.bits == 32);
                        glUniform1fv(location, @intCast(c_int, value.len), value.ptr);
                    },
                    else => unreachable,
                }
            },
            else => unreachable,
        }
    } else {
        unreachable;
    }
}

const std = @import("std");
const gamekit = @import("gamekit.zig");
const renderkit = @import("renderkit");
const math = renderkit.math;

pub const PassConfig = struct {
    color_action: renderkit.ClearAction = .clear,
    color: math.Color = math.Color.aya,
    stencil_action: renderkit.ClearAction = .dont_care,
    stencil: u8 = 0,
    depth_action: renderkit.ClearAction = .dont_care,
    depth: f64 = 0,

    trans_mat: ?math.Mat32 = null,
    shader: ?renderkit.Shader = null,
    pass: ?renderkit.OffscreenPass = null,

    pub fn asClearCommand(self: PassConfig) renderkit.ClearCommand {
        return .{
            .color = self.color.asArray(),
        };
    }
};

pub const Gfx = struct {
    batcher: renderkit.Batcher,
    white_tex: renderkit.Texture,
    shader: renderkit.Shader = null,
    quad: math.Quad = math.Quad.init(0, 0, 1, 1, 1, 1),
    blitted_to_screen: bool = false,
    transform_mat: math.Mat32 = math.Mat32.identity,

    pub fn init() Gfx {
        var shader = renderkit.Shader.init(@embedFile("shaders/default.vs"), @embedFile("shaders/default.fs")) catch unreachable;
        shader.bind();
        shader.setUniformName(i32, "MainTex", 0);

        return .{
            .batcher = renderkit.Batcher.init(std.testing.allocator, 1000),
            .white_tex = renderkit.Texture.initSingleColor(0xFFFFFFFF),
            .shader = shader,
        };
    }

    pub fn deinit(self: Gfx) void {
        self.batcher.deinit();
        self.white_tex.deinit();
    }

    pub fn setShader(self: *Gfx, shader: ?renderkit.Shader) void {
        const new_shader = shader orelse self.shader;

        self.batcher.flush();
        new_shader.bind();
        new_shader.setUniformName(math.Mat32, "TransformMatrix", self.transform_mat);
    }

    pub fn beginPass(self: *Gfx, config: PassConfig) void {
        var proj_mat: math.Mat32 = math.Mat32.init();
        var clear_command = config.asClearCommand();

        if (config.pass) |pass| {
            // TODO: move viewport setting into renderkit
            renderkit.viewport(0, 0, @floatToInt(c_int, pass.color_texture.width), @floatToInt(c_int, pass.color_texture.height));
            renderkit.beginPass(pass.pass, clear_command);
            // inverted for OpenGL offscreen passes
            if (renderkit.current_renderer == .opengl) {
                proj_mat = math.Mat32.initOrthoInverted(pass.color_texture.width, pass.color_texture.height);
            } else {
                proj_mat = math.Mat32.initOrtho(pass.color_texture.width, pass.color_texture.height);
            }
        } else {
            const size = gamekit.window.drawableSize();
            // TODO: move viewport setting into renderkit
            renderkit.viewport(0, 0, size.w, size.h);
            renderkit.beginDefaultPass(clear_command, size.w, size.h);
            proj_mat = math.Mat32.initOrtho(@intToFloat(f32, size.w), @intToFloat(f32, size.h));
        }

        // if we were given a transform matrix multiply it here
        if (config.trans_mat) |trans_mat| {
            proj_mat = proj_mat.mul(trans_mat);
        }

        self.transform_mat = proj_mat;

        // if we were given a Shader use it else set the default Pipeline
        self.setShader(config.shader);
    }

    pub fn endPass(self: *Gfx) void {
        // setting the shader will flush the batch
        self.setShader(null);
        renderkit.endPass();
    }

    /// if we havent yet blitted to the screen do so now
    pub fn commitFrame(self: *Gfx) void {
        self.batcher.end();
        renderkit.commitFrame();
    }

    // Drawing
    pub fn drawTexture(self: *Gfx, texture: renderkit.Texture, pos: math.Vec2) void {
        self.quad.setFill(texture.width, texture.height);

        var mat = math.Mat32.initTransform(.{ .x = pos.x, .y = pos.y });
        self.batcher.draw(texture, self.quad, mat, math.Color.white);
    }
};

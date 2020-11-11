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
            .color_action = self.color_action,
            .stencil_action = self.stencil_action,
            .stencil = self.stencil,
            .depth_action = self.depth_action,
            .depth = self.depth,
        };
    }
};

pub var state = struct {
    shader: renderkit.Shader = undefined,
    transform_mat: math.Mat32 = math.Mat32.identity,
}{};

pub fn init() void {
    state.shader = renderkit.Shader.init(@embedFile("shaders/default.vs"), @embedFile("shaders/default.fs")) catch unreachable;
    state.shader.bind();
    state.shader.setUniformName(i32, "MainTex", 0);
    draw.init();
}

pub fn deinit() void {
    draw.deinit();
}

pub fn setShader(shader: ?renderkit.Shader) void {
    const new_shader = shader orelse state.shader;

    draw.batcher.flush();
    new_shader.bind();
    new_shader.setUniformName(math.Mat32, "TransformMatrix", state.transform_mat);
}

pub fn beginPass(config: PassConfig) void {
    var proj_mat: math.Mat32 = math.Mat32.init();
    var clear_command = config.asClearCommand();

    if (config.pass) |pass| {
        renderkit.renderer.beginPass(pass.pass, clear_command);
        // inverted for OpenGL offscreen passes
        if (renderkit.current_renderer == .opengl) {
            proj_mat = math.Mat32.initOrthoInverted(pass.color_texture.width, pass.color_texture.height);
        } else {
            proj_mat = math.Mat32.initOrtho(pass.color_texture.width, pass.color_texture.height);
        }
    } else {
        const size = gamekit.window.drawableSize();
        renderkit.renderer.beginDefaultPass(clear_command, size.w, size.h);
        proj_mat = math.Mat32.initOrtho(@intToFloat(f32, size.w), @intToFloat(f32, size.h));
    }

    // if we were given a transform matrix multiply it here
    if (config.trans_mat) |trans_mat| {
        proj_mat = proj_mat.mul(trans_mat);
    }

    state.transform_mat = proj_mat;

    // if we were given a Shader use it else set the default Pipeline
    setShader(config.shader);
}

pub fn endPass() void {
    // setting the shader will flush the batch
    setShader(null);
    renderkit.renderer.endPass();
}

/// if we havent yet blitted to the screen do so now
pub fn commitFrame() void {
    draw.batcher.end();
    renderkit.renderer.commitFrame();
}

// import all the drawing methods
usingnamespace @import("draw.zig");
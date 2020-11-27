# Zig RenderKit 2D
Cross platform Zig graphics backends with a 2D focus. `RenderKit` is an API abstraction (very similar to and inspired by Sokol) that wraps calls to the backend renderer (currently OpenGL and Metal supported). It aims to be as dependency-free as possible. The OpenGL backend has its own GL function loader so no external loader is required though you can optionally pass in your own GL loader function (`SDL_GL_GetProcAddress` or `glfwGetProcAddress` for example).


### Adding New Backends
There is a _dummy_ backend that can be used as a template to add a new backend. It contains the full API any backend must satisfy. Backends pass no pointers or objects back to user code. [Handles](https://floooh.github.io/2018/06/17/handles-vs-pointers.html) are used for all renderer-specific objects. There are `Handles` and `HandledCache` structs built to make using handles seamless. The companion [GameKit repository](https://github.com/prime31/zig-gamekit) can be used to test new backends while developing them (see next section).


### GameKit Companion Project
`RenderKit` is just a pure backend render API abstraction layer. In order to get something on screen, it requires an OS window and a graphics context. The companion [GameKit repository](https://github.com/prime31/zig-gamekit) provides all of that and more. It has all the high-level abstractions needed to make fast, efficient 2D games. `GameKit` can be used to help with building new backends, as a standalone 2D framework or as inspiration for using `RenderKit` in your own projects.


### Usage
- clone the repository: `git clone https://github.com/prime31/zig-renderkit`
- in your projects build.zig, pass your `LibExeObjStep` to `addRenderKitToArtifact` in `RenderKit`'s build.zig


## RenderKit API
Currently, RenderKit supports OpenGL and Metal. You can set the renderer used by passing to `zig build` the flag `-Drenderer=[enum]` (dummy, opengl and metal currently). Alternatively, you can declare your renderer in your root file: `pub const renderer: renderkit.Renderer = .metal;`. The RenderKit API uses descriptor structs for creating backend objects much like the Metal API or Sokol. Backend objects are passed by as handles to avoid any pointer management being exposed to game code.

### Setup and State
General backend setup and management of graphics state.

`pub fn setup(desc: RendererDesc) void`<br>
`pub fn shutdown() void`<br>
`pub fn setRenderState(state: RenderState) void`<br>
`pub fn viewport(x: c_int, y: c_int, width: c_int, height: c_int) void`<br>
`pub fn scissor(x: c_int, y: c_int, width: c_int, height: c_int) void`


### Images
Loading and updating of GPU textures.

`pub fn createImage(desc: ImageDesc) Image`<br>
`pub fn destroyImage(image: Image) void`<br>
`pub fn updateImage(comptime T: type, image: Image, content: []const T) void`


### Passes
Offscreen passes (commonly refered to as render targets or framebuffers).

`pub fn createPass(desc: PassDesc) Pass`<br>
`pub fn destroyPass(pass: Pass) void`


### Render Loop
These are the methods you will use in your main render loop. `beginPass` renderes to an offscreen pass and all offscreen rendering should be done first. Once all offscreen rendering is done drawing to the backbuffer is handled via `beginDefaultPass`. Each call to `beginPass/beginDefaultPass` should be followed by a matching call to `endPass`. Finally, when all rendering for the frame is done calling `commitFrame` flushes all the graphcis commands.

`pub fn beginDefaultPass(action: ClearCommand, width: c_int, height: c_int) void`<br>
`pub fn beginPass(pass: Pass, action: ClearCommand) void`<br>
`pub fn endPass() void`<br>
`pub fn commitFrame() void`


### Buffers
Creating and management of buffers (vertex and index).

`pub fn createBuffer(comptime T: type, desc: BufferDesc(T)) Buffer`<br>
`pub fn destroyBuffer(buffer: Buffer) void`<br>
`pub fn updateBuffer(comptime T: type, buffer: Buffer, verts: []const T) void`<br>
`pub fn appendBuffer(comptime T: type, buffer: Buffer, verts: []const T) u32`


### Bindings
The only short lived player in the API. BufferBindings envelop what you want to render including an index buffer, 1 - 4 vertex buffers and the textures to bind.

`pub fn applyBindings(bindings: BufferBindings) void`<br>
`pub fn draw(base_element: c_int, element_count: c_int, instance_count: c_int) void`


### Shaders
An important aspect to understand about RenderKit shaders is how the manage uniforms for compatibility with the various backends. When you create a shader you have to tell RenderKit what your vertex and fragment uniforms are.

`pub fn createShaderProgram(comptime VertUniformT: type, comptime FragUniformT: type, desc: ShaderDesc) ShaderProgram`<br>
`pub fn destroyShaderProgram(shader: ShaderProgram) void`<br>
`pub fn useShaderProgram(shader: ShaderProgram) void`<br>
`pub fn setShaderProgramUniformBlock(comptime UniformT: type, shader: ShaderProgram, stage: ShaderStage, value: *UniformT) void`


### Shader Details
Cross platform, cross renderer shaders can be tricky. RenderKit provides an interface that only exposes by default the subset of features that work across all the renderers. It is recommended to use the `ShaderCompileStep` (docs [here](shader_compiler/README.md)) and let RenderKit handle cross-compiling your shaders and generating your uniform structs. Note that only `float` uniforms are supported due to issues with `int`s between the different backends. The shader compiler will handle getting alignment and paddings correct automatically. The shader compiler leverages [Sokol Shader Compiler](https://github.com/floooh/sokol-tools/blob/master/docs/sokol-shdc.md) and takes GLSL in spitting out GLSL/SPIR-V/Metal shaders and a zig file with your uniform structs. A commented example of a struct generated by the `ShaderCompileStep` is below.

There are a few key points to understand with regard to the comptime `metadata` field. While you can handwrite these if you prefer, the compiler can also handle them for you. The `metadata` field contains a required `uniforms` field, that contains the uniforms for your shader. The shader compiler will pack all your uniforms into a single array of `float4`. This lets you update all of them in one single call.

The `images` field (currently only supports fragment shaders) specifies the names of all the images in your shader. RenderKit will automatically find the declarations and bind the correct slots for you.

```zig
pub const DissolveParams = extern struct {
    // the comptime metadata used when creating a shader program to initialize the backend details
    pub const metadata = .{
        // an array of the images that should be setup
        .images = .{ "main_tex", "dissolve_tex" },

        // definition of each uniform along with its type/size. The shader compiler will always pack all data into
        // a single array of float4. Only handwritten shaders would need multiple uniforms (one per struct field).
        .uniforms = .{ .DissolveParams = .{ .type = .float4, .array_count = 2 } },
    };

    // the runtime fields, generated from the uniforms defined in the shader. Note that the `threshold_color` field
    // is automatically aligned for you by the shader compiler.
    progress: f32 = 0,
    threshold: f32 = 0,
    threshold_color: [4]f32 align(16) = [_]f32{0} ** 4,
};
```


<br/><br/><br/><br/><br/>

#### Some interesting GL code used for inspiration

[ZGL](https://github.com/ziglibs/zgl/blob/master/zgl.zig)<br/>
[Oxid](https://github.com/dbandstra/oxid/blob/master/lib/gl.zig)<br/>
[didot](https://github.com/zenith391/didot)<br/>
[learnopengl](https://github.com/cshenton/learnopengl)<br/>
[minifb (Rust)](https://github.com/emoon/rust_minifb)<br/>

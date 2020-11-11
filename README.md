### Zig RenderKit 2D

Cross platform Zig graphics backends with a 2D focus. There are two packages exported by RenderKit:
- **renderkit:** an API abstraction (very similar to and inspired by Sokol) that wraps calls to the backend renderer (currently OpenGL with Metal started). It aims to be as dependency-free as possible. The OpenGL backend has its own GL function loader so no external loader is required though you can optionally pass in your own GL loader function (`SDL_GL_GetProcAddress` or `glfwGetProcAddress` for example).
- **gamekit:** provides an example implementation of a game framework built on top of `renderkit`. Includes the core render loop, window (via SDL), input, timing and Dear ImGui support. You can use it as a base to make a 2D game as-is or create your own 2D game kit based on it.

GameKit provides the following wrappers around `renderkit`'s API showing how it can be abstracted away in a real work project: `Texture`, `Shader` and `OffscreenPass`. Building on top of those types, GameKit then provides `Mesh` and `DynamicMesh` which manage buffers and bindings for you. Finally, the high level types utilize `DynamicMesh` and cover pretty much all that any 2D game would require: `Batcher` (quad/sprite batch) and `TriangleBatcher`.

Some basic utilities and a small math lib with just the types required for the renderer (`Vec2`, `Color`, `3x2 Matrix`, `Quad`) are also included.


### Adding New Backends

There is a _dummy_ backend that can be used as a template to add a new backend. It contains the full API any backend must satisfy. Backends pass no pointers or objects back to user code. [Handles](https://floooh.github.io/2018/06/17/handles-vs-pointers.html) are used for all renderer-specific objects. There are `Handles` and `HandledCache` structs built to make using handles seamless.


### Usage

- clone the repository recursively: `git clone --recursive https://github.com/prime31/zig-renderkit`
- `zig build help` to see what examples are availble
- `zig build EXAMPLE_NAME` to run an example


### Minimal GameKit Project File

```zig
var texture: Texture = undefined;

pub fn main() !void {
    try gamekit.run(.{ .init = init, .render = render, });
}

fn init() !void {
    texture = Texture.initFromFile(std.testing.allocator, "texture.png", .nearest) catch unreachable;
}

fn render() !void {
    gamekit.gfx.beginPass(.{ .color = Color.lime });
    gamekit.gfx.drawTexture(texture, .{ .x = 50, .y = 50 });
    gamekit.gfx.endPass();
}
```


#### Some interesting GL zig code used for inspiration

[ZGL](https://github.com/ziglibs/zgl/blob/master/zgl.zig)

[Oxid](https://github.com/dbandstra/oxid/blob/master/lib/gl.zig)

[didot](https://github.com/zenith391/didot)

[learnopengl](https://github.com/cshenton/learnopengl)

[minifb (Rust)](https://github.com/emoon/rust_minifb)

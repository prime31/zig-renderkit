# Zig RenderKit 2D
Cross platform Zig graphics backends with a 2D focus. `RenderKit` is an API abstraction (very similar to and inspired by Sokol) that wraps calls to the backend renderer (currently OpenGL with Metal started). It aims to be as dependency-free as possible. The OpenGL backend has its own GL function loader so no external loader is required though you can optionally pass in your own GL loader function (`SDL_GL_GetProcAddress` or `glfwGetProcAddress` for example).


## Adding New Backends
There is a _dummy_ backend that can be used as a template to add a new backend. It contains the full API any backend must satisfy. Backends pass no pointers or objects back to user code. [Handles](https://floooh.github.io/2018/06/17/handles-vs-pointers.html) are used for all renderer-specific objects. There are `Handles` and `HandledCache` structs built to make using handles seamless. The compantion `GameKit` project can be used to test new backends while developing them (see next section).


## GameKit Companion Project
`RenderKit` is just a pure backend render API abstraction layer. In order to get something on screen, it requires an OS window and a graphics context. The companion [`GameKit`](https://github.com/prime31/zig-gamekit) repository provides all of that and more. It has all the high-level abstractions needed to make fast, efficient 2D games. `GameKit` can be used to help with building new backends, as a standalone 2D framework or as inspiration for using `RenderKit` in your own projects.


## Usage
- clone the repository: `git clone https://github.com/prime31/zig-renderkit`
- in your projects build.zig, pass your `LibExeObjStep` to `addRenderKitToArtifact` in `RenderKit`s build.zig




#### Some interesting GL zig code used for inspiration

[ZGL](https://github.com/ziglibs/zgl/blob/master/zgl.zig)

[Oxid](https://github.com/dbandstra/oxid/blob/master/lib/gl.zig)

[didot](https://github.com/zenith391/didot)

[learnopengl](https://github.com/cshenton/learnopengl)

[minifb (Rust)](https://github.com/emoon/rust_minifb)

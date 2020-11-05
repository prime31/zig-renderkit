### zig-gl
Zig graphics backends with a 2D focus. If it doesn't make sense for 2D it won't be found here. OpenGL currently implemented along with higher level objects (mesh, dyanmic mesh, sprite batcher, multi-texture sprite batcher, triangle batcher) built on top of the generic renderer API. A small math lib with just the types required (Vec2, Color, 3x2 Matrix) is also included.

It should be fairly easy to add new backends for Metal, DirectX11, Vulkan using the interface laid out in the dummy renderer (empty implementation).


### Some other interesting GL zig code

[ZGL](https://github.com/ziglibs/zgl/blob/master/zgl.zig)

[Oxid](https://github.com/dbandstra/oxid/blob/master/lib/gl.zig)

[didot](https://github.com/zenith391/didot)

[learnopengl](https://github.com/cshenton/learnopengl)


Eventually can grab DX/Metal setup from here eventually for Metal backends
[minifb](https://github.com/emoon/rust_minifb)

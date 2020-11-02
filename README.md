### zig-gl
This repo is pretty much a hack job of code that was used to get Zig + SDL + OpenGL setup without needing an external function loader. Some code was grabbed from the repos below to get a jump start.

The main premise of the testing was to see if 2D batcher could be improved by binding multiple textures instead of flushing when a second texture is passed to it. The `batcher` example lets you play with the concept. The other examples are just from Learn OpenGL.


### Some other interesting GL zig code

[ZGL](https://github.com/ziglibs/zgl/blob/master/zgl.zig)
[Oxid](https://github.com/dbandstra/oxid/blob/master/lib/gl.zig)
[didot](https://github.com/zenith391/didot)
[learnopengl](https://github.com/cshenton/learnopengl)

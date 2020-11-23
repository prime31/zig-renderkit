# RenderKit Shader Compiler

```zig
const res = ShaderCompileStep.init(b, .{
    .shader = "shaders/shd.glsl",
    .additional_imports = &[_][]const u8{"usingnamespace @import(\"stuff\");"},
});

// override the float2 type, which defaults to [2]f32
res.float2_type = "math.Vec2";
exe.step.dependOn(&res.step);

// depending on the config passed to `ShaderCompileStep`, there may or may not be a package
if (res.package) |package| exe.addPackage(package);
```
const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("gl");

// var shader: ShaderProgram = undefined;
// var VAO: c_uint = undefined;

pub fn main() !void {
    try runner.run(null, render);
}

fn render() !void {
    var shader = try ShaderProgram.createFromFile(std.testing.allocator, "assets/shaders/1_3_shaders.vert", "assets/shaders/1_3_shaders.frag");

    const vertices = [_]f32{
        // positions      // colors
        0.5, -0.5, 0.0, 1.0, 0.0, 0.0, // bottom right
        -0.5, -0.5, 0.0, 0.0, 1.0, 0.0, // bottom left
        0.0, 0.5, 0.0, 0.0, 0.0, 1.0, // top
    };

    var VAO: c_uint = undefined;
    var VBO: c_uint = undefined;
    glGenVertexArrays(1, &VAO);
    defer glDeleteVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    defer glDeleteBuffers(1, &VBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * @sizeOf(f32), null);
    glEnableVertexAttribArray(0);

    // color attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * @sizeOf(f32), 3 * @sizeOf(f32));
    glEnableVertexAttribArray(1);

    while (!runner.pollEvents()) {
        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);

        shader.bind();
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);

        runner.swapWindow();
    }
}

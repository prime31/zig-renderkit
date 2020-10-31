const std = @import("std");
const runner = @import("runner");
const sdl = @import("sdl");
usingnamespace @import("stb");
usingnamespace @import("gl");

pub fn main() !void {
    try runner.run(null, render);
}

fn render() !void {
    var shader = try ShaderProgram.createFromFile(std.testing.allocator, "assets/shaders/1_4_textures.vert", "assets/shaders/1_4_textures.frag");

    // set up vertex data (and buffer(s)) and configure vertex attributes
    const vertices = [_]f32{
        // positions   // colors            // texture coords
        0.5, 0.5,      1.0, 0.0, 0.0,      1.0, 1.0, // top right
        0.5, -0.5,     0.0, 1.0, 0.0,      1.0, 0.0, // bottom right
        -0.5, -0.5,    0.0, 0.0, 1.0,      0.0, 0.0, // bottom left
        -0.5, 0.5,     1.0, 1.0, 0.0,      0.0, 1.0, // top left
    };
    const indices = [_]u32{
        0, 1, 3, // first triangle
        1, 2, 3, // second triangle
    };

    var VAO: c_uint = undefined;
    var VBO: c_uint = undefined;
    var EBO: c_uint = undefined;
    glGenVertexArrays(1, &VAO);
    defer glDeleteVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    defer glDeleteBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    defer glDeleteBuffers(1, &EBO);
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, indices.len * @sizeOf(u32), &indices, GL_STATIC_DRAW);

    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, vertices.len * @sizeOf(f32), &vertices, GL_STATIC_DRAW);

    // position attribute
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 7 * @sizeOf(f32), null);
    glEnableVertexAttribArray(0);

    // color attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 7 * @sizeOf(f32), 2 * @sizeOf(f32));
    glEnableVertexAttribArray(1);

    // texture coord attribute
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 7 * @sizeOf(f32), 5 * @sizeOf(f32));
    glEnableVertexAttribArray(2);


    var width: c_int = undefined;
    var height: c_int = undefined;
    var channels: c_int = undefined;
    stbi_set_flip_vertically_on_load(1); // tell stb_image.h to flip loaded texture's on the y-axis.

    // texture 1
    var tex1 = Texture.init();
    var data = stbi_load("assets/textures/container.png", &width, &height, &channels, 4);
    if (data != null) {
        tex1.setData(width, height, data);
        stbi_image_free(data);
    }

    // texture 2
    // load image, create texture and generate mipmaps
    var tex2 = Texture.init();
    data = stbi_load("assets/textures/awesomeface.png", &width, &height, &channels, 4);
    defer stbi_image_free(data);
    if (data != null) {
        tex2.setData(width, height, data);
    }

    shader.bind();
    glUniform1i(glGetUniformLocation(shader.id, "texture1"), 0);
    shader.setInt("texture2", 1);

    while (!runner.pollEvents()) {
        glClearColor(0.2, 0.3, 0.3, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);

        // bind textures on corresponding texture units
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, tex1.id);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, tex2.id);

        // render container
        shader.bind();
        glBindVertexArray(VAO);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, null);

        runner.swapWindow();
    }
}

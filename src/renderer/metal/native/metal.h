#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

enum TextureFilter_t {
    texture_filter_nearest,
    texture_filter_linear,
};

enum TextureWrap_t {
    texture_wrap_clamp,
    texture_wrap_repeat,
};

enum PixelFormat_t {
    pixel_format_rgba,
    pixel_format_stencil,
    pixel_format_depth_stencil,
};

enum Usage_t {
    usage_immutable,
    usage_dynamic,
    usage_stream,
};

enum BufferType_t {
    buffer_type_vertex,
    buffer_type_index,
};

enum VertexBufferUsage_t {
    vertex_buffer_usage_stream_draw,
    vertex_buffer_usage_static_draw,
    vertex_buffer_usage_dynamic_draw,
};

enum PrimitiveType_t {
    primitive_type_points,
    primitive_type_line_strip,
    primitive_type_lines,
    primitive_type_triangle_strip,
    primitive_type_triangles,
};

enum ElementType_t {
    element_type_u8,
    element_type_u16,
    element_type_u32,
};

enum CompareFunc_t {
    compre_func_never,
    compre_func_less,
    compre_func_equal,
    compre_func_less_equal,
    compre_func_greater,
    compre_func_not_equal,
    compre_func_greater_equal,
    compre_func_always,
};

enum StencilOp_t {
    stencil_op_keep,
    stencil_op_zero,
    stencil_op_replace,
    stencil_op_incr_clamp,
    stencil_op_decr_clamp,
    stencil_op_invert,
    stencil_op_incr_wrap,
    stencil_op_decr_wrap,
};

enum BlendFactor_t {
    blend_zero,
    blend_one,
    blend_src_color,
    blend_one_minus_src_color,
    blend_src_alpha,
    blend_one_minus_src_alpha,
    blend_dst_color,
    blend_one_minus_dst_color,
    blend_dst_alpha,
    blend_one_minus_dst_alpha,
    blend_src_alpha_saturated,
    blend_blend_color,
    blend_one_minus_blend_color,
    blend_blend_alpha,
    blend_one_minus_blend_alpha,
};

enum BlendOp_t {
    blend_op_add,
    blend_op_subtract,
    blend_op_reverse_subtract,
};

enum ClearAction_t {
    clear_action_clear,
    clear_action_dontcare,
    clear_action_load,
};

MTLLoadAction _mtl_load_action(enum ClearAction_t a) {
    switch (a) {
        case clear_action_clear:    return MTLLoadActionClear;
        case clear_action_dontcare: return MTLLoadActionDontCare;
        case clear_action_load:     return MTLLoadActionLoad;
        default: return (MTLLoadAction)0;
    }
}

enum ColorMask_t {
    color_mask_none,
    color_mask_r,
    color_mask_g,
    color_mask_b = 4,
    color_mask_a = 8,
    color_mask_rgb,
    color_mask_rgba = 15,
    color_mask_force_u32 = 2147483647,
};

typedef struct PoolSizes_t {
   uint8_t texture;
   uint8_t offscreen_pass;
   uint8_t buffers;
   uint8_t shaders;
} PoolSizes_t;

typedef struct _t {
   void* ca_layer;
} MetalSetup_t;

typedef struct RendererDesc_t {
   void* allocator;
   const void* (*getProcAddress)(uint8_t*);
   PoolSizes_t pool_sizes;
   MetalSetup_t metal;
} RendererDesc_t;

typedef struct ImageDesc_t {
   bool render_target;
   int32_t width;
   int32_t height;
   enum Usage_t usage;
   enum PixelFormat_t pixel_format;
   enum TextureFilter_t min_filter;
   enum TextureFilter_t mag_filter;
   enum TextureWrap_t wrap_u;
   enum TextureWrap_t wrap_v;
   uint8_t* content;
} ImageDesc_t;

typedef struct PassDesc_t {
   uint16_t color_img;
   uint16_t depth_stencil_img;
} PassDesc_t;

typedef struct ShaderDesc_t {
   uint8_t* vs;
   uint8_t* fs;
   uint8_t** images;
} ShaderDesc_t;

typedef struct Depth_t {
   bool enabled;
   enum CompareFunc_t compare_func;
} Depth_t;

typedef struct Stencil_t {
   bool enabled;
   enum StencilOp_t fail_op;
   enum StencilOp_t depth_fail_op;
   enum StencilOp_t pass_op;
   enum CompareFunc_t compare_func;
   uint8_t read_mask;
   uint8_t write_mask;
   uint8_t ref;
} Stencil_t;

typedef struct Blend_t {
   bool enabled;
   enum BlendFactor_t src_factor_rgb;
   enum BlendFactor_t dst_factor_rgb;
   enum BlendOp_t op_rgb;
   enum BlendFactor_t src_factor_alpha;
   enum BlendFactor_t dst_factor_alpha;
   enum BlendOp_t op_alpha;
   enum ColorMask_t color_write_mask;
   float color[4];
} Blend_t;

typedef struct RenderState_t {
   Depth_t depth;
   Stencil_t stencil;
   Blend_t blend;
   bool scissor;
} RenderState_t;

typedef struct ClearCommand_t {
   enum ClearAction_t color_action;
   float color[4];
   enum ClearAction_t stencil_action;
   uint8_t stencil;
   enum ClearAction_t depth_action;
   double depth;
} ClearCommand_t;


void metal_setup(RendererDesc_t desc);
void metal_shutdown();

void metal_set_render_state(RenderState_t arg0);
void metal_viewport(int arg0, int arg1, int arg2, int arg3);
void metal_scissor(int arg0, int arg1, int arg2, int arg3);

uint16_t metal_create_image(ImageDesc_t arg0);
void metal_destroy_image(uint16_t arg0);
void metal_update_image(uint16_t arg0, void* arg1);
void metal_bind_image(uint16_t arg0, uint32_t arg1);

uint16_t metal_create_pass(PassDesc_t desc);
void mmetal_destroy_pass(uint16_t pass);
void metal_begin_pass(uint16_t pass, ClearCommand_t clear, int w, int h);
void metal_end_pass();
void metal_commit_frame();

void metal_destroy_buffer(uint16_t arg0);
void metal_update_buffer(uint16_t arg0, void* arg1);

uint16_t metal_create_buffer_bindings(uint16_t arg0, uint16_t arg1);
void metal_destroy_buffer_bindings(uint16_t arg0);
void metal_draw_buffer_bindings(uint16_t arg0, int arg1);

uint16_t metal_create_shader(ShaderDesc_t arg0);
void metal_destroy_shader(uint16_t arg0);
void metal_use_shader(uint16_t arg0);
void metal_set_shader_uniform(uint16_t arg0, uint8_t* arg1, void* arg2);

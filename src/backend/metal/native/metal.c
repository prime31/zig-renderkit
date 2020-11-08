#if __has_feature(objc_arc) && !__has_feature(objc_arc_fields)
    #error "sokol_app.h requires __has_feature(objc_arc_field) if ARC is enabled (use a more recent compiler version)"
#endif

#include "metal.h"

enum {
    NUM_INFLIGHT_FRAMES = 1,
};

CAMetalLayer* layer;
id<MTLCommandQueue> cmd_queue;
id<MTLCommandBuffer> cmd_buffer;
id<MTLRenderCommandEncoder> cmd_encoder;
dispatch_semaphore_t render_semaphore;

bool in_pass = false;
bool pass_valid = false;

void metal_init(RendererDesc_t desc) {
    render_semaphore = dispatch_semaphore_create(NUM_INFLIGHT_FRAMES);
    layer = (__bridge CAMetalLayer*)desc.metal.ca_layer;
    layer.device = MTLCreateSystemDefaultDevice();
    layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

    cmd_queue = [layer.device newCommandQueue];
}

void metal_setup(RendererDesc_t desc) {
    printf("----- setup\n");
}

void metal_shutdown() {
    printf("----- shutdown\n");
}


void metal_setRenderState(RenderState_t arg0) {}
void metal_viewport(int arg0, int arg1, int arg2, int arg3) {}
void metal_scissor(int arg0, int arg1, int arg2, int arg3) {}
void metal_clear(ClearCommand_t arg0) {}

void metal_beginPass(uint16_t pass_index, ClearCommand_t clear, int w, int h) {
    // if this is the first pass in the frame, create a command buffer
    if (cmd_buffer == nil) {
        // block until the oldest frame in flight has finished
        dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);
        cmd_buffer = [cmd_queue commandBufferWithUnretainedReferences];
    }

    id<CAMetalDrawable> drawable = [layer nextDrawable];

    // initialize a render pass descriptor
    MTLRenderPassDescriptor *pass_desc = nil;
    if (pass_index > 0) { // offscreen render pass
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
    } else {
        // TODO: use cached RenderPassDescriptor
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
    }

    // default pass descriptor will not be valid if window is minimized
    if (pass_desc == nil) {
        pass_valid = false;
        return;
    }

    // setup pass descriptor for backbuffer or offscreen rendering
    if (pass_index > 0) {
    } else {
        // pass_desc.colorAttachments[0].texture = drawable.texture;
        pass_desc.colorAttachments[0].clearColor = MTLClearColorMake(clear.color[0], clear.color[1], clear.color[2], clear.color[3]);
        pass_desc.colorAttachments[0].loadAction  = _mtl_load_action(clear.color_action);
        pass_desc.depthAttachment.loadAction = _mtl_load_action(clear.depth_action);
        pass_desc.depthAttachment.clearDepth = clear.depth;
        pass_desc.stencilAttachment.loadAction = _mtl_load_action(clear.stencil_action);
        pass_desc.stencilAttachment.clearStencil = clear.stencil;
    }

    // create a render command encoder, this might return nil if window is minimized
    cmd_encoder = [cmd_buffer renderCommandEncoderWithDescriptor:pass_desc];
    if (cmd_encoder == nil) {
        pass_valid = false;
        return;
    }
}

void metal_endPass() {
    in_pass = false;
    pass_valid = false;
    if (cmd_encoder != nil) {
        [cmd_encoder endEncoding];
        cmd_encoder = nil;
    }
}

void metal_commit_frame() {
    assert(!pass_valid);
    assert(cmd_encoder == nil);
    assert(cmd_buffer != nil);

    // present, commit and signal semaphore when done
    id<CAMetalDrawable> drawable = [layer nextDrawable];
    [cmd_buffer presentDrawable:drawable];
    [cmd_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        dispatch_semaphore_signal(render_semaphore);
    }];
    [cmd_buffer commit];
    cmd_buffer = nil;
}

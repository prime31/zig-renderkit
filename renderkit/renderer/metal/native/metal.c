
#if __has_feature(objc_arc) && !__has_feature(objc_arc_fields)
    #error "Metal requires __has_feature(objc_arc_field) if ARC is enabled (use a more recent compiler version)"
#endif

#include "metal.h"

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

RKMetalBackend* mtl_backend;
CAMetalLayer* layer;
id<MTLCommandQueue> cmd_queue;
id<MTLCommandBuffer> cmd_buffer;
id<MTLRenderCommandEncoder> cmd_encoder;
id<CAMetalDrawable> cur_drawable;
dispatch_semaphore_t render_semaphore;

bool origin_top_left = true;
bool in_pass = false;
bool pass_valid = false;
int cur_width;
int cur_height;
uint32_t frame_index;

// setup
void metal_setup(RendererDesc_t desc) {
    mtl_backend = [[RKMetalBackend alloc] initWithRendererDesc:desc];

	render_semaphore = dispatch_semaphore_create(NUM_INFLIGHT_FRAMES);
	layer = (__bridge CAMetalLayer*)desc.metal.ca_layer;
	layer.device = MTLCreateSystemDefaultDevice();
	layer.pixelFormat = MTLPixelFormatBGRA8Unorm;

	cmd_queue = [layer.device newCommandQueue];
}

void metal_shutdown() {
	printf("----- shutdown\n");

	// wait for the last frame to finish
	for (int i = 0; i < NUM_INFLIGHT_FRAMES; i++)
		dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);

	// semaphore must be "relinquished" before destruction
	for (int i = 0; i < NUM_INFLIGHT_FRAMES; i++)
		dispatch_semaphore_signal(render_semaphore);

    mtl_backend = nil;
	cmd_buffer = nil;
	cmd_encoder = nil;
}


// render state
void metal_set_render_state(RenderState_t state) {
    printf("metal_set_render_state\n");
    assert(!in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    [cmd_encoder setBlendColorRed:state.blend.color[0] green: state.blend.color[1] blue: state.blend.color[2] alpha: state.blend.color[3]];
    [cmd_encoder setStencilReferenceValue:state.stencil.ref];
    // [cmd_encoder setRenderPipelineState:_sg_mtl_id(pip->mtl.rps)];
    // [cmd_encoder setDepthStencilState:_sg_mtl_id(pip->mtl.dss)];
}

void metal_viewport(int x, int y, int w, int h) {
    printf("metal_viewport\n");
    assert(in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    MTLViewport vp;
    vp.originX = (double) x;
    vp.originY = (double) (origin_top_left ? y : (cur_height - (y + h)));
    vp.width   = (double) w;
    vp.height  = (double) h;
    vp.znear   = 0.0;
    vp.zfar    = 1.0;
    [cmd_encoder setViewport:vp];
}

void metal_scissor(int x, int y, int w, int h) {
    printf("metal_scissor\n");
    assert(in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    // clip against framebuffer rect
    x = min(max(0, x), cur_width - 1);
    y = min(max(0, y), cur_height - 1);
    if ((x + w) > cur_width) {
        w = cur_width - x;
    }
    if ((y + h) > cur_height) {
        h = cur_height - y;
    }
    w = max(w, 1);
    h = max(h, 1);

    MTLScissorRect r;
    r.x = x;
    r.y = origin_top_left ? y : (cur_height - (y + h));
    r.width = w;
    r.height = h;
    [cmd_encoder setScissorRect:r];
}


// images
_mtl_image* metal_create_image(ImageDesc_t desc) {
    MTLTextureDescriptor* mtl_desc = [[MTLTextureDescriptor alloc] init];
    mtl_desc.textureType = MTLTextureType2D;
    mtl_desc.pixelFormat = MTLPixelFormatRGBA8Unorm;
    mtl_desc.width = desc.width;
    mtl_desc.height = desc.height;
    mtl_desc.depth = 1;
    mtl_desc.arrayLength = 1;
    mtl_desc.usage = MTLTextureUsageShaderRead;
    if (desc.usage != usage_immutable)
        mtl_desc.cpuCacheMode = MTLCPUCacheModeWriteCombined;
    mtl_desc.resourceOptions = MTLResourceStorageModeManaged;
    mtl_desc.storageMode = MTLStorageModeManaged;

	// initialize MTLTextureDescritor with rendertarget attributes
	if (desc.render_target) {
		// reset the cpuCacheMode to 'default'
		mtl_desc.cpuCacheMode = MTLCPUCacheModeDefaultCache;
		// render targets are only visible to the GPU
		mtl_desc.resourceOptions = MTLResourceStorageModePrivate;
		mtl_desc.storageMode = MTLStorageModePrivate;
		// render targets are shader-readable
		mtl_desc.usage = MTLTextureUsageShaderRead | MTLTextureUsageRenderTarget;
	}

	_mtl_image img;

    // special case depth-stencil-buffer
    if (desc.pixel_format == pixel_format_depth_stencil || desc.pixel_format == pixel_format_stencil) {
        assert(desc.render_target);

        id<MTLTexture> tex = [layer.device newTextureWithDescriptor:mtl_desc];
		RK_ASSERT(tex != nil);
        img.depth_tex = [mtl_backend addResource:tex];
		RK_UNREACHABLE;
    } else {
        id<MTLTexture> tex = [layer.device newTextureWithDescriptor:mtl_desc];
		if (desc.usage == usage_immutable && !desc.render_target) {
			MTLRegion region = MTLRegionMake2D(0, 0, desc.width, desc.height);
			[tex replaceRegion:region
                  mipmapLevel:0
                    withBytes:desc.content
                  bytesPerRow:desc.width * 4];
		}

        // create (possibly shared) sampler state
        img.sampler_state = [mtl_backend createSampler:layer.device withImageDesc:&desc];
        img.tex = [mtl_backend addResource:tex];
    }

    // HACK: for some reason zig doesnt like getting passed the struct by value
	_mtl_image* img_ptr = malloc(sizeof(_mtl_image));
    memset(img_ptr, 0, sizeof(_mtl_image));
    *img_ptr = img;
    printf("metal_destroy_image\n");

	return img_ptr;
}

void metal_destroy_image(_mtl_image* img) {
	printf("metal_destroy_image\n");
    // it's valid to call release resource with a 'null resource'
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->tex];
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->depth_tex];
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->stencil_tex];
    free(img);
}

void metal_update_image(_mtl_image* img, void* data) {
    printf("metal_update_image\n");
}


// passes

void metal_begin_pass(uint16_t pass_index, ClearCommand_t clear, int w, int h) {
    in_pass = true;
    cur_width = w;
    cur_height = h;

    // if this is the first pass in the frame, create a command buffer
    if (cmd_buffer == nil) {
        // block until the oldest frame in flight has finished
        dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);
        cmd_buffer = [cmd_queue commandBufferWithUnretainedReferences];
    }

    // initialize a render pass descriptor
    MTLRenderPassDescriptor *pass_desc = nil;
    if (pass_index > 0) { // offscreen render pass
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
    } else {
        pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];
        // only do this once per frame. a pass to the framebuffer can be done multiple times in a frame.
        if (cur_drawable == nil)
            cur_drawable = [layer nextDrawable];
        pass_desc.colorAttachments[0].texture = cur_drawable.texture;
    }

    // default pass descriptor will not be valid if window is minimized
    if (pass_desc == nil) {
        pass_valid = false;
        return;
    }
    pass_valid = true;

    // setup pass descriptor for backbuffer or offscreen rendering
    if (pass_index > 0) {
    } else {
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

void metal_end_pass() {
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
    [cmd_buffer presentDrawable:cur_drawable];
    [cmd_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        dispatch_semaphore_signal(render_semaphore);
    }];
    [cmd_buffer commit];
    
    // garbage-collect resources pending for release
    [mtl_backend garbageCollectResources:frame_index];
    frame_index++;
    
    cmd_buffer = nil;
    cur_drawable = nil;
}


// buffers
_mtl_buffer* metal_create_buffer(MtlBufferDesc_T desc) {
    printf("metal_create_buffer\n");
    _mtl_buffer* buffer = malloc(sizeof(_mtl_buffer));
    memset(buffer, 0, sizeof(_mtl_buffer));
    
    // TODO: multiple buffers when they are mutable
    MTLResourceOptions mtl_options = _mtl_buffer_resource_options(desc.usage);
    id<MTLBuffer> mtl_buf;
    if (desc.usage == usage_immutable)
        mtl_buf = [layer.device newBufferWithBytes:desc.content length:desc.size options:mtl_options];
    else
        mtl_buf = [layer.device newBufferWithLength:desc.size options:mtl_options];
    buffer->buffer = [mtl_backend addResource:mtl_buf];
    
    return buffer;
}

void metal_destroy_buffer(_mtl_buffer* buffer) {
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:buffer->buffer];
    free(buffer);
}

void metal_update_buffer(_mtl_buffer* buffer, const void* data, uint32_t data_size) {
    printf("metal_update_buffer\n");
    __unsafe_unretained id<MTLBuffer> mtl_buf = mtl_backend.objectPool[buffer->buffer];
    void* dst_ptr = [mtl_buf contents];
    memcpy(dst_ptr, data, data_size);
    [mtl_buf didModifyRange:NSMakeRange(0, data_size)];
}


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

bool in_pass = false;
bool pass_valid = false;
int cur_width;
int cur_height;
uint32_t frame_index = 1;

// pipeline state
_mtl_shader* cur_shader;
RenderState_t cur_render_state;
MtlBufferBindings_t cur_bindings;
id<MTLRenderPipelineState> pipeline;

// setup
void mtl_setup(RendererDesc_t desc) {
    mtl_backend = [[RKMetalBackend alloc] initWithRendererDesc:desc];

	render_semaphore = dispatch_semaphore_create(NUM_INFLIGHT_FRAMES);
	layer = (__bridge CAMetalLayer*)desc.metal.ca_layer;
	layer.device = MTLCreateSystemDefaultDevice();
	layer.pixelFormat = MTLPixelFormatBGRA8Unorm;
	// layer.displaySyncEnabled = NO; // disables vsunc

	cmd_queue = [layer.device newCommandQueue];
}

void mtl_shutdown() {
	printf("----- metal_shutdown\n");

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
void mtl_set_render_state(RenderState_t state) {
    printf("metal_set_render_state\n");
    assert(!in_pass);
	cur_render_state = state;
}

void mtl_viewport(int x, int y, int w, int h) {
    assert(in_pass);
    if (!pass_valid) return;
    assert(cmd_encoder != nil);

    MTLViewport vp;
    vp.originX = (double) x;
    vp.originY = (double) y;
    vp.width   = (double) w;
    vp.height  = (double) h;
    vp.znear   = 0.0;
    vp.zfar    = 1.0;
    [cmd_encoder setViewport:vp];
}

void mtl_scissor(int x, int y, int w, int h) {
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
    r.y = y;
    r.width = w;
    r.height = h;
    [cmd_encoder setScissorRect:r];
}


// images
_mtl_image* mtl_create_image(ImageDesc_t desc) {
    _mtl_image* img = malloc(sizeof(_mtl_image));
    memset(img, 0, sizeof(_mtl_image));
    
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
        mtl_desc.pixelFormat = MTLPixelFormatBGRA8Unorm;
	}

	img->width = desc.width;
	img->height = desc.height;

    // special case depth-stencil-buffer
    if (desc.pixel_format == pixel_format_depth_stencil || desc.pixel_format == pixel_format_stencil) {
        assert(desc.render_target);

        id<MTLTexture> tex = [layer.device newTextureWithDescriptor:mtl_desc];
		RK_ASSERT(tex != nil);
        img->depth_tex = [mtl_backend addResource:tex];
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
        img->sampler_state = [mtl_backend createSampler:layer.device withImageDesc:&desc];
        img->tex = [mtl_backend addResource:tex];
    }
    
    return img;
}

void mtl_destroy_image(_mtl_image* img) {
	printf("metal_destroy_image\n");
    // it's valid to call release resource with a 'null resource'
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->tex];
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->depth_tex];
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:img->stencil_tex];
    free(img);
}

void mtl_update_image(_mtl_image* img, void* data) {
    printf("metal_update_image\n");
	__unsafe_unretained id<MTLTexture> mtl_tex = mtl_backend.objectPool[img->tex];
	MTLRegion region = MTLRegionMake2D(0, 0, img->width, img->height);
	[mtl_tex replaceRegion:region mipmapLevel:0 withBytes:data bytesPerRow:img->width * 4];
}


// passes
_mtl_pass* mtl_create_pass(PassDesc_t desc) {
    _mtl_pass* pass = malloc(sizeof(_mtl_pass));
    memset(pass, 0, sizeof(_mtl_pass));
    
	pass->color_tex = desc.color_img;
	pass->stencil_tex = desc.depth_stencil_img;
    return pass;
}

void mtl_destroy_pass(_mtl_pass* pass) {
	free(pass);
}

void mtl_begin_pass(_mtl_pass* pass, ClearCommand_t clear, int w, int h) {
    in_pass = true;
	cur_width = pass ? pass->color_tex->width : w;
	cur_height = pass ? pass->color_tex->height : h;

    // if this is the first pass in the frame, create a command buffer
    if (cmd_buffer == nil) {
        // block until the oldest frame in flight has finished
        dispatch_semaphore_wait(render_semaphore, DISPATCH_TIME_FOREVER);
        cmd_buffer = [cmd_queue commandBufferWithUnretainedReferences];
    }

    // initialize a render pass descriptor
	MTLRenderPassDescriptor* pass_desc = [MTLRenderPassDescriptor renderPassDescriptor];

    // default pass descriptor will not be valid if window is minimized
    if (pass_desc == nil) {
        pass_valid = false;
        return;
    }
    pass_valid = true;

    // setup pass descriptor for backbuffer or offscreen rendering
    if (pass) {
		pass_desc.colorAttachments[0].texture = mtl_backend.objectPool[pass->color_tex->tex];
		pass_desc.colorAttachments[0].storeAction = MTLStoreActionStore;

		if (pass->stencil_tex) {
			pass_desc.colorAttachments[0].texture = mtl_backend.objectPool[pass->stencil_tex->tex];
		}
    } else {
		// only do this once per frame. a pass to the framebuffer can be done multiple times in a frame.
		if (cur_drawable == nil)
			cur_drawable = [layer nextDrawable];
		pass_desc.colorAttachments[0].texture = cur_drawable.texture;
    }

	// common pass descriptor setup
	pass_desc.colorAttachments[0].clearColor = MTLClearColorMake(clear.color[0], clear.color[1], clear.color[2], clear.color[3]);
	pass_desc.colorAttachments[0].loadAction  = _mtl_load_action(clear.color_action);
	pass_desc.depthAttachment.loadAction = _mtl_load_action(clear.depth_action);
	pass_desc.depthAttachment.clearDepth = clear.depth;
	pass_desc.stencilAttachment.loadAction = _mtl_load_action(clear.stencil_action);
	pass_desc.stencilAttachment.clearStencil = clear.stencil;

    // create a render command encoder, this might return nil if window is minimized
    cmd_encoder = [cmd_buffer renderCommandEncoderWithDescriptor:pass_desc];
    if (cmd_encoder == nil) {
        pass_valid = false;
        return;
    }

	mtl_viewport(0, 0, cur_width, cur_height);

	// setup our render state
	[cmd_encoder setBlendColorRed:cur_render_state.blend.color[0] green: cur_render_state.blend.color[1] blue: cur_render_state.blend.color[2] alpha: cur_render_state.blend.color[3]];
	[cmd_encoder setStencilReferenceValue:cur_render_state.stencil.ref];
	[cmd_encoder setCullMode:MTLCullModeNone];
}

void mtl_end_pass() {
    in_pass = false;
    pass_valid = false;
    if (cmd_encoder != nil) {
        [cmd_encoder endEncoding];
        cmd_encoder = nil;
    }
}

void mtl_commit_frame() {
	RK_ASSERT(!in_pass);
    RK_ASSERT(!pass_valid);
	RK_ASSERT(cmd_encoder == nil);
	RK_ASSERT(cmd_buffer != nil);

    // present, commit and signal semaphore when done
    [cmd_buffer presentDrawable:cur_drawable];

	__block dispatch_semaphore_t block_sema = render_semaphore;
    [cmd_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
        dispatch_semaphore_signal(block_sema);
    }];
    [cmd_buffer commit];

    // garbage-collect resources pending for release
    [mtl_backend garbageCollectResources:frame_index];
    frame_index++;

    cmd_buffer = nil;
    cur_drawable = nil;
}


// buffers
_mtl_buffer* mtl_create_buffer(MtlBufferDesc_T desc) {
    printf("metal_create_buffer\n");
    _mtl_buffer* buffer = malloc(sizeof(_mtl_buffer));
    memset(buffer, 0, sizeof(_mtl_buffer));
    
    buffer->size = (int)desc.size;

    // store off some data we will need for the pipeline later
    if (desc.type == buffer_type_vertex) {
        for (int i = 0; i < 4; i++) {
            buffer->vertex_layout[i].stride = desc.vertex_layout[i].stride;
            buffer->vertex_layout[i].step_func = _mtl_step_function(desc.vertex_layout[i].step_func);
        }

        for (int i = 0; i < 8; i++) {
            buffer->vertex_attrs[i].format = _mtl_vertex_format(desc.vertex_attrs[i].format);
            buffer->vertex_attrs[i].offset = desc.vertex_attrs[i].offset;
        }
	} else {
		buffer->index_type = _mtl_index_type(desc.index_type);
	}

    // TODO: support multiple in-flight buffers when they are mutable
    MTLResourceOptions mtl_options = _mtl_buffer_resource_options(desc.usage);
    id<MTLBuffer> mtl_buf;
    if (desc.usage == usage_immutable)
        mtl_buf = [layer.device newBufferWithBytes:desc.content length:desc.size options:mtl_options];
    else
        mtl_buf = [layer.device newBufferWithLength:desc.size options:mtl_options];
    buffer->buffer = [mtl_backend addResource:mtl_buf];
    
    return buffer;
}

void mtl_destroy_buffer(_mtl_buffer* buffer) {
    printf("metal_destroy_buffer\n");
    [mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:buffer->buffer];
    free(buffer);
}

void mtl_update_buffer(_mtl_buffer* buffer, const void* data, uint32_t num_bytes) {
    RK_ASSERT(num_bytes <= buffer->size);
    // only one update allowed per buffer and frame
    RK_ASSERT(buffer->update_frame_index != frame_index);
    // update and append on same buffer in same frame not allowed
    RK_ASSERT(buffer->append_frame_index != frame_index);
    
    if (++buffer->active_slot >= buffer->num_slots)
        buffer->active_slot = 0;
    
    __unsafe_unretained id<MTLBuffer> mtl_buf = mtl_backend.objectPool[buffer->buffer];
    void* dst_ptr = [mtl_buf contents];
    memcpy(dst_ptr, data, num_bytes);
    [mtl_buf didModifyRange:NSMakeRange(0, num_bytes)];
    
    buffer->update_frame_index = frame_index;
}

// this is the workhorse for buffer appends, called by mtl_append_buffer after it does its validation and bookkeeping
uint32_t _mtl_append_buffer(_mtl_buffer* buffer, const void* data, uint32_t num_bytes, bool new_frame) {
    // if this is our first append this frame rotate the active slot
    if (new_frame) {
        if (++buffer->active_slot >= buffer->num_slots)
            buffer->active_slot = 0;
    }
    
    __unsafe_unretained id<MTLBuffer> mtl_buf = mtl_backend.objectPool[buffer->buffer];
    uint8_t* dst_ptr = (uint8_t*) [mtl_buf contents];
    dst_ptr += buffer->append_pos;
    memcpy(dst_ptr, data, num_bytes);
    [mtl_buf didModifyRange:NSMakeRange(buffer->append_pos, num_bytes)];

    return num_bytes;
}

int mtl_append_buffer(_mtl_buffer* buffer, const void* data, uint32_t num_bytes) {
    RK_ASSERT(num_bytes <= buffer->size);
    
    // rewind append cursor in a new frame
    if (buffer->append_frame_index != frame_index) {
        buffer->append_pos = 0;
        buffer->append_overflow = false;
    }
    
    if ((buffer->append_pos + num_bytes) > buffer->size)
        buffer->append_overflow = true;
    
    const int start_pos = buffer->append_pos;
    if (!buffer->append_overflow && (num_bytes > 0)) {
        // update and append on same buffer in same frame not allowed
        RK_ASSERT(buffer->update_frame_index != frame_index);
        uint32_t copied_num_bytes = _mtl_append_buffer(buffer, data, num_bytes, buffer->append_frame_index != frame_index);
        buffer->append_pos += copied_num_bytes;
        buffer->append_frame_index = frame_index;
    }
    
    return start_pos;
}


// shaders
_mtl_shader* mtl_create_shader(ShaderDesc_t desc) {
    _mtl_shader* shader = malloc(sizeof(_mtl_shader));
    memset(shader, 0, sizeof(_mtl_shader));
    
	// create metal libray objects and lookup entry functions
	NSError* err = NULL;
	id<MTLLibrary> vs_lib = [layer.device newLibraryWithSource:[NSString stringWithUTF8String:desc.vs]
													  options:nil
														error:&err];
	if (err) {
		NSLog(@"failed to compile vs library: %@", err.localizedDescription);
		return NULL;
	}

	err = NULL;
	id<MTLLibrary> fs_lib = [layer.device newLibraryWithSource:[NSString stringWithUTF8String:desc.fs]
													  options:nil
														error:&err];
	if (err) {
		NSLog(@"failed to compile vs library: %@", err.localizedDescription);
        return NULL;
	}

	id<MTLFunction> vs_func = [vs_lib newFunctionWithName:@"_main"];
	id<MTLFunction> fs_func = [fs_lib newFunctionWithName:@"_main"];

	if (vs_func == nil) {
		NSLog(@"failed to location vs function");
        return NULL;
	}

	if (fs_func == nil) {
		NSLog(@"failed to location vs function");
        return NULL;
	}

	shader->vs_lib  = [mtl_backend addResource:vs_lib];
	shader->fs_lib  = [mtl_backend addResource:fs_lib];
	shader->vs_func = [mtl_backend addResource:vs_func];
	shader->fs_func = [mtl_backend addResource:fs_func];
    
    return shader;
}

void mtl_destroy_shader(_mtl_shader* shader) {
	printf("metal_destroy_shader\n");
	[mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:shader->vs_lib];
	[mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:shader->fs_lib];
	[mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:shader->vs_func];
	[mtl_backend releaseResourceWithFrameIndex:frame_index slotIndex:shader->fs_func];

    // TODO: destroy all Pipelines that use this shader
    free(shader);
}

void mtl_use_shader(_mtl_shader* shader) {
    cur_shader = shader;
}

void mtl_set_shader_uniform(_mtl_shader* shader, uint8_t* arg1, void* arg2) {

}


// bindings and draw
void mtl_apply_bindings(MtlBufferBindings_t bindings) {
    cur_bindings = bindings;

    if (pipeline == nil) {
        // TODO: this needs a proper home and proper caching
        // Graphics Pipeline
        MTLRenderPipelineDescriptor* pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
        pipelineStateDescriptor.label = @"Sprite Pipeline";
        pipelineStateDescriptor.vertexFunction = mtl_backend.objectPool[cur_shader->vs_func];
        pipelineStateDescriptor.fragmentFunction = mtl_backend.objectPool[cur_shader->fs_func];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = layer.pixelFormat;
		pipelineStateDescriptor.colorAttachments[0].writeMask = _mtl_color_write_mask(cur_render_state.blend.color_write_mask);
		pipelineStateDescriptor.colorAttachments[0].blendingEnabled = cur_render_state.blend.enabled;
		pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = _mtl_blend_op(cur_render_state.blend.op_alpha);
		pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = _mtl_blend_op(cur_render_state.blend.op_rgb);
		pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = _mtl_blend_factor(cur_render_state.blend.dst_factor_alpha);
		pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = _mtl_blend_factor(cur_render_state.blend.dst_factor_rgb);
		pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = _mtl_blend_factor(cur_render_state.blend.src_factor_alpha);
		pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = _mtl_blend_factor(cur_render_state.blend.src_factor_rgb);


        // preprare the MTLVertexDescriptor
        MTLVertexDescriptor* vertexDesc = [MTLVertexDescriptor vertexDescriptor];

        int attr_index = 0;
        for (int i = 0; i < 4; i++) {
            if (bindings.vertex_buffers[i] == NULL) break;
            _mtl_buffer* buff = bindings.vertex_buffers[i];

            // attributes
            for (int j = 0; j < 8; j++) {
                mtl_vertex_attribute_t attr = buff->vertex_attrs[j];
                // an offset of 0 for an attribute other than the first indicates we are done
                if (j > 0 && attr.offset == 0) break;

                vertexDesc.attributes[attr_index].format = attr.format;
                vertexDesc.attributes[attr_index].offset = attr.offset;
                vertexDesc.attributes[attr_index].bufferIndex = i;

                attr_index++;
            }

            // layout
            for (int j = 0; j < 4; j++) {
                mtl_vertex_layout_t layout = buff->vertex_layout[j];
                if (layout.stride == 0) break;

                vertexDesc.layouts[j].stepFunction = layout.step_func;
                vertexDesc.layouts[j].stride = layout.stride;
            }
        }

        pipelineStateDescriptor.vertexDescriptor = vertexDesc;

        // Create Pipeline State Object
        NSError* error = nil;
        id<MTLRenderPipelineState> pipelineState = [layer.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];

        if (error) {
            NSLog(@"Failed to created pipeline state, error %@", error);
            return;
        }

        pipeline = pipelineState;
    }

    [cmd_encoder setRenderPipelineState:pipeline];

    // bind vertex buffers
    for (int i = 0; i < 4; i++) {
        if (bindings.vertex_buffers[i] == NULL) break;
        [cmd_encoder setVertexBuffer:mtl_backend.objectPool[bindings.vertex_buffers[i]->buffer] offset:0 atIndex:0];
    }

    // set textures
    for (int i = 0; i < 8; i++) {
        if (bindings.images[i] == NULL) break;
        RK_ASSERT(bindings.images[i]->sampler_state != 0);
        [cmd_encoder setFragmentTexture:mtl_backend.objectPool[bindings.images[i]->tex] atIndex:i];
        [cmd_encoder setFragmentSamplerState:mtl_backend.objectPool[bindings.images[i]->sampler_state] atIndex:i];
    }

    [cmd_encoder setCullMode:MTLCullModeNone];
}

void mtl_draw(int base_element, int element_count, int instance_count) {
	[cmd_encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
							indexCount:element_count
							 indexType:cur_bindings.index_buffer->index_type
						   indexBuffer:mtl_backend.objectPool[cur_bindings.index_buffer->buffer]
					 indexBufferOffset:0
						 instanceCount:1];
}

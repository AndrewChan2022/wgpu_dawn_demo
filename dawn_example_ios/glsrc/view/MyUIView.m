//
//  MyUIView.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyUIView.h"
#import "GLESUtils.h"
#import "MyContext.h"
#import "MyQuadMesh.h"
#import "MyTriangleMesh.h"
#import "MyRenderPass.h"
#import "MyRenderTarget.h"
#import "MyShaders.h"
#import "MyTexture.h"
#import "MyWGPUPass.h"

@interface MyUIView () {
    
    // render
    MyTriangleMesh* _triangle;
    MyRenderPass* _renderpass;
    MyWGPUPass* _wgpupass;
    MyRenderTarget* _triangleTarget;
    
    // present
    MyQuadMesh* _quad;
    MyRenderPass* _presentpass;
    MyRenderTarget* _canvas;
    
    MyTexture* _texture;
    MyTexture* _texture2;
    
    
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    
}
@property (nonatomic, retain)NSTimer* timer;

@end

@implementation MyUIView

+ (Class)layerClass {
    // 只有 [CAEAGLLayer class] 类型的 layer 才支持在其上描绘 OpenGL 内容。
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _context = MyContext.shared.context;
        
        _eaglLayer = (CAEAGLLayer*) self.layer;
        _eaglLayer.opaque = YES;
        
        // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
        _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        [self setupRender];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self mainloop];
        }];
    }

    return self;
}

#pragma mark - init
-(void)setupRender {
    
    
    CAEAGLLayer* layer = (CAEAGLLayer*)self.layer;
    
    [MyContext.shared runSynchronouslyOnVideoProcessingQueue:^{
        [MyContext.shared useAsCurrentContext];
        
        // texture
        uint8_t* data = malloc(4 * 1024 * 1024);
        for (size_t i = 0; i < 4 * 1024 * 1024; ++i) {
            data[i] = (uint8_t)(i / (1024 * 4) % 253);
        }
        _texture2 = [[MyTexture alloc] initWithWidth:1024 height:1024 data:(void*)data];
        free(data);
        //UIImage* img2 = [UIImage imageNamed:@"girl.jpg"];
        //_texture = [[MyTexture alloc] initWithImage:img2.CGImage needMipmap:false];
        
        // renderpass
        _triangle = [[MyTriangleMesh alloc] init];
        _triangle.map = _texture2;
        _renderpass = [[MyRenderPass alloc] initWithVS:[MyShaders getVS] fs:[MyShaders getFSWithTexture]];
        _wgpupass = [[MyWGPUPass alloc] init];
        _triangleTarget = [[MyRenderTarget alloc] initWithWidth:layer.bounds.size.width height:layer.bounds.size.height];
        
        // presentpass
        _quad = [[MyQuadMesh alloc] init];
        _quad.map = _triangleTarget.texture;
        _presentpass = [[MyRenderPass alloc] initWithVS:[MyShaders getVS] fs:[MyShaders getPresentFSWithTexture]];
        _canvas = [[MyRenderTarget alloc] initWithDrawable:layer];
        
    }];
}

#pragma mark - per frame render
-(void)mainloop {
    [self render];
}
- (void)render {
    
    NSLog(@"...");
    
    [MyContext.shared runSynchronouslyOnVideoProcessingQueue:^{
        [MyContext.shared useAsCurrentContext];
    
        //CAEAGLLayer* layer = (CAEAGLLayer*)self.layer;
        //[self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
        
        //glClearColor(0, 1.0, 0, 1.0);
        //glClear(GL_COLOR_BUFFER_BIT);

#define USE_WGPU
        
#ifdef USE_WGPU
        [_wgpupass drawWithMesh:_triangle renderTarget:_triangleTarget];
        _quad.map = [_wgpupass getRenderTexture];
#else
        [_renderpass drawWithMesh:_triangle renderTarget:_triangleTarget];
        _quad.map = _triangleTarget.texture;
#endif
        
        
        
        [_presentpass drawWithMesh:_quad renderTarget:_canvas];
        glBindRenderbuffer(GL_RENDERBUFFER, _canvas.colorRenderBuffer);
        [_context presentRenderbuffer:GL_RENDERBUFFER];
        
    }];
}


@end

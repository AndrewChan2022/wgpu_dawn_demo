//
//  MyWGPUPass.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyWGPUPass.h"
#import "MyContext.h"
#import "GLESUtils.h"
#import "MyBuffer.h"
#import "MyBaseUniforms.h"
#import "MyTexture.h"
#import "MyWGPUPassImp.h"
#import <memory>

@interface MyWGPUPass () {
    std::shared_ptr<MyWGPUPassImp> _wgpupassimp;
    
}
@end

@implementation MyWGPUPass


#pragma mark - init
- (instancetype)init {
    self = [super init];
    if (self) {
        _wgpupassimp = std::make_shared<MyWGPUPassImp>();
        _wgpupassimp->init();
    }
    return self;
}

#pragma mark - draw

-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget {
    NSLog(@"...");
    _wgpupassimp->frame();
}

-(MyTexture*)getRenderTexture {
    int tid = _wgpupassimp->getTextureId();
    MyTexture* texture = [[MyTexture alloc] initWithTexture:(GLuint)tid];
    return texture;
}

@end

//
//  MyWGPUPass.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyQuadMesh.h"
#import "MyRenderTarget.h"
#import "MyBasePass.h"
#import "MyTexture.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBaseUniforms;
@class MyBaseMesh;

@interface MyWGPUPass : MyBasePass

- (instancetype)init;
//- (instancetype)initWithRenderTarget:(MyRenderTarget*)renderTarget;
-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget;

-(MyTexture*)getRenderTexture;

@end

NS_ASSUME_NONNULL_END




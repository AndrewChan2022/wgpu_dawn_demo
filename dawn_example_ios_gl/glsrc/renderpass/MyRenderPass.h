//
//  MyRenderPass.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyQuadMesh.h"
#import "MyRenderTarget.h"
#import "MyBasePass.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBaseUniforms;
@class MyBaseMesh;
@interface MyRenderPass : MyBasePass

- (instancetype)initWithVSPath:(NSString*)vspath fspath:(NSString*)fspath;
- (instancetype)initWithVS:(NSString*)vs fs:(NSString*)fs;
-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget;
-(void)setActive;

@end

NS_ASSUME_NONNULL_END




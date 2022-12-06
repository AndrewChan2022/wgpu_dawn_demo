//
//  MyBasePass.h
//  Ch7HelloComputerpass
//
//  Created by chenkai on 2019/12/22.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyQuadMesh.h"
#import "MyRenderTarget.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBaseUniforms;
@class MyBaseMesh;

@interface MyBasePass : NSObject

- (instancetype)initWithVSPath:(NSString*)vspath fspath:(NSString*)fspath;
- (instancetype)initWithVS:(NSString*)vs fs:(NSString*)fs;
-(void)createProgramGetSlot:(NSString*)vspath fspath:(NSString*)fspath;
-(void)createProgramGetSlot:(NSString*)vs fs:(NSString*)fs;
-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget;
-(void)setActive;

@property (nonatomic, strong)MyBaseUniforms* uniforms;
@property (nonatomic, assign)GLuint programId;


@end

NS_ASSUME_NONNULL_END

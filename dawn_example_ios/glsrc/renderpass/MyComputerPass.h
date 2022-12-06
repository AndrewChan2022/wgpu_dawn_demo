//
//  MyComputerPass.h
//  Ch7HelloComputerpass
//
//  Created by chenkai on 2019/12/22.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyBasePass.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBaseUniforms;
@class MyBaseMesh;

@interface MyComputerPass : MyBasePass

- (instancetype)initWithVSPath:(NSString*)vspath fspath:(NSString*)fspath;
- (instancetype)initWithVS:(NSString*)vs fs:(NSString*)fs;
-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget;
-(void)setActive;

@end

NS_ASSUME_NONNULL_END

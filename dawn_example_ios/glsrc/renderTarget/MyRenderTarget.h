//
//  MyRenderTarget.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MyTexture;

@interface MyRenderTarget : NSObject

- (instancetype)initWithDrawable:(CAEAGLLayer*)drawable;
- (instancetype)initWithWidth:(GLint)w height:(GLint)h;

@property (nonatomic, assign, readonly)GLint width;
@property (nonatomic, assign, readonly)GLint height;
@property (nonatomic, assign, readonly)GLuint frameBuffer;
@property (nonatomic, assign, readonly)GLuint colorRenderBuffer;

@property (nonatomic, retain)MyTexture* texture;



@end

NS_ASSUME_NONNULL_END

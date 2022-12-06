//
//  MyTexture.h
//  Ch6HelloTexture
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <CoreGraphics/CoreGraphics.h>


NS_ASSUME_NONNULL_BEGIN

@interface MyTexture : NSObject

@property (nonatomic, assign)GLuint textureID;
@property (nonatomic, assign, readonly)int width;
@property (nonatomic, assign, readonly)int height;

- (instancetype)initWithImage:(CGImageRef)cgimage needMipmap:(BOOL)needMipmap;
- (instancetype)initWithWidth:(int)width height:(int)height;
- (instancetype)initWithWidth:(int)width height:(int)height data:(void*)data;
-(instancetype)initWithTexture:(GLuint)textureID;
//-(void)uploadTexture: (GLubyte*)bytes;

@end

NS_ASSUME_NONNULL_END

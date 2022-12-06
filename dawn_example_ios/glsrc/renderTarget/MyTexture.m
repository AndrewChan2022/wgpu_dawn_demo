//
//  MyTexture.m
//  Ch6HelloTexture
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyTexture.h"
#import <UIKit/UIKit.h>

@interface MyTexture () {
    //int _width;
    //int _height;
    
}

@end

@implementation MyTexture

-(instancetype)initWithTexture:(GLuint)textureID {
    self = [super init];
    if (self) {
        
        self.textureID = textureID;
        
        
        //glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, texDims, 0);
        //_width = glGetTexParameteri(, , );
        //_height = height;
    }
    
    return self;
}

- (instancetype)initWithWidth:(int)width height:(int)height {
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        
        [self generateTexture];
    }
    
    return self;
}

- (instancetype)initWithWidth:(int)width height:(int)height data:(void*)data {
    self = [super init];
    if (self) {
        _width = width;
        _height = height;
        
        [self generateTexture:data];
    }
    
    return self;
}

- (instancetype)initWithImage:(CGImageRef)cgimage needMipmap:(BOOL)needMipmap {
    self = [super init];
    if (self) {
        
        _width = (int)CGImageGetWidth(cgimage);
        _height = (int)CGImageGetHeight(cgimage);
        //CGSize pixelSizeOfImage = CGSizeMake(_width, _height);
        //CGSize pixelSizeToUseForTexture = pixelSizeOfImage;
        
        CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(cgimage));
        GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        
        [self generateTexture:imageData];
        //[self uploadTexture:imageData];
        
        
//        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
//        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)pixelSizeToUseForTexture.width, (int)pixelSizeToUseForTexture.height, 0, format, GL_UNSIGNED_BYTE, imageData);
//
        
    }
    return self;
}

- (GLuint)generateTexture:(GLubyte*)bytes {
    
    
//    defaultTextureOptions.minFilter = GL_LINEAR;
//    defaultTextureOptions.magFilter = GL_LINEAR;
//    defaultTextureOptions.wrapS = GL_CLAMP_TO_EDGE;
//    defaultTextureOptions.wrapT = GL_CLAMP_TO_EDGE;
//    defaultTextureOptions.internalFormat = GL_RGBA;
//    defaultTextureOptions.format = GL_BGRA;
//    defaultTextureOptions.type = GL_UNSIGNED_BYTE;
    
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    GLenum format = GL_RGBA; //GL_BGRA;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)_width, (int)_height, 0, format, GL_UNSIGNED_BYTE, bytes);
    
    
    //glBindTexture(GL_TEXTURE_2D, 0);
    
    return _textureID;
    
    // TODO: Handle mipmaps
}

- (GLuint)generateTexture {
    
    
//    defaultTextureOptions.minFilter = GL_LINEAR;
//    defaultTextureOptions.magFilter = GL_LINEAR;
//    defaultTextureOptions.wrapS = GL_CLAMP_TO_EDGE;
//    defaultTextureOptions.wrapT = GL_CLAMP_TO_EDGE;
//    defaultTextureOptions.internalFormat = GL_RGBA;
//    defaultTextureOptions.format = GL_BGRA;
//    defaultTextureOptions.type = GL_UNSIGNED_BYTE;
    
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    // This is necessary for non-power-of-two textures
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)_width, (int)_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
    
    return _textureID;
    
    // TODO: Handle mipmaps
}


/*
-(void)uploadTexture: (GLubyte*)bytes {
    
    GLenum format = GL_RGBA; //GL_BGRA;
    
    //glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)_width, (int)_height, 0, format, GL_UNSIGNED_BYTE, bytes);
    //glBindTexture(GL_TEXTURE_2D, 0);
    //glActiveTexture(GL_INVALID_ENUM);
}

-(void)uploadTextureBlankContent {
    
    GLenum format = GL_RGBA; //GL_BGRA;
    
    //glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)_width, (int)_height, 0, format, GL_UNSIGNED_BYTE, 0);
    //glBindTexture(GL_TEXTURE_2D, 0);
}*/


/*glActiveTexture(GL_TEXTURE0);
glBindTexture(GL_TEXTURE_2D, 0);
GLuint textureID1, textureID2;
CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(img.CGImage));
GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
glGenTextures(1, &textureID1);
glBindTexture(GL_TEXTURE_2D, textureID1);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
// This is necessary for non-power-of-two textures
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)img.size.width, (int)img.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
glBindTexture(GL_TEXTURE_2D, 0);

//glActiveTexture(GL_TEXTURE1);
dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(img2.CGImage));
imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
glGenTextures(1, &textureID2);
glBindTexture(GL_TEXTURE_2D, textureID2);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
// This is necessary for non-power-of-two textures
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)img2.size.width, (int)img2.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
glBindTexture(GL_TEXTURE_2D, 0);

//_sourceTexture = [[MyTexture alloc] initWithImage:img.CGImage needMipmap:false];
_sourceTexture = [[MyTexture alloc] initWithTexture:textureID1];
//usleep(3000*1000);
_filterMesh = [[MyQuadMesh alloc] init];
_filterPass = [[MyComputerPass alloc] initWithVS:@"VertexShader" fs:@"FragmentBWShader"];
*/

@end

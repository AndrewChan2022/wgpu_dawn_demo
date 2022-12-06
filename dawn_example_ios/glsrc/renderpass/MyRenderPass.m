//
//  MyRenderPass.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyRenderPass.h"
#import "MyContext.h"
#import "GLESUtils.h"
#import "MyBuffer.h"
#import "MyBaseUniforms.h"
#import "MyTexture.h"

@interface MyRenderPass () {
    GLuint _programHandle;
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _uvSlot;
    GLuint _inputTextureSlot;
    
}


@end
@implementation MyRenderPass

- (instancetype)initWithVSPath:(NSString*)vspath fspath:(NSString*)fspath {
    self = [super init];
    if (self) {
        //MyContext.shared.context
        [self createProgramGetSlot:vspath fspath:fspath];
    }
    return self;
}

- (instancetype)initWithVS:(NSString*)vs fs:(NSString*)fs {
    self = [super initWithVS:vs fs:fs];
    return self;
    
    self = [super init];
    if (self) {
        //MyContext.shared.context
        [self createProgramGetSlot:vs fs:fs];
    }
    
    return self;
}

-(void)setActive {
    glUseProgram(_programHandle);
}

#pragma mark - init

-(void)createProgramGetSlot:(NSString*)vspath fspath:(NSString*)fspath {
    
    // create program
    NSString * vertexShaderPath = [[NSBundle mainBundle] pathForResource:vspath
                                                                  ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:fspath
                                                                    ofType:@"glsl"];
    _programHandle = [GLESUtils loadProgram:vertexShaderPath
                 withFragmentShaderFilepath:fragmentShaderPath];
    if (_programHandle == 0) {
        NSLog(@" >> Error: Failed to setup program.");
        assert(false);
        return;
    }
    
    // get slot
    _positionSlot = glGetAttribLocation(_programHandle, "aPosition");
    _colorSlot = glGetAttribLocation(_programHandle, "aColor");
    _uvSlot = glGetAttribLocation(_programHandle, "aUV");
    
    // get uniform slot
    self.uniforms = [[MyBaseUniforms alloc] initWithPass:self];
    
    // fatal error: use "inputTexture" not @"inputTexture"
    //_inputTextureSlot = glGetUniformLocation(_programHandle, @"inputTexture");
    _inputTextureSlot = glGetUniformLocation(_programHandle, "inputTexture");
    
}

-(void)createProgramGetSlot:(NSString*)vs fs:(NSString*)fs {
    
    // create program
    _programHandle = [GLESUtils loadProgram:vs withFragmentString:fs];
    if (_programHandle == 0) {
        NSLog(@" >> Error: Failed to setup program.");
        assert(false);
        return;
    }
    
    // get slot
    _positionSlot = glGetAttribLocation(_programHandle, "aPosition");
    _colorSlot = glGetAttribLocation(_programHandle, "aColor");
    _uvSlot = glGetAttribLocation(_programHandle, "aUV");
    
    // get uniform slot
    self.uniforms = [[MyBaseUniforms alloc] initWithPass:self];
    
    // fatal error: use "inputTexture" not @"inputTexture"
    //_inputTextureSlot = glGetUniformLocation(_programHandle, @"inputTexture");
    _inputTextureSlot = glGetUniformLocation(_programHandle, "inputTexture");
    
}

-(void)drawWithMesh:(MyBaseMesh*)mesh renderTarget:(MyRenderTarget*)renderTarget {
    NSLog(@"...");
    
    // set program
    glUseProgram(_programHandle);
    
    // set target
    glBindFramebuffer(GL_FRAMEBUFFER, renderTarget.frameBuffer);
    
    // clear buffer
    glClearColor(0.0, 0.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // set input, array of struct in client, not struct of array
    GLint posComponentSize = 3;
    GLint colorComponentSize = 3;
    GLint uvComponentSize = 2;
    GLint stride = (posComponentSize + colorComponentSize + uvComponentSize) * sizeof(float);
    [mesh.vertexBuffer setVertexBuffer];
    uint8_t* offset = 0;
    glEnableVertexAttribArray(_positionSlot);  // attr array, per vertex. if disable, constant
    glVertexAttribPointer(_positionSlot, posComponentSize, GL_FLOAT, GL_FALSE,
                          stride, offset);
    offset += posComponentSize*sizeof(float);
    glEnableVertexAttribArray(_colorSlot);  // attr array, per vertex. if disable, constant
    glVertexAttribPointer(_colorSlot, colorComponentSize, GL_FLOAT, GL_FALSE,
                          stride, offset);
    offset += colorComponentSize*sizeof(float);
    glEnableVertexAttribArray(_uvSlot);  // attr array, per vertex. if disable, constant
    glVertexAttribPointer(_uvSlot, uvComponentSize, GL_FLOAT, GL_FALSE, stride, offset);
    
    // set uniform
    [self.uniforms refreshUniforms];
    
    // set texture
    if (mesh.map != nil) {
        // use GL_TEXTURE_2D.0
        // set 0 to uniform inputTexture
        // set uv to vertex attribute
        
        glActiveTexture(GL_TEXTURE3);
        glBindTexture(GL_TEXTURE_2D, mesh.map.textureID);
        glUniform1i(_inputTextureSlot, 3);
    }
    
    // draw
    glViewport(0, 0, renderTarget.width, renderTarget.height);
    //glDrawArrays(GL_TRIANGLES, 0, mesh.vertexCount);

    [mesh.indexBuffer setIndexBuffer];//GLushort indices[] = {0, 1, 2};
    glDrawElements(GL_TRIANGLES, mesh.indexCount, GL_UNSIGNED_SHORT, 0);
    
}

-(GLuint) programId {
    return _programHandle;
}

@end

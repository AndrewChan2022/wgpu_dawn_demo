//
//  MyRenderTarget.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyRenderTarget.h"
#import "MyContext.h"
#import "MyTexture.h"

@interface MyRenderTarget () {
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    GLint _canvasWidth, _canvasHeight;
}

@end

@implementation MyRenderTarget

- (instancetype)initWithDrawable:(CAEAGLLayer*)drawable {
    self = [super init];
    if (self) {
        glGenRenderbuffers(1, &_colorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
        //[self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.layer];
        //[self bindDrawable];
        
        [MyContext.shared.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:drawable];
        
        self.texture = nil;
        
        
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
        

        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_canvasWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_canvasHeight);
    }
    return self;
}

- (instancetype)initWithWidth:(GLint)w height:(GLint)h {
    self = [super init];
    if (self) {
        _canvasWidth = w;
        _canvasHeight = h;
        
        self.texture = [[MyTexture alloc] initWithWidth:w height:h];
        
        glGenFramebuffers(1, &_frameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
        
        //glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, self.texture.textureID);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.texture.textureID, 0);
        
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    return self;
}

-(GLint) width {
    return _canvasWidth;
}

-(GLint) height {
    return _canvasHeight;
}

-(GLuint) frameBuffer {
    return _frameBuffer;
}
-(GLuint) colorRenderBuffer {
    return _colorRenderBuffer;
}


@end

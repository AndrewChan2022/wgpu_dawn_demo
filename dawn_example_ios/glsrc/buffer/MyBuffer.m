//
//  MyBuffer.m
//  Ch3HelloBuffer_ocoes
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyBuffer.h"

@interface MyBuffer () {
    GLuint _bufferId;
}

@end

@implementation MyBuffer


-(instancetype)initWithBytes:(void*)bytes length:(int)length {
    self = [super init];
    if (self) {
        
        self.length = length;
        
        glGenBuffers(1, &_bufferId);
        glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
        glBufferData(GL_ARRAY_BUFFER, length, bytes, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
    return self;
}

-(instancetype)initWithLength:(int)length {
    self = [super init];
    if (self) {
        self.length = length;
        glGenBuffers(2, _bufferId);
    }
    return self;
}

-(void)updateBuffer:(void*)bytes length:(int)length {
    glBindBuffer(GL_ARRAY_BUFFER, _bufferId);
    glBufferData(GL_ARRAY_BUFFER, length, bytes, GL_DYNAMIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)setVertexBuffer {
    
    // bind buffer
    glBindBuffer(GL_ARRAY_BUFFER, self.bufferId);
}

-(void)setIndexBuffer {
    
    // bind buffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self.bufferId);
}

-(GLuint)bufferId {
    return _bufferId;
}


@end

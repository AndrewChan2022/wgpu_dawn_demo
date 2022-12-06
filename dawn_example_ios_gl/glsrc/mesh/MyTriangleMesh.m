//
//  MyTriangleMesh.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyTriangleMesh.h"
#import "MyBuffer.h"

@implementation MyTriangleMesh

- (instancetype)init
{
    self = [super init];
    if (self) {
        GLfloat vertices[] = {
            0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.5, 0.0,      // xyz.rgb.uv of vertex 0: top
            -1.0, -1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0,    // xyz.rgb.uv of vertex 1: bottom left
            1.0, -1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0};    // xyz.rgb.uv of vertex 2: bottom right

        self.vertexCount = 3;
        self.vertexBuffer = [[MyBuffer alloc] initWithBytes:vertices length:sizeof(vertices)];

        GLushort indices[] = {0, 1, 2};

        self.indexCount = 3;
        self.indexBuffer = [[MyBuffer alloc] initWithBytes:indices length:sizeof(indices)];
        
    }
    return self;
}


@end

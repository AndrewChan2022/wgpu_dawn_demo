//
//  MyQuadMesh.m
//  Ch6HelloTexture
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyQuadMesh.h"
#import "MyBuffer.h"

@implementation MyQuadMesh

// In OpenGL, the first pixel of the texture is considered to be the bottom-left pixel.
// so filter: (-1,-1) -> (0, 0)
// view: (-1,-1) -> (0,1)
- (instancetype)init
{
    self = [super init];
    if (self) {
        GLfloat vertices[] = {
            -1.0, 1.0, 0.0, 1.0, 0.0, 0.0,  0.0, 0.0,   // xyz.rgb.uv of vertex 0: top left
            -1.0, -1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0,    // xyz.rgb.uv of vertex 1: bottom left
            1.0, -1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0,     // xyz.rgb.uv of vertex 2: bottom right
            1.0, 1.0, 0.0, 0.0, 0.0, 1.0,  1.0, 0.0     // xyz.rgb.uv uv of vertex 3: bottom right
        };
        
        self.vertexCount = 4;
        self.vertexBuffer = [[MyBuffer alloc] initWithBytes:vertices length:sizeof(vertices)];
        
        GLushort indices[] = {
            0, 1, 2,  // triangle 0 indices
            0, 2, 3   // triangle 1 indices
        };
        
        self.indexCount = 6;
        self.indexBuffer = [[MyBuffer alloc] initWithBytes:indices length:sizeof(indices)];
        
        
    }
    return self;
}



@end

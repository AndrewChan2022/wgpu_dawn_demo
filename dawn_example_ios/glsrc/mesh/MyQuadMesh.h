//
//  MyQuadMesh.h
//  Ch6HelloTexture
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyBaseMesh.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBuffer;

@interface MyQuadMesh : MyBaseMesh

@property (nonatomic, retain)MyBuffer* vertexBuffer;
@property (nonatomic, assign)int vertexCount;

@property (nonatomic, retain)MyBuffer* indexBuffer;
@property (nonatomic, assign)int indexCount;

@end

NS_ASSUME_NONNULL_END

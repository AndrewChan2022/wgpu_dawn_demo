//
//  MyTriangleMesh.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyBaseMesh.h"

NS_ASSUME_NONNULL_BEGIN

@class MyBuffer;

@interface MyTriangleMesh : MyBaseMesh

@property (nonatomic, retain)MyBuffer* vertexBuffer;
@property (nonatomic, assign)int vertexCount;

@property (nonatomic, retain)MyBuffer* indexBuffer;
@property (nonatomic, assign)int indexCount;



@end

NS_ASSUME_NONNULL_END


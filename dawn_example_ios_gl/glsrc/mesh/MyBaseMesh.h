//
//  MyBaseMesh.h
//  Ch6HelloTexture
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@class MyBuffer;
@class MyTexture;


@interface MyBaseMesh : NSObject

@property (nonatomic, retain)MyBuffer* vertexBuffer;
@property (nonatomic, assign)int vertexCount;

@property (nonatomic, retain)MyBuffer* indexBuffer;
@property (nonatomic, assign)int indexCount;

@property (nonatomic, retain)MyTexture* map;



@end

NS_ASSUME_NONNULL_END

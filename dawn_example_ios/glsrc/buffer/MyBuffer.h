//
//  MyBuffer.h
//  Ch3HelloBuffer_ocoes
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES2/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBuffer : NSObject

@property (nonatomic, assign, readonly)GLuint bufferId;
@property (nonatomic, assign)int length;

-(instancetype)initWithBytes:(void*)bytes length:(int)length;
-(instancetype)initWithLength:(int)length;
-(void)updateBuffer:(void*)bytes length:(int)length;
-(void)setVertexBuffer;
-(void)setIndexBuffer;

@end

NS_ASSUME_NONNULL_END

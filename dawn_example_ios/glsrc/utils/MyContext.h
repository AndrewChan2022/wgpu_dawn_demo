//
//  MyContext.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyContext : NSObject

@property (class, readonly) MyContext* shared;
@property (nonatomic, retain)EAGLContext* context;
@property(readonly, nonatomic) dispatch_queue_t videoQueue;


-(void)useAsCurrentContext;
-(void)runAsynchronouslyOnVideoProcessingQueue:(void (^)(void))block;
-(void)runSynchronouslyOnVideoProcessingQueue:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END

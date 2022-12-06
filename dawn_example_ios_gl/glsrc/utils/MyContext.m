//
//  MyContext.m
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyContext.h"


@implementation MyContext

static void *openGLESVideoQueueKey;


+ (MyContext *)shared {
    static MyContext *s_instance = nil;
    if (s_instance == nil) {
        s_instance = [[MyContext alloc] init];
    }
    return s_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _videoQueue = dispatch_queue_create("com.sunsetlakesoftware.GPUImage.openGLESContextQueue", [self getDefaultQueueAttribute]);
        openGLESVideoQueueKey = &openGLESVideoQueueKey;
        #if OS_OBJECT_USE_OBJC
            dispatch_queue_set_specific(_videoQueue, openGLESVideoQueueKey, (__bridge void *)self, NULL);
        #endif
        
        
        // set context to view, so can display
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
        self.context = [[EAGLContext alloc] initWithAPI:api];
        
        // set context to EAGLContext as default
        if (![EAGLContext setCurrentContext:self.context]) {
            //self.context = nil;
            NSLog(@" >> Error: Failed to set current OpenGL context");
            exit(1);
        }
    }
    return self;
}

-(void)useAsCurrentContext {
    if ([EAGLContext currentContext] != self.context) {
        [EAGLContext setCurrentContext: self.context];
    }
}

-(dispatch_queue_attr_t)getDefaultQueueAttribute {
    #if TARGET_OS_IPHONE
        if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
        {
            return dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
        }
    #endif
        return nil;
}

//void runAsynchronouslyOnVideoProcessingQueue(void (^block)(void)){}
-(void)runAsynchronouslyOnVideoProcessingQueue:(void (^)(void))block {
    #if !OS_OBJECT_USE_OBJC
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == self.videoQueue) {
    #pragma clang diagnostic pop
    #else
        if (dispatch_get_specific(openGLESVideoQueueKey)) {
    #endif
        //block();
        dispatch_async(self.videoQueue, block);
    } else {
        dispatch_async(self.videoQueue, block);
    }
}

-(void)runSynchronouslyOnVideoProcessingQueue:(void (^)(void))block {
    
    #if !OS_OBJECT_USE_OBJC
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == self.videoQueue) {
    #pragma clang diagnostic pop
    #else
        if (dispatch_get_specific(openGLESVideoQueueKey)) {
    #endif
        block();
    } else {
        dispatch_sync(self.videoQueue, block);
    }
}


@end

//
//  MyShaders.h
//  Ch7HelloComputerpass
//
//  Created by kai chen on 12/1/22.
//  Copyright © 2022 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyShaders : NSObject

+(NSString*)getVS;
+(NSString*)getFSNoTexture;
+(NSString*)getFSWithTexture;
+(NSString*)getPresentFSWithTexture;
+(NSString*)getBWFilter;

@end

NS_ASSUME_NONNULL_END

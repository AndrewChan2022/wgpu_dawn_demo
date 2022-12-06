//
//  MyBaseUniforms.h
//  Ch5HelloUniform_ocoes
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MyBasePass;

@interface MyBaseUniforms : NSObject

-(instancetype)initWithPass:(MyBasePass*)pass;
-(void)refreshUniforms;

@property (nonatomic, assign)float brightness;



@end

NS_ASSUME_NONNULL_END

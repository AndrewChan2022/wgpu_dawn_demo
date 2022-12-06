//
//  MyBaseUniforms.m
//  Ch5HelloUniform_ocoes
//
//  Created by chenkai on 2019/12/21.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#import "MyBaseUniforms.h"
#import "MyBasePass.h"

@interface MyBaseUniforms () {
    GLuint _brightnessSlot;
}

@property (nonatomic, weak)MyBasePass* pass;
@property (nonatomic, assign)BOOL isDirty;


@end

@implementation MyBaseUniforms

-(instancetype)initWithPass:(MyBasePass*)pass {
    self = [super init];
    if (self) {
        
        // init paras
        self.isDirty = false;
        self.brightness = 1.0;
        
        // get slot
        _brightnessSlot = glGetUniformLocation(pass.programId, "brightness");
        
        // update paras
        glUniform1f(_brightnessSlot, self.brightness);
    }
    
    return self;
}

-(void)setBrightness:(float)newValue {
    _brightness = newValue;
    self.isDirty = true;
    //glUniform1f(_brightnessSlot, _brightness);
}

-(void)refreshUniforms {
    if (self.isDirty) {
        glUniform1f(_brightnessSlot, _brightness);
    }
}

@end

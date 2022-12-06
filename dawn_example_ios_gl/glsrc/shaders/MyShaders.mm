//
//  MyShaders.m
//  Ch7HelloComputerpass
//
//  Created by kai chen on 12/1/22.
//  Copyright © 2022 ImBatman. All rights reserved.
//

#import "MyShaders.h"
#import <string>

@implementation MyShaders

+(NSString*)getVS {
    
//    std::string vs = R"(
//    attribute vec4 aPosition;
//    attribute vec4 aColor;
//    attribute vec2 aUV;
//
//    varying vec4 vColor;
//    varying vec2 vUV;
//
//    void main(void)
//    {
//        //gl_Position = projection * modelView * vPosition;
//        gl_Position = aPosition;
//        vColor = aColor;
//        vUV = aUV;
//    }
//    )";
    
    std::string vs = R"(#version 300 es
    layout(location = 0) in vec4 aPosition;
    layout(location = 1) in vec4 aColor;
    layout(location = 2) in vec2 aUV;

    out vec4 vColor;
    out vec2 vUV;
     
    void main(void)
    {
        //gl_Position = projection * modelView * vPosition;
        gl_Position = aPosition;
        vColor = aColor;
        vUV = aUV;
    }
    )";
    
    return [NSString stringWithUTF8String:vs.c_str()];
}

+(NSString*)getFSNoTexture {
//    std::string fs = R"(
//
//    precision mediump float;
//
//    varying vec4 vColor;
//    uniform float brightness;
//
//    varying highp vec2 vUV;
//    uniform sampler2D inputTexture;
//
//    void main()
//    {
//        gl_FragColor = vColor; //vec4(1.0, 0.0, 0.0, 1.0);
//    }
//
//
//    )";
    
    std::string fs = R"(#version 300 es
    precision mediump float;

    in vec4 vColor;
    in highp vec2 vUV;
    
    uniform float brightness;
    uniform sampler2D inputTexture;
    layout(location = 0) out vec4 outColor;

    void main()
    {
        outColor = vColor; //vec4(1.0, 0.0, 0.0, 1.0);
    }

    
    )";
    
    return [NSString stringWithUTF8String:fs.c_str()];
}

+(NSString*)getFSWithTexture {
//    std::string fs = R"(
//
//    precision mediump float;
//
//    varying vec4 vColor;
//    uniform float brightness;
//
//    varying highp vec2 vUV;
//    uniform sampler2D inputTexture;
//
//    void main()
//    {
//        //vec4 newColor = vec4(brightness, brightness, brightness, 1.0);
//        //newColor.rgb = newColor.rgb + vColor.rgb;
//        vec4 texColor = texture2D(inputTexture, vUV);
//        //newColor.rgb = newColor.rgb + texColor.rgb;
//        //newColor.rgb = newColor.rgb + texColor.rgb;
//        gl_FragColor = texColor; //vec4(1.0, 0.0, 0.0, 1.0);
//    }
//    )";
    
    std::string fs = R"(#version 300 es
    precision mediump float;

    in vec4 vColor;
    in highp vec2 vUV;
    
    uniform float brightness;
    uniform sampler2D inputTexture;
    layout(location = 0) out vec4 outColor;

    void main()
    {
        //vec4 newColor = vec4(brightness, brightness, brightness, 1.0);
        //newColor.rgb = newColor.rgb + vColor.rgb;
        vec4 texColor = texture(inputTexture, vUV);
        //newColor.rgb = newColor.rgb + texColor.rgb;
        //newColor.rgb = newColor.rgb + texColor.rgb;
        outColor = texColor; //vec4(1.0, 0.0, 0.0, 1.0);
    }
    )";
    
    return [NSString stringWithUTF8String:fs.c_str()];
}

+(NSString*)getPresentFSWithTexture {
//    std::string fs = R"(
//
//    precision mediump float;
//
//    varying vec4 vColor;
//    uniform float brightness;
//
//    varying highp vec2 vUV;
//    uniform sampler2D inputTexture;
//
//    void main()
//    {
//        //vec4 newColor = vec4(brightness, brightness, brightness, 1.0);
//        //newColor.rgb = newColor.rgb + vColor.rgb;
//        //vUV.y = 1.0 - vUV.y;
//        vec2 uv = vec2(vUV.x, 1.0 - vUV.y);
//        vec4 texColor = texture2D(inputTexture, uv);
//        //newColor.rgb = newColor.rgb + texColor.rgb;
//        //newColor.rgb = newColor.rgb + texColor.rgb;
//        gl_FragColor = texColor; //vec4(1.0, 0.0, 0.0, 1.0);
//    }
//    )";
    
    std::string fs = R"(#version 300 es
    precision mediump float;

    in vec4 vColor;
    in highp vec2 vUV;
    

    uniform float brightness;
    uniform sampler2D inputTexture;
    layout(location = 0) out vec4 outColor;

    void main()
    {
        //vec4 newColor = vec4(brightness, brightness, brightness, 1.0);
        //newColor.rgb = newColor.rgb + vColor.rgb;
        //vUV.y = 1.0 - vUV.y;
        vec2 uv = vec2(vUV.x, 1.0 - vUV.y);
        vec4 texColor = texture(inputTexture, uv);
        //newColor.rgb = newColor.rgb + texColor.rgb;
        //newColor.rgb = newColor.rgb + texColor.rgb;
        outColor = texColor; //vec4(1.0, 0.0, 0.0, 1.0);
    }
    )";
    
    return [NSString stringWithUTF8String:fs.c_str()];
}

+(NSString*)getBWFilter {
    std::string fs = R"(
    //#version 300 es
    precision mediump float;

    varying vec4 vColor;
    uniform float brightness;

    varying highp vec2 vUV;
    uniform sampler2D inputTexture;

    const vec3 kRec709Luma = vec3(0.2126, 0.7152, 0.0722);

    void main()
    {
        vec4 newColor = vec4(brightness, brightness, brightness, vColor.a);
        //newColor.rgb = newColor.rgb + vColor.rgb;
        
        // In OpenGL, the first pixel of the texture is considered to be the bottom-left pixel.
        vec2 inverseUV = vUV;
        
        vec4 texColor = texture2D(inputTexture, inverseUV);
        newColor.rgb = texColor.rgb;
        
        float  gray     = dot(newColor.rgb, kRec709Luma);
        newColor    = vec4(gray, gray, gray, 1.0);
        //newColor = vec4(1.0, 0.0, 0.0, 1.0);
        
        gl_FragColor = newColor; //vec4(1.0, 0.0, 0.0, 1.0);
    }

    )";
    
    return [NSString stringWithUTF8String:fs.c_str()];
}


@end

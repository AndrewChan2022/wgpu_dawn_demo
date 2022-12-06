//
//  MyWGPUPassImp.h
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//

#include "dawn/webgpu_cpp.h"
//#include "dawn/dawn_wsi.h"

class MyWGPUPassImp {
public:
    static wgpu::Device createDeviceByNativeAPI(wgpu::BackendType backendType);
    static wgpu::Device createDeviceByCppAPI();
    static wgpu::Device createDeviceByCAPI();
    static wgpu::TextureView createDefaultDepthStencilView(const wgpu::Device& device, int width, int height);
    
public:
    MyWGPUPassImp() = default;
    ~MyWGPUPassImp() = default;

    void init();
    void frame();
    uint32_t getTextureId();
private:
    void initBuffers();
    void initTextures();
    void initRenderTarget(int width, int height);
private:
    
    // global
    wgpu::Device device;
    wgpu::Queue queue;
    
    // input
    wgpu::Buffer indexBuffer;
    wgpu::Buffer vertexBuffer;

    wgpu::Texture texture;
    //wgpu::TextureView textureView;
    wgpu::Sampler sampler;
    
    // output
    //wgpu::Texture depthStencilTexture;
    wgpu::TextureView depthStencilView;
    wgpu::Texture colorTexture;
    wgpu::TextureView colorView;
    wgpu::Sampler colorSampler;
    
    // pipeline
    wgpu::RenderPipeline pipeline;
    wgpu::BindGroup bindGroup;
    
};


//
//  MyWGPUPassImp.cpp
//  Ch2HelloTriangle_oes
//
//  Created by chenkai on 2019/12/20.
//  Copyright © 2019 ImBatman. All rights reserved.
//


#include "MyWGPUPassImp.h"
#include <OpenGLES/ES3/gl.h>

#include <algorithm>
#include <cstring>
#include <memory>
#include <string>
#include <vector>
#include <iostream>

//#include "dawn/common/Assert.h"
//#include "dawn/common/Log.h"
//#include "dawn/common/Platform.h"
//#include "dawn/common/SystemUtils.h"


#include "dawn/dawn_proc.h"
//#include "dawn/dawn_wsi.h"
#include "dawn/native/DawnNative.h"


#include "dawn/utils/ComboRenderPipelineDescriptor.h"
//#include "dawn/utils/ScopedAutoreleasePool.h"
//#include "dawn/utils/SystemUtils.h"
#include "dawn/utils/WGPUHelpers.h"


void PrintDeviceError(WGPUErrorType errorType, const char* message, void*) {
    const char* errorTypeName = "";
    switch (errorType) {
        case WGPUErrorType_Validation:
            errorTypeName = "Validation";
            break;
        case WGPUErrorType_OutOfMemory:
            errorTypeName = "Out of memory";
            break;
        case WGPUErrorType_Unknown:
            errorTypeName = "Unknown";
            break;
        case WGPUErrorType_DeviceLost:
            errorTypeName = "Device lost";
            break;
        default:
            errorTypeName = "unkwn errorType";
            //UNREACHABLE();
            return;
    }
    //dawn::ErrorLog() << errorTypeName << " error: " << message;
    std::cout << errorTypeName << " error: " << message << std::endl;
}

wgpu::Device MyWGPUPassImp::createDeviceByNativeAPI(wgpu::BackendType backendType) {
    
    utils::SetOpenGLGetProc();
    
    std::unique_ptr<dawn::native::Instance> native_instance;
    
    native_instance = std::make_unique<dawn::native::Instance>();
    native_instance->DiscoverDefaultAdapters();

    // Get an adapter for the backend to use, and create the device.
    dawn::native::Adapter backendAdapter;
    {
        std::vector<dawn::native::Adapter> adapters = native_instance->GetAdapters();
        auto adapterIt = std::find_if(adapters.begin(), adapters.end(),
                                      [backendType](const dawn::native::Adapter adapter) -> bool {
                                          wgpu::AdapterProperties properties;
                                          adapter.GetProperties(&properties);
                                          return properties.backendType == backendType;
                                      });
        //ASSERT(adapterIt != adapters.end());
        assert(adapterIt != adapters.end());
        backendAdapter = *adapterIt;
    }
    

    glEnable(GL_SCISSOR_TEST); // bugfix
    WGPUDevice backendDevice = backendAdapter.CreateDevice();
    glDisable(GL_SCISSOR_TEST); // bugfix
    
    DawnProcTable backendProcs = dawn::native::GetProcs();
    
    WGPUDevice cDevice = backendDevice;
    DawnProcTable procs = backendProcs;
    
    dawnProcSetProcs(&procs);
    procs.deviceSetUncapturedErrorCallback(cDevice, PrintDeviceError, nullptr);
    
    return wgpu::Device::Acquire(cDevice);
    return wgpu::Device::Acquire(nullptr);
}

#define UNUSED(x) (void)x
void request_adapter_callback(WGPURequestAdapterStatus status,
                              WGPUAdapter received, const char *message,
                              void *userdata) {
    UNUSED(status);
    UNUSED(message);

    *(WGPUAdapter *)userdata = received;
}
void request_adapter_callback_cpp(WGPURequestAdapterStatus status,
                              WGPUAdapter received, const char *message,
                              void *userdata) {
    UNUSED(status);
    UNUSED(message);
    wgpu::Adapter* padpater = (wgpu::Adapter*)userdata;
    *padpater = wgpu::Adapter::Acquire(received);
}
wgpu::Device MyWGPUPassImp::createDeviceByCAPI() {
    
    utils::SetOpenGLGetProc();
    DawnProcTable backendProcs = dawn::native::GetProcs();
    dawnProcSetProcs(&backendProcs);
    
    WGPUInstance cInstance;
    WGPUAdapter cAdapter;

    // instance
    cInstance = wgpuCreateInstance(nullptr);

    // adapter
    WGPURequestAdapterOptions adapterOptions {
        .nextInChain = NULL,
        .compatibleSurface = nullptr,
    };
    wgpuInstanceRequestAdapter(cInstance,
                               &adapterOptions,
                               request_adapter_callback,
                               (void *)&cAdapter);

    // device
    glEnable(GL_SCISSOR_TEST); // bugfix
    WGPUDevice cDevice = wgpuAdapterCreateDevice(cAdapter, nullptr);
    glDisable(GL_SCISSOR_TEST); // bugfix
    
    backendProcs.deviceSetUncapturedErrorCallback(cDevice, PrintDeviceError, nullptr);
    return wgpu::Device::Acquire(cDevice);
}


wgpu::Device MyWGPUPassImp::createDeviceByCppAPI() {
    
    utils::SetOpenGLGetProc();
    DawnProcTable backendProcs = dawn::native::GetProcs();
    dawnProcSetProcs(&backendProcs);
    
    wgpu::Instance instance;
    wgpu::InstanceDescriptor descriptor;
    descriptor.nextInChain = nullptr;
    instance = wgpu::CreateInstance(&descriptor);
    
    // cannot specify which api,
    // InstanceBase::RequestAdapterInternal only filter by AdapterProperties.AdapterType(cpu, intgpu, desgpu), not backendType
    // IterateBitSet(GetEnabledBackends()) => priority: Null, D3D12, Metal, Vulkan, OpenGL, OpenGLES
    wgpu::RequestAdapterOptions options;
    wgpu::Adapter adapter;
    instance.RequestAdapter(&options, [](WGPURequestAdapterStatus status,
                                         WGPUAdapter received, const char *message,
                                         void *userdata) {
        wgpu::Adapter* padpater = (wgpu::Adapter*)userdata;
        *padpater = wgpu::Adapter::Acquire(received);
    }, &adapter);
    
    glEnable(GL_SCISSOR_TEST); // bugfix
    wgpu::Device device = adapter.CreateDevice();
    glDisable(GL_SCISSOR_TEST); // bugfix
    
    backendProcs.deviceSetUncapturedErrorCallback(device.Get(), PrintDeviceError, nullptr);
    return device;
}

wgpu::TextureView MyWGPUPassImp::createDefaultDepthStencilView(const wgpu::Device& device, int width, int height) {
    
    wgpu::TextureDescriptor descriptor;
    descriptor.dimension = wgpu::TextureDimension::e2D;
    descriptor.size.width = width;
    descriptor.size.height = height;
    descriptor.size.depthOrArrayLayers = 1;
    descriptor.sampleCount = 1;
    descriptor.format = wgpu::TextureFormat::Depth24PlusStencil8;
    descriptor.mipLevelCount = 1;
    descriptor.usage = wgpu::TextureUsage::RenderAttachment;
    auto depthStencilTexture = device.CreateTexture(&descriptor);
    return depthStencilTexture.CreateView();
}

void MyWGPUPassImp::initBuffers() {
    static const uint32_t indexData[3] = {
        0,
        1,
        2,
    };
    indexBuffer =
        utils::CreateBufferFromData(device, indexData, sizeof(indexData), wgpu::BufferUsage::Index);

    static const float vertexData[] = {
        0.0f, 0.5f, -1.0f, 1.0f,  0.5f, 0.0f,      // xyzw.uv
        -0.5f, -0.5f, 1.0f, 1.0f, 0.0f, 1.0f,
        0.5f, -0.5f, 1.0f, 1.0f, 1.0f, 1.0f
    };
    vertexBuffer = utils::CreateBufferFromData(device, vertexData, sizeof(vertexData),
                                               wgpu::BufferUsage::Vertex);
}

void MyWGPUPassImp::initTextures() {
    wgpu::TextureDescriptor descriptor;
    descriptor.dimension = wgpu::TextureDimension::e2D;
    descriptor.size.width = 1024;
    descriptor.size.height = 1024;
    descriptor.size.depthOrArrayLayers = 1;
    descriptor.sampleCount = 1;
    descriptor.format = wgpu::TextureFormat::RGBA8Unorm;
    descriptor.mipLevelCount = 1;
    descriptor.usage = wgpu::TextureUsage::CopyDst | wgpu::TextureUsage::TextureBinding;
    texture = device.CreateTexture(&descriptor);

    sampler = device.CreateSampler();

    // Initialize the texture with arbitrary data until we can load images
    std::vector<uint8_t> data(4 * 1024 * 1024, 0);
    for (size_t i = 0; i < data.size(); ++i) {
        data[i] = static_cast<uint8_t>(i / (1024 * 4) % 253);
    }

    wgpu::Buffer stagingBuffer = utils::CreateBufferFromData(
        device, data.data(), static_cast<uint32_t>(data.size()), wgpu::BufferUsage::CopySrc);
    wgpu::ImageCopyBuffer imageCopyBuffer =
        utils::CreateImageCopyBuffer(stagingBuffer, 0, 4 * 1024);
    wgpu::ImageCopyTexture imageCopyTexture = utils::CreateImageCopyTexture(texture, 0, {0, 0, 0});
    wgpu::Extent3D copySize = {1024, 1024, 1};

    wgpu::CommandEncoder encoder = device.CreateCommandEncoder();
    encoder.CopyBufferToTexture(&imageCopyBuffer, &imageCopyTexture, &copySize);

    wgpu::CommandBuffer copy = encoder.Finish();
    queue.Submit(1, &copy);
}

void MyWGPUPassImp::initRenderTarget(int width, int height) {
    wgpu::TextureDescriptor descriptor;
    descriptor.dimension = wgpu::TextureDimension::e2D;
    descriptor.size.width = width;
    descriptor.size.height = height;
    descriptor.size.depthOrArrayLayers = 1;
    descriptor.sampleCount = 1;
    descriptor.format = wgpu::TextureFormat::RGBA8Unorm;
    descriptor.mipLevelCount = 1;
    descriptor.usage = wgpu::TextureUsage::RenderAttachment | wgpu::TextureUsage::TextureBinding;
    colorTexture = device.CreateTexture(&descriptor);
    colorSampler = device.CreateSampler();
    colorView = colorTexture.CreateView();
}

void MyWGPUPassImp::init() {
    
    //device = createDeviceByCAPI();
    device = createDeviceByCppAPI();
    //device = createDeviceByNativeAPI(wgpu::BackendType::OpenGLES);
    queue = device.GetQueue();
    
    
    
    initBuffers();
    initTextures();
    initRenderTarget(640*2, 480*2);
    

    // google demo
//    wgpu::ShaderModule vsModule = utils::CreateShaderModule(device, R"(
//        @vertex fn main(@location(0) pos : vec4<f32>)
//                            -> @builtin(position) vec4<f32> {
//
//            //var pos2:vec4<f32> = pos;
//            //pos2.y = -pos2.y;
//            return pos;
//        })");
    
//    wgpu::ShaderModule fsModule = utils::CreateShaderModule(device, R"(
//        @group(0) @binding(0) var mySampler: sampler;
//        @group(0) @binding(1) var myTexture : texture_2d<f32>;
//
//        @fragment fn main(@builtin(position) FragCoord : vec4<f32>)
//                              -> @location(0) vec4<f32> {
//            return textureSample(myTexture, mySampler, FragCoord.xy / vec2<f32>(640.0*2.0, 480.0*2.0));
//            //return vec4(0.0, 0.0, 1.0, 1.0);
//        })");
    
    
    // gpubook
//    wgpu::ShaderModule vsModule = utils::CreateShaderModule(device, R"(
//        [location(0)] var<in> pos : vec4<f32>;
//        [[location(1)]] var<in> uv : vec2<f32>;
//
//        [[builtin(position)]] var<out> Position : vec4<f32>;
//        [[location(0)]] var<out> vUV : vec2<f32>;
//
//        [[stage(vertex)]]
//        fn main() -> void {
//            Position = pos;
//            vUV = uv;
//        })");
//
//    wgpu::ShaderModule fsModule = utils::CreateShaderModule(device, R"(
//
//        [[binding(0), group(0)]] var textureSampler : sampler;
//        [[binding(1), group(0)]] var textureData : texture_2d<f32>;
//
//        [[location(0)]] var<in> vUV : vec2<f32>;
//        [[location(0)]] var<out> fragColor : vec4<f32>;
//
//        [[stage(fragment)]]
//        fn main() -> void {
//            return textureSample(textureData, textureSampler, FragCoord.xy / vec2<f32>(640.0*2.0, 480.0*2.0));
//            //return vec4(0.0, 0.0, 1.0, 1.0);
//        })");
    
    // https://sotrh.github.io/learn-wgpu/beginner/tutorial5-textures/#a-change-to-the-vertices
    wgpu::ShaderModule vsModule = utils::CreateShaderModule(device, R"(
        
        // Vertex shader
        
        struct VertexInput {
            @location(0) pos: vec4<f32>,
            @location(1) aUV: vec2<f32>,
        }

        struct VertexOutput {
            @builtin(position) position: vec4<f32>,
            @location(0) vUV: vec2<f32>,
        }

        @vertex
        fn main(
            model: VertexInput,
        ) -> VertexOutput {
            var out: VertexOutput;
            out.vUV = model.aUV;
            out.position = model.pos;
            return out;
        }
        )");

    wgpu::ShaderModule fsModule = utils::CreateShaderModule(device, R"(
        
        // Fragment shader
        
        struct VertexOutput {
            @builtin(position) position: vec4<f32>,
            @location(0) vUV: vec2<f32>,
        }
        
        @group(0)@binding(0) var s_diffuse: sampler;
        @group(0) @binding(1) var t_diffuse: texture_2d<f32>;
        

        @fragment
        fn main(in: VertexOutput) -> @location(0) vec4<f32> {
            return textureSample(t_diffuse, s_diffuse, in.vUV);
            //return textureSample(t_diffuse, s_diffuse, in.position.xy / vec2<f32>(640.0*2.0, 480.0*2.0));
            //return vec4(0.0, 0.0, 1.0, 1.0);
        }
        )");
    
    //#version 300 es
    wgpu::ShaderModule vs2Module = utils::CreateShaderModuleFromGLSL(device, utils::GLSLStage::VERTEX,  R"(
            #version 450
            layout(location = 0) in vec4 pos;
            layout(location = 1) in vec2 aUV;
            layout(location = 0) out vec2 vUV;
        
            void main() {
              gl_Position = pos;
              vUV = aUV;
              return;
            }
        )");

    wgpu::ShaderModule fs2Module = utils::CreateShaderModuleFromGLSL(device, utils::GLSLStage::FRAGMENT, R"(
            #version 450
            layout(location = 0) out vec4 value;
            layout(binding=0) uniform sampler mySampler;
            layout(binding=1) uniform texture2D textureData;
            //layout(binding=1) uniform sampler2D mySampler;
        
            layout(location = 0) in vec2 vUV;
            
            
            void main() {
              //vec4 color = texture(mySampler, (FragCoord.xy / vec2(640.0f, 480.0f)));
              //vec4 color = texture(sampler2D(textureData, mySampler), (gl_FragCoord.xy / vec2(640.0f*2.0f, 480.0f*2.0f)));
              vec4 color = texture(sampler2D(textureData, mySampler), vUV);
              //vec4 color = vec4(0.0, 0.0, 1.0, 1.0);
              value = color;
              return;
            }
        )");

    auto bgl = utils::MakeBindGroupLayout(
        device, {
                    {0, wgpu::ShaderStage::Fragment, wgpu::SamplerBindingType::Filtering},
                    {1, wgpu::ShaderStage::Fragment, wgpu::TextureSampleType::Float},
                });

    wgpu::PipelineLayout pl = utils::MakeBasicPipelineLayout(device, &bgl);

    depthStencilView = createDefaultDepthStencilView(device, 640*2, 480*2);

    wgpu::RenderPipelineDescriptor descriptor1;
    descriptor1.layout = utils::MakeBasicPipelineLayout(device, &bgl);
    descriptor1.vertex.module = vsModule;
    descriptor1.vertex.entryPoint = "main";
    descriptor1.vertex.bufferCount = 1;
    std::vector<wgpu::VertexBufferLayout> buffers(1);
    descriptor1.vertex.buffers = buffers.data();
    buffers[0].arrayStride = 6 * sizeof(float);
    buffers[0].attributeCount = 2;
    std::vector<wgpu::VertexAttribute> attributes(2);
    buffers[0].attributes = attributes.data();
    attributes[0].offset = 0;
    attributes[0].format = wgpu::VertexFormat::Float32x4;
    attributes[0].shaderLocation = 0;
    attributes[1].offset = sizeof(float) * 4;
    attributes[1].format = wgpu::VertexFormat::Float32x2;
    attributes[1].shaderLocation = 1;
    wgpu::FragmentState fragmentState;
    descriptor1.fragment = &fragmentState;
    fragmentState.module = fsModule;
    fragmentState.entryPoint = "main";
    fragmentState.targetCount = 1;
    wgpu::ColorTargetState colorTarget;
    fragmentState.targets = &colorTarget;
    colorTarget.format = wgpu::TextureFormat::RGBA8Unorm;
    wgpu::DepthStencilState depthStencil;
    descriptor1.depthStencil = &depthStencil;
    depthStencil.format = wgpu::TextureFormat::Depth24PlusStencil8;
    
    /*utils::ComboRenderPipelineDescriptor descriptor;
    descriptor.layout = utils::MakeBasicPipelineLayout(device, &bgl);
    descriptor.vertex.module = vs2Module;
    descriptor.vertex.bufferCount = 1;
    descriptor.cBuffers[0].arrayStride = 6 * sizeof(float);
    descriptor.cBuffers[0].attributeCount = 2;
    descriptor.cAttributes[0].format = wgpu::VertexFormat::Float32x4;
    descriptor.cAttributes[0].offset = 0;
    descriptor.cAttributes[0].shaderLocation = 0;
    descriptor.cAttributes[1].format = wgpu::VertexFormat::Float32x2;
    descriptor.cAttributes[1].offset = sizeof(float) * 4;
    descriptor.cAttributes[1].shaderLocation = 1;
    descriptor.cFragment.module = fs2Module;
    descriptor.cTargets[0].format = wgpu::TextureFormat::RGBA8Unorm;
    descriptor.EnableDepthStencil(wgpu::TextureFormat::Depth24PlusStencil8);*/

    pipeline = device.CreateRenderPipeline(&descriptor1);

    wgpu::TextureView textureView = texture.CreateView();

    bindGroup = utils::MakeBindGroup(device, bgl, {{0, sampler}, {1, textureView}});
}

static struct {
    uint32_t a;
    float b;
} s;

void MyWGPUPassImp::frame() {
    s.a = (s.a + 1) % 256;
    s.b += 0.02f;
    if (s.b >= 1.0f) {
        s.b = 0.0f;
    }

    wgpu::TextureView backbufferView = colorView;
    utils::ComboRenderPassDescriptor renderPass({backbufferView}, depthStencilView);

    wgpu::CommandEncoder encoder = device.CreateCommandEncoder();
    {
        wgpu::RenderPassEncoder pass = encoder.BeginRenderPass(&renderPass);
        pass.SetPipeline(pipeline);
        pass.SetBindGroup(0, bindGroup);
        pass.SetVertexBuffer(0, vertexBuffer);
        pass.SetIndexBuffer(indexBuffer, wgpu::IndexFormat::Uint32);
        pass.DrawIndexed(3);
        pass.End();
    }

    wgpu::CommandBuffer commands = encoder.Finish();
    queue.Submit(1, &commands);
}

uint32_t MyWGPUPassImp::getTextureId() {
    return utils::getGLTextureId(colorTexture);
    //return 2;
}


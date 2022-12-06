

# build for ios


debug:

    mkdir build && cd build
    cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS

release:

    mkdir build && cd build
    cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_BUILD_TYPE=Release
    then in xcode -> edit scheme -> choose release




# wgpu lib guide:

    check MyWGPUPassImp.cpp

     1. include

        #include "dawn/webgpu_cpp.h"            // api
        #include "dawn/dawn_proc.h"             // set api to one implement of dawn::native or dawn::wire(client/server)
        #include "dawn/native/DawnNative.h"     // choose implementation of dawn::native
        #include "dawn/utils/ComboRenderPipelineDescriptor.h"
        #include "dawn/utils/WGPUHelpers.h"     // helper functions

    2. lib
        libabsl.a                               // common util lib
        libglslang.a                            // compile glsl to spirv
        libtint.a                               // translate spirv/wgsl to glsl/spirv/msl/hlsl
        libSPIRV-Tools.a                        // validation of spirv after tint translation for vulkan backend
        libdawn.a                               // implement of wgpu, include utils::WGPUHelpers

        each lib is merged by several libs, details see mergelib.sh

    3. create device

        a. need call utils::SetOpenGLGetProc() before anything
            this acquire opengl getproc of platform
            will move inside in future, so no need call it
        b. need call glDisable(GL_SCISSOR_TEST) after create device
            this is a bug
        c. need call dawnProcSetProcs 
            set dawn implementation to dawn::native not dawn::wire(client/server)
        d. need call backendProcs.deviceSetUncapturedErrorCallback
            set error log

        // example
        wgpu::Device MyWGPUPassImp::createDeviceByCppAPI() {
        
            utils::SetOpenGLGetProc();
            DawnProcTable backendProcs = dawn::native::GetProcs();
            dawnProcSetProcs(&backendProcs);
            
            wgpu::Instance instance;
            wgpu::InstanceDescriptor descriptor;
            descriptor.nextInChain = nullptr;
            instance = wgpu::CreateInstance(&descriptor);
            
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

    4. init 
        create device
        get queue
        create buffer
        create texture
        create render target
        create pipeline with glsl or wgsl
        create bindgroup to describe resource

    5. render

        create command encoder
        begin rendperpass
            renderpass set pipeline/bindGroup/vertexBuffer/indexBuffer
            renderpass draw
        finish renderpass and get command buffer
        submit command buffer to queue

    6. demo

        one wgpupass draw triangle to render target
        get textureid from render target by utils::getGLTextureId(wgpu::texture)
        one opengl present pass to draw texture to screen

    7. demo with native opengl instead of wgpu
        
        MyUIView.m 
        //#define USE_WGPU


    8. ndc

        y no need negative
        z no need transform
        uv no need flip

        
        https://matthewwellings.com/blog/the-new-vulkan-coordinate-system/
        https://www.w3.org/TR/webgpu/#coordinate-systems
        https://stackoverflow.com/a/58782808/2482283

        Vulkan glsl and spirv 
            NDC: +Y is down. Point(-1, -1) is at the top left corner. z[0,1]
            Framebuffer coordinate: +Y is down. Origin(0, 0) is at the bottom left corner.
            Texture coordinate: +Y is up. Origin(0, 0) is at the bottom left corner.

        OpenGL glsl 
            NDC: +Y is up. Point(-1, -1) is at the bottom left corner. z[-1, 1].
            Framebuffer coordinate: +Y is up. Origin(0, 0) is at the bottom left corner.
            Texture coordinate: +Y is up. Origin(0, 0) is at the bottom left corner.

        Metal == D3D
            NDC: +Y is up. Point(-1, -1) is at the bottom left corner. z[0,1]
            Framebuffer coordinate: +Y is down. Origin(0, 0) is at the top left corner.
            Texture coordinate: +Y is down. Origin(0, 0) is at the top left corner.
        D3D 
            NDC: +Y is up. Point(-1, -1) is at the bottom left corner. z[0,1]
            Framebuffer coordinate: +Y is down. Origin(0, 0) is at the top left corner.
            Texture coordinate: +Y is down. Origin(0, 0) is at the top left corner.

        WebGPU and WGSL == D3D
            NDC: +Y is up. Point(-1, -1) is at the bottom left corner. z[0,1]
            Framebuffer coordinate: +Y is down. Origin(0, 0) is at the top left corner.
            Texture coordinate: +Y is down. Origin(0, 0) is at the top left corner.

        issue: we write OpenGL glsl, but read it as Vulkan glsl, 
               so y is negative, z is in [0, 1]
               uv should flip


    9. shaders uniform

         uniform:  
            not support uniform except texture
            force use ubo

    10. shaders varying

        varying of es 300:
            correct:
                out vec2 vUV;
                in vec2 vUV;

            errro:
                layout(location=0) out vec2 vUV;
                layout(location=0) in vec2 vUV;

        input: #version 310 es or #version 450

            ES shaders for SPIR-V require version 310 or higher
            => #version 310 es

            GL shaders for SPIR-V require version 400 or higher
            => #version 400
            texture need binding
            => #version 450
        
        output: ios
            #version 300


        300 =>
            out vec2 vUV;  // error during glsl to spirv
        310 =>
            layout(location = 0) out vec2 vUV;  // error during glsl to ios shader

        bugfix in libtint:
            output remove layout(location = 0)


    11. lib size
        remove libSPIRV
        remove libglslang
        remove dawn_wire

    






        

        


       

        
        




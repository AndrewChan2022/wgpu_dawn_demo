rm -rf ./raw
mkdir ./raw

#dawn
cp  ../xcodeios2/src/dawn/samples/Release-iphoneos/libdawn_sample_utils.a ./raw/
cp  ../xcodeios2/src/dawn/Release-iphoneos/libdawncpp.a ./raw/
cp  ../xcodeios2/src/dawn/utils/Release-iphoneos/libdawn_utils.a ./raw/
cp  ../xcodeios2/src/dawn/Release-iphoneos/libdawn_proc.a ./raw/
cp  ../xcodeios2/src/dawn/native/Release-iphoneos/libdawn_native.a ./raw/
cp  ../xcodeios2/src/dawn/platform/Release-iphoneos/libdawn_platform.a ./raw/
cp  ../xcodeios2/src/dawn/wire/Release-iphoneos/libdawn_wire.a ./raw/
cp  ../xcodeios2/src/dawn/common/Release-iphoneos/libdawn_common.a ./raw/
cp  ../xcodeios2/src/dawn/Release-iphoneos/libdawncpp_headers.a ./raw/
cp  ../xcodeios2/src/dawn/Release-iphoneos/libdawn_headers.a ./raw/


# tint
cp  ../xcodeios2/src/tint/Release-iphoneos/libtint.a ./raw/
cp  ../xcodeios2/src/tint/Release-iphoneos/libtint_diagnostic_utils.a ./raw/

# absl
cp  ../xcodeios2/third_party/abseil/absl/strings/Release-iphoneos/libabsl_str_format_internal.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/strings/Release-iphoneos/libabsl_strings.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/strings/Release-iphoneos/libabsl_strings_internal.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/base/Release-iphoneos/libabsl_base.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/base/Release-iphoneos/libabsl_spinlock_wait.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/numeric/Release-iphoneos/libabsl_int128.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/base/Release-iphoneos/libabsl_throw_delegate.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/base/Release-iphoneos/libabsl_raw_logging_internal.a ./raw/
cp  ../xcodeios2/third_party/abseil/absl/base/Release-iphoneos/libabsl_log_severity.a ./raw/

# spirv
cp  ../xcodeios2/third_party/spirv-tools/source/opt/Release-iphoneos/libSPIRV-Tools-opt.a ./raw/
cp  ../xcodeios2/third_party/spirv-tools/source/Release-iphoneos/libSPIRV-Tools.a ./raw/

# glslang
cp  ../xcodeios2/third_party/glslang/SPIRV/Release-iphoneos/libSPIRV.a ./raw/
cp  ../xcodeios2/third_party/glslang/StandAlone/Release-iphoneos/libglslang-default-resource-limits.a ./raw/
cp  ../xcodeios2/third_party/glslang/glslang/Release-iphoneos/libglslang.a ./raw/
cp  ../xcodeios2/third_party/glslang/glslang/Release-iphoneos/libMachineIndependent.a ./raw/
cp  ../xcodeios2/third_party/glslang/glslang/OSDependent/Unix/Release-iphoneos/libOSDependent.a ./raw/
cp  ../xcodeios2/third_party/glslang/glslang/Release-iphoneos/libGenericCodeGen.a ./raw/
cp  ../xcodeios2/third_party/glslang/OGLCompilersDLL/Release-iphoneos/libOGLCompiler.a ./raw/
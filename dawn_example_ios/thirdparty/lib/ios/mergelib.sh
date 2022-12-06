rm -rf ./dawn
mkdir ./dawn


libtool -no_warning_for_no_symbols -static -o  ./dawn/libtint.a ./raw/libtint.a ./raw/libtint_diagnostic_utils.a

libtool -no_warning_for_no_symbols -static -o  ./dawn/libdawn.a \
./raw/libdawn_sample_utils.a ./raw/libdawn_utils.a \
./raw/libdawn_native.a ./raw/libdawn_common.a ./raw/libdawn_proc.a ./raw/libdawn_platform.a \
 ./raw/libdawncpp_headers.a  ./raw/libdawn_headers.a  ./raw/libdawncpp.a \
./raw/libdawn_wire.a

libtool -no_warning_for_no_symbols -static -o  ./dawn/libabsl.a \
./raw/libabsl_str_format_internal.a ./raw/libabsl_strings.a \
./raw/libabsl_strings_internal.a ./raw/libabsl_base.a \
./raw/libabsl_spinlock_wait.a ./raw/libabsl_int128.a \
./raw/libabsl_throw_delegate.a ./raw/libabsl_raw_logging_internal.a \
./raw/libabsl_log_severity.a 


libtool -no_warning_for_no_symbols -static -o  ./dawn/libSPIRV-Tools.a \
./raw/libSPIRV-Tools.a ./raw/libSPIRV-Tools-opt.a


libtool -no_warning_for_no_symbols -static -o  ./dawn/libglslang.a \
./raw/libSPIRV.a ./raw/libglslang-default-resource-limits.a \
./raw/libglslang.a ./raw/libMachineIndependent.a \
./raw/libOSDependent.a ./raw/libGenericCodeGen.a \
./raw/libOGLCompiler.a

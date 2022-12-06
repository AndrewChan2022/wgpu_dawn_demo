cmake_minimum_required (VERSION 3.7)


set(CMAKE_CXX_STANDARD "17")

########### xcode
set(DEVELOPMENT_PROJECT_NAME "wgputriangle_ios")                     # <== Set to your project name, e.g. project.xcodeproj
set(DEVELOPMENT_TEAM_ID "AAAAAAAAAA")                       # <== Set to your team ID from Apple
set(APP_NAME "wgputriangle")                                     # <== Set To your app's name
set(APP_BUNDLE_IDENTIFIER "com.soulapp.wgputriangle")                # <== Set to your app's bundle identifier
set(CODE_SIGN_IDENTITY "iPhone Developer")                  # <== Set to your preferred code sign identity, to see list:
                                                            # /usr/bin/env xcrun security find-identity -v -p codesigning
set(DEPLOYMENT_TARGET 14.0)                                  # <== Set your deployment target version of iOS
set(DEVICE_FAMILY "1")                                      # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
set(LOGIC_ONLY_TESTS 0)                                     # <== Set to 1 if you do not want tests to be hosted by the application, speeds up pure logic tests but you can not run them on real devices

project(${DEVELOPMENT_PROJECT_NAME})
include(BundleUtilities)
include(FindXCTest)

message(STATUS XCTestFound:${XCTest_FOUND})

set(PRODUCT_NAME ${APP_NAME})
set(EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_INFO_STRING ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_GUI_IDENTIFIER ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_BUNDLE_NAME ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_ICON_FILE "")
set(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
set(MACOSX_BUNDLE_COPYRIGHT "Copyright YOU")
set(MACOSX_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET})


########### source code


FUNCTION(R_SEARCH search_paths return_list)
    FOREACH(search_path ${search_paths})
        # POINT A
        R_SEARCH_INNER(${search_path} inner_return)
        SET(all_list ${all_list} ${inner_return})
    ENDFOREACH()
    SET(${return_list} ${all_list} PARENT_SCOPE)
ENDFUNCTION(R_SEARCH)


FUNCTION(R_SEARCH_INNER search_path return_list)
    FILE(GLOB_RECURSE new_list ${search_path}/*.h*)
    SET(dir_list "")
    FOREACH(file_path ${new_list})
        GET_FILENAME_COMPONENT(dir_path ${file_path} PATH)
        SET(dir_list ${dir_list} ${dir_path})
    ENDFOREACH()
    LIST(REMOVE_DUPLICATES dir_list)
    SET(${return_list} ${dir_list} PARENT_SCOPE)
ENDFUNCTION(R_SEARCH_INNER)


R_SEARCH("./glsrc" aaa)
include_directories(${aaa})

set(APP_HEADER_FILES
  ./src/AppDelegate.h
  ./src/ViewController.h
  ./src/Prefix.pch
)

set(APP_SOURCE_FILES
  ./src/AppDelegate.m
  ./src/ViewController.m
  ./src/main.m
)

file(GLOB_RECURSE APP_GLHeaders 
  ./glsrc/*.h
  ./glsrc/*.hpp
)

file(GLOB_RECURSE APP_GLSources 
  ./glsrc/*.m
  ./glsrc/*.mm
  ./glsrc/*.cpp
)

set(RESOURCES
  ./src/Main.storyboard
  ./src/LaunchScreen.storyboard
)


#set_property(GLOBAL PROPERTY USE_FOLDERS ON)

SET (ALL_SRCS
  ${APP_HEADER_FILES}
  ${APP_GLHeaders}
  ${APP_SOURCE_FILES}
  ${APP_GLSources}
)
source_group(TREE ${CMAKE_SOURCE_DIR} FILES ${ALL_SRCS})

add_executable(
    ${APP_NAME}
    MACOSX_BUNDLE  
    ${ALL_SRCS}
    ${RESOURCES}
)

########### include
include_directories(thirdparty/include)

########### link

# add other target
#target_link_libraries(${APP_NAME} dawn_sample_utils)

# find lib and add
#find_library(lib_absl NAMES libabsl PATHS ${LIBS_DIR} NO_DEFAULT_PATH)
#set(LIBS ${LIBS} ${PNG_LIB} ${Z_LIB} ${astcenc_LIB} ${ktx_write_LIB} ${ktx_LIB} ${objUtil_LIB})
#target_link_libraries(testktxwin PUBLIC  ${LIBS})

# explicty set lib path
add_library(libabsl STATIC IMPORTED)
set_target_properties(libabsl
        PROPERTIES
        IMPORTED_LOCATION
        ${PROJECT_SOURCE_DIR}/thirdparty/lib/iOS/dawn/libabsl.a
        )

add_library(libtint STATIC IMPORTED)
set_target_properties(libtint
        PROPERTIES
        IMPORTED_LOCATION
        ${PROJECT_SOURCE_DIR}/thirdparty/lib/iOS/dawn/libtint.a
        )

add_library(libglslang STATIC IMPORTED)
set_target_properties(libglslang
        PROPERTIES
        IMPORTED_LOCATION
        ${PROJECT_SOURCE_DIR}/thirdparty/lib/iOS/dawn/libglslang.a
        )

add_library(libSPIRV-Tools STATIC IMPORTED)
set_target_properties(libSPIRV-Tools
        PROPERTIES
        IMPORTED_LOCATION
        ${PROJECT_SOURCE_DIR}/thirdparty/lib/iOS/dawn/libSPIRV-Tools.a
        )

add_library(libdawn STATIC IMPORTED)
set_target_properties(libdawn
        PROPERTIES
        IMPORTED_LOCATION
        ${PROJECT_SOURCE_DIR}/thirdparty/lib/iOS/dawn/libdawn.a
        )

target_link_libraries(${APP_NAME} libabsl libtint libglslang libSPIRV-Tools libdawn)


#source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/glsrc FILES "${APP_GLSources}")
#source_group(TREE "SourceFiles" FILES "${APP_SOURCE_FILES}")



# To disable bitcode:
# set_target_properties(${APP_NAME} PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")

# To link a statically linked Framework from the filesystem:
# Note: dynamic frameworks require copying to the app bundle. Statically linked are copied into the executable itself.
# target_link_libraries(${APP_NAME} 
  # ${PROJECT_SOURCE_DIR}/Torch.framework
# )


# Include the same headers for the statically linked framework:
# Include headers to they're available as #import <Header/Header.h> from a framework
# target_include_directories(${APP_NAME}
  # PUBLIC ${PROJECT_SOURCE_DIR}/Torch.framework/Headers
# )


# Static Link a library archive into the executable
# target_link_libraries(${APP_NAME} 
#   ${PROJECT_SOURCE_DIR}/framework/lib/libtorch.a
# )


########### link

# Locate system libraries on iOS
find_library(UIKIT UIKit)
find_library(FOUNDATION Foundation)
find_library(MOBILECORESERVICES MobileCoreServices)
find_library(CFNETWORK CFNetwork)
find_library(SYSTEMCONFIGURATION SystemConfiguration)

find_library(CoreGraphicsFW CoreGraphics)
find_library(OpenGLESFW OpenGLES)
find_library(QuartzCoreFW QuartzCore)

# link the frameworks located above
target_link_libraries(${APP_NAME} ${UIKIT})
target_link_libraries(${APP_NAME} ${FOUNDATION})
target_link_libraries(${APP_NAME} ${MOBILECORESERVICES})
target_link_libraries(${APP_NAME} ${CFNETWORK})
target_link_libraries(${APP_NAME} ${SYSTEMCONFIGURATION})
target_link_libraries(${APP_NAME} ${CoreGraphicsFW})
target_link_libraries(${APP_NAME} ${OpenGLESFW})
target_link_libraries(${APP_NAME} ${QuartzCoreFW})


# Turn on ARC
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")


########### xcode property

# Create the app target
set_target_properties(${APP_NAME} PROPERTIES
                      XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
                      XCODE_ATTRIBUTE_GCC_PREFIX_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/src/Prefix.pch"
                      RESOURCE "${RESOURCES}"
                      XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES"
                      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
                      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODE_SIGN_IDENTITY}
                      XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
                      XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
                      MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/src/plist.in
                      XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
                      XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES NO
                      XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)"
                      XCODE_ATTRIBUTE_ENABLE_TESTABILITY YES
                      XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN YES
)


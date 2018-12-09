# CMakeLists.txt
#
cmake_minimum_required (VERSION 3.5)

project ("ctp" VERSION 2.0 LANGUAGES CXX)

add_compile_options (-std=c++17)
add_compile_options (-Wreturn-type)
add_compile_options (-Wmain)
add_compile_options (-Werror=return-type)
add_compile_options (-Werror=main)
add_compile_options (-Wall)
add_compile_options (-Wextra)
add_compile_options (-Wdeprecated)
add_compile_options (-Werror)
add_compile_options (-pedantic)
add_compile_options (-pipe)

include (.modules/Sanitizers.cmake)
enable_testing ()

if (CMAKE_BUILD_TYPE STREQUAL ""
 OR CMAKE_BUILD_TYPE MATCHES "[Dd]ebug")
  message ("-- Making Debug Build")
  add_compile_options (-fno-inline)
  add_compile_options (-ggdb3)
  add_compile_options (-O0)

elseif (CMAKE_BUILD_TYPE MATCHES "[Cc]overage")
  message ("-- Making Coverage Build")
  add_compile_options (-fno-inline-small-functions)
  add_compile_options (-fno-default-inline)
  add_compile_options (-ftest-coverage)
  add_compile_options (-fprofile-arcs)
  add_compile_options (-fno-inline)
  add_compile_options (-fPIC)
  add_compile_options (-O0)
  add_compile_options (-g)

elseif (CMAKE_BUILD_TYPE MATCHES "[Rr]elease")
  message ("-- Making Release Build")
  add_compile_options (-O3)

else ()
  message ("-- Unsupported CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")

endif ()

include_directories ("${PROJECT_SOURCE_DIR}")

#add_subdirectory (benchmark)
add_subdirectory (crf)
add_subdirectory (test)


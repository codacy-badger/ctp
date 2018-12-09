if (DEFINED ASAN)
  add_compile_options (-fsanitize=address)
  add_compile_options (-fno-omit-frame-pointer)
  add_compile_options (-fno-optimize-sibling-calls)
  message ("-- Making AddressSanitized build")
  message ("-- LD_PRELOAD=/usr/lib/libasan.so")

elseif (DEFINED TSAN)
  add_compile_options (-fsanitize=thread)
  add_compile_options (-fno-omit-frame-pointer)
  add_compile_options (-fno-optimize-sibling-calls)
  message ("-- Making ThreadSanitized build")

endif ()

function (add_executable __target)
  _add_executable (${__target}  ${ARGN})
  if (DEFINED ASAN)
    target_link_libraries (${__target} asan)
    message ("-- Linking libasan to ${__target}")

  elseif (DEFINED TSAN)
    target_link_libraries (${__target} tsan)
    message ("-- Linking libtsan to ${__target}")

  elseif (CMAKE_BUILD_TYPE MATCHES "[Cc]overage")
    target_link_libraries (${__target} gcov)
    message ("-- Linking libgcov to ${__target}")

  endif ()
  set_target_properties (${__target} PROPERTIES 
    LINKER_LANGUAGE CXX
  )
endfunction (add_executable)

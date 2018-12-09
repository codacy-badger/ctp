# test/unit/CMakeLists.txt
#
add_executable (leaky "leaky.cc")
add_executable (racy  "racy.cc")
target_link_libraries (racy pthread)
add_executable (units
  "runner.cc"
)
target_link_libraries (units
  gtest
  pthread
)

gtest_add_tests (TARGET units)

add_custom_target (asan-check
  COMMAND echo '[[ \"`./test/unit/leaky 2>&1 | grep \"memory leak\"`\" != \"\" ]] && exit 0 || exit 1'
          > ${PROJECT_BINARY_DIR}/asan-check
       && chmod a+x ${PROJECT_BINARY_DIR}/asan-check
       && echo "[asan-check]"
       && cat ${PROJECT_BINARY_DIR}/asan-check
)
add_dependencies (asan-check leaky)
add_custom_target (tsan-check
  COMMAND echo '[[ \"`./test/unit/racy 2>&1 | grep \"data race\"`\" != \"\" ]] && exit 0 || exit 1'
          > ${PROJECT_BINARY_DIR}/tsan-check
       && chmod a+x ${PROJECT_BINARY_DIR}/tsan-check
       && echo "[tsan-check]"
       && cat ${PROJECT_BINARY_DIR}/tsan-check
)
add_dependencies (tsan-check racy)
add_dependencies (units asan-check tsan-check)

install (
  TARGETS leaky racy
  DESTINATION "${PROJECT_BINARY_DIR}"
)

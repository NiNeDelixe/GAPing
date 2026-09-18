include(cmake/SystemLink.cmake)
include(cmake/LibFuzzer.cmake)
include(CMakeDependentOption)
include(CheckCXXCompilerFlag)


include(CheckCXXSourceCompiles)


macro(GAPing_supports_sanitizers)
  # Emscripten doesn't support sanitizers
  if(EMSCRIPTEN)
    set(SUPPORTS_UBSAN OFF)
    set(SUPPORTS_ASAN OFF)
  elseif((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND NOT WIN32)

    message(STATUS "Sanity checking UndefinedBehaviorSanitizer, it should be supported on this platform")
    set(TEST_PROGRAM "int main() { return 0; }")

    # Check if UndefinedBehaviorSanitizer works at link time
    set(CMAKE_REQUIRED_FLAGS "-fsanitize=undefined")
    set(CMAKE_REQUIRED_LINK_OPTIONS "-fsanitize=undefined")
    check_cxx_source_compiles("${TEST_PROGRAM}" HAS_UBSAN_LINK_SUPPORT)

    if(HAS_UBSAN_LINK_SUPPORT)
      message(STATUS "UndefinedBehaviorSanitizer is supported at both compile and link time.")
      set(SUPPORTS_UBSAN ON)
    else()
      message(WARNING "UndefinedBehaviorSanitizer is NOT supported at link time.")
      set(SUPPORTS_UBSAN OFF)
    endif()
  else()
    set(SUPPORTS_UBSAN OFF)
  endif()

  if((CMAKE_CXX_COMPILER_ID MATCHES ".*Clang.*" OR CMAKE_CXX_COMPILER_ID MATCHES ".*GNU.*") AND WIN32)
    set(SUPPORTS_ASAN OFF)
  else()
    if (NOT WIN32)
      message(STATUS "Sanity checking AddressSanitizer, it should be supported on this platform")
      set(TEST_PROGRAM "int main() { return 0; }")

      # Check if AddressSanitizer works at link time
      set(CMAKE_REQUIRED_FLAGS "-fsanitize=address")
      set(CMAKE_REQUIRED_LINK_OPTIONS "-fsanitize=address")
      check_cxx_source_compiles("${TEST_PROGRAM}" HAS_ASAN_LINK_SUPPORT)

      if(HAS_ASAN_LINK_SUPPORT)
        message(STATUS "AddressSanitizer is supported at both compile and link time.")
        set(SUPPORTS_ASAN ON)
      else()
        message(WARNING "AddressSanitizer is NOT supported at link time.")
        set(SUPPORTS_ASAN OFF)
      endif()
    else()
      set(SUPPORTS_ASAN ON)
    endif()
  endif()
endmacro()

macro(GAPing_setup_options)
  option(GAPing_ENABLE_HARDENING "Enable hardening" ON)
  option(GAPing_ENABLE_COVERAGE "Enable coverage reporting" OFF)
  cmake_dependent_option(
    GAPing_ENABLE_GLOBAL_HARDENING
    "Attempt to push hardening options to built dependencies"
    ON
    GAPing_ENABLE_HARDENING
    OFF)

  GAPing_supports_sanitizers()

  if(NOT PROJECT_IS_TOP_LEVEL OR GAPing_PACKAGING_MAINTAINER_MODE)
    option(GAPing_ENABLE_IPO "Enable IPO/LTO" OFF)
    option(GAPing_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(GAPing_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(GAPing_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(GAPing_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(GAPing_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(GAPing_ENABLE_PCH "Enable precompiled headers" OFF)
    option(GAPing_ENABLE_CACHE "Enable ccache" OFF)
  elseif(ENABLE_DEVELOPER_MODE)
    option(GAPing_ENABLE_IPO "Enable IPO/LTO" ON)
    option(GAPing_WARNINGS_AS_ERRORS "Treat Warnings As Errors" ON)
    option(GAPing_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" ${SUPPORTS_ASAN})
    option(GAPing_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" ${SUPPORTS_UBSAN})
    option(GAPing_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(GAPing_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(GAPing_ENABLE_CLANG_TIDY "Enable clang-tidy" ON)
    option(GAPing_ENABLE_CPPCHECK "Enable cpp-check analysis" ON)
    option(GAPing_ENABLE_PCH "Enable precompiled headers" OFF)
    option(GAPing_ENABLE_CACHE "Enable ccache" ON)
  else()
    option(GAPing_ENABLE_IPO "Enable IPO/LTO" ON)
    option(GAPing_WARNINGS_AS_ERRORS "Treat Warnings As Errors" OFF)
    option(GAPing_ENABLE_SANITIZER_ADDRESS "Enable address sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_LEAK "Enable leak sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_UNDEFINED "Enable undefined sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_THREAD "Enable thread sanitizer" OFF)
    option(GAPing_ENABLE_SANITIZER_MEMORY "Enable memory sanitizer" OFF)
    option(GAPing_ENABLE_UNITY_BUILD "Enable unity builds" OFF)
    option(GAPing_ENABLE_CLANG_TIDY "Enable clang-tidy" OFF)
    option(GAPing_ENABLE_CPPCHECK "Enable cpp-check analysis" OFF)
    option(GAPing_ENABLE_PCH "Enable precompiled headers" OFF)
    option(GAPing_ENABLE_CACHE "Enable ccache" ON)
  endif()

  if(NOT PROJECT_IS_TOP_LEVEL)
    mark_as_advanced(
      GAPing_ENABLE_IPO
      GAPing_WARNINGS_AS_ERRORS
      GAPing_ENABLE_SANITIZER_ADDRESS
      GAPing_ENABLE_SANITIZER_LEAK
      GAPing_ENABLE_SANITIZER_UNDEFINED
      GAPing_ENABLE_SANITIZER_THREAD
      GAPing_ENABLE_SANITIZER_MEMORY
      GAPing_ENABLE_UNITY_BUILD
      GAPing_ENABLE_CLANG_TIDY
      GAPing_ENABLE_CPPCHECK
      GAPing_ENABLE_LIZARD
      GAPing_ENABLE_BLOATY
      GAPing_ENABLE_COVERAGE
      GAPing_ENABLE_PCH
      GAPing_ENABLE_CACHE)
  endif()

  GAPing_check_libfuzzer_support(LIBFUZZER_SUPPORTED)
  if(LIBFUZZER_SUPPORTED AND (GAPing_ENABLE_SANITIZER_ADDRESS OR GAPing_ENABLE_SANITIZER_THREAD OR GAPing_ENABLE_SANITIZER_UNDEFINED))
    set(DEFAULT_FUZZER ON)
  else()
    set(DEFAULT_FUZZER OFF)
  endif()

  option(GAPing_BUILD_FUZZ_TESTS "Enable fuzz testing executable" ${DEFAULT_FUZZER})

endmacro()

macro(GAPing_global_options)
  if(GAPing_ENABLE_IPO)
    include(cmake/InterproceduralOptimization.cmake)
    GAPing_enable_ipo()
  endif()

  GAPing_supports_sanitizers()

  if(GAPing_ENABLE_HARDENING AND GAPing_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR GAPing_ENABLE_SANITIZER_UNDEFINED
       OR GAPing_ENABLE_SANITIZER_ADDRESS
       OR GAPing_ENABLE_SANITIZER_THREAD
       OR GAPing_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    message("${GAPing_ENABLE_HARDENING} ${ENABLE_UBSAN_MINIMAL_RUNTIME} ${GAPing_ENABLE_SANITIZER_UNDEFINED}")
    GAPing_enable_hardening(GAPing_options ON ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()
endmacro()

macro(GAPing_local_options)
  if(PROJECT_IS_TOP_LEVEL)
    include(cmake/StandardProjectSettings.cmake)
  endif()

  add_library(GAPing_warnings INTERFACE)
  add_library(GAPing_options INTERFACE)

  include(cmake/CompilerWarnings.cmake)
  GAPing_set_project_warnings(
    GAPing_warnings
    ${GAPing_WARNINGS_AS_ERRORS}
    ""
    ""
    ""
    "")

  include(cmake/Linker.cmake)
  # Must configure each target with linker options, we're avoiding setting it globally for now

  if(NOT EMSCRIPTEN)
    include(cmake/Sanitizers.cmake)
    GAPing_enable_sanitizers(
      GAPing_options
      ${GAPing_ENABLE_SANITIZER_ADDRESS}
      ${GAPing_ENABLE_SANITIZER_LEAK}
      ${GAPing_ENABLE_SANITIZER_UNDEFINED}
      ${GAPing_ENABLE_SANITIZER_THREAD}
      ${GAPing_ENABLE_SANITIZER_MEMORY})
  endif()

  set_target_properties(GAPing_options PROPERTIES UNITY_BUILD ${GAPing_ENABLE_UNITY_BUILD})

  if(GAPing_ENABLE_PCH)
    target_precompile_headers(
      GAPing_options
      INTERFACE
      <vector>
      <string>
      <utility>)
  endif()

  if(GAPing_ENABLE_CACHE)
    include(cmake/Cache.cmake)
    GAPing_enable_cache()
  endif()

  include(cmake/StaticAnalyzers.cmake)
  if(GAPing_ENABLE_CLANG_TIDY)
    GAPing_enable_clang_tidy(GAPing_options ${GAPing_WARNINGS_AS_ERRORS})
  endif()

  if(GAPing_ENABLE_CPPCHECK)
    GAPing_enable_cppcheck(${GAPing_WARNINGS_AS_ERRORS} "" # override cppcheck options
    )
  endif()
  
  if(GAPing_ENABLE_LIZARD)
    GAPing_enable_lizard(${GAPing_WARNINGS_AS_ERRORS})
  endif()
  
  if(GAPing_ENABLE_BLOATY)
    GAPing_enable_bloaty()
  endif()

  if(GAPing_ENABLE_COVERAGE)
    include(cmake/Tests.cmake)
    GAPing_enable_coverage(GAPing_options)
  endif()

  if(GAPing_WARNINGS_AS_ERRORS)
    check_cxx_compiler_flag("-Wl,--fatal-warnings" LINKER_FATAL_WARNINGS)
    if(LINKER_FATAL_WARNINGS)
      # This is not working consistently, so disabling for now
      target_link_options(GAPing_options INTERFACE -Wl,--fatal-warnings)
    endif()
  endif()

  if(GAPing_ENABLE_HARDENING AND NOT GAPing_ENABLE_GLOBAL_HARDENING)
    include(cmake/Hardening.cmake)
    if(NOT SUPPORTS_UBSAN 
       OR GAPing_ENABLE_SANITIZER_UNDEFINED
       OR GAPing_ENABLE_SANITIZER_ADDRESS
       OR GAPing_ENABLE_SANITIZER_THREAD
       OR GAPing_ENABLE_SANITIZER_LEAK)
      set(ENABLE_UBSAN_MINIMAL_RUNTIME FALSE)
    else()
      set(ENABLE_UBSAN_MINIMAL_RUNTIME TRUE)
    endif()
    GAPing_enable_hardening(GAPing_options OFF ${ENABLE_UBSAN_MINIMAL_RUNTIME})
  endif()

endmacro()

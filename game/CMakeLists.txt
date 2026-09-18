cmake_minimum_required(VERSION 3.10)

project(Game)
set(EXECUTABLE_NAME "EvilGodSimulator")

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.cpp")
file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "src/*.h")

add_executable(${EXECUTABLE_NAME} ${SOURCES} ${HEADERS})

set_target_properties(${EXECUTABLE_NAME}
    PROPERTIES
        WIN32_EXECUTABLE TRUE
        LINK_FLAGS_DEBUG "/SUBSYSTEM:CONSOLE"
        LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup"
)

include(Dependencies.cmake)
GAPing_setup_dependencies()

target_link_libraries(${EXECUTABLE_NAME}
    PUBLIC
        Engine::Core
        cpptrace::cpptrace
        ng-log::ng-log
        GAP::GAP
        piper
        onnxruntime
        FlatBuffers
        #onnxruntime::onnxruntime
)

# add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different
#         "$<TARGET_FILE:piper>"
#         "$<TARGET_FILE_DIR:${EXECUTABLE_NAME}>/"
# )
# if (WIN32)
#     file(GLOB ORT_SHARED_LIBS "${ORT_LIBRARY_DIR}/*.dll")
# elseif (APPLE)
#     file(GLOB ORT_SHARED_LIBS "${ORT_LIBRARY_DIR}/*.dylib")
# else()
#     file(GLOB ORT_SHARED_LIBS "${ORT_LIBRARY_DIR}/*.so" "${ORT_LIBRARY_DIR}/*.so.*")
# endif()

# add_custom_command(TARGET ${EXECUTABLE_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different
#         ${ORT_SHARED_LIBS}
#         $<TARGET_FILE_DIR:${EXECUTABLE_NAME}>
# )

target_include_directories(${EXECUTABLE_NAME} PUBLIC "${PROJECT_SOURCE_DIR}/src")

execute_process(
    COMMAND ${CMAKE_COMMAND} -E create_symlink
    "${CMAKE_CURRENT_SOURCE_DIR}/resources"
    "${CMAKE_CURRENT_BINARY_DIR}/resources"
)

#file(GLOB_RECURSE RESOURCES "${CMAKE_CURRENT_SOURCE_DIR}/resources/*")
#file(COPY ${RESOURCES} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/resources")


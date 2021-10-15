cmake_minimum_required(VERSION 3.10)


project(Hello)

add_executable(Hello main.cpp)

add_subdirectory(greetlib)

target_link_libraries(Hello PUBLIC greetlib)

target_include_directories(Hello PUBLIC
                          "${PROJECT_BINARY_DIR}"
                          "${PROJECT_SOURCE_DIR}/greetlib"
                          )


add_library(greetlib greet.hpp greet.cpp)

target_include_directories (greetlib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

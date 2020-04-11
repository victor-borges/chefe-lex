cmake_minimum_required(VERSION 3.7)
project(chefe-lexer)

set(CMAKE_C_STANDARD 11)

find_package(FLEX REQUIRED)
set(FLEX_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/chefe-lexer.c)
if(FLEX_FOUND)
    FLEX_TARGET(chefe-lexer chefe-lexer.l  ${FLEX_OUTPUT})
endif()

add_executable(${PROJECT_NAME} ${FLEX_OUTPUT})

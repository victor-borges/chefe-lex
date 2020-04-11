cmake_minimum_required(VERSION 3.7)
project(calc)

set(CMAKE_C_STANDARD 11)

FIND_PACKAGE(FLEX REQUIRED)
SET(FLEX_OUTPUT ${CMAKE_SOURCE_DIR}/scanner.c)
IF(FLEX_FOUND)
    ADD_CUSTOM_COMMAND(
            OUTPUT ${FLEX_OUTPUT}
            COMMAND ${FLEX_EXECUTABLE}
            ${CMAKE_SOURCE_DIR}/chefe-lexer.l
            COMMENT "Generating chefe-lexer.l"
    )
ENDIF()

add_executable(${PROJECT_NAME} ${FLEX_OUTPUT})

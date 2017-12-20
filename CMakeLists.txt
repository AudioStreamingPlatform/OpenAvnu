cmake_minimum_required (VERSION 2.8) 
project (open-avb)

set(C++11 ON CACHE BOOL "Compile with C++11 support" FORCE)
set (CMAKE_CXX_STANDARD 11)

add_subdirectory("daemons/gptp")


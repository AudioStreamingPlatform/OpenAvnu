cmake_minimum_required (VERSION 3.1)
project (gptp)

set (CMAKE_CXX_STANDARD 11)

include_directories( "./common" )
file(GLOB GPTP_COMMON "./common/*.cpp" "./common/*.c")

option(MOZART "Build for Mozart" ON)
option(SYSTEMD_WATCHDOG "Include Systemd watchdog support" OFF)

if(MOZART)
  add_definitions(-DMOZART -DAPTP -DAPTP_IPV4)
endif(MOZART)

if(UNIX)
  include_directories( include "./linux/src" )
  file(GLOB GPTP_OS "${CMAKE_CURRENT_SOURCE_DIR}/linux/src/*.cpp")
  if(MOZART)
    list(REMOVE_ITEM GPTP_OS "${CMAKE_CURRENT_SOURCE_DIR}/linux/src/linux_hal_intelce.cpp")
    list(REMOVE_ITEM GPTP_OS "${CMAKE_CURRENT_SOURCE_DIR}/linux/src/linux_hal_i210.cpp")
    list(REMOVE_ITEM GPTP_OS "${CMAKE_CURRENT_SOURCE_DIR}/linux/src/linux_hal_rpi3.cpp")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -lsystemd")
  endif(MOZART)
  if(NOT SYSTEMD_WATCHDOG)
    list(REMOVE_ITEM GPTP_OS "${CMAKE_CURRENT_SOURCE_DIR}/linux/src/watchdog.cpp")
  endif(NOT SYSTEMD_WATCHDOG)
  message("GPTP_OS: ${GPTP_OS}")
  message("SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")
  add_executable (gptp ${GPTP_COMMON} ${GPTP_OS})
  target_link_libraries(gptp pthread rt)
elseif(WIN32)
  if( CMAKE_SIZEOF_VOID_P EQUAL 8 )
    link_directories($ENV{WPCAP_DIR}/Lib/x64)
  elseif( CMAKE_SIZEOF_VOID_P EQUAL 4 )
    link_directories($ENV{WPCAP_DIR}/Lib)
  endif()

  # HAVE_REMOTE change pcap include options
  add_definitions(-D_CRT_SECURE_NO_WARNINGS -DHAVE_REMOTE)
  include_directories( include "./windows/daemon_cl" $ENV{WPCAP_DIR}/Include )
  file(GLOB GPTP_OS "./windows/daemon_cl/*.cpp" "./windows/daemon_cl/gptp.manifest")
  add_executable (gptp ${GPTP_COMMON} ${GPTP_OS})
  target_link_libraries(gptp wpcap Iphlpapi Ws2_32)

  add_subdirectory("windows/named_pipe_test")

endif()


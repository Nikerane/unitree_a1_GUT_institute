
######################################


cmake_minimum_required(VERSION 2.8.3)
project(unitree_legged_real)

set(CMAKE_CXX_FLAGS "-O3 -fPIC -std=c++11")

find_package(catkin REQUIRED COMPONENTS
    roscpp
    geometry_msgs
    unitree_legged_msgs
    # unitree_legged_sdk # This was correctly commented out
)

# Find LCM
find_package(PkgConfig REQUIRED)
pkg_check_modules(LCM REQUIRED lcm) # This finds lcm via pkg-config

if(LCM_FOUND)
    include_directories(${LCM_INCLUDE_DIRS})
    message(STATUS "Found LCM: Adding include dir: ${LCM_INCLUDE_DIRS} and link libs: ${LCM_LIBRARIES}")
else()
    message(FATAL_ERROR "LCM not found by pkg-config. Please install liblcm-dev.")
endif()

# ... (your existing find_library for UNITREE_LEGGED_SDK_LIB_FILE) ...
# set(EXTRA_LIBS -pthread ${FOUND_UNITREE_LEGGED_LIB_FILE}) # Your old line

# Modify EXTRA_LIBS or target_link_libraries directly
# For EXTRA_LIBS:
# set(EXTRA_LIBS -pthread ${FOUND_UNITREE_LEGGED_LIB_FILE} ${LCM_LIBRARIES})

# Or more commonly, add it directly to target_link_libraries for each target
# For example, for twist_sub:
#target_link_libraries(twist_sub
#  ${EXTRA_LIBS}       # This already has pthread and FOUND_UNITREE_LEGGED_LIB_FILE
#  ${catkin_LIBRARIES}
#  ${LCM_LIBRARIES}    # Add LCM libraries here
#)




set(UNITREE_LEGGED_SDK_ROOT_DIR "/home/unitree/nikhil_ws/src/unitree_ros/unitree_ros_to_real/unitree_legged_sdk")
message(STATUS "Using Unitree Legged SDK from: ${UNITREE_LEGGED_SDK_ROOT_DIR}")

catkin_package() 

message("-- CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
if("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "x86_64.*")
  set(ARCH amd64)
else()
  set(ARCH arm64) # This correctly identifies your system
endif()
message(STATUS "Targeting ARCH: ${ARCH}")

# Correctly add the SDK's include directory
# This path should contain the 'unitree_legged_sdk' subdirectory with the headers.
# e.g., ${UNITREE_LEGGED_SDK_ROOT_DIR}/include/unitree_legged_sdk/unitree_legged_sdk.h
include_directories(
    include # For project's own headers in its 'include' folder
    ${catkin_INCLUDE_DIRS}
    ${UNITREE_LEGGED_SDK_ROOT_DIR}/include # Add the SDK's main include folder
)

# Find the specific Unitree Legged SDK library file
# The library files are named like libunitree_legged_sdk_arm64.so, etc.
find_library(FOUND_UNITREE_LEGGED_LIB_FILE # This variable will store the full path to the library
             NAMES unitree_legged_sdk_${ARCH} # Looks for libunitree_legged_sdk_arm64.so or libunitree_legged_sdk_amd64.so
             PATHS ${UNITREE_LEGGED_SDK_ROOT_DIR}/lib # Search in the 'lib' subfolder of your SDK root
             NO_DEFAULT_PATH) # Only search the specified path

if(NOT FOUND_UNITREE_LEGGED_LIB_FILE)
    message(FATAL_ERROR "Unitree Legged SDK library (looking for 'libunitree_legged_sdk_${ARCH}.so') NOT FOUND in ${UNITREE_LEGGED_SDK_ROOT_DIR}/lib. Please check UNITREE_LEGGED_SDK_ROOT_DIR and that the library for ARCH='${ARCH}' exists.")
else()
    message(STATUS "Found Unitree Legged SDK library: ${FOUND_UNITREE_LEGGED_LIB_FILE}")
endif()

# Set EXTRA_LIBS to include pthread and the found Unitree Legged SDK library
set(EXTRA_LIBS -pthread ${FOUND_UNITREE_LEGGED_LIB_FILE})

# --- Your executables ---
# Example for one, applies to all:
add_executable(ros_example_walk src/exe/example_walk.cpp)
target_link_libraries(ros_example_walk ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(ros_example_walk ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

# (Repeat for your other executables: ros_example_position, state_sub, ros_udp, control_via_keyboard, twist_sub)



add_executable(ros_example_position src/exe/example_position.cpp)
target_link_libraries(ros_example_position ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(ros_example_position ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

add_executable(state_sub src/exe/state_sub.cpp)
target_link_libraries(state_sub ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(state_sub ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

add_executable(ros_udp src/exe/ros_udp.cpp)
target_link_libraries(ros_udp ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(ros_udp ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

add_executable(control_via_keyboard src/exe/control_via_keyboard.cpp)
target_link_libraries(control_via_keyboard ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(control_via_keyboard ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

add_executable(twist_sub src/exe/twist_sub.cpp)
target_link_libraries(twist_sub ${EXTRA_LIBS} ${catkin_LIBRARIES} ${LCM_LIBRARIES})
add_dependencies(twist_sub ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
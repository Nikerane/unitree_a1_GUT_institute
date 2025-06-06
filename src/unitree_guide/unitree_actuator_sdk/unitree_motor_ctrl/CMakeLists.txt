cmake_minimum_required(VERSION 2.8.3)
project(unitree_motor_ctrl)

## Compile as C++11, supported in ROS Kinetic and newer
# add_compile_options(-std=c++11)

## Find catkin macros and libraries
find_package(catkin REQUIRED COMPONENTS
  roscpp
)

## System dependencies are found with CMake's conventions
# find_package(Boost REQUIRED COMPONENTS system)

## Uncomment this if the package has a setup.py. This macro ensures
## modules and global scripts declared therein get installed
# catkin_python_setup()

################################################
## Declare ROS messages, services and actions ##
################################################
# (All message/service/action generation is commented out as in your original file)
# ## Generate messages in the 'msg' folder
# # add_message_files(
# #   FILES
# #   Message1.msg
# #   Message2.msg
# # )
# ## Generate services in the 'srv' folder
# # add_service_files(
# #   FILES
# #   Service1.srv
# #   Service2.srv
# # )
# ## Generate actions in the 'action' folder
# # add_action_files(
# #   FILES
# #   Action1.action
# #   Action2.action
# # )
# ## Generate added messages and services with any dependencies listed here
# # generate_messages(
# #   DEPENDENCIES
# #   std_msgs  # Or other packages containing msgs
# # )

################################################
## Declare ROS dynamic reconfigure parameters ##
################################################
# (Dynamic reconfigure is commented out as in your original file)
# ## Generate dynamic reconfigure parameters in the 'cfg' folder
# # generate_dynamic_reconfigure_options(
# #   cfg/DynReconf1.cfg
# #   cfg/DynReconf2.cfg
# # )

###################################
## catkin specific configuration ##
###################################
catkin_package(
#  INCLUDE_DIRS include  # Uncomment if you have headers in 'include' to be used by other packages
#  LIBRARIES ${PROJECT_NAME} # Uncomment if this project builds a library to be used by other packages
#  CATKIN_DEPENDS roscpp
#  DEPENDS system_lib
)

###########################################################################
## Manually Find and Link Unitree Motor SDK (Corrected Section)          ##
###########################################################################

# 1. Determine Architecture Suffix for library name
if("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "x86_64.*")
  # For x86_64, your motor SDK files are named with "Linux64" (e.g., libUnitree_motor_SDK_Linux64.so)
  set(MOTOR_SDK_ARCH_SUFFIX Linux64)
else()
  # For your aarch64 system, your motor SDK files are named with "ARM64" (e.g., libUnitree_motor_SDK_ARM64.so)
  set(MOTOR_SDK_ARCH_SUFFIX ARM64) # Note: Changed from arm64 to ARM64 to match your file names
endif()
message(STATUS "unitree_motor_ctrl: Targeting Motor SDK with ARCH_SUFFIX: ${MOTOR_SDK_ARCH_SUFFIX}")

# 2. Define the Root Directory of your Unitree ACTUATOR/MOTOR SDK
#    This is the directory containing 'lib' and potentially 'include' subfolders for the motor SDK.
#    USER: VERY IMPORTANT - VERIFY this path is correct for YOUR motor/actuator SDK location.
set(UNITREE_MOTOR_SDK_ROOT_DIR "/home/unitree/nikhil_ws/src/unitree_guide/unitree_actuator_sdk")
message(STATUS "unitree_motor_ctrl: Using Unitree Motor SDK from: ${UNITREE_MOTOR_SDK_ROOT_DIR}")

# 3. Add SDK Include Directories
#    If your src/check.cpp (or other source files) needs headers from the motor SDK,
#    ensure they are in ${UNITREE_MOTOR_SDK_ROOT_DIR}/include
include_directories(
  include/unitree_motor_ctrl   # Project's own headers (if any in this subfolder, e.g. include/unitree_motor_ctrl/my_header.h)
  ${catkin_INCLUDE_DIRS}
  ${UNITREE_MOTOR_SDK_ROOT_DIR}/include # Add this if motor SDK has headers in an 'include' folder
)

# 4. Find the specific Unitree Motor SDK library file
#    This will look for libUnitree_motor_SDK_ARM64.so or libUnitree_motor_SDK_Linux64.so
find_library(FOUND_UNITREE_MOTOR_LIBRARY_PATH # Variable to store the full path to the library
             NAMES Unitree_motor_SDK_${MOTOR_SDK_ARCH_SUFFIX} # e.g., Unitree_motor_SDK_ARM64
             PATHS ${UNITREE_MOTOR_SDK_ROOT_DIR}/lib         # Search in the 'lib' subfolder of the SDK
             NO_DEFAULT_PATH)                               # Only search the specified path

if(NOT FOUND_UNITREE_MOTOR_LIBRARY_PATH)
    message(FATAL_ERROR "unitree_motor_ctrl: Unitree Motor SDK library (looking for 'libUnitree_motor_SDK_${MOTOR_SDK_ARCH_SUFFIX}.so') NOT FOUND in ${UNITREE_MOTOR_SDK_ROOT_DIR}/lib. Please check UNITREE_MOTOR_SDK_ROOT_DIR, the library name, and MOTOR_SDK_ARCH_SUFFIX. Ensure the library file exists and has the correct name.")
else()
    message(STATUS "unitree_motor_ctrl: Found Unitree Motor SDK library: ${FOUND_UNITREE_MOTOR_LIBRARY_PATH}")
endif()

###########################################################################
## Build ##
###########################################################################

## Declare a C++ executable
add_executable(${PROJECT_NAME}_node src/check.cpp)

## Specify libraries to link a library or executable target against
target_link_libraries(${PROJECT_NAME}_node
  ${catkin_LIBRARIES}
  ${FOUND_UNITREE_MOTOR_LIBRARY_PATH} # Use the full path found by find_library
)

# The old link_directories line from your file is removed as find_library with PATHS is more explicit.
# The find_library block for "unitree_legged_sdk" from your file is removed as it was incorrect here.

#############
## Install ##
#############
# (All install rules are commented out as in your original file)
# ## Mark executables for installation
# # install(TARGETS ${PROJECT_NAME}_node
# #   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# # )
# ## Mark libraries for installation
# # install(TARGETS ${PROJECT_NAME}
# #   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
# #   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
# #   RUNTIME DESTINATION ${CATKIN_GLOBAL_BIN_DESTINATION}
# # )
# ## Mark cpp header files for installation
# # install(DIRECTORY include/${PROJECT_NAME}/
# #   DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
# #   FILES_MATCHING PATTERN "*.h"
# #   PATTERN ".svn" EXCLUDE
# # )
# ## Mark other files for installation
# # install(FILES
# #   # myfile1
# #   # myfile2
# #   DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
# # )

#############
## Testing ##
#############
# (All testing rules are commented out as in your original file)
# ## Add gtest based cpp test target and link libraries
# # catkin_add_gtest(${PROJECT_NAME}-test test/test_test_so.cpp)
# # if(TARGET ${PROJECT_NAME}-test)
# #   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# # endif()
# ## Add folders to be run by python nosetests
# # catkin_add_nosetests(test)
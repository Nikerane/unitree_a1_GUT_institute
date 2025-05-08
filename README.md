# Unitree_A1_GUT_institute

Check Wiki for more info

Major issuses detected in the following files after directly cloning them from unitree repo:

```
/home/unitree/nikhil_ws/src/unitree_ros/unitree_ros_to_real/unitree_legged_real/CMakeLists.txt
```
This CMakeLists.txt was modified to manually integrate the Unitree Legged SDK because it's not set up as a standard Catkin package discoverable by find_package. The changes involve removing unitree_legged_sdk from find_package(catkin ...) and instead using a user-defined UNITREE_LEGGED_SDK_ROOT_DIR variable to specify the SDK's location. Include directories are now added directly from this path, and find_library is used to locate the correct architecture-specific SDK library (e.g., for arm64), which is then explicitly linked. Users must ensure UNITREE_LEGGED_SDK_ROOT_DIR points to the correct SDK version containing the appropriate libraries and headers.

```
/home/unitree/nikhil_ws/src/unitree_ros/unitree_ros_to_real/unitree_legged_sdk/include/unitree_legged_sdk/comm.h 
```
In this header file, we need to replace this file with the latest version of the comm.h file as few struct types are not defined in v3.3.4 and v 3.2 which are recommended for A1 robot (unitree_ros_to_real)


Packages are getting build except for two nodes are not getting compiled (twist_sub and ros_udp), i have commented them out for now. Thez are located in 

```
/home/unitree/nikhil_ws/src/unitree_ros/unitree_ros_to_real/unitree_legged_real/CMakeLists.txt
```

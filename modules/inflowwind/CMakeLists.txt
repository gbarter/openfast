#
# Copyright 2023 National Renewable Energy Laboratory
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if (GENERATE_TYPES)
  generate_f90_types(src/IfW_FlowField.txt ${CMAKE_CURRENT_LIST_DIR}/src/IfW_FlowField_Types.f90 -noextrap)
  generate_f90_types(src/InflowWind_IO.txt ${CMAKE_CURRENT_LIST_DIR}/src/InflowWind_IO_Types.f90 -noextrap)
  generate_f90_types(src/Lidar.txt ${CMAKE_CURRENT_LIST_DIR}/src/Lidar_Types.f90)
  generate_f90_types(src/InflowWind.txt ${CMAKE_CURRENT_LIST_DIR}/src/InflowWind_Types.f90)
  generate_f90_types(src/InflowWind_Driver_Registry.txt ${CMAKE_CURRENT_LIST_DIR}/src/InflowWind_Driver_Types.f90 -noextrap)
endif()

# InflowWind object library
add_library(ifwlib STATIC
  src/IfW_FlowField_Types.f90
  src/IfW_FlowField.f90
  src/InflowWind_IO_Types.f90
  src/InflowWind_IO.f90
  src/InflowWind_Subs.f90
  src/InflowWind_Types.f90
  src/InflowWind.f90 
  src/Lidar_Types.f90
  src/Lidar.f90
)
target_link_libraries(ifwlib nwtclibs)

# InflowWind C-Interface Library
add_library(ifw_c_binding SHARED 
  src/IfW_C_Binding.f90
)
target_link_libraries(ifw_c_binding ifwlib versioninfolib)
if(APPLE OR UNIX)
   target_compile_definitions(ifw_c_binding PRIVATE IMPLICIT_DLLEXPORT)
endif()

# InflowWind Driver executable
add_executable(inflowwind_driver 
  src/InflowWind_Driver_Types.f90 
  src/InflowWind_Driver_Subs.f90
  src/InflowWind_Driver.f90
)
target_link_libraries(inflowwind_driver ifwlib versioninfolib)

install(TARGETS ifwlib inflowwind_driver ifw_c_binding 
  EXPORT "${CMAKE_PROJECT_NAME}Libraries"
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib)

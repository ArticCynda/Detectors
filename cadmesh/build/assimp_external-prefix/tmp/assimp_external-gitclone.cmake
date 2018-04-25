if("v4.0.1" STREQUAL "")
  message(FATAL_ERROR "Tag for git checkout should not be empty.")
endif()

set(run 0)

if("/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitinfo.txt" IS_NEWER_THAN "/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitclone-lastrun.txt")
  set(run 1)
endif()

if(NOT run)
  message(STATUS "Avoiding repeated git clone, stamp file is up to date: '/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitclone-lastrun.txt'")
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E remove_directory "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp'")
endif()

# try the clone 3 times incase there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git" clone --origin "origin" "https://github.com/assimp/assimp.git" "assimp"
    WORKING_DIRECTORY "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external"
    RESULT_VARIABLE error_code
    )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once:
          ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/assimp/assimp.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git" checkout v4.0.1
  WORKING_DIRECTORY "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'v4.0.1'")
endif()

execute_process(
  COMMAND "/usr/bin/git" submodule init 
  WORKING_DIRECTORY "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to init submodules in: '/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp'")
endif()

execute_process(
  COMMAND "/usr/bin/git" submodule update --recursive 
  WORKING_DIRECTORY "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy
    "/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitinfo.txt"
    "/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitclone-lastrun.txt"
  WORKING_DIRECTORY "/media/anon/Data/uob/iac/scintillators/cadmesh/CADMesh/external/assimp"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/media/anon/Data/uob/iac/scintillators/cadmesh/build/assimp_external-prefix/src/assimp_external-stamp/assimp_external-gitclone-lastrun.txt'")
endif()


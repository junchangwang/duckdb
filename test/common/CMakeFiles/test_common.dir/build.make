# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.23.2/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/jordan/code/duckdb

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/jordan/code/duckdb

# Include any dependencies generated for this target.
include test/common/CMakeFiles/test_common.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include test/common/CMakeFiles/test_common.dir/compiler_depend.make

# Include the progress variables for this target.
include test/common/CMakeFiles/test_common.dir/progress.make

# Include the compile flags for this target's objects.
include test/common/CMakeFiles/test_common.dir/flags.make

test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o: test/common/CMakeFiles/test_common.dir/flags.make
test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o: test/common/ub_test_common.cpp
test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o: test/common/CMakeFiles/test_common.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o"
	cd /Users/jordan/code/duckdb/test/common && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o -MF CMakeFiles/test_common.dir/ub_test_common.cpp.o.d -o CMakeFiles/test_common.dir/ub_test_common.cpp.o -c /Users/jordan/code/duckdb/test/common/ub_test_common.cpp

test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test_common.dir/ub_test_common.cpp.i"
	cd /Users/jordan/code/duckdb/test/common && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/test/common/ub_test_common.cpp > CMakeFiles/test_common.dir/ub_test_common.cpp.i

test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test_common.dir/ub_test_common.cpp.s"
	cd /Users/jordan/code/duckdb/test/common && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/test/common/ub_test_common.cpp -o CMakeFiles/test_common.dir/ub_test_common.cpp.s

test_common: test/common/CMakeFiles/test_common.dir/ub_test_common.cpp.o
test_common: test/common/CMakeFiles/test_common.dir/build.make
.PHONY : test_common

# Rule to build all files generated by this target.
test/common/CMakeFiles/test_common.dir/build: test_common
.PHONY : test/common/CMakeFiles/test_common.dir/build

test/common/CMakeFiles/test_common.dir/clean:
	cd /Users/jordan/code/duckdb/test/common && $(CMAKE_COMMAND) -P CMakeFiles/test_common.dir/cmake_clean.cmake
.PHONY : test/common/CMakeFiles/test_common.dir/clean

test/common/CMakeFiles/test_common.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/test/common /Users/jordan/code/duckdb /Users/jordan/code/duckdb/test/common /Users/jordan/code/duckdb/test/common/CMakeFiles/test_common.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : test/common/CMakeFiles/test_common.dir/depend


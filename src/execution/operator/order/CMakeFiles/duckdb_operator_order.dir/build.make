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
include src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/compiler_depend.make

# Include the progress variables for this target.
include src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/progress.make

# Include the compile flags for this target's objects.
include src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/flags.make

src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o: src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/flags.make
src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o: src/execution/operator/order/ub_duckdb_operator_order.cpp
src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o: src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o"
	cd /Users/jordan/code/duckdb/src/execution/operator/order && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o -MF CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o.d -o CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o -c /Users/jordan/code/duckdb/src/execution/operator/order/ub_duckdb_operator_order.cpp

src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.i"
	cd /Users/jordan/code/duckdb/src/execution/operator/order && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/src/execution/operator/order/ub_duckdb_operator_order.cpp > CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.i

src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.s"
	cd /Users/jordan/code/duckdb/src/execution/operator/order && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/src/execution/operator/order/ub_duckdb_operator_order.cpp -o CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.s

duckdb_operator_order: src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/ub_duckdb_operator_order.cpp.o
duckdb_operator_order: src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/build.make
.PHONY : duckdb_operator_order

# Rule to build all files generated by this target.
src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/build: duckdb_operator_order
.PHONY : src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/build

src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/clean:
	cd /Users/jordan/code/duckdb/src/execution/operator/order && $(CMAKE_COMMAND) -P CMakeFiles/duckdb_operator_order.dir/cmake_clean.cmake
.PHONY : src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/clean

src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/execution/operator/order /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/execution/operator/order /Users/jordan/code/duckdb/src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/depend


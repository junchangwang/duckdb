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
include src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/compiler_depend.make

# Include the progress variables for this target.
include src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/progress.make

# Include the compile flags for this target's objects.
include src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/flags.make

src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o: src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/flags.make
src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o: src/storage/buffer/ub_duckdb_storage_buffer.cpp
src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o: src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o"
	cd /Users/jordan/code/duckdb/src/storage/buffer && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o -MF CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o.d -o CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o -c /Users/jordan/code/duckdb/src/storage/buffer/ub_duckdb_storage_buffer.cpp

src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.i"
	cd /Users/jordan/code/duckdb/src/storage/buffer && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/src/storage/buffer/ub_duckdb_storage_buffer.cpp > CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.i

src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.s"
	cd /Users/jordan/code/duckdb/src/storage/buffer && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/src/storage/buffer/ub_duckdb_storage_buffer.cpp -o CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.s

duckdb_storage_buffer: src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/ub_duckdb_storage_buffer.cpp.o
duckdb_storage_buffer: src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/build.make
.PHONY : duckdb_storage_buffer

# Rule to build all files generated by this target.
src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/build: duckdb_storage_buffer
.PHONY : src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/build

src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/clean:
	cd /Users/jordan/code/duckdb/src/storage/buffer && $(CMAKE_COMMAND) -P CMakeFiles/duckdb_storage_buffer.dir/cmake_clean.cmake
.PHONY : src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/clean

src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/storage/buffer /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/storage/buffer /Users/jordan/code/duckdb/src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/depend


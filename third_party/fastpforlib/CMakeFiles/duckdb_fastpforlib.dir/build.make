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
include third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/compiler_depend.make

# Include the progress variables for this target.
include third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/progress.make

# Include the compile flags for this target's objects.
include third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/flags.make

third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o: third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/flags.make
third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o: third_party/fastpforlib/bitpacking.cpp
third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o: third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o"
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o -MF CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o.d -o CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o -c /Users/jordan/code/duckdb/third_party/fastpforlib/bitpacking.cpp

third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.i"
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/third_party/fastpforlib/bitpacking.cpp > CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.i

third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.s"
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/third_party/fastpforlib/bitpacking.cpp -o CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.s

# Object files for target duckdb_fastpforlib
duckdb_fastpforlib_OBJECTS = \
"CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o"

# External object files for target duckdb_fastpforlib
duckdb_fastpforlib_EXTERNAL_OBJECTS =

third_party/fastpforlib/libduckdb_fastpforlib.a: third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/bitpacking.cpp.o
third_party/fastpforlib/libduckdb_fastpforlib.a: third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/build.make
third_party/fastpforlib/libduckdb_fastpforlib.a: third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library libduckdb_fastpforlib.a"
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && $(CMAKE_COMMAND) -P CMakeFiles/duckdb_fastpforlib.dir/cmake_clean_target.cmake
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/duckdb_fastpforlib.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/build: third_party/fastpforlib/libduckdb_fastpforlib.a
.PHONY : third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/build

third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/clean:
	cd /Users/jordan/code/duckdb/third_party/fastpforlib && $(CMAKE_COMMAND) -P CMakeFiles/duckdb_fastpforlib.dir/cmake_clean.cmake
.PHONY : third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/clean

third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/third_party/fastpforlib /Users/jordan/code/duckdb /Users/jordan/code/duckdb/third_party/fastpforlib /Users/jordan/code/duckdb/third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/depend


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
include src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/compiler_depend.make

# Include the progress variables for this target.
include src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/progress.make

# Include the compile flags for this target's objects.
include src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/flags.make

src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o: src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/flags.make
src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o: src/catalog/catalog_entry/ub_duckdb_catalog_entries.cpp
src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o: src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o"
	cd /Users/jordan/code/duckdb/src/catalog/catalog_entry && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o -MF CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o.d -o CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o -c /Users/jordan/code/duckdb/src/catalog/catalog_entry/ub_duckdb_catalog_entries.cpp

src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.i"
	cd /Users/jordan/code/duckdb/src/catalog/catalog_entry && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/src/catalog/catalog_entry/ub_duckdb_catalog_entries.cpp > CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.i

src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.s"
	cd /Users/jordan/code/duckdb/src/catalog/catalog_entry && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/src/catalog/catalog_entry/ub_duckdb_catalog_entries.cpp -o CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.s

duckdb_catalog_entries: src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/ub_duckdb_catalog_entries.cpp.o
duckdb_catalog_entries: src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/build.make
.PHONY : duckdb_catalog_entries

# Rule to build all files generated by this target.
src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/build: duckdb_catalog_entries
.PHONY : src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/build

src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/clean:
	cd /Users/jordan/code/duckdb/src/catalog/catalog_entry && $(CMAKE_COMMAND) -P CMakeFiles/duckdb_catalog_entries.dir/cmake_clean.cmake
.PHONY : src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/clean

src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/catalog/catalog_entry /Users/jordan/code/duckdb /Users/jordan/code/duckdb/src/catalog/catalog_entry /Users/jordan/code/duckdb/src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/depend


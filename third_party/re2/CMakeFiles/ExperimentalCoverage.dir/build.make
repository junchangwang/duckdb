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

# Utility rule file for ExperimentalCoverage.

# Include any custom commands dependencies for this target.
include third_party/re2/CMakeFiles/ExperimentalCoverage.dir/compiler_depend.make

# Include the progress variables for this target.
include third_party/re2/CMakeFiles/ExperimentalCoverage.dir/progress.make

third_party/re2/CMakeFiles/ExperimentalCoverage:
	cd /Users/jordan/code/duckdb/third_party/re2 && /opt/homebrew/Cellar/cmake/3.23.2/bin/ctest -D ExperimentalCoverage

ExperimentalCoverage: third_party/re2/CMakeFiles/ExperimentalCoverage
ExperimentalCoverage: third_party/re2/CMakeFiles/ExperimentalCoverage.dir/build.make
.PHONY : ExperimentalCoverage

# Rule to build all files generated by this target.
third_party/re2/CMakeFiles/ExperimentalCoverage.dir/build: ExperimentalCoverage
.PHONY : third_party/re2/CMakeFiles/ExperimentalCoverage.dir/build

third_party/re2/CMakeFiles/ExperimentalCoverage.dir/clean:
	cd /Users/jordan/code/duckdb/third_party/re2 && $(CMAKE_COMMAND) -P CMakeFiles/ExperimentalCoverage.dir/cmake_clean.cmake
.PHONY : third_party/re2/CMakeFiles/ExperimentalCoverage.dir/clean

third_party/re2/CMakeFiles/ExperimentalCoverage.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/third_party/re2 /Users/jordan/code/duckdb /Users/jordan/code/duckdb/third_party/re2 /Users/jordan/code/duckdb/third_party/re2/CMakeFiles/ExperimentalCoverage.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : third_party/re2/CMakeFiles/ExperimentalCoverage.dir/depend


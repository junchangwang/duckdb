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
include test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/compiler_depend.make

# Include the progress variables for this target.
include test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/progress.make

# Include the compile flags for this target's objects.
include test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/flags.make

test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o: test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/flags.make
test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o: test/sql/parallelism/interquery/ub_test_sql_interquery_parallelism.cpp
test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o: test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/jordan/code/duckdb/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o"
	cd /Users/jordan/code/duckdb/test/sql/parallelism/interquery && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o -MF CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o.d -o CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o -c /Users/jordan/code/duckdb/test/sql/parallelism/interquery/ub_test_sql_interquery_parallelism.cpp

test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.i"
	cd /Users/jordan/code/duckdb/test/sql/parallelism/interquery && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /Users/jordan/code/duckdb/test/sql/parallelism/interquery/ub_test_sql_interquery_parallelism.cpp > CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.i

test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.s"
	cd /Users/jordan/code/duckdb/test/sql/parallelism/interquery && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /Users/jordan/code/duckdb/test/sql/parallelism/interquery/ub_test_sql_interquery_parallelism.cpp -o CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.s

test_sql_interquery_parallelism: test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/ub_test_sql_interquery_parallelism.cpp.o
test_sql_interquery_parallelism: test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/build.make
.PHONY : test_sql_interquery_parallelism

# Rule to build all files generated by this target.
test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/build: test_sql_interquery_parallelism
.PHONY : test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/build

test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/clean:
	cd /Users/jordan/code/duckdb/test/sql/parallelism/interquery && $(CMAKE_COMMAND) -P CMakeFiles/test_sql_interquery_parallelism.dir/cmake_clean.cmake
.PHONY : test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/clean

test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/depend:
	cd /Users/jordan/code/duckdb && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/jordan/code/duckdb /Users/jordan/code/duckdb/test/sql/parallelism/interquery /Users/jordan/code/duckdb /Users/jordan/code/duckdb/test/sql/parallelism/interquery /Users/jordan/code/duckdb/test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/depend


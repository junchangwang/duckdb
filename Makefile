.PHONY: all opt unit clean debug release release_expanded test unittest allunit benchmark docs doxygen format sqlite imdb

all: release
opt: release
unit: unittest
imdb: third_party/imdb/data

GENERATOR=
FORCE_COLOR=
WARNINGS_AS_ERRORS=
FORCE_WARN_UNUSED_FLAG=
DISABLE_UNITY_FLAG=
DISABLE_SANITIZER_FLAG=
OSX_BUILD_UNIVERSAL_FLAG=
FORCE_32_BIT_FLAG=
ifeq ($(GEN),ninja)
	GENERATOR=-G "Ninja"
	FORCE_COLOR=-DFORCE_COLORED_OUTPUT=1
endif
ifeq (${TREAT_WARNINGS_AS_ERRORS}, 1)
	WARNINGS_AS_ERRORS=-DTREAT_WARNINGS_AS_ERRORS=1
endif
ifeq (${OSX_BUILD_UNIVERSAL}, 1)
	OSX_BUILD_UNIVERSAL_FLAG=-DOSX_BUILD_UNIVERSAL=1
endif
ifeq (${FORCE_32_BIT}, 1)
	FORCE_32_BIT_FLAG=-DFORCE_32_BIT=1
endif
ifeq (${FORCE_WARN_UNUSED}, 1)
	FORCE_WARN_UNUSED_FLAG=-DFORCE_WARN_UNUSED=1
endif
ifeq (${DISABLE_UNITY}, 1)
	DISABLE_UNITY_FLAG=-DDISABLE_UNITY=1
endif
ifeq (${DISABLE_SANITIZER}, 1)
	DISABLE_SANITIZER_FLAG=-DENABLE_SANITIZER=FALSE -DENABLE_UBSAN=0
endif
ifeq (${DISABLE_UBSAN}, 1)
	DISABLE_SANITIZER_FLAG=-DENABLE_UBSAN=0
endif
ifeq (${DISABLE_VPTR_SANITIZER}, 1)
	DISABLE_SANITIZER_FLAG:=${DISABLE_SANITIZER_FLAG} -DDISABLE_VPTR_SANITIZER=1
endif
ifeq (${FORCE_SANITIZER}, 1)
	DISABLE_SANITIZER_FLAG:=${DISABLE_SANITIZER_FLAG} -DFORCE_SANITIZER=1
endif
ifeq (${THREADSAN}, 1)
	DISABLE_SANITIZER_FLAG:=${DISABLE_SANITIZER_FLAG} -DENABLE_THREAD_SANITIZER=1
endif
ifeq (${STATIC_LIBCPP}, 1)
	STATIC_LIBCPP=-DSTATIC_LIBCPP=TRUE
endif
EXTENSIONS=-DBUILD_PARQUET_EXTENSION=TRUE
ifeq (${DISABLE_PARQUET}, 1)
	EXTENSIONS:=
endif
ifeq (${DISABLE_MAIN_DUCKDB_LIBRARY}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_MAIN_DUCKDB_LIBRARY=0
endif
ifeq (${EXTENSION_STATIC_BUILD}, 1)
	EXTENSIONS:=${EXTENSIONS} -DEXTENSION_STATIC_BUILD=1
endif
ifeq (${DISABLE_BUILTIN_EXTENSIONS}, 1)
	EXTENSIONS:=${EXTENSIONS} -DDISABLE_BUILTIN_EXTENSIONS=1
endif
ifeq (${BUILD_BENCHMARK}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_BENCHMARKS=1
endif
ifeq (${BUILD_ICU}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_ICU_EXTENSION=1
endif
ifeq (${BUILD_TPCH}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_TPCH_EXTENSION=1
endif
ifeq (${BUILD_TPCDS}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_TPCDS_EXTENSION=1
endif
ifeq (${BUILD_FTS}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_FTS_EXTENSION=1
endif
ifeq (${BUILD_VISUALIZER}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_VISUALIZER_EXTENSION=1
endif
ifeq (${BUILD_HTTPFS}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_HTTPFS_EXTENSION=1
endif
ifeq (${BUILD_JSON}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_JSON_EXTENSION=1
endif
ifeq (${BUILD_EXCEL}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_EXCEL_EXTENSION=1
endif
ifeq (${STATIC_OPENSSL}, 1)
	EXTENSIONS:=${EXTENSIONS} -DOPENSSL_USE_STATIC_LIBS=1
endif
ifeq (${BUILD_SQLSMITH}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_SQLSMITH_EXTENSION=1
endif
ifeq (${BUILD_TPCE}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_TPCE=1
endif
ifeq (${BUILD_SUBSTRAIT_EXTENSION}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_SUBSTRAIT_EXTENSION=1
endif
ifeq (${BUILD_JDBC}, 1)
	EXTENSIONS:=${EXTENSIONS} -DJDBC_DRIVER=1
endif
ifeq (${BUILD_ODBC}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_ODBC_DRIVER=1
endif
ifeq (${BUILD_PYTHON}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_PYTHON=1 -DBUILD_JSON_EXTENSION=1 -DBUILD_FTS_EXTENSION=1 -DBUILD_TPCH_EXTENSION=1 -DBUILD_VISUALIZER_EXTENSION=1 -DBUILD_TPCDS_EXTENSION=1
endif
ifeq (${BUILD_R}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_R=1
endif
ifeq (${CONFIGURE_R}, 1)
	EXTENSIONS:=${EXTENSIONS} -DCONFIGURE_R=1
endif
ifeq (${BUILD_REST}, 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_REST=1
endif
ifneq ($(TIDY_THREADS),)
	TIDY_THREAD_PARAMETER := -j ${TIDY_THREADS}
endif
ifneq ($(TIDY_BINARY),)
	TIDY_BINARY_PARAMETER := -clang-tidy-binary ${TIDY_BINARY}
endif
ifeq ($(BUILD_ARROW_ABI_TEST), 1)
	EXTENSIONS:=${EXTENSIONS} -DBUILD_ARROW_ABI_TEST=1
endif
ifneq ("${FORCE_QUERY_LOG}a", "a")
	EXTENSIONS:=${EXTENSIONS} -DFORCE_QUERY_LOG=${FORCE_QUERY_LOG}
endif
ifneq ($(BUILD_OUT_OF_TREE_EXTENSION),)
	EXTENSIONS:=${EXTENSIONS} -DEXTERNAL_EXTENSION_DIRECTORY=$(BUILD_OUT_OF_TREE_EXTENSION)
endif

# Default target executed when no arguments are given to make.
default_target: all
.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:

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

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake cache editor..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/ccmake -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache
.PHONY : edit_cache/fast

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake --regenerate-during-build -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache
.PHONY : rebuild_cache/fast

# Special rule for the target list_install_components
list_install_components:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Available install components are: \"Unspecified\""
.PHONY : list_install_components

# Special rule for the target list_install_components
list_install_components/fast: list_install_components
.PHONY : list_install_components/fast

# Special rule for the target install
install: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Install the project..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -P cmake_install.cmake
.PHONY : install

# Special rule for the target install
install/fast: preinstall/fast
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Install the project..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -P cmake_install.cmake
.PHONY : install/fast

# Special rule for the target install/local
install/local: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing only the local directory..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -DCMAKE_INSTALL_LOCAL_ONLY=1 -P cmake_install.cmake
.PHONY : install/local

# Special rule for the target install/local
install/local/fast: preinstall/fast
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing only the local directory..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -DCMAKE_INSTALL_LOCAL_ONLY=1 -P cmake_install.cmake
.PHONY : install/local/fast

# Special rule for the target install/strip
install/strip: preinstall
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing the project stripped..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -DCMAKE_INSTALL_DO_STRIP=1 -P cmake_install.cmake
.PHONY : install/strip

# Special rule for the target install/strip
install/strip/fast: preinstall/fast
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Installing the project stripped..."
	/opt/homebrew/Cellar/cmake/3.23.2/bin/cmake -DCMAKE_INSTALL_DO_STRIP=1 -P cmake_install.cmake
.PHONY : install/strip/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /Users/jordan/code/duckdb/CMakeFiles /Users/jordan/code/duckdb//CMakeFiles/progress.marks
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /Users/jordan/code/duckdb/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean
.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named duckdb

# Build rule for target.
duckdb: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb
.PHONY : duckdb

# fast build rule for target.
duckdb/fast:
	$(MAKE) $(MAKESILENT) -f src/CMakeFiles/duckdb.dir/build.make src/CMakeFiles/duckdb.dir/build
.PHONY : duckdb/fast

#=============================================================================
# Target rules for targets named duckdb_static

# Build rule for target.
duckdb_static: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_static
.PHONY : duckdb_static

# fast build rule for target.
duckdb_static/fast:
	$(MAKE) $(MAKESILENT) -f src/CMakeFiles/duckdb_static.dir/build.make src/CMakeFiles/duckdb_static.dir/build
.PHONY : duckdb_static/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer

# Build rule for target.
duckdb_optimizer: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer
.PHONY : duckdb_optimizer

# fast build rule for target.
duckdb_optimizer/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/CMakeFiles/duckdb_optimizer.dir/build.make src/optimizer/CMakeFiles/duckdb_optimizer.dir/build
.PHONY : duckdb_optimizer/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_matcher

# Build rule for target.
duckdb_optimizer_matcher: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_matcher
.PHONY : duckdb_optimizer_matcher

# fast build rule for target.
duckdb_optimizer_matcher/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/matcher/CMakeFiles/duckdb_optimizer_matcher.dir/build.make src/optimizer/matcher/CMakeFiles/duckdb_optimizer_matcher.dir/build
.PHONY : duckdb_optimizer_matcher/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_join_order

# Build rule for target.
duckdb_optimizer_join_order: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_join_order
.PHONY : duckdb_optimizer_join_order

# fast build rule for target.
duckdb_optimizer_join_order/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/join_order/CMakeFiles/duckdb_optimizer_join_order.dir/build.make src/optimizer/join_order/CMakeFiles/duckdb_optimizer_join_order.dir/build
.PHONY : duckdb_optimizer_join_order/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_pushdown

# Build rule for target.
duckdb_optimizer_pushdown: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_pushdown
.PHONY : duckdb_optimizer_pushdown

# fast build rule for target.
duckdb_optimizer_pushdown/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/pushdown/CMakeFiles/duckdb_optimizer_pushdown.dir/build.make src/optimizer/pushdown/CMakeFiles/duckdb_optimizer_pushdown.dir/build
.PHONY : duckdb_optimizer_pushdown/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_pullup

# Build rule for target.
duckdb_optimizer_pullup: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_pullup
.PHONY : duckdb_optimizer_pullup

# fast build rule for target.
duckdb_optimizer_pullup/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/pullup/CMakeFiles/duckdb_optimizer_pullup.dir/build.make src/optimizer/pullup/CMakeFiles/duckdb_optimizer_pullup.dir/build
.PHONY : duckdb_optimizer_pullup/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_rules

# Build rule for target.
duckdb_optimizer_rules: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_rules
.PHONY : duckdb_optimizer_rules

# fast build rule for target.
duckdb_optimizer_rules/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/rule/CMakeFiles/duckdb_optimizer_rules.dir/build.make src/optimizer/rule/CMakeFiles/duckdb_optimizer_rules.dir/build
.PHONY : duckdb_optimizer_rules/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_statistics_expr

# Build rule for target.
duckdb_optimizer_statistics_expr: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_statistics_expr
.PHONY : duckdb_optimizer_statistics_expr

# fast build rule for target.
duckdb_optimizer_statistics_expr/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/statistics/expression/CMakeFiles/duckdb_optimizer_statistics_expr.dir/build.make src/optimizer/statistics/expression/CMakeFiles/duckdb_optimizer_statistics_expr.dir/build
.PHONY : duckdb_optimizer_statistics_expr/fast

#=============================================================================
# Target rules for targets named duckdb_optimizer_statistics_op

# Build rule for target.
duckdb_optimizer_statistics_op: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_optimizer_statistics_op
.PHONY : duckdb_optimizer_statistics_op

# fast build rule for target.
duckdb_optimizer_statistics_op/fast:
	$(MAKE) $(MAKESILENT) -f src/optimizer/statistics/operator/CMakeFiles/duckdb_optimizer_statistics_op.dir/build.make src/optimizer/statistics/operator/CMakeFiles/duckdb_optimizer_statistics_op.dir/build
.PHONY : duckdb_optimizer_statistics_op/fast

#=============================================================================
# Target rules for targets named duckdb_planner

# Build rule for target.
duckdb_planner: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_planner
.PHONY : duckdb_planner

# fast build rule for target.
duckdb_planner/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/CMakeFiles/duckdb_planner.dir/build.make src/planner/CMakeFiles/duckdb_planner.dir/build
.PHONY : duckdb_planner/fast

#=============================================================================
# Target rules for targets named duckdb_planner_expression

# Build rule for target.
duckdb_planner_expression: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_planner_expression
.PHONY : duckdb_planner_expression

# fast build rule for target.
duckdb_planner_expression/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/expression/CMakeFiles/duckdb_planner_expression.dir/build.make src/planner/expression/CMakeFiles/duckdb_planner_expression.dir/build
.PHONY : duckdb_planner_expression/fast

#=============================================================================
# Target rules for targets named duckdb_bind_expression

# Build rule for target.
duckdb_bind_expression: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_bind_expression
.PHONY : duckdb_bind_expression

# fast build rule for target.
duckdb_bind_expression/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/binder/expression/CMakeFiles/duckdb_bind_expression.dir/build.make src/planner/binder/expression/CMakeFiles/duckdb_bind_expression.dir/build
.PHONY : duckdb_bind_expression/fast

#=============================================================================
# Target rules for targets named duckdb_bind_query_node

# Build rule for target.
duckdb_bind_query_node: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_bind_query_node
.PHONY : duckdb_bind_query_node

# fast build rule for target.
duckdb_bind_query_node/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/binder/query_node/CMakeFiles/duckdb_bind_query_node.dir/build.make src/planner/binder/query_node/CMakeFiles/duckdb_bind_query_node.dir/build
.PHONY : duckdb_bind_query_node/fast

#=============================================================================
# Target rules for targets named duckdb_bind_statement

# Build rule for target.
duckdb_bind_statement: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_bind_statement
.PHONY : duckdb_bind_statement

# fast build rule for target.
duckdb_bind_statement/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/binder/statement/CMakeFiles/duckdb_bind_statement.dir/build.make src/planner/binder/statement/CMakeFiles/duckdb_bind_statement.dir/build
.PHONY : duckdb_bind_statement/fast

#=============================================================================
# Target rules for targets named duckdb_bind_tableref

# Build rule for target.
duckdb_bind_tableref: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_bind_tableref
.PHONY : duckdb_bind_tableref

# fast build rule for target.
duckdb_bind_tableref/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/binder/tableref/CMakeFiles/duckdb_bind_tableref.dir/build.make src/planner/binder/tableref/CMakeFiles/duckdb_bind_tableref.dir/build
.PHONY : duckdb_bind_tableref/fast

#=============================================================================
# Target rules for targets named duckdb_expression_binders

# Build rule for target.
duckdb_expression_binders: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_expression_binders
.PHONY : duckdb_expression_binders

# fast build rule for target.
duckdb_expression_binders/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/expression_binder/CMakeFiles/duckdb_expression_binders.dir/build.make src/planner/expression_binder/CMakeFiles/duckdb_expression_binders.dir/build
.PHONY : duckdb_expression_binders/fast

#=============================================================================
# Target rules for targets named duckdb_planner_filter

# Build rule for target.
duckdb_planner_filter: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_planner_filter
.PHONY : duckdb_planner_filter

# fast build rule for target.
duckdb_planner_filter/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/filter/CMakeFiles/duckdb_planner_filter.dir/build.make src/planner/filter/CMakeFiles/duckdb_planner_filter.dir/build
.PHONY : duckdb_planner_filter/fast

#=============================================================================
# Target rules for targets named duckdb_planner_operator

# Build rule for target.
duckdb_planner_operator: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_planner_operator
.PHONY : duckdb_planner_operator

# fast build rule for target.
duckdb_planner_operator/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/operator/CMakeFiles/duckdb_planner_operator.dir/build.make src/planner/operator/CMakeFiles/duckdb_planner_operator.dir/build
.PHONY : duckdb_planner_operator/fast

#=============================================================================
# Target rules for targets named duckdb_planner_subquery

# Build rule for target.
duckdb_planner_subquery: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_planner_subquery
.PHONY : duckdb_planner_subquery

# fast build rule for target.
duckdb_planner_subquery/fast:
	$(MAKE) $(MAKESILENT) -f src/planner/subquery/CMakeFiles/duckdb_planner_subquery.dir/build.make src/planner/subquery/CMakeFiles/duckdb_planner_subquery.dir/build
.PHONY : duckdb_planner_subquery/fast

#=============================================================================
# Target rules for targets named duckdb_parser

# Build rule for target.
duckdb_parser: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_parser
.PHONY : duckdb_parser

# fast build rule for target.
duckdb_parser/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/CMakeFiles/duckdb_parser.dir/build.make src/parser/CMakeFiles/duckdb_parser.dir/build
.PHONY : duckdb_parser/fast

#=============================================================================
# Target rules for targets named duckdb_constraints

# Build rule for target.
duckdb_constraints: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_constraints
.PHONY : duckdb_constraints

# fast build rule for target.
duckdb_constraints/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/constraints/CMakeFiles/duckdb_constraints.dir/build.make src/parser/constraints/CMakeFiles/duckdb_constraints.dir/build
.PHONY : duckdb_constraints/fast

#=============================================================================
# Target rules for targets named duckdb_expression

# Build rule for target.
duckdb_expression: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_expression
.PHONY : duckdb_expression

# fast build rule for target.
duckdb_expression/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/expression/CMakeFiles/duckdb_expression.dir/build.make src/parser/expression/CMakeFiles/duckdb_expression.dir/build
.PHONY : duckdb_expression/fast

#=============================================================================
# Target rules for targets named duckdb_parsed_data

# Build rule for target.
duckdb_parsed_data: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_parsed_data
.PHONY : duckdb_parsed_data

# fast build rule for target.
duckdb_parsed_data/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/parsed_data/CMakeFiles/duckdb_parsed_data.dir/build.make src/parser/parsed_data/CMakeFiles/duckdb_parsed_data.dir/build
.PHONY : duckdb_parsed_data/fast

#=============================================================================
# Target rules for targets named duckdb_query_node

# Build rule for target.
duckdb_query_node: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_query_node
.PHONY : duckdb_query_node

# fast build rule for target.
duckdb_query_node/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/query_node/CMakeFiles/duckdb_query_node.dir/build.make src/parser/query_node/CMakeFiles/duckdb_query_node.dir/build
.PHONY : duckdb_query_node/fast

#=============================================================================
# Target rules for targets named duckdb_statement

# Build rule for target.
duckdb_statement: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_statement
.PHONY : duckdb_statement

# fast build rule for target.
duckdb_statement/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/statement/CMakeFiles/duckdb_statement.dir/build.make src/parser/statement/CMakeFiles/duckdb_statement.dir/build
.PHONY : duckdb_statement/fast

#=============================================================================
# Target rules for targets named duckdb_parser_tableref

# Build rule for target.
duckdb_parser_tableref: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_parser_tableref
.PHONY : duckdb_parser_tableref

# fast build rule for target.
duckdb_parser_tableref/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/tableref/CMakeFiles/duckdb_parser_tableref.dir/build.make src/parser/tableref/CMakeFiles/duckdb_parser_tableref.dir/build
.PHONY : duckdb_parser_tableref/fast

#=============================================================================
# Target rules for targets named duckdb_transformer_constraint

# Build rule for target.
duckdb_transformer_constraint: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transformer_constraint
.PHONY : duckdb_transformer_constraint

# fast build rule for target.
duckdb_transformer_constraint/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/transform/constraint/CMakeFiles/duckdb_transformer_constraint.dir/build.make src/parser/transform/constraint/CMakeFiles/duckdb_transformer_constraint.dir/build
.PHONY : duckdb_transformer_constraint/fast

#=============================================================================
# Target rules for targets named duckdb_transformer_expression

# Build rule for target.
duckdb_transformer_expression: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transformer_expression
.PHONY : duckdb_transformer_expression

# fast build rule for target.
duckdb_transformer_expression/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/transform/expression/CMakeFiles/duckdb_transformer_expression.dir/build.make src/parser/transform/expression/CMakeFiles/duckdb_transformer_expression.dir/build
.PHONY : duckdb_transformer_expression/fast

#=============================================================================
# Target rules for targets named duckdb_transformer_helpers

# Build rule for target.
duckdb_transformer_helpers: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transformer_helpers
.PHONY : duckdb_transformer_helpers

# fast build rule for target.
duckdb_transformer_helpers/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/transform/helpers/CMakeFiles/duckdb_transformer_helpers.dir/build.make src/parser/transform/helpers/CMakeFiles/duckdb_transformer_helpers.dir/build
.PHONY : duckdb_transformer_helpers/fast

#=============================================================================
# Target rules for targets named duckdb_transformer_statement

# Build rule for target.
duckdb_transformer_statement: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transformer_statement
.PHONY : duckdb_transformer_statement

# fast build rule for target.
duckdb_transformer_statement/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/transform/statement/CMakeFiles/duckdb_transformer_statement.dir/build.make src/parser/transform/statement/CMakeFiles/duckdb_transformer_statement.dir/build
.PHONY : duckdb_transformer_statement/fast

#=============================================================================
# Target rules for targets named duckdb_transformer_tableref

# Build rule for target.
duckdb_transformer_tableref: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transformer_tableref
.PHONY : duckdb_transformer_tableref

# fast build rule for target.
duckdb_transformer_tableref/fast:
	$(MAKE) $(MAKESILENT) -f src/parser/transform/tableref/CMakeFiles/duckdb_transformer_tableref.dir/build.make src/parser/transform/tableref/CMakeFiles/duckdb_transformer_tableref.dir/build
.PHONY : duckdb_transformer_tableref/fast

#=============================================================================
# Target rules for targets named duckdb_function

# Build rule for target.
duckdb_function: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_function
.PHONY : duckdb_function

# fast build rule for target.
duckdb_function/fast:
	$(MAKE) $(MAKESILENT) -f src/function/CMakeFiles/duckdb_function.dir/build.make src/function/CMakeFiles/duckdb_function.dir/build
.PHONY : duckdb_function/fast

#=============================================================================
# Target rules for targets named duckdb_func_aggr

# Build rule for target.
duckdb_func_aggr: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_aggr
.PHONY : duckdb_func_aggr

# fast build rule for target.
duckdb_func_aggr/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/CMakeFiles/duckdb_func_aggr.dir/build.make src/function/aggregate/CMakeFiles/duckdb_func_aggr.dir/build
.PHONY : duckdb_func_aggr/fast

#=============================================================================
# Target rules for targets named duckdb_aggr_algebraic

# Build rule for target.
duckdb_aggr_algebraic: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_aggr_algebraic
.PHONY : duckdb_aggr_algebraic

# fast build rule for target.
duckdb_aggr_algebraic/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/algebraic/CMakeFiles/duckdb_aggr_algebraic.dir/build.make src/function/aggregate/algebraic/CMakeFiles/duckdb_aggr_algebraic.dir/build
.PHONY : duckdb_aggr_algebraic/fast

#=============================================================================
# Target rules for targets named duckdb_aggr_distr

# Build rule for target.
duckdb_aggr_distr: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_aggr_distr
.PHONY : duckdb_aggr_distr

# fast build rule for target.
duckdb_aggr_distr/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/distributive/CMakeFiles/duckdb_aggr_distr.dir/build.make src/function/aggregate/distributive/CMakeFiles/duckdb_aggr_distr.dir/build
.PHONY : duckdb_aggr_distr/fast

#=============================================================================
# Target rules for targets named duckdb_aggr_holistic

# Build rule for target.
duckdb_aggr_holistic: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_aggr_holistic
.PHONY : duckdb_aggr_holistic

# fast build rule for target.
duckdb_aggr_holistic/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/holistic/CMakeFiles/duckdb_aggr_holistic.dir/build.make src/function/aggregate/holistic/CMakeFiles/duckdb_aggr_holistic.dir/build
.PHONY : duckdb_aggr_holistic/fast

#=============================================================================
# Target rules for targets named duckdb_aggr_nested

# Build rule for target.
duckdb_aggr_nested: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_aggr_nested
.PHONY : duckdb_aggr_nested

# fast build rule for target.
duckdb_aggr_nested/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/nested/CMakeFiles/duckdb_aggr_nested.dir/build.make src/function/aggregate/nested/CMakeFiles/duckdb_aggr_nested.dir/build
.PHONY : duckdb_aggr_nested/fast

#=============================================================================
# Target rules for targets named duckdb_aggr_regr

# Build rule for target.
duckdb_aggr_regr: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_aggr_regr
.PHONY : duckdb_aggr_regr

# fast build rule for target.
duckdb_aggr_regr/fast:
	$(MAKE) $(MAKESILENT) -f src/function/aggregate/regression/CMakeFiles/duckdb_aggr_regr.dir/build.make src/function/aggregate/regression/CMakeFiles/duckdb_aggr_regr.dir/build
.PHONY : duckdb_aggr_regr/fast

#=============================================================================
# Target rules for targets named duckdb_func_pragma

# Build rule for target.
duckdb_func_pragma: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_pragma
.PHONY : duckdb_func_pragma

# fast build rule for target.
duckdb_func_pragma/fast:
	$(MAKE) $(MAKESILENT) -f src/function/pragma/CMakeFiles/duckdb_func_pragma.dir/build.make src/function/pragma/CMakeFiles/duckdb_func_pragma.dir/build
.PHONY : duckdb_func_pragma/fast

#=============================================================================
# Target rules for targets named duckdb_func_scalar

# Build rule for target.
duckdb_func_scalar: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_scalar
.PHONY : duckdb_func_scalar

# fast build rule for target.
duckdb_func_scalar/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/CMakeFiles/duckdb_func_scalar.dir/build.make src/function/scalar/CMakeFiles/duckdb_func_scalar.dir/build
.PHONY : duckdb_func_scalar/fast

#=============================================================================
# Target rules for targets named duckdb_func_blob

# Build rule for target.
duckdb_func_blob: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_blob
.PHONY : duckdb_func_blob

# fast build rule for target.
duckdb_func_blob/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/blob/CMakeFiles/duckdb_func_blob.dir/build.make src/function/scalar/blob/CMakeFiles/duckdb_func_blob.dir/build
.PHONY : duckdb_func_blob/fast

#=============================================================================
# Target rules for targets named duckdb_func_date

# Build rule for target.
duckdb_func_date: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_date
.PHONY : duckdb_func_date

# fast build rule for target.
duckdb_func_date/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/date/CMakeFiles/duckdb_func_date.dir/build.make src/function/scalar/date/CMakeFiles/duckdb_func_date.dir/build
.PHONY : duckdb_func_date/fast

#=============================================================================
# Target rules for targets named duckdb_func_generic

# Build rule for target.
duckdb_func_generic: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_generic
.PHONY : duckdb_func_generic

# fast build rule for target.
duckdb_func_generic/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/generic/CMakeFiles/duckdb_func_generic.dir/build.make src/function/scalar/generic/CMakeFiles/duckdb_func_generic.dir/build
.PHONY : duckdb_func_generic/fast

#=============================================================================
# Target rules for targets named duckdb_func_list

# Build rule for target.
duckdb_func_list: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_list
.PHONY : duckdb_func_list

# fast build rule for target.
duckdb_func_list/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/list/CMakeFiles/duckdb_func_list.dir/build.make src/function/scalar/list/CMakeFiles/duckdb_func_list.dir/build
.PHONY : duckdb_func_list/fast

#=============================================================================
# Target rules for targets named duckdb_func_map_nested

# Build rule for target.
duckdb_func_map_nested: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_map_nested
.PHONY : duckdb_func_map_nested

# fast build rule for target.
duckdb_func_map_nested/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/map/CMakeFiles/duckdb_func_map_nested.dir/build.make src/function/scalar/map/CMakeFiles/duckdb_func_map_nested.dir/build
.PHONY : duckdb_func_map_nested/fast

#=============================================================================
# Target rules for targets named duckdb_func_math

# Build rule for target.
duckdb_func_math: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_math
.PHONY : duckdb_func_math

# fast build rule for target.
duckdb_func_math/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/math/CMakeFiles/duckdb_func_math.dir/build.make src/function/scalar/math/CMakeFiles/duckdb_func_math.dir/build
.PHONY : duckdb_func_math/fast

#=============================================================================
# Target rules for targets named duckdb_func_ops

# Build rule for target.
duckdb_func_ops: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_ops
.PHONY : duckdb_func_ops

# fast build rule for target.
duckdb_func_ops/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/operators/CMakeFiles/duckdb_func_ops.dir/build.make src/function/scalar/operators/CMakeFiles/duckdb_func_ops.dir/build
.PHONY : duckdb_func_ops/fast

#=============================================================================
# Target rules for targets named duckdb_func_seq

# Build rule for target.
duckdb_func_seq: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_seq
.PHONY : duckdb_func_seq

# fast build rule for target.
duckdb_func_seq/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/sequence/CMakeFiles/duckdb_func_seq.dir/build.make src/function/scalar/sequence/CMakeFiles/duckdb_func_seq.dir/build
.PHONY : duckdb_func_seq/fast

#=============================================================================
# Target rules for targets named duckdb_func_string

# Build rule for target.
duckdb_func_string: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_string
.PHONY : duckdb_func_string

# fast build rule for target.
duckdb_func_string/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/string/CMakeFiles/duckdb_func_string.dir/build.make src/function/scalar/string/CMakeFiles/duckdb_func_string.dir/build
.PHONY : duckdb_func_string/fast

#=============================================================================
# Target rules for targets named duckdb_func_struct

# Build rule for target.
duckdb_func_struct: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_struct
.PHONY : duckdb_func_struct

# fast build rule for target.
duckdb_func_struct/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/struct/CMakeFiles/duckdb_func_struct.dir/build.make src/function/scalar/struct/CMakeFiles/duckdb_func_struct.dir/build
.PHONY : duckdb_func_struct/fast

#=============================================================================
# Target rules for targets named duckdb_func_system

# Build rule for target.
duckdb_func_system: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_system
.PHONY : duckdb_func_system

# fast build rule for target.
duckdb_func_system/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/system/CMakeFiles/duckdb_func_system.dir/build.make src/function/scalar/system/CMakeFiles/duckdb_func_system.dir/build
.PHONY : duckdb_func_system/fast

#=============================================================================
# Target rules for targets named duckdb_func_enum

# Build rule for target.
duckdb_func_enum: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_enum
.PHONY : duckdb_func_enum

# fast build rule for target.
duckdb_func_enum/fast:
	$(MAKE) $(MAKESILENT) -f src/function/scalar/enum/CMakeFiles/duckdb_func_enum.dir/build.make src/function/scalar/enum/CMakeFiles/duckdb_func_enum.dir/build
.PHONY : duckdb_func_enum/fast

#=============================================================================
# Target rules for targets named duckdb_func_table

# Build rule for target.
duckdb_func_table: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_table
.PHONY : duckdb_func_table

# fast build rule for target.
duckdb_func_table/fast:
	$(MAKE) $(MAKESILENT) -f src/function/table/CMakeFiles/duckdb_func_table.dir/build.make src/function/table/CMakeFiles/duckdb_func_table.dir/build
.PHONY : duckdb_func_table/fast

#=============================================================================
# Target rules for targets named duckdb_table_func_system

# Build rule for target.
duckdb_table_func_system: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_table_func_system
.PHONY : duckdb_table_func_system

# fast build rule for target.
duckdb_table_func_system/fast:
	$(MAKE) $(MAKESILENT) -f src/function/table/system/CMakeFiles/duckdb_table_func_system.dir/build.make src/function/table/system/CMakeFiles/duckdb_table_func_system.dir/build
.PHONY : duckdb_table_func_system/fast

#=============================================================================
# Target rules for targets named duckdb_func_table_version

# Build rule for target.
duckdb_func_table_version: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_func_table_version
.PHONY : duckdb_func_table_version

# fast build rule for target.
duckdb_func_table_version/fast:
	$(MAKE) $(MAKESILENT) -f src/function/table/version/CMakeFiles/duckdb_func_table_version.dir/build.make src/function/table/version/CMakeFiles/duckdb_func_table_version.dir/build
.PHONY : duckdb_func_table_version/fast

#=============================================================================
# Target rules for targets named duckdb_catalog

# Build rule for target.
duckdb_catalog: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_catalog
.PHONY : duckdb_catalog

# fast build rule for target.
duckdb_catalog/fast:
	$(MAKE) $(MAKESILENT) -f src/catalog/CMakeFiles/duckdb_catalog.dir/build.make src/catalog/CMakeFiles/duckdb_catalog.dir/build
.PHONY : duckdb_catalog/fast

#=============================================================================
# Target rules for targets named duckdb_catalog_entries

# Build rule for target.
duckdb_catalog_entries: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_catalog_entries
.PHONY : duckdb_catalog_entries

# fast build rule for target.
duckdb_catalog_entries/fast:
	$(MAKE) $(MAKESILENT) -f src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/build.make src/catalog/catalog_entry/CMakeFiles/duckdb_catalog_entries.dir/build
.PHONY : duckdb_catalog_entries/fast

#=============================================================================
# Target rules for targets named duckdb_catalog_default_entries

# Build rule for target.
duckdb_catalog_default_entries: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_catalog_default_entries
.PHONY : duckdb_catalog_default_entries

# fast build rule for target.
duckdb_catalog_default_entries/fast:
	$(MAKE) $(MAKESILENT) -f src/catalog/default/CMakeFiles/duckdb_catalog_default_entries.dir/build.make src/catalog/default/CMakeFiles/duckdb_catalog_default_entries.dir/build
.PHONY : duckdb_catalog_default_entries/fast

#=============================================================================
# Target rules for targets named duckdb_common

# Build rule for target.
duckdb_common: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common
.PHONY : duckdb_common

# fast build rule for target.
duckdb_common/fast:
	$(MAKE) $(MAKESILENT) -f src/common/CMakeFiles/duckdb_common.dir/build.make src/common/CMakeFiles/duckdb_common.dir/build
.PHONY : duckdb_common/fast

#=============================================================================
# Target rules for targets named duckdb_common_crypto

# Build rule for target.
duckdb_common_crypto: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common_crypto
.PHONY : duckdb_common_crypto

# fast build rule for target.
duckdb_common_crypto/fast:
	$(MAKE) $(MAKESILENT) -f src/common/crypto/CMakeFiles/duckdb_common_crypto.dir/build.make src/common/crypto/CMakeFiles/duckdb_common_crypto.dir/build
.PHONY : duckdb_common_crypto/fast

#=============================================================================
# Target rules for targets named duckdb_common_enums

# Build rule for target.
duckdb_common_enums: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common_enums
.PHONY : duckdb_common_enums

# fast build rule for target.
duckdb_common_enums/fast:
	$(MAKE) $(MAKESILENT) -f src/common/enums/CMakeFiles/duckdb_common_enums.dir/build.make src/common/enums/CMakeFiles/duckdb_common_enums.dir/build
.PHONY : duckdb_common_enums/fast

#=============================================================================
# Target rules for targets named duckdb_common_operators

# Build rule for target.
duckdb_common_operators: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common_operators
.PHONY : duckdb_common_operators

# fast build rule for target.
duckdb_common_operators/fast:
	$(MAKE) $(MAKESILENT) -f src/common/operator/CMakeFiles/duckdb_common_operators.dir/build.make src/common/operator/CMakeFiles/duckdb_common_operators.dir/build
.PHONY : duckdb_common_operators/fast

#=============================================================================
# Target rules for targets named duckdb_row_operations

# Build rule for target.
duckdb_row_operations: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_row_operations
.PHONY : duckdb_row_operations

# fast build rule for target.
duckdb_row_operations/fast:
	$(MAKE) $(MAKESILENT) -f src/common/row_operations/CMakeFiles/duckdb_row_operations.dir/build.make src/common/row_operations/CMakeFiles/duckdb_row_operations.dir/build
.PHONY : duckdb_row_operations/fast

#=============================================================================
# Target rules for targets named duckdb_common_serializer

# Build rule for target.
duckdb_common_serializer: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common_serializer
.PHONY : duckdb_common_serializer

# fast build rule for target.
duckdb_common_serializer/fast:
	$(MAKE) $(MAKESILENT) -f src/common/serializer/CMakeFiles/duckdb_common_serializer.dir/build.make src/common/serializer/CMakeFiles/duckdb_common_serializer.dir/build
.PHONY : duckdb_common_serializer/fast

#=============================================================================
# Target rules for targets named duckdb_sort

# Build rule for target.
duckdb_sort: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_sort
.PHONY : duckdb_sort

# fast build rule for target.
duckdb_sort/fast:
	$(MAKE) $(MAKESILENT) -f src/common/sort/CMakeFiles/duckdb_sort.dir/build.make src/common/sort/CMakeFiles/duckdb_sort.dir/build
.PHONY : duckdb_sort/fast

#=============================================================================
# Target rules for targets named duckdb_common_types

# Build rule for target.
duckdb_common_types: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_common_types
.PHONY : duckdb_common_types

# fast build rule for target.
duckdb_common_types/fast:
	$(MAKE) $(MAKESILENT) -f src/common/types/CMakeFiles/duckdb_common_types.dir/build.make src/common/types/CMakeFiles/duckdb_common_types.dir/build
.PHONY : duckdb_common_types/fast

#=============================================================================
# Target rules for targets named duckdb_value_operations

# Build rule for target.
duckdb_value_operations: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_value_operations
.PHONY : duckdb_value_operations

# fast build rule for target.
duckdb_value_operations/fast:
	$(MAKE) $(MAKESILENT) -f src/common/value_operations/CMakeFiles/duckdb_value_operations.dir/build.make src/common/value_operations/CMakeFiles/duckdb_value_operations.dir/build
.PHONY : duckdb_value_operations/fast

#=============================================================================
# Target rules for targets named duckdb_vector_operations

# Build rule for target.
duckdb_vector_operations: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_vector_operations
.PHONY : duckdb_vector_operations

# fast build rule for target.
duckdb_vector_operations/fast:
	$(MAKE) $(MAKESILENT) -f src/common/vector_operations/CMakeFiles/duckdb_vector_operations.dir/build.make src/common/vector_operations/CMakeFiles/duckdb_vector_operations.dir/build
.PHONY : duckdb_vector_operations/fast

#=============================================================================
# Target rules for targets named duckdb_execution

# Build rule for target.
duckdb_execution: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_execution
.PHONY : duckdb_execution

# fast build rule for target.
duckdb_execution/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/CMakeFiles/duckdb_execution.dir/build.make src/execution/CMakeFiles/duckdb_execution.dir/build
.PHONY : duckdb_execution/fast

#=============================================================================
# Target rules for targets named duckdb_expression_executor

# Build rule for target.
duckdb_expression_executor: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_expression_executor
.PHONY : duckdb_expression_executor

# fast build rule for target.
duckdb_expression_executor/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/expression_executor/CMakeFiles/duckdb_expression_executor.dir/build.make src/execution/expression_executor/CMakeFiles/duckdb_expression_executor.dir/build
.PHONY : duckdb_expression_executor/fast

#=============================================================================
# Target rules for targets named duckdb_nested_loop_join

# Build rule for target.
duckdb_nested_loop_join: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_nested_loop_join
.PHONY : duckdb_nested_loop_join

# fast build rule for target.
duckdb_nested_loop_join/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/nested_loop_join/CMakeFiles/duckdb_nested_loop_join.dir/build.make src/execution/nested_loop_join/CMakeFiles/duckdb_nested_loop_join.dir/build
.PHONY : duckdb_nested_loop_join/fast

#=============================================================================
# Target rules for targets named duckdb_operator_aggregate

# Build rule for target.
duckdb_operator_aggregate: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_aggregate
.PHONY : duckdb_operator_aggregate

# fast build rule for target.
duckdb_operator_aggregate/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/aggregate/CMakeFiles/duckdb_operator_aggregate.dir/build.make src/execution/operator/aggregate/CMakeFiles/duckdb_operator_aggregate.dir/build
.PHONY : duckdb_operator_aggregate/fast

#=============================================================================
# Target rules for targets named duckdb_operator_filter

# Build rule for target.
duckdb_operator_filter: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_filter
.PHONY : duckdb_operator_filter

# fast build rule for target.
duckdb_operator_filter/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/filter/CMakeFiles/duckdb_operator_filter.dir/build.make src/execution/operator/filter/CMakeFiles/duckdb_operator_filter.dir/build
.PHONY : duckdb_operator_filter/fast

#=============================================================================
# Target rules for targets named duckdb_operator_helper

# Build rule for target.
duckdb_operator_helper: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_helper
.PHONY : duckdb_operator_helper

# fast build rule for target.
duckdb_operator_helper/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/helper/CMakeFiles/duckdb_operator_helper.dir/build.make src/execution/operator/helper/CMakeFiles/duckdb_operator_helper.dir/build
.PHONY : duckdb_operator_helper/fast

#=============================================================================
# Target rules for targets named duckdb_operator_join

# Build rule for target.
duckdb_operator_join: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_join
.PHONY : duckdb_operator_join

# fast build rule for target.
duckdb_operator_join/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/join/CMakeFiles/duckdb_operator_join.dir/build.make src/execution/operator/join/CMakeFiles/duckdb_operator_join.dir/build
.PHONY : duckdb_operator_join/fast

#=============================================================================
# Target rules for targets named duckdb_operator_order

# Build rule for target.
duckdb_operator_order: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_order
.PHONY : duckdb_operator_order

# fast build rule for target.
duckdb_operator_order/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/build.make src/execution/operator/order/CMakeFiles/duckdb_operator_order.dir/build
.PHONY : duckdb_operator_order/fast

#=============================================================================
# Target rules for targets named duckdb_operator_persistent

# Build rule for target.
duckdb_operator_persistent: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_persistent
.PHONY : duckdb_operator_persistent

# fast build rule for target.
duckdb_operator_persistent/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/persistent/CMakeFiles/duckdb_operator_persistent.dir/build.make src/execution/operator/persistent/CMakeFiles/duckdb_operator_persistent.dir/build
.PHONY : duckdb_operator_persistent/fast

#=============================================================================
# Target rules for targets named duckdb_operator_projection

# Build rule for target.
duckdb_operator_projection: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_projection
.PHONY : duckdb_operator_projection

# fast build rule for target.
duckdb_operator_projection/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/projection/CMakeFiles/duckdb_operator_projection.dir/build.make src/execution/operator/projection/CMakeFiles/duckdb_operator_projection.dir/build
.PHONY : duckdb_operator_projection/fast

#=============================================================================
# Target rules for targets named duckdb_operator_scan

# Build rule for target.
duckdb_operator_scan: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_scan
.PHONY : duckdb_operator_scan

# fast build rule for target.
duckdb_operator_scan/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/scan/CMakeFiles/duckdb_operator_scan.dir/build.make src/execution/operator/scan/CMakeFiles/duckdb_operator_scan.dir/build
.PHONY : duckdb_operator_scan/fast

#=============================================================================
# Target rules for targets named duckdb_operator_schema

# Build rule for target.
duckdb_operator_schema: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_schema
.PHONY : duckdb_operator_schema

# fast build rule for target.
duckdb_operator_schema/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/schema/CMakeFiles/duckdb_operator_schema.dir/build.make src/execution/operator/schema/CMakeFiles/duckdb_operator_schema.dir/build
.PHONY : duckdb_operator_schema/fast

#=============================================================================
# Target rules for targets named duckdb_operator_set

# Build rule for target.
duckdb_operator_set: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_operator_set
.PHONY : duckdb_operator_set

# fast build rule for target.
duckdb_operator_set/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/operator/set/CMakeFiles/duckdb_operator_set.dir/build.make src/execution/operator/set/CMakeFiles/duckdb_operator_set.dir/build
.PHONY : duckdb_operator_set/fast

#=============================================================================
# Target rules for targets named duckdb_physical_plan

# Build rule for target.
duckdb_physical_plan: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_physical_plan
.PHONY : duckdb_physical_plan

# fast build rule for target.
duckdb_physical_plan/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/physical_plan/CMakeFiles/duckdb_physical_plan.dir/build.make src/execution/physical_plan/CMakeFiles/duckdb_physical_plan.dir/build
.PHONY : duckdb_physical_plan/fast

#=============================================================================
# Target rules for targets named duckdb_art_index_execution

# Build rule for target.
duckdb_art_index_execution: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_art_index_execution
.PHONY : duckdb_art_index_execution

# fast build rule for target.
duckdb_art_index_execution/fast:
	$(MAKE) $(MAKESILENT) -f src/execution/index/art/CMakeFiles/duckdb_art_index_execution.dir/build.make src/execution/index/art/CMakeFiles/duckdb_art_index_execution.dir/build
.PHONY : duckdb_art_index_execution/fast

#=============================================================================
# Target rules for targets named duckdb_main

# Build rule for target.
duckdb_main: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_main
.PHONY : duckdb_main

# fast build rule for target.
duckdb_main/fast:
	$(MAKE) $(MAKESILENT) -f src/main/CMakeFiles/duckdb_main.dir/build.make src/main/CMakeFiles/duckdb_main.dir/build
.PHONY : duckdb_main/fast

#=============================================================================
# Target rules for targets named duckdb_main_capi

# Build rule for target.
duckdb_main_capi: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_main_capi
.PHONY : duckdb_main_capi

# fast build rule for target.
duckdb_main_capi/fast:
	$(MAKE) $(MAKESILENT) -f src/main/capi/CMakeFiles/duckdb_main_capi.dir/build.make src/main/capi/CMakeFiles/duckdb_main_capi.dir/build
.PHONY : duckdb_main_capi/fast

#=============================================================================
# Target rules for targets named duckdb_main_extension

# Build rule for target.
duckdb_main_extension: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_main_extension
.PHONY : duckdb_main_extension

# fast build rule for target.
duckdb_main_extension/fast:
	$(MAKE) $(MAKESILENT) -f src/main/extension/CMakeFiles/duckdb_main_extension.dir/build.make src/main/extension/CMakeFiles/duckdb_main_extension.dir/build
.PHONY : duckdb_main_extension/fast

#=============================================================================
# Target rules for targets named duckdb_main_relation

# Build rule for target.
duckdb_main_relation: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_main_relation
.PHONY : duckdb_main_relation

# fast build rule for target.
duckdb_main_relation/fast:
	$(MAKE) $(MAKESILENT) -f src/main/relation/CMakeFiles/duckdb_main_relation.dir/build.make src/main/relation/CMakeFiles/duckdb_main_relation.dir/build
.PHONY : duckdb_main_relation/fast

#=============================================================================
# Target rules for targets named duckdb_main_settings

# Build rule for target.
duckdb_main_settings: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_main_settings
.PHONY : duckdb_main_settings

# fast build rule for target.
duckdb_main_settings/fast:
	$(MAKE) $(MAKESILENT) -f src/main/settings/CMakeFiles/duckdb_main_settings.dir/build.make src/main/settings/CMakeFiles/duckdb_main_settings.dir/build
.PHONY : duckdb_main_settings/fast

#=============================================================================
# Target rules for targets named duckdb_parallel

# Build rule for target.
duckdb_parallel: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_parallel
.PHONY : duckdb_parallel

# fast build rule for target.
duckdb_parallel/fast:
	$(MAKE) $(MAKESILENT) -f src/parallel/CMakeFiles/duckdb_parallel.dir/build.make src/parallel/CMakeFiles/duckdb_parallel.dir/build
.PHONY : duckdb_parallel/fast

#=============================================================================
# Target rules for targets named duckdb_storage

# Build rule for target.
duckdb_storage: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage
.PHONY : duckdb_storage

# fast build rule for target.
duckdb_storage/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/CMakeFiles/duckdb_storage.dir/build.make src/storage/CMakeFiles/duckdb_storage.dir/build
.PHONY : duckdb_storage/fast

#=============================================================================
# Target rules for targets named duckdb_storage_buffer

# Build rule for target.
duckdb_storage_buffer: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage_buffer
.PHONY : duckdb_storage_buffer

# fast build rule for target.
duckdb_storage_buffer/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/build.make src/storage/buffer/CMakeFiles/duckdb_storage_buffer.dir/build
.PHONY : duckdb_storage_buffer/fast

#=============================================================================
# Target rules for targets named duckdb_storage_checkpoint

# Build rule for target.
duckdb_storage_checkpoint: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage_checkpoint
.PHONY : duckdb_storage_checkpoint

# fast build rule for target.
duckdb_storage_checkpoint/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/checkpoint/CMakeFiles/duckdb_storage_checkpoint.dir/build.make src/storage/checkpoint/CMakeFiles/duckdb_storage_checkpoint.dir/build
.PHONY : duckdb_storage_checkpoint/fast

#=============================================================================
# Target rules for targets named duckdb_storage_segment

# Build rule for target.
duckdb_storage_segment: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage_segment
.PHONY : duckdb_storage_segment

# fast build rule for target.
duckdb_storage_segment/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/compression/CMakeFiles/duckdb_storage_segment.dir/build.make src/storage/compression/CMakeFiles/duckdb_storage_segment.dir/build
.PHONY : duckdb_storage_segment/fast

#=============================================================================
# Target rules for targets named duckdb_storage_statistics

# Build rule for target.
duckdb_storage_statistics: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage_statistics
.PHONY : duckdb_storage_statistics

# fast build rule for target.
duckdb_storage_statistics/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/statistics/CMakeFiles/duckdb_storage_statistics.dir/build.make src/storage/statistics/CMakeFiles/duckdb_storage_statistics.dir/build
.PHONY : duckdb_storage_statistics/fast

#=============================================================================
# Target rules for targets named duckdb_storage_table

# Build rule for target.
duckdb_storage_table: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_storage_table
.PHONY : duckdb_storage_table

# fast build rule for target.
duckdb_storage_table/fast:
	$(MAKE) $(MAKESILENT) -f src/storage/table/CMakeFiles/duckdb_storage_table.dir/build.make src/storage/table/CMakeFiles/duckdb_storage_table.dir/build
.PHONY : duckdb_storage_table/fast

#=============================================================================
# Target rules for targets named duckdb_transaction

# Build rule for target.
duckdb_transaction: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_transaction
.PHONY : duckdb_transaction

# fast build rule for target.
duckdb_transaction/fast:
	$(MAKE) $(MAKESILENT) -f src/transaction/CMakeFiles/duckdb_transaction.dir/build.make src/transaction/CMakeFiles/duckdb_transaction.dir/build
.PHONY : duckdb_transaction/fast

#=============================================================================
# Target rules for targets named sqlite3_api_wrapper_static

# Build rule for target.
sqlite3_api_wrapper_static: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sqlite3_api_wrapper_static
.PHONY : sqlite3_api_wrapper_static

# fast build rule for target.
sqlite3_api_wrapper_static/fast:
	$(MAKE) $(MAKESILENT) -f tools/sqlite3_api_wrapper/CMakeFiles/sqlite3_api_wrapper_static.dir/build.make tools/sqlite3_api_wrapper/CMakeFiles/sqlite3_api_wrapper_static.dir/build
.PHONY : sqlite3_api_wrapper_static/fast

#=============================================================================
# Target rules for targets named sqlite3_api_wrapper

# Build rule for target.
sqlite3_api_wrapper: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sqlite3_api_wrapper
.PHONY : sqlite3_api_wrapper

# fast build rule for target.
sqlite3_api_wrapper/fast:
	$(MAKE) $(MAKESILENT) -f tools/sqlite3_api_wrapper/CMakeFiles/sqlite3_api_wrapper.dir/build.make tools/sqlite3_api_wrapper/CMakeFiles/sqlite3_api_wrapper.dir/build
.PHONY : sqlite3_api_wrapper/fast

#=============================================================================
# Target rules for targets named test_sqlite3_api_wrapper

# Build rule for target.
test_sqlite3_api_wrapper: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sqlite3_api_wrapper
.PHONY : test_sqlite3_api_wrapper

# fast build rule for target.
test_sqlite3_api_wrapper/fast:
	$(MAKE) $(MAKESILENT) -f tools/sqlite3_api_wrapper/CMakeFiles/test_sqlite3_api_wrapper.dir/build.make tools/sqlite3_api_wrapper/CMakeFiles/test_sqlite3_api_wrapper.dir/build
.PHONY : test_sqlite3_api_wrapper/fast

#=============================================================================
# Target rules for targets named sqlite3_api_wrapper_sqlite3

# Build rule for target.
sqlite3_api_wrapper_sqlite3: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sqlite3_api_wrapper_sqlite3
.PHONY : sqlite3_api_wrapper_sqlite3

# fast build rule for target.
sqlite3_api_wrapper_sqlite3/fast:
	$(MAKE) $(MAKESILENT) -f tools/sqlite3_api_wrapper/sqlite3/CMakeFiles/sqlite3_api_wrapper_sqlite3.dir/build.make tools/sqlite3_api_wrapper/sqlite3/CMakeFiles/sqlite3_api_wrapper_sqlite3.dir/build
.PHONY : sqlite3_api_wrapper_sqlite3/fast

#=============================================================================
# Target rules for targets named sqlite3_udf_api

# Build rule for target.
sqlite3_udf_api: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sqlite3_udf_api
.PHONY : sqlite3_udf_api

# fast build rule for target.
sqlite3_udf_api/fast:
	$(MAKE) $(MAKESILENT) -f tools/sqlite3_api_wrapper/sqlite3_udf_api/CMakeFiles/sqlite3_udf_api.dir/build.make tools/sqlite3_api_wrapper/sqlite3_udf_api/CMakeFiles/sqlite3_udf_api.dir/build
.PHONY : sqlite3_udf_api/fast

#=============================================================================
# Target rules for targets named shell

# Build rule for target.
shell: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 shell
.PHONY : shell

# fast build rule for target.
shell/fast:
	$(MAKE) $(MAKESILENT) -f tools/shell/CMakeFiles/shell.dir/build.make tools/shell/CMakeFiles/shell.dir/build
.PHONY : shell/fast

#=============================================================================
# Target rules for targets named sketch_extension

# Build rule for target.
sketch_extension: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sketch_extension
.PHONY : sketch_extension

# fast build rule for target.
sketch_extension/fast:
	$(MAKE) $(MAKESILENT) -f extension/sketch/CMakeFiles/sketch_extension.dir/build.make extension/sketch/CMakeFiles/sketch_extension.dir/build
.PHONY : sketch_extension/fast

#=============================================================================
# Target rules for targets named sketch_loadable_extension

# Build rule for target.
sketch_loadable_extension: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 sketch_loadable_extension
.PHONY : sketch_loadable_extension

# fast build rule for target.
sketch_loadable_extension/fast:
	$(MAKE) $(MAKESILENT) -f extension/sketch/CMakeFiles/sketch_loadable_extension.dir/build.make extension/sketch/CMakeFiles/sketch_loadable_extension.dir/build
.PHONY : sketch_loadable_extension/fast

#=============================================================================
# Target rules for targets named unittest

# Build rule for target.
unittest: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 unittest
.PHONY : unittest

# fast build rule for target.
unittest/fast:
	$(MAKE) $(MAKESILENT) -f test/CMakeFiles/unittest.dir/build.make test/CMakeFiles/unittest.dir/build
.PHONY : unittest/fast

#=============================================================================
# Target rules for targets named test_api

# Build rule for target.
test_api: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_api
.PHONY : test_api

# fast build rule for target.
test_api/fast:
	$(MAKE) $(MAKESILENT) -f test/api/CMakeFiles/test_api.dir/build.make test/api/CMakeFiles/test_api.dir/build
.PHONY : test_api/fast

#=============================================================================
# Target rules for targets named test_sql_capi

# Build rule for target.
test_sql_capi: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sql_capi
.PHONY : test_sql_capi

# fast build rule for target.
test_sql_capi/fast:
	$(MAKE) $(MAKESILENT) -f test/api/capi/CMakeFiles/test_sql_capi.dir/build.make test/api/capi/CMakeFiles/test_sql_capi.dir/build
.PHONY : test_sql_capi/fast

#=============================================================================
# Target rules for targets named test_api_udf_function

# Build rule for target.
test_api_udf_function: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_api_udf_function
.PHONY : test_api_udf_function

# fast build rule for target.
test_api_udf_function/fast:
	$(MAKE) $(MAKESILENT) -f test/api/udf_function/CMakeFiles/test_api_udf_function.dir/build.make test/api/udf_function/CMakeFiles/test_api_udf_function.dir/build
.PHONY : test_api_udf_function/fast

#=============================================================================
# Target rules for targets named test_appender

# Build rule for target.
test_appender: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_appender
.PHONY : test_appender

# fast build rule for target.
test_appender/fast:
	$(MAKE) $(MAKESILENT) -f test/appender/CMakeFiles/test_appender.dir/build.make test/appender/CMakeFiles/test_appender.dir/build
.PHONY : test_appender/fast

#=============================================================================
# Target rules for targets named test_common

# Build rule for target.
test_common: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_common
.PHONY : test_common

# fast build rule for target.
test_common/fast:
	$(MAKE) $(MAKESILENT) -f test/common/CMakeFiles/test_common.dir/build.make test/common/CMakeFiles/test_common.dir/build
.PHONY : test_common/fast

#=============================================================================
# Target rules for targets named loadable_extension_demo_loadable_extension

# Build rule for target.
loadable_extension_demo_loadable_extension: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 loadable_extension_demo_loadable_extension
.PHONY : loadable_extension_demo_loadable_extension

# fast build rule for target.
loadable_extension_demo_loadable_extension/fast:
	$(MAKE) $(MAKESILENT) -f test/extension/CMakeFiles/loadable_extension_demo_loadable_extension.dir/build.make test/extension/CMakeFiles/loadable_extension_demo_loadable_extension.dir/build
.PHONY : loadable_extension_demo_loadable_extension/fast

#=============================================================================
# Target rules for targets named test_helpers

# Build rule for target.
test_helpers: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_helpers
.PHONY : test_helpers

# fast build rule for target.
test_helpers/fast:
	$(MAKE) $(MAKESILENT) -f test/helpers/CMakeFiles/test_helpers.dir/build.make test/helpers/CMakeFiles/test_helpers.dir/build
.PHONY : test_helpers/fast

#=============================================================================
# Target rules for targets named test_index

# Build rule for target.
test_index: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_index
.PHONY : test_index

# fast build rule for target.
test_index/fast:
	$(MAKE) $(MAKESILENT) -f test/sql/index/CMakeFiles/test_index.dir/build.make test/sql/index/CMakeFiles/test_index.dir/build
.PHONY : test_index/fast

#=============================================================================
# Target rules for targets named test_sql_interquery_parallelism

# Build rule for target.
test_sql_interquery_parallelism: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sql_interquery_parallelism
.PHONY : test_sql_interquery_parallelism

# fast build rule for target.
test_sql_interquery_parallelism/fast:
	$(MAKE) $(MAKESILENT) -f test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/build.make test/sql/parallelism/interquery/CMakeFiles/test_sql_interquery_parallelism.dir/build
.PHONY : test_sql_interquery_parallelism/fast

#=============================================================================
# Target rules for targets named test_sql_storage

# Build rule for target.
test_sql_storage: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sql_storage
.PHONY : test_sql_storage

# fast build rule for target.
test_sql_storage/fast:
	$(MAKE) $(MAKESILENT) -f test/sql/storage/CMakeFiles/test_sql_storage.dir/build.make test/sql/storage/CMakeFiles/test_sql_storage.dir/build
.PHONY : test_sql_storage/fast

#=============================================================================
# Target rules for targets named test_sql_storage_catalog

# Build rule for target.
test_sql_storage_catalog: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sql_storage_catalog
.PHONY : test_sql_storage_catalog

# fast build rule for target.
test_sql_storage_catalog/fast:
	$(MAKE) $(MAKESILENT) -f test/sql/storage/catalog/CMakeFiles/test_sql_storage_catalog.dir/build.make test/sql/storage/catalog/CMakeFiles/test_sql_storage_catalog.dir/build
.PHONY : test_sql_storage_catalog/fast

#=============================================================================
# Target rules for targets named test_sqlite

# Build rule for target.
test_sqlite: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_sqlite
.PHONY : test_sqlite

# fast build rule for target.
test_sqlite/fast:
	$(MAKE) $(MAKESILENT) -f test/sqlite/CMakeFiles/test_sqlite.dir/build.make test/sqlite/CMakeFiles/test_sqlite.dir/build
.PHONY : test_sqlite/fast

#=============================================================================
# Target rules for targets named test_ossfuzz

# Build rule for target.
test_ossfuzz: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_ossfuzz
.PHONY : test_ossfuzz

# fast build rule for target.
test_ossfuzz/fast:
	$(MAKE) $(MAKESILENT) -f test/ossfuzz/CMakeFiles/test_ossfuzz.dir/build.make test/ossfuzz/CMakeFiles/test_ossfuzz.dir/build
.PHONY : test_ossfuzz/fast

#=============================================================================
# Target rules for targets named test_mbedtls

# Build rule for target.
test_mbedtls: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_mbedtls
.PHONY : test_mbedtls

# fast build rule for target.
test_mbedtls/fast:
	$(MAKE) $(MAKESILENT) -f test/mbedtls/CMakeFiles/test_mbedtls.dir/build.make test/mbedtls/CMakeFiles/test_mbedtls.dir/build
.PHONY : test_mbedtls/fast

#=============================================================================
# Target rules for targets named test_persistence

# Build rule for target.
test_persistence: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 test_persistence
.PHONY : test_persistence

# fast build rule for target.
test_persistence/fast:
	$(MAKE) $(MAKESILENT) -f test/persistence/CMakeFiles/test_persistence.dir/build.make test/persistence/CMakeFiles/test_persistence.dir/build
.PHONY : test_persistence/fast

#=============================================================================
# Target rules for targets named duckdb_fmt

# Build rule for target.
duckdb_fmt: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_fmt
.PHONY : duckdb_fmt

# fast build rule for target.
duckdb_fmt/fast:
	$(MAKE) $(MAKESILENT) -f third_party/fmt/CMakeFiles/duckdb_fmt.dir/build.make third_party/fmt/CMakeFiles/duckdb_fmt.dir/build
.PHONY : duckdb_fmt/fast

#=============================================================================
# Target rules for targets named duckdb_pg_query

# Build rule for target.
duckdb_pg_query: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_pg_query
.PHONY : duckdb_pg_query

# fast build rule for target.
duckdb_pg_query/fast:
	$(MAKE) $(MAKESILENT) -f third_party/libpg_query/CMakeFiles/duckdb_pg_query.dir/build.make third_party/libpg_query/CMakeFiles/duckdb_pg_query.dir/build
.PHONY : duckdb_pg_query/fast

#=============================================================================
# Target rules for targets named Experimental

# Build rule for target.
Experimental: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 Experimental
.PHONY : Experimental

# fast build rule for target.
Experimental/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/Experimental.dir/build.make third_party/re2/CMakeFiles/Experimental.dir/build
.PHONY : Experimental/fast

#=============================================================================
# Target rules for targets named Nightly

# Build rule for target.
Nightly: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 Nightly
.PHONY : Nightly

# fast build rule for target.
Nightly/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/Nightly.dir/build.make third_party/re2/CMakeFiles/Nightly.dir/build
.PHONY : Nightly/fast

#=============================================================================
# Target rules for targets named Continuous

# Build rule for target.
Continuous: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 Continuous
.PHONY : Continuous

# fast build rule for target.
Continuous/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/Continuous.dir/build.make third_party/re2/CMakeFiles/Continuous.dir/build
.PHONY : Continuous/fast

#=============================================================================
# Target rules for targets named NightlyMemoryCheck

# Build rule for target.
NightlyMemoryCheck: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyMemoryCheck
.PHONY : NightlyMemoryCheck

# fast build rule for target.
NightlyMemoryCheck/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyMemoryCheck.dir/build.make third_party/re2/CMakeFiles/NightlyMemoryCheck.dir/build
.PHONY : NightlyMemoryCheck/fast

#=============================================================================
# Target rules for targets named NightlyStart

# Build rule for target.
NightlyStart: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyStart
.PHONY : NightlyStart

# fast build rule for target.
NightlyStart/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyStart.dir/build.make third_party/re2/CMakeFiles/NightlyStart.dir/build
.PHONY : NightlyStart/fast

#=============================================================================
# Target rules for targets named NightlyUpdate

# Build rule for target.
NightlyUpdate: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyUpdate
.PHONY : NightlyUpdate

# fast build rule for target.
NightlyUpdate/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyUpdate.dir/build.make third_party/re2/CMakeFiles/NightlyUpdate.dir/build
.PHONY : NightlyUpdate/fast

#=============================================================================
# Target rules for targets named NightlyConfigure

# Build rule for target.
NightlyConfigure: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyConfigure
.PHONY : NightlyConfigure

# fast build rule for target.
NightlyConfigure/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyConfigure.dir/build.make third_party/re2/CMakeFiles/NightlyConfigure.dir/build
.PHONY : NightlyConfigure/fast

#=============================================================================
# Target rules for targets named NightlyBuild

# Build rule for target.
NightlyBuild: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyBuild
.PHONY : NightlyBuild

# fast build rule for target.
NightlyBuild/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyBuild.dir/build.make third_party/re2/CMakeFiles/NightlyBuild.dir/build
.PHONY : NightlyBuild/fast

#=============================================================================
# Target rules for targets named NightlyTest

# Build rule for target.
NightlyTest: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyTest
.PHONY : NightlyTest

# fast build rule for target.
NightlyTest/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyTest.dir/build.make third_party/re2/CMakeFiles/NightlyTest.dir/build
.PHONY : NightlyTest/fast

#=============================================================================
# Target rules for targets named NightlyCoverage

# Build rule for target.
NightlyCoverage: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyCoverage
.PHONY : NightlyCoverage

# fast build rule for target.
NightlyCoverage/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyCoverage.dir/build.make third_party/re2/CMakeFiles/NightlyCoverage.dir/build
.PHONY : NightlyCoverage/fast

#=============================================================================
# Target rules for targets named NightlyMemCheck

# Build rule for target.
NightlyMemCheck: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlyMemCheck
.PHONY : NightlyMemCheck

# fast build rule for target.
NightlyMemCheck/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlyMemCheck.dir/build.make third_party/re2/CMakeFiles/NightlyMemCheck.dir/build
.PHONY : NightlyMemCheck/fast

#=============================================================================
# Target rules for targets named NightlySubmit

# Build rule for target.
NightlySubmit: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 NightlySubmit
.PHONY : NightlySubmit

# fast build rule for target.
NightlySubmit/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/NightlySubmit.dir/build.make third_party/re2/CMakeFiles/NightlySubmit.dir/build
.PHONY : NightlySubmit/fast

#=============================================================================
# Target rules for targets named ExperimentalStart

# Build rule for target.
ExperimentalStart: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalStart
.PHONY : ExperimentalStart

# fast build rule for target.
ExperimentalStart/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalStart.dir/build.make third_party/re2/CMakeFiles/ExperimentalStart.dir/build
.PHONY : ExperimentalStart/fast

#=============================================================================
# Target rules for targets named ExperimentalUpdate

# Build rule for target.
ExperimentalUpdate: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalUpdate
.PHONY : ExperimentalUpdate

# fast build rule for target.
ExperimentalUpdate/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalUpdate.dir/build.make third_party/re2/CMakeFiles/ExperimentalUpdate.dir/build
.PHONY : ExperimentalUpdate/fast

#=============================================================================
# Target rules for targets named ExperimentalConfigure

# Build rule for target.
ExperimentalConfigure: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalConfigure
.PHONY : ExperimentalConfigure

# fast build rule for target.
ExperimentalConfigure/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalConfigure.dir/build.make third_party/re2/CMakeFiles/ExperimentalConfigure.dir/build
.PHONY : ExperimentalConfigure/fast

#=============================================================================
# Target rules for targets named ExperimentalBuild

# Build rule for target.
ExperimentalBuild: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalBuild
.PHONY : ExperimentalBuild

# fast build rule for target.
ExperimentalBuild/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalBuild.dir/build.make third_party/re2/CMakeFiles/ExperimentalBuild.dir/build
.PHONY : ExperimentalBuild/fast

#=============================================================================
# Target rules for targets named ExperimentalTest

# Build rule for target.
ExperimentalTest: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalTest
.PHONY : ExperimentalTest

# fast build rule for target.
ExperimentalTest/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalTest.dir/build.make third_party/re2/CMakeFiles/ExperimentalTest.dir/build
.PHONY : ExperimentalTest/fast

#=============================================================================
# Target rules for targets named ExperimentalCoverage

# Build rule for target.
ExperimentalCoverage: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalCoverage
.PHONY : ExperimentalCoverage

# fast build rule for target.
ExperimentalCoverage/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalCoverage.dir/build.make third_party/re2/CMakeFiles/ExperimentalCoverage.dir/build
.PHONY : ExperimentalCoverage/fast

#=============================================================================
# Target rules for targets named ExperimentalMemCheck

# Build rule for target.
ExperimentalMemCheck: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalMemCheck
.PHONY : ExperimentalMemCheck

# fast build rule for target.
ExperimentalMemCheck/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalMemCheck.dir/build.make third_party/re2/CMakeFiles/ExperimentalMemCheck.dir/build
.PHONY : ExperimentalMemCheck/fast

#=============================================================================
# Target rules for targets named ExperimentalSubmit

# Build rule for target.
ExperimentalSubmit: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ExperimentalSubmit
.PHONY : ExperimentalSubmit

# fast build rule for target.
ExperimentalSubmit/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ExperimentalSubmit.dir/build.make third_party/re2/CMakeFiles/ExperimentalSubmit.dir/build
.PHONY : ExperimentalSubmit/fast

#=============================================================================
# Target rules for targets named ContinuousStart

# Build rule for target.
ContinuousStart: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousStart
.PHONY : ContinuousStart

# fast build rule for target.
ContinuousStart/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousStart.dir/build.make third_party/re2/CMakeFiles/ContinuousStart.dir/build
.PHONY : ContinuousStart/fast

#=============================================================================
# Target rules for targets named ContinuousUpdate

# Build rule for target.
ContinuousUpdate: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousUpdate
.PHONY : ContinuousUpdate

# fast build rule for target.
ContinuousUpdate/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousUpdate.dir/build.make third_party/re2/CMakeFiles/ContinuousUpdate.dir/build
.PHONY : ContinuousUpdate/fast

#=============================================================================
# Target rules for targets named ContinuousConfigure

# Build rule for target.
ContinuousConfigure: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousConfigure
.PHONY : ContinuousConfigure

# fast build rule for target.
ContinuousConfigure/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousConfigure.dir/build.make third_party/re2/CMakeFiles/ContinuousConfigure.dir/build
.PHONY : ContinuousConfigure/fast

#=============================================================================
# Target rules for targets named ContinuousBuild

# Build rule for target.
ContinuousBuild: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousBuild
.PHONY : ContinuousBuild

# fast build rule for target.
ContinuousBuild/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousBuild.dir/build.make third_party/re2/CMakeFiles/ContinuousBuild.dir/build
.PHONY : ContinuousBuild/fast

#=============================================================================
# Target rules for targets named ContinuousTest

# Build rule for target.
ContinuousTest: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousTest
.PHONY : ContinuousTest

# fast build rule for target.
ContinuousTest/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousTest.dir/build.make third_party/re2/CMakeFiles/ContinuousTest.dir/build
.PHONY : ContinuousTest/fast

#=============================================================================
# Target rules for targets named ContinuousCoverage

# Build rule for target.
ContinuousCoverage: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousCoverage
.PHONY : ContinuousCoverage

# fast build rule for target.
ContinuousCoverage/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousCoverage.dir/build.make third_party/re2/CMakeFiles/ContinuousCoverage.dir/build
.PHONY : ContinuousCoverage/fast

#=============================================================================
# Target rules for targets named ContinuousMemCheck

# Build rule for target.
ContinuousMemCheck: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousMemCheck
.PHONY : ContinuousMemCheck

# fast build rule for target.
ContinuousMemCheck/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousMemCheck.dir/build.make third_party/re2/CMakeFiles/ContinuousMemCheck.dir/build
.PHONY : ContinuousMemCheck/fast

#=============================================================================
# Target rules for targets named ContinuousSubmit

# Build rule for target.
ContinuousSubmit: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 ContinuousSubmit
.PHONY : ContinuousSubmit

# fast build rule for target.
ContinuousSubmit/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/ContinuousSubmit.dir/build.make third_party/re2/CMakeFiles/ContinuousSubmit.dir/build
.PHONY : ContinuousSubmit/fast

#=============================================================================
# Target rules for targets named duckdb_re2

# Build rule for target.
duckdb_re2: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_re2
.PHONY : duckdb_re2

# fast build rule for target.
duckdb_re2/fast:
	$(MAKE) $(MAKESILENT) -f third_party/re2/CMakeFiles/duckdb_re2.dir/build.make third_party/re2/CMakeFiles/duckdb_re2.dir/build
.PHONY : duckdb_re2/fast

#=============================================================================
# Target rules for targets named duckdb_miniz

# Build rule for target.
duckdb_miniz: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_miniz
.PHONY : duckdb_miniz

# fast build rule for target.
duckdb_miniz/fast:
	$(MAKE) $(MAKESILENT) -f third_party/miniz/CMakeFiles/duckdb_miniz.dir/build.make third_party/miniz/CMakeFiles/duckdb_miniz.dir/build
.PHONY : duckdb_miniz/fast

#=============================================================================
# Target rules for targets named duckdb_utf8proc

# Build rule for target.
duckdb_utf8proc: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_utf8proc
.PHONY : duckdb_utf8proc

# fast build rule for target.
duckdb_utf8proc/fast:
	$(MAKE) $(MAKESILENT) -f third_party/utf8proc/CMakeFiles/duckdb_utf8proc.dir/build.make third_party/utf8proc/CMakeFiles/duckdb_utf8proc.dir/build
.PHONY : duckdb_utf8proc/fast

#=============================================================================
# Target rules for targets named duckdb_hyperloglog

# Build rule for target.
duckdb_hyperloglog: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_hyperloglog
.PHONY : duckdb_hyperloglog

# fast build rule for target.
duckdb_hyperloglog/fast:
	$(MAKE) $(MAKESILENT) -f third_party/hyperloglog/CMakeFiles/duckdb_hyperloglog.dir/build.make third_party/hyperloglog/CMakeFiles/duckdb_hyperloglog.dir/build
.PHONY : duckdb_hyperloglog/fast

#=============================================================================
# Target rules for targets named duckdb_fastpforlib

# Build rule for target.
duckdb_fastpforlib: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_fastpforlib
.PHONY : duckdb_fastpforlib

# fast build rule for target.
duckdb_fastpforlib/fast:
	$(MAKE) $(MAKESILENT) -f third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/build.make third_party/fastpforlib/CMakeFiles/duckdb_fastpforlib.dir/build
.PHONY : duckdb_fastpforlib/fast

#=============================================================================
# Target rules for targets named duckdb_mbedtls

# Build rule for target.
duckdb_mbedtls: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_mbedtls
.PHONY : duckdb_mbedtls

# fast build rule for target.
duckdb_mbedtls/fast:
	$(MAKE) $(MAKESILENT) -f third_party/mbedtls/CMakeFiles/duckdb_mbedtls.dir/build.make third_party/mbedtls/CMakeFiles/duckdb_mbedtls.dir/build
.PHONY : duckdb_mbedtls/fast

#=============================================================================
# Target rules for targets named imdb

# Build rule for target.
imdb: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 imdb
.PHONY : imdb

# fast build rule for target.
imdb/fast:
	$(MAKE) $(MAKESILENT) -f third_party/imdb/CMakeFiles/imdb.dir/build.make third_party/imdb/CMakeFiles/imdb.dir/build
.PHONY : imdb/fast

#=============================================================================
# Target rules for targets named duckdb_sqlite3

# Build rule for target.
duckdb_sqlite3: cmake_check_build_system
	$(MAKE) $(MAKESILENT) -f CMakeFiles/Makefile2 duckdb_sqlite3
.PHONY : duckdb_sqlite3

# fast build rule for target.
duckdb_sqlite3/fast:
	$(MAKE) $(MAKESILENT) -f third_party/sqlite/CMakeFiles/duckdb_sqlite3.dir/build.make third_party/sqlite/CMakeFiles/duckdb_sqlite3.dir/build
.PHONY : duckdb_sqlite3/fast

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... edit_cache"
	@echo "... install"
	@echo "... install/local"
	@echo "... install/strip"
	@echo "... list_install_components"
	@echo "... rebuild_cache"
	@echo "... Continuous"
	@echo "... ContinuousBuild"
	@echo "... ContinuousConfigure"
	@echo "... ContinuousCoverage"
	@echo "... ContinuousMemCheck"
	@echo "... ContinuousStart"
	@echo "... ContinuousSubmit"
	@echo "... ContinuousTest"
	@echo "... ContinuousUpdate"
	@echo "... Experimental"
	@echo "... ExperimentalBuild"
	@echo "... ExperimentalConfigure"
	@echo "... ExperimentalCoverage"
	@echo "... ExperimentalMemCheck"
	@echo "... ExperimentalStart"
	@echo "... ExperimentalSubmit"
	@echo "... ExperimentalTest"
	@echo "... ExperimentalUpdate"
	@echo "... Nightly"
	@echo "... NightlyBuild"
	@echo "... NightlyConfigure"
	@echo "... NightlyCoverage"
	@echo "... NightlyMemCheck"
	@echo "... NightlyMemoryCheck"
	@echo "... NightlyStart"
	@echo "... NightlySubmit"
	@echo "... NightlyTest"
	@echo "... NightlyUpdate"
	@echo "... duckdb"
	@echo "... duckdb_aggr_algebraic"
	@echo "... duckdb_aggr_distr"
	@echo "... duckdb_aggr_holistic"
	@echo "... duckdb_aggr_nested"
	@echo "... duckdb_aggr_regr"
	@echo "... duckdb_art_index_execution"
	@echo "... duckdb_bind_expression"
	@echo "... duckdb_bind_query_node"
	@echo "... duckdb_bind_statement"
	@echo "... duckdb_bind_tableref"
	@echo "... duckdb_catalog"
	@echo "... duckdb_catalog_default_entries"
	@echo "... duckdb_catalog_entries"
	@echo "... duckdb_common"
	@echo "... duckdb_common_crypto"
	@echo "... duckdb_common_enums"
	@echo "... duckdb_common_operators"
	@echo "... duckdb_common_serializer"
	@echo "... duckdb_common_types"
	@echo "... duckdb_constraints"
	@echo "... duckdb_execution"
	@echo "... duckdb_expression"
	@echo "... duckdb_expression_binders"
	@echo "... duckdb_expression_executor"
	@echo "... duckdb_fastpforlib"
	@echo "... duckdb_fmt"
	@echo "... duckdb_func_aggr"
	@echo "... duckdb_func_blob"
	@echo "... duckdb_func_date"
	@echo "... duckdb_func_enum"
	@echo "... duckdb_func_generic"
	@echo "... duckdb_func_list"
	@echo "... duckdb_func_map_nested"
	@echo "... duckdb_func_math"
	@echo "... duckdb_func_ops"
	@echo "... duckdb_func_pragma"
	@echo "... duckdb_func_scalar"
	@echo "... duckdb_func_seq"
	@echo "... duckdb_func_string"
	@echo "... duckdb_func_struct"
	@echo "... duckdb_func_system"
	@echo "... duckdb_func_table"
	@echo "... duckdb_func_table_version"
	@echo "... duckdb_function"
	@echo "... duckdb_hyperloglog"
	@echo "... duckdb_main"
	@echo "... duckdb_main_capi"
	@echo "... duckdb_main_extension"
	@echo "... duckdb_main_relation"
	@echo "... duckdb_main_settings"
	@echo "... duckdb_mbedtls"
	@echo "... duckdb_miniz"
	@echo "... duckdb_nested_loop_join"
	@echo "... duckdb_operator_aggregate"
	@echo "... duckdb_operator_filter"
	@echo "... duckdb_operator_helper"
	@echo "... duckdb_operator_join"
	@echo "... duckdb_operator_order"
	@echo "... duckdb_operator_persistent"
	@echo "... duckdb_operator_projection"
	@echo "... duckdb_operator_scan"
	@echo "... duckdb_operator_schema"
	@echo "... duckdb_operator_set"
	@echo "... duckdb_optimizer"
	@echo "... duckdb_optimizer_join_order"
	@echo "... duckdb_optimizer_matcher"
	@echo "... duckdb_optimizer_pullup"
	@echo "... duckdb_optimizer_pushdown"
	@echo "... duckdb_optimizer_rules"
	@echo "... duckdb_optimizer_statistics_expr"
	@echo "... duckdb_optimizer_statistics_op"
	@echo "... duckdb_parallel"
	@echo "... duckdb_parsed_data"
	@echo "... duckdb_parser"
	@echo "... duckdb_parser_tableref"
	@echo "... duckdb_pg_query"
	@echo "... duckdb_physical_plan"
	@echo "... duckdb_planner"
	@echo "... duckdb_planner_expression"
	@echo "... duckdb_planner_filter"
	@echo "... duckdb_planner_operator"
	@echo "... duckdb_planner_subquery"
	@echo "... duckdb_query_node"
	@echo "... duckdb_re2"
	@echo "... duckdb_row_operations"
	@echo "... duckdb_sort"
	@echo "... duckdb_sqlite3"
	@echo "... duckdb_statement"
	@echo "... duckdb_static"
	@echo "... duckdb_storage"
	@echo "... duckdb_storage_buffer"
	@echo "... duckdb_storage_checkpoint"
	@echo "... duckdb_storage_segment"
	@echo "... duckdb_storage_statistics"
	@echo "... duckdb_storage_table"
	@echo "... duckdb_table_func_system"
	@echo "... duckdb_transaction"
	@echo "... duckdb_transformer_constraint"
	@echo "... duckdb_transformer_expression"
	@echo "... duckdb_transformer_helpers"
	@echo "... duckdb_transformer_statement"
	@echo "... duckdb_transformer_tableref"
	@echo "... duckdb_utf8proc"
	@echo "... duckdb_value_operations"
	@echo "... duckdb_vector_operations"
	@echo "... imdb"
	@echo "... loadable_extension_demo_loadable_extension"
	@echo "... shell"
	@echo "... sketch_extension"
	@echo "... sketch_loadable_extension"
	@echo "... sqlite3_api_wrapper"
	@echo "... sqlite3_api_wrapper_sqlite3"
	@echo "... sqlite3_api_wrapper_static"
	@echo "... sqlite3_udf_api"
	@echo "... test_api"
	@echo "... test_api_udf_function"
	@echo "... test_appender"
	@echo "... test_common"
	@echo "... test_helpers"
	@echo "... test_index"
	@echo "... test_mbedtls"
	@echo "... test_ossfuzz"
	@echo "... test_persistence"
	@echo "... test_sql_capi"
	@echo "... test_sql_interquery_parallelism"
	@echo "... test_sql_storage"
	@echo "... test_sql_storage_catalog"
	@echo "... test_sqlite"
	@echo "... test_sqlite3_api_wrapper"
	@echo "... unittest"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# No rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -S$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system


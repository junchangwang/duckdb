#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import numpy
import sys
from setuptools import setup, Extension
from setuptools.command.install import install
from setuptools.command.sdist import sdist
import subprocess
import platform
import distutils.spawn
import shutil

# some paranoia to start with
cmake_bin = distutils.spawn.find_executable('cmake')
if (cmake_bin is None):
    raise Exception('DuckDB needs cmake to build from source')

if platform.architecture()[0] != '64bit':
    raise Exception('DuckDB only supports 64 bit at this point')

# make sure we are in the right directory
os.chdir(os.path.dirname(os.path.realpath(__file__)))

archive_ext = 'a'
lib_prefix = 'lib'
if os.name == 'nt':
    archive_ext = 'lib'
    lib_prefix = 'RelWithDebInfo/'

dd_prefix = 'src/duckdb'
if not os.path.exists(dd_prefix):
    dd_prefix = '../../' # this is a build from within the tools/pythonpkg directory

# wrapper that builds the main DuckDB library first
class CustomInstallCommand(install):
    def run(self):
        wd = os.getcwd()
        os.chdir(dd_prefix)
        if not os.path.exists('build/release_notest'):
            os.makedirs('build/release_notest')
        os.chdir('build/release_notest')

        configcmd = 'cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLEAN=1 ../..'
        buildcmd = 'cmake --build . --target duckdb_static'

        if os.name == 'nt':
            configcmd += ' -DCMAKE_GENERATOR_PLATFORM=x64'
            buildcmd += ' --config RelWithDebInfo'

        subprocess.Popen(configcmd.split(' ')).wait()
        subprocess.Popen(buildcmd.split(' ')).wait()

        os.chdir(wd)
        if not os.path.isfile('%s/build/release_notest/src/%sduckdb_static.%s' % (dd_prefix, lib_prefix, archive_ext)):
            raise Exception('Library build failed :/') 
        install.run(self)

# create a distributable directory structure
class CustomSdistCommand(sdist):
    def run(self):
        if os.path.exists('src/duckdb'):
            shutil.rmtree('src/duckdb')
        if not os.path.exists('src/duckdb/third_party'):
            os.makedirs('src/duckdb/third_party')
        shutil.copyfile('../../CMakeLists.txt', 'src/duckdb/CMakeLists.txt')
        shutil.copyfile('../../third_party/CMakeLists.txt', 'src/duckdb/third_party/CMakeLists.txt')
        shutil.copytree('../../src', 'src/duckdb/src')
        shutil.copytree('../../third_party/libpg_query', 'src/duckdb/third_party/libpg_query')
        shutil.copytree('../../third_party/hyperloglog', 'src/duckdb/third_party/hyperloglog')
        shutil.copytree('../../third_party/re2', 'src/duckdb/third_party/re2')
        shutil.copytree('../../third_party/miniz', 'src/duckdb/third_party/miniz')
        sdist.run(self)

includes = [numpy.get_include(), '%s/src/include' % (dd_prefix), '.']
sources = ['connection.cpp', 'cursor.cpp', 'module.cpp']

libduckdb = Extension('duckdb',
    include_dirs=includes,
    sources=sources,
    extra_compile_args=['-std=c++11', '-Wall'],
    language='c++', # for linking c++ stdlib
    extra_objects=['%s/build/release_notest/src/%sduckdb_static.%s' % (dd_prefix, lib_prefix, archive_ext), '%s/build/release_notest/third_party/libpg_query/%spg_query.%s' % (dd_prefix, lib_prefix, archive_ext), '%s/build/release_notest/third_party/re2/%sre2.%s' % (dd_prefix, lib_prefix, archive_ext), '%s/build/release_notest/third_party/miniz/%sminiz.%s' % (dd_prefix, lib_prefix, archive_ext)])

setup(
    name = "duckdb",
    version = '0.0.2',
    description = 'DuckDB embedded database',
    keywords = 'DuckDB Database SQL OLAP',
    url="https://github.com/cwida/duckdb",
    long_description = '',
    install_requires=[
         'numpy>=1.16',
         'pandas>=0.24'
    ],
    setup_requires=['pytest-runner'],
    tests_require=['pytest'],
    classifiers = [
        'Programming Language :: Python :: 3.7',
        'Topic :: Database :: Database Engines/Servers',
        'Intended Audience :: Developers',
        'Development Status :: 3 - Alpha'
    ],
    cmdclass={
       'install': CustomInstallCommand,
       'sdist': CustomSdistCommand
    },
    ext_modules = [libduckdb],
    maintainer = "Hannes Muehleisen",
    maintainer_email = "hannes@cwi.nl"
)

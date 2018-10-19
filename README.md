
<br><a href="https://github.com/cginternals/cmake-init/"><img src="https://raw.githubusercontent.com/cginternals/cmake-init/master/cmake-init-logo.svg?sanitize=true" width="50%"></a>

The C++ CMake Project Template

[![Travis](https://img.shields.io/travis/cginternals/cmake-init/master.svg?style=flat&logo=travis)](https://travis-ci.org/cginternals/cmake-init)
[![Appveyor](https://img.shields.io/appveyor/ci/scheibel/cmake-init/master.svg?style=flat&logo=appveyor)](https://ci.appveyor.com/project/scheibel/cmake-init/branch/master)
[![Tokei](https://tokei.rs/b1/github/cginternals/cmake-init)](https://github.com/Aaronepower/tokei)
[![Setup Guide](https://img.shields.io/badge/cmake%20guide-wiki-blue.svg?style=flat)](https://github.com/cginternals/cmake-init/wiki/Setup-Guide)


*cmake-init* is a sophisticated copy & paste template for modern C and C++ projects.
The main goals include support of all use cases around software development (programming, testing, Q&A, deployment, documentation) while being modular, flexible, and idomatic. *cmake-init* is therefore a collection of cmake best-practices.

The main target platforms are typical desktop, laptop, and server platforms. Currently supported are:

* Windows
* macOS
* GNU/Linux

The cmake-init template assumes you want to setup a project using
* CMake (3.0 or above)
* C/C++ compiler


# Contents

* [Adaption Guide](#adaption-guide)
* [Non-Goals](#non-goals)
* [Module Documentation](#module-documentation)
  * [Core Modules](#core-modules)
    * [CMake Initialization](cmake-initialization)
    * [CMake Backward Compatibility](#cmake-backward-compatability)
    * [Project Meta Information](#project-meta-information)
    * [Project Meta Information Code Generation](#project-meta-information-code-generation)
    * [Project Build Options](#project-build-options)
  * [Maintainer Modules](#maintainer-modules)
    * [cmake-init Template Check](#cmake-init-template-check)
  * [Development Modules](#development-modules)
    * [Build Targets](#build-targets)
    * [Documentation](#documentation)
    * [Tests](#tests)
    * [Linter](#linter)
    * [Continuous Integration](#continuous-integration)
    * [Deployment](#deployment)
    * [Packaging](#packaging)
    * [Run-time Assets](#run-time-assets)

# Adaption Guide

The file [ADAPT.md](https://github.com/cginternals/cmake-init/blob/master/ADAPT.md) contains a task checklist for new projects.
More generally, a new project should contain all core modules and, as needed, add the maintainer and development modules as required. cmake-init does not impose modularity rules for the cmake targets.

# Non-Goals

In order to be usable in a deterministic, idiomatic fashion, we avoid the following approaches and features:

### Super-Build

Due to the current semantics of targets and CMake internals, combining multiple
cmake-init projects into one super-build project is not officially supported.
There are limited and restricting workarounds.
Actual solution: treat each project separately and use explicit dependency management.

### High Abstraction

We use low abstractions to not build a language upon CMake a user has to learn.

### File Glob

Explicit source specification prevents erroneous cases when adding and removing
sources from the project tree.

# Module Documentation

## Core Modules

### CMake Initialization

### CMake Backward Compatibility

### Project Meta Information

### Project Meta Information Code Generation

### Project Build Options

## Maintainer Modules

### cmake-init Template Check

## Development Modules

### Build Targets

### Documentation

### Tests

### Linter

### Continuous Integration

### Deployment

### Packaging

### Run-time Assets

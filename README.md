
<br><a href="https://github.com/cginternals/cmake-init/"><img src="https://raw.githubusercontent.com/cginternals/cmake-init/master/cmake-init-logo.svg?sanitize=true" width="50%"></a>

The C++ CMake Project Template

[![Travis](https://img.shields.io/travis/cginternals/cmake-init/master.svg?style=flat&logo=travis)](https://travis-ci.org/cginternals/cmake-init)
[![Appveyor](https://img.shields.io/appveyor/ci/scheibel/cmake-init/master.svg?style=flat&logo=appveyor)](https://ci.appveyor.com/project/scheibel/cmake-init/branch/master)
[![Tokei](https://tokei.rs/b1/github/cginternals/cmake-init)](https://github.com/Aaronepower/tokei)
[![Setup Guide](https://img.shields.io/badge/cmake%20guide-wiki-blue.svg?style=flat)](https://github.com/cginternals/cmake-init/wiki/Setup-Guide)


*cmake-init* is a sophisticated copy & paste template for modern C and C++ projects.
The main goals include support of all use cases around software development (programming, testing, Q&A, deployment, documentation) while being modular, flexible, and idiomatic. *cmake-init* is therefore a collection of cmake best-practices.

The main target platforms are typical desktop, laptop, and server platforms. Currently supported are:

* Windows
* macOS
* GNU/Linux

However, other UNIX versions may work as well if they are supported by CMake.

The cmake-init template assumes you want to setup a project using
* CMake (3.0 or above)
* C/C++ compiler


# Contents

* [Usage](#usage)
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
    * [Version Control System Integration](#version-control-system-integration)
    * [Build Targets](#build-targets)
    * [Documentation](#documentation)
    * [Tests](#tests)
    * [Linter](#linter)
    * [Continuous Integration](#continuous-integration)
    * [Deployment](#deployment)
    * [Packaging](#packaging)
    * [Run-time Assets](#run-time-assets)

# Usage

The intended use of the template is a copy of the current version with a subsequent replacement of project names and customization of modules to your needs. This is documented within the [adaption guide](#adaption-guide).
Another approach is the initialization of a new CMake project where the required features are adopted from cmake-init. We propose the former workflow.

Concluding, a new project should contain the core modules and, as needed, add the maintainer and development modules as required. All modules are designed in a way that they can be excluded. The process of integration or removal of a module/feature is documented with each module.

## Adaption Guide

The file [ADAPT.md](https://github.com/cginternals/cmake-init/blob/master/ADAPT.md) contains a task checklist for new projects. Your start with a copy of cmake-init and process each item from the checklist, adjusting the template to your needs.

## Update

After some time working on a project, cmake-init may be updated and you want to integrate the changes.
For an overview of changes we suggest to use the [cmake-init Template Check](#cmake-init-template-check) module.
Alternatively, you can update the required modules selectively.



# Non-Goals

In order to be usable in a deterministic, idiomatic fashion, cmake-init avoids the following approaches and features:

## Super-Build

Due to the current semantics of targets and CMake internals, combining multiple
cmake-init projects into one super-build project is not officially supported.
There are limited and restricting workarounds.
Actual solution: treat each project separately and use explicit dependency management.

## High Abstraction

We use low abstractions to not build a language upon CMake a user has to learn.

## File Glob

Explicit source specification prevents erroneous cases when adding and removing
sources from the project tree.

# Module Documentation

## Core Modules

### CMake Initialization

As with most CMake projects, cmake-init initializes the CMake environment. This includes the minimum required CMake version,

```cmake
# CMake version
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
```

required policies,

```cmake
# Set policies
set_policy(CMP0054 NEW) # ENABLE CMP0054: Only interpret if() arguments as variables or keywords when unquoted.
set_policy(CMP0042 NEW) # ENABLE CMP0042: MACOSX_RPATH is enabled by default.
set_policy(CMP0063 NEW) # ENABLE CMP0063: Honor visibility properties for all target types.
```

adaption of the cmake module path,

```cmake
# Include cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
```

and an include of default modules that are typically required for each project.

```cpp
include(GenerateExportHeader)
include(WriteCompilerDetectionHeader)
```


### CMake Backward Compatibility

As some modules as `WriteCompilerDetectionHeader` may not be available, cmake-init suggests to use fallbacks and availability detection.

Using this example, the module include

```cmake
include(WriteCompilerDetectionHeader)
```

is replaced by

```cmake
set(WriterCompilerDetectionHeaderFound NOTFOUND)
# This module is only available with CMake >=3.1, so check whether it could be found
# BUT in CMake 3.1 this module doesn't recognize AppleClang as compiler, so just use it as of CMake 3.2
if (${CMAKE_VERSION} VERSION_GREATER "3.2")
    include(WriteCompilerDetectionHeader OPTIONAL RESULT_VARIABLE WriterCompilerDetectionHeaderFound)
endif()
```

and the result can be later used with

```cmake
if (WriterCompilerDetectionHeaderFound)
  # ...
endif ()
```

Another issue with older CMake versions is the unavailability of then-unpublished language standards (e.g., C++11 and CMake 3.0). For those versions, the compile options has to be extended manually.

For new projects, we suggest to require at least CMake 3.2 and to therefore adjust the minimum required version:

```cmake
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)
```


### Project Meta Information

The declaration of project-wide information--that are used, e.g., within documentation, testing, and deployment--, is combined within the project meta information section in the main `CMakeLists.txt`.

```cmake
#
# Project description and (meta) information
#

# Meta information about the project
set(META_PROJECT_NAME        "template")
set(META_PROJECT_DESCRIPTION "CMake Project Template")
set(META_AUTHOR_ORGANIZATION "CG Internals GmbH")
set(META_AUTHOR_DOMAIN       "https://github.com/cginternals/cmake-init/")
set(META_AUTHOR_MAINTAINER   "opensource@cginternals.com")
set(META_VERSION_MAJOR       "2")
set(META_VERSION_MINOR       "0")
set(META_VERSION_PATCH       "0")
set(META_VERSION_REVISION    "<REVISION>")
set(META_VERSION             "${META_VERSION_MAJOR}.${META_VERSION_MINOR}.${META_VERSION_PATCH}")
set(META_NAME_VERSION        "${META_PROJECT_NAME} v${META_VERSION} (${META_VERSION_REVISION})")
set(META_CMAKE_INIT_SHA      "<CMAKE_INIT_REVISION>")

string(MAKE_C_IDENTIFIER ${META_PROJECT_NAME} META_PROJECT_ID)
string(TOUPPER ${META_PROJECT_ID} META_PROJECT_ID)
```

*cmake-init* supports the projects name, description, organization, domain, and maintainer email as well as detailed version information. For the version, we suggest to use [semantic versioning](https://semver.org/).
Depending on your version control system, you may want to integrate the current revision of the software as well: see [Version Control System Integration](#version-control-system-integration). If you use the [cmake-init Template Check](#cmake-init-template-check) module, the cmake-init SHA is declared within this section, too.

Last, *cmake-init* derives a project ID that complies with the naming schemes of C to be used within auto-generated and derived source code content (e.g., macro identifiers).


### Project Meta Information Code Generation

The result of this module is the generation of a C header file that propagates the project meta information to your C and C++ projects.
For this, the CMake file configuration feature is used on the `version.h.in` header template.

```c
#define @META_PROJECT_ID@_PROJECT_NAME        "@META_PROJECT_NAME@"
#define @META_PROJECT_ID@_PROJECT_DESCRIPTION "@META_PROJECT_DESCRIPTION@"

#define @META_PROJECT_ID@_AUTHOR_ORGANIZATION "@META_AUTHOR_ORGANIZATION@"
#define @META_PROJECT_ID@_AUTHOR_DOMAIN       "@META_AUTHOR_DOMAIN@"
#define @META_PROJECT_ID@_AUTHOR_MAINTAINER   "@META_AUTHOR_MAINTAINER@"

#define @META_PROJECT_ID@_VERSION_MAJOR       "@META_VERSION_MAJOR@"
#define @META_PROJECT_ID@_VERSION_MINOR       "@META_VERSION_MINOR@"
#define @META_PROJECT_ID@_VERSION_PATCH       "@META_VERSION_PATCH@"
#define @META_PROJECT_ID@_VERSION_REVISION    "@META_VERSION_REVISION@"

#define @META_PROJECT_ID@_VERSION             "@META_VERSION@"
#define @META_PROJECT_ID@_NAME_VERSION        "@META_NAME_VERSION@"
```

The template file is configured with the project meta information and the result is stored within the build directory. Beware that this header is stored in a path derived from your project name. You should adopt this as required.

```cmake
# Generate version-header
configure_file(version.h.in ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME}/${META_PROJECT_NAME}-version.h)
```

We suggest to deploy this header disregarding its internal or even public use.

```cmake
#
# Deployment
#

# Deploy generated headers
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/${META_PROJECT_NAME} DESTINATION include COMPONENT dev)
```


### Project Build Options

## Maintainer Modules

### cmake-init Template Check

This module allows to check the actuality of the used cmake-init template for own projects.
This module is usable when the following is integrated into the `CMakeLists.txt`.

```cmake
# Add cmake-init template check cmake targets
add_check_template_target(<CMAKE_INIT_SHA>)
```

Here, the `<CMAKE_INIT_SHA>` contains the git hash of the used cmake-init template.
Further, the files `cmake/HealthCheck.cmake` and `cmake/CheckTemplate.cmake` are required.

The hash is usually configured using

```cmake
# Meta information about the project
set(META_CMAKE_INIT_SHA      "<CMAKE_INIT_SHA>")

# Add cmake-init template check cmake targets
add_check_template_target(<CMAKE_INIT_SHA>)
```

Correctly configures, this module adds a cmake build target named `check-template` that compares the passed `<CMAKE_INIT_SHA>` with the current master commit hash of this repository and provides a link for a diff view.

## Development Modules

### Version Control System Integration

```cmake
# Get git revision
get_git_head_revision(GIT_REFSPEC GIT_SHA1)
string(SUBSTRING "${GIT_SHA1}" 0 12 GIT_REV)
if(NOT GIT_SHA1)
    set(GIT_REV "0")
endif()
```

### Build Targets

### Documentation

### Tests

### Linter

### Continuous Integration

### Deployment

### Packaging

### Run-time Assets

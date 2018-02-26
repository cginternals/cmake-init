## Update googletest and googlemock

After updating, the following changes needs to be applied manually:

* https://github.com/cginternals/cmake-init/commit/6df2e5acd0111ca13f4a54f616a8e9e729f3fedc
* https://github.com/cginternals/cmake-init/commit/da2b52c0b8b47989d779b8285c1a0294a71947ac
* https://github.com/cginternals/cmake-init/commit/f505bef30fe3122d7bd3b8061fcf704fac452d7f
* https://github.com/cginternals/cmake-init/commit/217786a6e8ab1c3a69ab899ec7fba06d5516452a

### Explicit diff

`googletest/googlemock/CMakeLists.txt`

* Add `set(BUILD_SHARED_LIBS OFF)` after the call to `option(BUILD_SHARED_LIBS ...)`
* Add `set(CMAKE_MACOSX_RPATH OFF)` before the calls to `cxx_library(...)`
* Add `set_target_properties(gmock_main PROPERTIES FOLDER "Tests")` after the calls to `cxx_library(...)`
* Add `set_target_properties(gmock      PROPERTIES FOLDER "Tests")` after the calls to `cxx_library(...)`

`googletest/googletest/CMakeLists.txt`

* Add `set(BUILD_SHARED_LIBS OFF)` after the call to `option(BUILD_SHARED_LIBS ...)`
* Add `set(CMAKE_MACOSX_RPATH OFF)` before the calls to `cxx_library(...)`
* Add `set_target_properties(gtest_main PROPERTIES FOLDER "Tests")` after the calls to `cxx_library(...)`
* Add `set_target_properties(gtest      PROPERTIES FOLDER "Tests")` after the calls to `cxx_library(...)`
* Comment out the calls to `install`


#pragma once


#include <string>

#include <baselib/baselib_api.h>


namespace baselib
{


/**
*  @brief
*    Get data path for baselib
*
*  @return
*    Path to data directory
*/
BASELIB_API std::string dataPath();

/**
*  @brief
*    Print information about the library to the console
*/
BASELIB_API void printInfo();


} // namespace baselib

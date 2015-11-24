
#include <baselib/baselib.h>

#include <iostream>


#define xstr(s) str(s)
#define str(s)  #s


namespace baselib
{


void printInfo()
{
    // Library name
    std::cout << "Library template::baselib" << std::endl;
    std::cout << "========================================" << std::endl;

    // Library type (static or dynamic)
    #ifdef BASELIB_STATIC_DEFINE
        std::cout << "Library type: STATIC" << std::endl;
    #else
        std::cout << "Library type: SHARED" << std::endl;
    #endif

    // Export macro
    std::cout << "Export def:   " << xstr(BASELIB_API) << std::endl;
}


} // namespace baselib

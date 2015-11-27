
#include <template/template-meta.h>

#include <baselib/baselib.h>

#include <iostream>


#define xstr(s) str(s)
#define str(s)  #s


namespace baselib
{


std::string dataPath()
{
    return std::string(TEMPLATE_DATA_PATH);
}

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

    // Data directory
    std::cout << "Data path:    " << TEMPLATE_DATA_PATH << std::endl;
}


} // namespace baselib

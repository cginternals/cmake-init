
#include <iostream>
#include <fstream>

#include <template/template-version.h>
#include <template/template-meta.h>

#include <baselib/baselib.h>


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
    std::string dataPath = TEMPLATE_DATA_PATH;

    // Library name
    std::cout << "Library template::baselib" << std::endl;
    std::cout << "========================================" << std::endl;

    // Library version
    std::cout << "Version: " << TEMPLATE_VERSION << std::endl;
    std::cout << std::endl;

    // Library type (static or dynamic)
    #ifdef BASELIB_STATIC_DEFINE
        std::cout << "Library type: STATIC" << std::endl;
    #else
        std::cout << "Library type: SHARED" << std::endl;
    #endif

    // Export macro
	// std::cout << "Export def:   " << xstr(BASELIB_API) << std::endl;

    // Data directory
    std::cout << "Data path:    " << TEMPLATE_DATA_PATH << std::endl;
    std::cout << std::endl;

    // Read file
    std::cout << "Data directory access" << std::endl;
    std::cout << "========================================" << std::endl;

    std::string fileName = dataPath + "/DATA_FOLDER.txt";
    std::cout << "Reading from '" << fileName << "': " << std::endl;
    std::cout << std::endl;

    std::ifstream f(fileName);
    if (f.is_open()) {
        std::string line;
        while (getline(f, line)) {
            std::cout << line << '\n';
        }
        f.close();
    } else {
        std::cout << "Unable to open file." << std::endl;
    }
}


} // namespace baselib


#include <iostream>

#include <template/template-version.h>

#include <baselib/baselib.h>

#include <fiblib/Fibonacci.h>


int main(int /*argc*/, char* /*argv*/[])
{
    // Print project version
    std::cout << "Version: " << TEMPLATE_VERSION << std::endl;
    std::cout << std::endl;

    // Print library info
    baselib::printInfo();
    std::cout << std::endl;

    // Calculate and print fibonacci number
    std::cout << "Fibonacci(8) = " << fiblib::Fibonacci()(8) << std::endl;
    std::cout << std::endl;

    return 0;
}

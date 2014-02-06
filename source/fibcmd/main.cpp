
#include <iostream>

#include <template-version.h>
#include <fiblib/Fibonacci.h>

int main(int /*argc*/, char* /*argv*/[])
{
    std::cout << "Version: " << TEMPLATE_VERSION << std::endl;
    std::cout << "Fibonacci(8) = " << fiblib::Fibonacci()(8) << std::endl;

    return 0;
}

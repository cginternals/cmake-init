#include <iostream>
#include <fiblib/Fibonacci.h>


int main(int /*argc*/, char* /*argv*/[])
{
    std::cout << "Hello World" << std::endl;
    std::cout << "Fibonacci(4) = " << fiblib::Fibonacci()(4) << std::endl;
    return 0;
}

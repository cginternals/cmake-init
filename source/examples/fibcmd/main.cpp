
#include <iostream>

#include <baselib/baselib.h>

#include <fiblib/CTFibonacci.h>
#include <fiblib/Fibonacci.h>


int main(int /*argc*/, char* /*argv*/[])
{
    // Print library info
    baselib::printInfo();
    std::cout << std::endl;

    // Calculate and print fibonacci number
    std::cout << "Fibonacci library" << std::endl;
    std::cout << "========================================" << std::endl;
    std::cout << "CTFibonacci(6) = " << fiblib::CTFibonacci<6>::value << std::endl;
    std::cout << "Fibonacci(8)   = " << fiblib::Fibonacci()(8) << std::endl;
    std::cout << std::endl;

    return 0;
}

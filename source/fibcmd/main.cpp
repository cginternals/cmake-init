
#include <iostream>
#include <fstream>
#include <string>

#include <template-version.h>
#include <fiblib/Fibonacci.h>

int main(int /*argc*/, char* /*argv*/[])
{
    std::cout << "Version: " << TEMPLATE_VERSION << std::endl;
    std::cout << "Fibonacci(8) = " << fiblib::Fibonacci()(8) << std::endl;
    std::cout << std::endl;

    // Read file
    std::cout << "Reading from 'data/example.txt': " << std::endl;
    std::cout << std::endl;
    std::ifstream f("data/example.txt");
    if (f.is_open()) {
        std::string line;
        while (getline(f, line)) {
            std::cout << line << '\n';
        }
        f.close();
    } else {
        std::cout << "Unable to open file." << std::endl;
    }

    return 0;
}


#include <fiblib/Fibonacci.h>


namespace fiblib
{


Fibonacci::Fibonacci()
{
}

Fibonacci::~Fibonacci()
{
}

unsigned int Fibonacci::operator()(unsigned int i)
{
    if (i < 2) {
        return i;
    } else {
        return this->operator()(i - 1) + this->operator()(i - 2);
    }
}


} // namespace fiblib

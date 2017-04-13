
#pragma once


#include <fiblib/fiblib_api.h>


namespace fiblib
{


/**
*  @brief
*    Compile-time computation of fibonacci numbers
*/
template <unsigned long long i>
class FIBLIB_TEMPLATE_API CTFibonacci
{
public:
    enum {
        value = CTFibonacci<i-2>::value + CTFibonacci<i-1>::value
    };
};


} // namespace fiblib


#include <fiblib/CTFibonacci.inl>

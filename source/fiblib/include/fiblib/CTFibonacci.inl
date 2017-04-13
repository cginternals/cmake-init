
#pragma once


namespace fiblib
{


template <>
class FIBLIB_TEMPLATE_API CTFibonacci<0>
{
public:
    enum {
        value = 0
    };
};

template <>
class FIBLIB_TEMPLATE_API CTFibonacci<1>
{
public:
    enum {
        value = 1
    };
};


} // namespace fiblib

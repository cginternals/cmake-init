
#include <gmock/gmock.h>


#include <fiblib/Fibonacci.h>

class fibonacci_test: public testing::Test
{
public:
};

TEST_F(fibonacci_test, CheckSomeResults)
{
    fiblib::Fibonacci fib;

    EXPECT_EQ((unsigned int) 0, fib(0));
    EXPECT_EQ((unsigned int) 1, fib(1));
    EXPECT_EQ((unsigned int) 1, fib(2));
    EXPECT_EQ((unsigned int)21, fib(8));
    // ...
}

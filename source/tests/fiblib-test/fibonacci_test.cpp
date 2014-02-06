
#include <gmock/gmock.h>


#include <fiblib/Fibonacci.h>

class fibonacci_test: public testing::Test
{
public:
};

TEST_F(fibonacci_test, CheckSomeResults)
{
    fiblib::Fibonacci fib;

    EXPECT_EQ( 0, fib( 0));
    EXPECT_EQ( 1, fib( 1));
    EXPECT_EQ( 1, fib( 2));
    EXPECT_EQ(21, fib( 8));
    // ...
}

def square(x):
    return x*x

def neg(f, x):
    return -f(x)


def first(x):
    x += 8
    def second(y):
        print('second')
        return x + y
    print('first')
    return second


def foo(x):
    def bar(y):
        return x + y
    return bar


def troy():
    abed = 0
    while abed < 10:
        def britta():
            return abed
        abed += 1
    abed = 20
    return britta


def shirley():
    return annie


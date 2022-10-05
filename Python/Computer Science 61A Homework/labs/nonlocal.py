def make_fib():
    """Returns a function that returns the next Fibonacci number
    every time it is called.

    >>> fib = make_fib()
    >>> fib()
    0
    >>> fib()
    1
    >>> fib()
    1
    >>> fib()
    2
    >>> fib()
    3
    """
    fn_1 = 0
    fn_2 = 1
    n = 0
    value = 0
    def fib_helper():
        nonlocal n, value, fn_1, fn_2
        n = n + 1
        if n == 0:
            value = fn_2
        if n == 1: 
            value = fn_1
        else:
            value = fn_1 + fn_2
            fn_2 = fn_1
            fn_1 = value
        return value
    return fib_helper


def make_test_dice(seq):
    """Makes deterministic dice.

    >>> dice = make_test_dice([2, 6, 1])
    >>> dice()
    2
    >>> dice()
    6
    >>> dice()
    1
    >>> dice()
    2
    >>> other = make_test_dice([1])
    >>> other()
    1
    >>> dice()
    6
    """
    n = 0
    def dicer():
        nonlocal n, seq
        value = seq[n]
        n = (n+1)%len(seq)
        return value
    return dicer


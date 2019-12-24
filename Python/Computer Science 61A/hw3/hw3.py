#  Name: Naval Handa 
#  Email: nhanda@berkeley.edu

# Q1.

def g(n):
    """Return the value of G(n), computed recursively.

    >>> g(1)
    1
    >>> g(2)
    2
    >>> g(3)
    3
    >>> g(4)
    10
    >>> g(5)
    22
    """
    if n <= 3:
        return n
    else:
        return g(n-1) + 2*g(n-2) + 3*g(n-3)

def g_iter(n):
    """Return the value of G(n), computed iteratively.

    >>> g_iter(1)
    1
    >>> g_iter(2)
    2
    >>> g_iter(3)
    3
    >>> g_iter(4)
    10
    >>> g_iter(5)
    22
    """
    valueStore = (1,2,3)
    if n <= 3:
        return valueStore[n-1]
    else:
        i = 3
        while i < n:
            valueStore = valueStore + (valueStore[i-1] + 2*valueStore[i-2] + 3*valueStore[i-3],)
            i = i + 1
        return valueStore[n-1]


# Q2.

def has_seven(k):
    """Has a has_seven
    >>> has_seven(3)
    False
    >>> has_seven(7)
    True
    >>> has_seven(2734)
    True
    >>> has_seven(2634)
    False
    >>> has_seven(734)
    True
    >>> has_seven(7777)
    True
    """
    if k % 10 == 7:
        return True

    if k//10 == 0:
        return False
    else:
        return has_seven(k//10)

# Q3.

"1 2 3 4 5 6 [7] 6 5 4 3 2 1 [0] 1 2 [3] 2 1 0 [-1] 0 1 2 3 4 [5] [4] 5 6"


def pingpong(n):
    """Return the nth element of the ping-pong sequence.

    >>> pingpong(7)
    7
    >>> pingpong(8)
    6
    >>> pingpong(15)
    1
    >>> pingpong(21)
    -1
    >>> pingpong(22)
    0
    >>> pingpong(30)
    6
    >>> pingpong(68)
    2
    >>> pingpong(69)
    1
    >>> pingpong(70)
    0
    >>> pingpong(71)
    1
    >>> pingpong(72)
    0
    >>> pingpong(100)
    2
    """

    def pingponger (i, n, op, value):
        if i == n:
            return value
        if i%7 == 0 or has_seven(i) == True:
            op = op * (-1)
        return pingponger(i+1, n, op, value + op)

    return pingponger(1,n,1,1)  

# Q4.

def ten_pairs(n):
    """Return the number of ten-pairs within positive integer n.

    >>> ten_pairs(7823952)
    3
    >>> ten_pairs(55055)
    6
    >>> ten_pairs(9641469)
    6
    """
    def pairer (number, digitToCompare):
        if number == 0:
            return 0
        if number%10 + digitToCompare == 10:
            return 1 + pairer(number//10, digitToCompare)
        else:
            return pairer(number//10, digitToCompare)

    if n <= 9:
        return 0
    else:
        return pairer(n//10, n%10) + ten_pairs(n//10)

# Q5.

def count_change(amount):
    """Return the number of ways to make change for amount.

    >>> count_change(7)
    6
    >>> count_change(10)
    14
    >>> count_change(20)
    60
    >>> count_change(100)
    9828
    """
    from math import log

    def findMaxDenomination(x):
        return 2**(int(log(x,2)))

    def counter(n, k):
        if n==0:
            return 1
        elif n < 0 or k <=0:
            return 0
        else:
            return counter(n-k, k) + counter (n, k//2)
    return counter(amount, findMaxDenomination(amount))

# Q6.

from operator import sub, mul

def make_anonymous_factorial():
    """Return the value of an expression that computes factorial.

    >>> make_anonymous_factorial()(5)
    120
    """
    return YOUR_EXPRESSION_HERE



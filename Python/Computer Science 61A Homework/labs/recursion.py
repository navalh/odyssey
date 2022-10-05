"""Starter file for recursion lab."""



def summation(n, term):
    """Return the sum of the 0th to nth terms in the sequence defined
    by term.

    >>> summation(4, lambda x: x*x) # 0 + 1 + 4 + 9 + 16
    30
    """
    if n == 0:
        return term(0)
    else:
        return term(n) + summation(n-1, term)


def gcd(a, b):
    """Return the greatest common divisor of a and b.

    >>> gcd(24, 18)
    6
    >>> gcd(2, 4)
    2
    """
    if b % a == 0:
        return a
    elif a % b == 0:
        return b
    elif a > b:
        return gcd (b, a % b)
    else:
        return gcd(a, b % a)
        

def hailstone(n):
    """Print out the hailstone sequence starting at n, and return the
    number of elements in the sequence.

    >>> a = hailstone(10)
    10
    5
    16
    8
    4
    2
    1
    >>> a
    7
    """
    print (n)
    if n == 1:
      return 1
    elif n % 2 == 0:
        return 1 +  hailstone(n//2)
    elif n % 2 == 1:
        return 1 +  hailstone (3*n + 1)

def paths(m, n):
    if n == 1 or m == 1:
        return 1
    else:
        return paths(m-1,n) + paths(m, n-1)


#  Name: Naval Handa
#  Email: nhanda@berkeley.edu

# Q1.

def overlaps(low0, high0, low1, high1):
    """Return whether the open intervals (LOW0, HIGH0) and (LOW1, HIGH1)
    overlap.

    >>> overlaps(10, 15, 14, 16)
    True
    >>> overlaps(10, 15, 1, 5)
    False
    >>> overlaps(10, 10, 9, 11)
    False
    >>> result = overlaps(1, 5, 0, 3)  # Return, don't print
    >>> result
    True
    >>> [overlaps(a0, b0, a1, b1) for a0, b0, a1, b1 in
    ...       ( (1, 4, 2, 3), (1, 4, 0, 2), (1, 4, 3, 5), (0.1, 0.4, 0.2, 0.3),
    ...         (2, 3, 1, 4), (0, 2, 1, 4), (3, 5, 1, 4) )].count(False)
    0
    >>> [overlaps(a0, b0, a1, b1) for a0, b0, a1, b1 in
    ...       ( (1, 4, -1, 0), (1, 4, 5, 6), (1, 4, 4, 5), (1, 4, 0, 1),
    ...         (-1, 0, 1, 4), (5, 6, 1, 4), (4, 5, 1, 4), (0, 1, 1, 4),
    ...         (5, 5, 3, 6), (5, 3, 4, 6), (5, 5, 5, 5),
    ...         (3, 6, 5, 5), (4, 6, 5, 3), (0.3, 0.6, 0.5, 0.5) )].count(True)
    0
    """
    overlap = False
    if low0 >= high0 or low1 >= high1:
        return overlap

    if (low1 >= low0 and low1 < high0) or (high1 > low0 and high1 <= high0):
        overlap = True

    return overlap

# Q2.

def last_square(x):
    """Return the largest perfect square less than X, where X>0.

    >>> last_square(10)
    9
    >>> last_square(39)
    36
    >>> last_square(100)
    81
    >>> result = last_square(2) # Return, don't print
    >>> result
    1
    >>> last_square(1) == 0
    True
    >>> last_square(2) == 1
    True
    >>> last_square(3) == 1
    True
    """
    from math import sqrt
    squareRoot = int(sqrt(x-1))
    return squareRoot*squareRoot


# Q3.

def ordered_digits(x):
    """Return True if the (base 10) digits of X>0 are in non-decreasing
    order, and False otherwise.

    >>> ordered_digits(5)
    True
    >>> ordered_digits(11)
    True
    >>> ordered_digits(127)
    True
    >>> ordered_digits(1357)
    True
    >>> ordered_digits(21)
    False
    >>> result = ordered_digits(1375) # Return, don't print
    >>> result
    False
    >>> ordered_digits(1) == True
    True
    >>> ordered_digits(9) == True
    True
    >>> ordered_digits(10) == False
    True
    """
    num = x
    while num > 9:
        firstDigit = num % 10
        num = num // 10

        if firstDigit < (num % 10):
            return False
    return True




"""Starter file for lists lab."""


def reverse(lst):
    """Reverses lst using mutation.
    >>> original_list = [5, -1, 29, 0]
    >>> reverse(original_list)
    >>> original_list
    [0, 29, -1, 5]
    """
    i = 0
    while i < (len(lst))/2:
        a = lst[(-1)*i - 1]
        lst[(-1)*i - 1] = lst[i]
        lst[i]= a
        i = i + 1

    b = lst[:]
    i = 0
    lst = []
    while i < len(b):
        print(lst)
        x = b[(-1)*i-1]
        print(x)
        lst.append(x)
        i = i + 1

    
    
   
def map(fn, lst):
    """Maps fn onto lst using mutation.
    >>> original_list = [5, -1, 2, 0]
    >>> map(lambda x: x * x, original_list)
    >>> original_list
    [25, 1, 4, 0]
    """
    "*** YOUR CODE HERE ***"

def filter(pred, lst):
    """Filters lst with pred using mutation.
    >>> original_list = [5, -1, 2, 0]
    >>> filter(lambda x: x % 2 == 0, original_list)
    >>> original_list
    [2, 0]
    """
    "*** YOUR CODE HERE ***"

def coords(fn, seq, lower, upper):
    """
    >>> seq = (-4, -2, 0, 1, 3)
    >>> fn = lambda x: x**2
    >>> coords(fn, seq, 1, 9)
    [(-2, 4), (1, 1), (3, 9)]
    """ 
    return "*** YOUR CODE HERE ***"

def add_matrices(x, y):
    """
    >>> add_matrices([[1, 3], [2, 0]], [[-3, 0], [1, 2]])
    [[-2, 3], [3, 2]]
    """
    return "*** YOUR CODE HERE ***"

def deck():
    return "*** YOUR CODE HERE ***"

def sort_deck(deck):
    "*** YOUR CODE HERE ***"

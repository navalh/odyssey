# Rlist definition
class Rlist:
    """A recursive list consisting of a first element and the rest.

    >>> s = Rlist(1, Rlist(2, Rlist(3)))
    >>> print(rlist_expression(s.rest))
    Rlist(2, Rlist(3))
    >>> len(s)
    3
    >>> s[1]
    2
    """

    class EmptyList:
        def __len__(self):
            return 0

    empty = EmptyList()

    def __init__(self, first, rest=empty):
        self.first = first
        self.rest = rest

    def __len__(self):
        "*** YOUR CODE HERE ***"

    def __getitem__(self, index):
        "*** YOUR CODE HERE ***"
#################
# RList folding #
#################

from operator import add, sub, mul

def rlist_expression(s):
    """Return a string that would evaluate to s."""
    if s.rest is Rlist.empty:
        rest = ''
    else:
        rest = ', ' + rlist_expression(s.rest)
    return 'Rlist({0}{1})'.format(s.first, rest)

def foldl(rlist, fn, z):
    """ Left fold
    >>> lst = Rlist(3, Rlist(2, Rlist(1)))
    >>> foldl(lst, sub, 0) # (((0 - 3) - 2) - 1)
    -6
    >>> foldl(lst, add, 0) # (((0 + 3) + 2) + 1)
    6
    >>> foldl(lst, mul, 1) # (((1 * 3) * 2) * 1)
    6
    """
    if rlist == Rlist.empty:
        return z
    return foldl(______, ______, ______)

def foldr(rlist, fn, z):
    """ Right fold
    >>> lst = Rlist(3, Rlist(2, Rlist(1)))
    >>> foldr(lst, sub, 0) # (3 - (2 - (1 - 0)))
    2
    >>> foldr(lst, add, 0) # (3 + (2 + (1 + 0)))
    6
    >>> foldr(lst, mul, 1) # (3 * (2 * (1 * 1)))
    6
    """
    "*** YOUR CODE HERE ***"

def mapl(lst, fn):
    """ Maps FN on LST
    >>> lst = Rlist(3, Rlist(2, Rlist(1)))
    >>> mapped = mapl(lst, lambda x: x*x)
    >>> print(rlist_expression(mapped))
    Rlist(9, Rlist(4, Rlist(1)))
    """
    "*** YOUR CODE HERE ***"

def filterl(lst, pred):
    """ Filters LST based on PRED
    >>> lst = Rlist(4, Rlist(3, Rlist(2, Rlist(1))))
    >>> filtered = filterl(lst, lambda x: x % 2 == 0)
    >>> print(rlist_expression(filtered))
    Rlist(4, Rlist(2))
    """
    "*** YOUR CODE HERE ***"

def reverse(lst):
    """ Reverses LST with foldl
    >>> reversed = reverse(Rlist(3, Rlist(2, Rlist(1))))
    >>> print(rlist_expression(reversed))
    Rlist(1, Rlist(2, Rlist(3)))
    >>> reversed = reverse(Rlist(1))
    >>> print(rlist_expression(reversed))
    Rlist(1)
    >>> reversed = reverse(Rlist.empty)
    >>> reversed == Rlist.empty
    True
    """
    "*** YOUR CODE HERE ***"

def reverse2(lst):
    """ Reverses LST without the Rlist constructor
    >>> reversed = reverse2(Rlist(3, Rlist(2, Rlist(1))))
    >>> print(rlist_expression(reversed))
    Rlist(1, Rlist(2, Rlist(3)))
    >>> reversed = reverse2(Rlist(1))
    >>> print(rlist_expression(reversed))
    Rlist(1)
    >>> reversed = reverse(Rlist.empty)
    >>> reversed == Rlist.empty
    True
    """
    "*** YOUR CODE HERE ***"

identity = lambda x: x

def foldl2(rlist, fn, z):
    """ Write foldl using foldr
    >>> list = Rlist(3, Rlist(2, Rlist(1)))
    >>> foldl2(list, sub, 0) # (((0 - 3) - 2) - 1)
    -6
    >>> foldl2(list, add, 0) # (((0 + 3) + 2) + 1)
    6
    >>> foldl2(list, mul, 1) # (((1 * 3) * 2) * 1)
    6
    """
    def step(x, g):
        "*** YOUR CODE HERE ***"
    return foldr(rlist, step, identity)(z)

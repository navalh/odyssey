#  Name: Naval Handa
#  Email: nhanda@berkeley.edu

# Q1.

class Amount(object):
    """An amount of nickels and pennies.

    >>> a = Amount(3, 7)
    >>> a.nickels
    3
    >>> a.pennies
    7
    >>> a.value
    22
    >>> a.nickels = 5
    >>> a.value
    32
    """
    def __init__(self, nickels, pennies):
        self.nickels = nickels
        self.pennies = pennies


    @property
    def value(self):
        return self.nickels*5 + self.pennies

class MinimalAmount(Amount):
    """An amount of nickels and pennies that is initialized with no more than
    four pennies, by converting excess pennies to nickels.

    >>> a = MinimalAmount(3, 7)
    >>> a.nickels
    4
    >>> a.pennies
    2
    >>> a.value
    22
    """
    def __init__(self, nickels, pennies):
        while pennies >= 5:
            pennies = pennies - 5
            nickels = nickels + 1
        Amount.__init__(self, nickels, pennies) 

# Q2.

class Square(object):
    def __init__(self, side):
        self.side = side

class Rect(object):
    def __init__(self, width, height):
        self.width = width
        self.height = height

def apply(operator_name, shape):
    """Apply operator to shape.

    >>> apply('area', Square(10))
    100
    >>> apply('perimeter', Square(5))
    20
    >>> apply('area', Rect(5, 10))
    50
    >>> apply('perimeter', Rect(2, 4))
    12
    """
    operator_dispatch_table = { ('area', Square): lambda x: x.side*x.side, ('area', Rect): lambda x: x.width*x.height, ('perimeter', Square): lambda x: 4*x.side, ('perimeter', Rect): lambda x: 2*x.width + 2*x.height}
    return operator_dispatch_table[(operator_name, type(shape))](shape)

# Q3.

class Rlist:
    """A recursive list consisting of a first element and the rest.

    >>> s = Rlist(1, Rlist(2, Rlist(3)))
    >>> s.rest
    Rlist(2, Rlist(3))
    >>> len(s)
    3
    >>> s[1]
    2
    """

    class EmptyList:
        def __len__(self):
            return 0
        def __repr__(self):
            return "Rlist.empty"

    empty = EmptyList()

    def __init__(self, first, rest=empty):
        assert type(rest) is Rlist or rest is Rlist.empty
        self.first = first
        self.rest = rest

    def __getitem__(self, index):
        if index == 0:
            return self.first
        else:
            if self.rest is Rlist.empty:
                raise IndexError("Rlist index out of bounds")
            return self.rest[index-1]

    def __len__(self):
        return 1 + len(self.rest)

    def __repr__(self):
        """Return a string that would evaluate to s."""
        if self.rest is Rlist.empty:
            rest = ''
        else:
            rest = ', ' + repr(self.rest)
        return 'Rlist({0}{1})'.format(self.first, rest)



class rlist_set:
    """A set of arbitrary items that have an ordering (i.e., that
    define <=, <, and other relational operations between them)."""

    # Representation: rlist_sets are represented by Rlists of items
    # maintained in sorted order.

    def __init__(self, *initial_items):
        """A set that initially contains the values in
        INITIAL_ITEMS, which can be any iterable."""
        self._s = Rlist.empty
        for v in initial_items:
            self.add(v)

    @staticmethod
    def _make_set(r):
        """An internal method for creating rlist_sets out of rlists."""
        result = rlist_set()
        result._s = r
        return result

    def as_rlist(self):
        """An Rlist of my values in sorted order.  This Rlist must not be modified."""
        return self._s

    def empty(self):
        return self._s is Rlist.empty

    def __contains__(self, v):
        """True iff I currently contain the value V.
        >>> s = rlist_set(3, 8, 7, 1)
        >>> s.__contains__(7)
        True
        >>> 7 in s     # __contains__ defines 'in'
        True
        >>> 9 in s
        False"""
        if self.empty() or self._s.first > v:
            return False
        elif self._s.first == v:
            return True
        else:
            return v in self._s.rest

    def __repr__(self):
        result = "{"
        s = self._s
        while s is not Rlist.empty:
            if result != "{":
                result += ", "
            result += repr(s.first)
            s = s.rest
        return result + "}"

    def intersection(self, other_set):
        """Return a set containing all elements common to rlist_sets
        SELF and OTHER_SET.

        >>> s = rlist_set(1, 2, 3)
        >>> t = rlist_set(2, 3, 4)
        >>> s.intersection(t)
        {2, 3}
        """
        return rlist_set._make_set(rlist_intersect(self._s, other_set._s))

    def adjoin(self, v):
        """Return a set containing all elements of s and element v.
        >>> s = rlist_set(1, 2, 3)
        >>> s.adjoin(2.5)
        {1, 2, 2.5, 3}
        >>> s.adjoin(0.5)
        {0.5, 1, 2, 3}
        >>> s.adjoin(3)
        {1, 2, 3}
        """
        return rlist_set._make_set(rlist_adjoin(self._s, v))

    def add(self, v):
        """Destructively changes me to the result of adjoining V, returning the modified
        set."""
        self._s = drlist_adjoin(self._s, v)

    def union(self, other_set):
        """Return a set containing all elements either in myself or OTHER_SET.

        >>> s0 = rlist_set(2, 3)
        >>> s = s0.adjoin(1)
        >>> t0 = rlist_set(3, 5)
        >>> t = t0.adjoin(1)
        >>> s.union(t)
        {1, 2, 3, 5}
        >>> s0.union(t)
        {1, 2, 3, 5}
        >>> rlist_set().union(s0.intersection(t))
        {3}
        """
        return rlist_set._make_set(rlist_union(self._s, other_set._s))

def rlist_adjoin(s, v):
    """Assuming S is an Rlist in sorted order, a new Rlist that contains all the original
    values, plus V (if not already present) in sorted order."""
    if s is Rlist.empty:
        return Rlist(v)
    elif s.first == v:
        return s
    elif s.first < v:
        return  Rlist(s.first, rlist_adjoin(s.rest, v))
    else:
        return Rlist(v, s)


def drlist_adjoin(s, v):
    """Destructively add V to the appropriate place in sorted Rlist S, if it is not already
    present, returning the modified Rlist."""
    if s == Rlist.empty:
        s = Rlist(v)
        return s
    
    i = 0
    traverser = s   
    previous = Rlist.empty
    while traverser != Rlist.empty:
        if traverser.first < v:
            previous = traverser
            traverser = traverser.rest
        elif traverser.first == v:
            return s
        elif traverser.first > v:
            new_rlist = Rlist(v, traverser)
            previous.rest = new_rlist
            return s
    previous.rest = Rlist(v)
    return s


def rlist_intersect(s1, s2):
    """Assuming S1 and S2 are two Rlists in sorted order, return a new Rlist in
    sorted order containing exactly the values both have in common, in sorted order."""
    if s1 == Rlist.empty or s2 == Rlist.empty:
        return Rlist.empty
    elif s1.first == s2.first:
        return Rlist(s1.first, rlist_intersect(s1.rest, s2.rest))
    elif s1.first < s2.first:
        return rlist_intersect(s1.rest, s2)
    elif s1.first > s2.first:
        return rlist_intersect(s1, s2.rest)

def rlist_union(s1, s2):
    """Assuming S1 and S2 are two Rlists in sorted order, return a new Rlist in
    sorted order containing the union of the values in both, in sorted order."""
    if s1 == Rlist.empty:
        return s2
    if s2 == Rlist.empty:
        return s1
    elif s1.first == s2.first:
        return Rlist(s1.first, rlist_union(s1.rest, s2.rest))
    elif s1.first < s2.first:
        return Rlist(s1.first, rlist_union(s1.rest, s2))
    elif s1.first > s2.first:
        return Rlist(s2.first, rlist_union(s1, s2.rest))


# Q4.

class BinTree:
    """A binary tree."""

    def __init__(self, label, left=None, right=None):
        """The binary tree node with given LABEL, whose left
        and right children are BinTrees LEFT and RIGHT, which
        default to the empty tree."""
        self._label = label
        self._left = left or BinTree.empty
        self._right = right or BinTree.empty

    @property
    def is_empty(self):
         """This tree contains no labels or children."""
         return self is BinTree.empty

    @property
    def label(self):
        return self._label

    @property
    def left(self): 
        return self._left

    @property
    def right(self):
        return self._right

    def set_left(self, newval):
        """Assuming NEWVAL is a BinTree, sets SELF.left to NEWVAL."""
        assert isinstance(newval, BinTree)
        self._left = newval

    def set_right(self, newval):
        """Assuming NEWVAL is a BinTree, sets SELF.right to NEWVAL."""
        assert isinstance(newval, BinTree)
        self._right = newval

    def inorder_values(self): 
        """An iterator over my labels in inorder (left tree labels, recursively,
        then my label, then right tree labels).
        >>> T = BinTree(10, BinTree(5, BinTree(2), BinTree(6)), BinTree(15))
        >>> for v in T.inorder_values():
        ...     print(v, end=" ")
        2 5 6 10 15 """
        return inorder_tree_iter(self)

    # A placeholder, initialized right after the class.
    empty = None

    def __repr__(self):
        if self.is_empty:
            return "BinTree.empty"
        else:
            args = repr(self.label)
            if not self.left.is_empty or not self.right.is_empty:
                args += ', {0}, {1}'.format(repr(self.left), repr(self.right))
            return 'BinTree({0})'.format(args)

class EmptyBinTree(BinTree):
    """Represents the empty tree.  There should only be one of these."""

    def __init__(self):
        pass

    @property
    def is_empty(self): return True
    @property
    def label(self): raise NotImplemented
    @property
    def left(self): raise NotImplemented
    @property
    def right(self): raise NotImplemented

    def set_left(self, newval): raise NotImplemented
    def set_right(self, newval): raise NotImplemented

# Set the empty BinTree (we could only do this after defining EmptyBinTree
BinTree.empty = EmptyBinTree()

class inorder_tree_iter:
    def __init__(self, the_tree):
        self._work_queue = [ the_tree ]

    def __next__(self):
        while len(self._work_queue) > 0:
            subtree_or_label = self._work_queue.pop()
            if isinstance(subtree_or_label, EmptyBinTree):
                pass
            elif subtree_or_label.left == BinTree.empty and subtree_or_label.right == BinTree.empty:
                self._work_queue.append(subtree_or_label.right)
                self._work_queue.append(subtree_or_label.left)
                return subtree_or_label.label
            else:
                self._work_queue.append(subtree_or_label.right)
                self._work_queue.append(BinTree(subtree_or_label.label))
                self._work_queue.append(subtree_or_label.left)
                
        raise StopIteration

    def __iter__(self): return self

# Q5.

class bintree_set:
    """A set of arbitrary items that have an ordering (i.e., that
    define <=, <, and other relational operations between them)."""

    # Representation: bintree_sets are represented by BinTrees used as binary search trees.

    def __init__(self, *initial_items):
        """A set that initially contains the values in
        INITIAL_ITEMS, which can be any iterable."""
        self._s = BinTree.empty
        for v in initial_items:
            self.add(v)

    def __repr__(self):
        return "{" + ", ".join(map(repr, self._s.inorder_values())) + "}"

    def __contains__(self, v):
        """True iff I currently contain the value V.
        >>> s = bintree_set(3, 8, 7, 1)
        >>> s.__contains__(7)
        True
        >>> 7 in s     # __contains__ defines 'in'
        True
        >>> 9 in s
        False"""
        s = self._s
        while not s is BinTree.empty and s._label != v:
            if v < s._label:
                s = s.left
            else:
                s = s.right
        return not s.is_empty

    @staticmethod
    def _make_set(b):
        """An internal method for creating a bintree_set out of bintree B."""
        result = bintree_set()
        result._s = b 
        return result

    def adjoin(self, v):
        """Return a set containing all elements of s and element v."""
        def tree_add(T, x):
            if T.is_empty:
                return BinTree(x)
            elif x == T.label:
                return T
            elif x < T.label:
                return BinTree(T.label, tree_add(T.left, x), T.right)
            else:
                return BinTree(T.label, T.left, tree_add(T.right, x))
        return bintree_set._make_set(tree_add(self._s, v))

    def add(self, v):
        """Destructively adjoin V to my values, returning modified set."""
        def dtree_add(T, x):
            if T.is_empty:
                return BinTree(x)
            elif x == T.label:
                return T
            elif x < T.label:
                T.set_left(dtree_add(T.left, x))
                return T
            else:
                T.set_right(dtree_add(T.right, x))
                return T
        self._s = dtree_add(self._s, v)
        return self

    def intersection(self, other_set):
        """Return a set containing all elements common to bintree_sets
        SELF and OTHER_SET.

        >>> s = bintree_set(1, 2, 3)
        >>> t = bintree_set(2, 3, 4)
        >>> s.intersection(t)
        {2, 3}
        """
        list1 = rlist_set(*self._s.inorder_values()).as_rlist()
        list2 = rlist_set(*other_set._s.inorder_values()).as_rlist()
        return bintree_set._make_set(ordered_sequence_to_tree(rlist_intersect(list1, list2)))

    def union(self, other_set):
        """Return a set containing all elements either in myself or OTHER_SET.

        >>> s0 = bintree_set(2, 3)
        >>> s = s0.adjoin(1)
        >>> t0 = bintree_set(3, 5)
        >>> t = t0.adjoin(1)
        >>> s.union(t)
        {1, 2, 3, 5}
        >>> s0.union(t)
        {1, 2, 3, 5}
        >>> bintree_set().union(s0.intersection(t))
        {3}"""
        list1 = rlist_set(*self._s.inorder_values()).as_rlist()
        list2 = rlist_set(*other_set._s.inorder_values()).as_rlist()
        return bintree_set._make_set(ordered_sequence_to_tree(rlist_union(list1, list2)))


def partial_sequence_to_tree(s, n):
    """Return a tuple (b, r), where b is a tree of the first N elements of Rlist S, and 
    r is the Rlist of the remaining elements of S. A tree is balanced if

      (a) the number of entries in its left branch differs from the number
          of entries in its right branch by at most 1, and

      (b) its non-empty branches are also balanced trees.

    Examples of balanced trees:

    Tree(1)                    # branch difference 0 - 0 = 0
    Tree(1, Tree(2), None)     # branch difference 1 - 0 = 1
    Tree(1, None, Tree(2))     # branch difference 0 - 1 = -1
    Tree(1, Tree(2), Tree(3))  # branch difference 1 - 1 = 0

    Examples of unbalanced trees:

    BinTree(1, BinTree(2, BinTree(3)), None)  # branch difference 2 - 0 = 2
    BinTree(1, BinTree(2, BinTree(3), None),
            BinTree(4, BinTree(5, BinTree(6), None), None)) # Unbalanced right branch

    >>> s = Rlist(1, Rlist(2, Rlist(3, Rlist(4, Rlist(5)))))
    >>> partial_sequence_to_tree(s, 3)
    (BinTree(2, BinTree(1), BinTree(3)), Rlist(4, Rlist(5)))
    >>> t = Rlist(-2, Rlist(-1, Rlist(0, s)))
    >>> partial_sequence_to_tree(t, 7)[0]
    BinTree(1, BinTree(-1, BinTree(-2), BinTree(0)), BinTree(3, BinTree(2), BinTree(4)))
    >>> partial_sequence_to_tree(t, 7)[1]
    Rlist(5)
    """
    if n == 0:
        return BinTree.empty, s

    left_size = (n-1)//2
    right_size = n - left_size - 1
    
    left_child = partial_sequence_to_tree(s, left_size)
    right_child = partial_sequence_to_tree(left_child[1].rest, right_size)

    counter = 0
    traversed = s
    while counter < n:
        traversed = traversed.rest
        counter = counter + 1

    return BinTree(s[left_size], left_child[0], right_child[0]), traversed
    

def ordered_sequence_to_tree(s):
    """Return a balanced tree containing the elements of ordered Rlist s.

    Note: this implementation is complete, but the definition of partial_sequence_to_tree
    above is not complete.

    >>> ordered_sequence_to_tree(Rlist(1, Rlist(2, Rlist(3))))
    BinTree(2, BinTree(1), BinTree(3))
    >>> b = rlist_set(*range(1, 20, 3))
    >>> elements = b.as_rlist()
    >>> elements
    Rlist(1, Rlist(4, Rlist(7, Rlist(10, Rlist(13, Rlist(16, Rlist(19)))))))
    >>> ordered_sequence_to_tree(elements)
    BinTree(10, BinTree(4, BinTree(1), BinTree(7)), BinTree(16, BinTree(13), BinTree(19)))
    """
    return partial_sequence_to_tree(s, len(s))[0]

# Q6.

def mario_number(level):
    """Return the number of ways that Mario can perform a sequence of steps
    or jumps to reach the end of the level without ever landing in a Piranha
    plant. Assume that every level begins and ends with a space.

    >>> mario_number(' P P ')   # jump, jump
    1
    >>> mario_number(' P P  ')   # jump, jump, step
    1
    >>> mario_number('  P P ')  # step, jump, jump
    1
    >>> mario_number('   P P ') # step, step, jump, jump or jump, jump, jump
    2
    >>> mario_number(' P PP ')  # Mario cannot jump two plants
    0
    >>> mario_number('    ')    # step, jump ; jump, step ; step, step, step
    3
    >>> mario_number('    P    ')
    9
    >>> mario_number('   P    P P   P  P P    P     P ')
    180
    """
    if 'PP' in level: 
        return 0
    if level[0] == 'P':
        return 0
    if len(level) == 0:
        return 0
    if len(level) == 1:
        return 1
    if len(level) == 2 and 'P' not in level:
        return 1
    return mario_number(level[2:]) + mario_number(level[1:])

# Q7.

def has_cycle(s):
    """Return whether Rlist s contains a cycle.

    >>> s = Rlist(1, Rlist(2, Rlist(3)))
    >>> s.rest.rest.rest = s
    >>> has_cycle(s)
    True
    >>> t = Rlist(1, Rlist(2, Rlist(3)))
    >>> has_cycle(t)
    False
    """
    "*** YOUR CODE HERE ***"

def has_cycle_constant(s):
    """Return whether Rlist s contains a cycle.

    >>> s = Rlist(1, Rlist(2, Rlist(3)))
    >>> s.rest.rest.rest = s
    >>> has_cycle_constant(s)
    True
    >>> t = Rlist(1, Rlist(2, Rlist(3)))
    >>> has_cycle_constant(t)
    False
    """
    "*** YOUR CODE HERE ***"
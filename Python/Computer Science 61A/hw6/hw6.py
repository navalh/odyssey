#  Name: Naval Handa
#  Email: nhanda@berkeley.edu

# Q0.
# Q1.

class VendingMachine(object):
    """A vending machine that vends some product for some price.

    >>> v = VendingMachine('candy', 10)
    >>> v.vend()
    'Machine is out of stock.'
    >>> v.restock(2)
    'Current candy stock: 2'
    >>> v.vend()
    'You must deposit $10 more.'
    >>> v.deposit(7)
    'Current balance: $7'
    >>> v.vend()
    'You must deposit $3 more.'
    >>> v.deposit(5)
    'Current balance: $12'
    >>> v.vend()
    'Here is your candy and $2 change.'
    >>> v.deposit(10)
    'Current balance: $10'
    >>> v.vend()
    'Here is your candy.'
    >>> v.deposit(15)
    'Machine is out of stock. Here is your $15.'
    """
    def __init__(self, item, price):
        self.item = item
        self.price = price
        self.stock = 0
        self.total_deposited = 0

    def vend(self):
        if self.stock <= 0:
            print("'Machine is out of stock.'")
        elif self.total_deposited < self.price:
            print("'You must deposit $" +str(self.price - self.total_deposited) + " more.'")
        else:
            self.total_deposited = self.total_deposited - self.price
            self.stock = self.stock - 1
            if self.total_deposited == 0:
                print ("'Here is your " + str(self.item)+ ".'")
            else:
                print ("'Here is your " + str(self.item) + " and $" + str(self.total_deposited) + " change.'")
                self.total_deposited = 0

    def restock (self, item_amount):
        self.stock = self.stock + item_amount
        print ("'Current " + str(self.item) + " stock: " + str(self.stock) + "'")

    def deposit (self, amount):
        if self.stock > 0:
            self.total_deposited = self.total_deposited + amount
            print ("'Current balance: $" + str(self.total_deposited) +  "'")
        else:
            print ("'Machine is out of stock. Here is your $" + str(amount) + ".'")

# Q2.

class MissManners(object):
    """A container class that only forward messages that say please.

    >>> v = VendingMachine('teaspoon', 10)
    >>> v.restock(2)
    'Current teaspoon stock: 2'
    >>> m = MissManners(v)
    >>> m.ask('vend')
    'You must learn to say please first.'
    >>> m.ask('please vend')
    'You must deposit $10 more.'
    >>> m.ask('please deposit', 20)
    'Current balance: $20'
    >>> m.ask('now will you vend?')
    'You must learn to say please first.'
    >>> m.ask('please hand over a teaspoon')
    'Thanks for asking, but I know not how to hand over a teaspoon'
    >>> m.ask('please vend')
    'Here is your teaspoon and $10 change.'
    """
    def __init__ (self, object):
        self.object = object

    def ask(self, command, *args):
        if 'please' in command:
            try:
                getattr(self.object, command[7:])(*args)
            except AttributeError:
                print ("'Thanks for asking, but I know not how to " + command[7:] +"'")
        else:
            print ("'You must learn to say please first.'")


# Q3.

from life import life

class life_lists(life):
    """An implementation of the Game of Life where the board is represented
    as a list of lists, one list per row.  The elements of the row lists
    are integers; odd integers represent cells with living organisms, and
    even integers represent empty cells."""

    def __init__(self, nrows, ncols, init=None):
        """A new Life board containing NROWS rows and NCOLS columns, which wrap around.
        If INIT is not None, then it should be a sequence (any iterable) of rows, each
        of which is itself a sequence (any iterable).   The values fill the board as
        for life.set_board."""
        super().__init__(nrows, ncols)
        self._board = [[0 for c in range(ncols)] for r in range(nrows)]
        if init is not None:
            self.set_board(init)

    def _is_alive(self, row, col):
        row = row % self.rows
        col = col % self.cols
        if self._board[row][col] % 2 == 1:
            return True
        return False

    def _set_alive(self, row, col, alivep):
        row = row % self.rows
        col = col % self.cols
        if alivep:
            if not(self._is_alive(row, col)):
                self._board[row][col] += 1

    def tick(self):
        """Update the board to the next generation.
        >>> b = life_lists(10, 10,    # Glider
        ...                ("     ",
        ...                 "  *  ",
        ...                 "   *  ",
        ...                 " ***  ",
        ...                 "      "))
        >>> print(b, end="")
        ----------
        --*-------
        ---*------
        -***------
        ----------
        ----------
        ----------
        ----------
        ----------
        ----------
        >>> b.tick()
        >>> print(b, end="")
        ----------
        ----------
        -*-*------
        --**------
        --*-------
        ----------
        ----------
        ----------
        ----------
        ----------
        >>> b.tick()
        >>> b.tick()
        >>> b.tick()
        >>> print(b, end="")
        ----------
        ----------
        ---*------
        ----*-----
        --***-----
        ----------
        ----------
        ----------
        ----------
        ----------
        """
        fake_board = [[self._board[r][c] for c in range(self.cols)] for r in range(self.rows)]
        
        for i in range(self.rows):
            for j in range(self.cols):
                if (self.survives(i,j) and not(self._is_alive(i,j))) or (not(self.survives(i,j)) and self._is_alive(i,j)):
                    fake_board[i][j] += 1

        self._board = fake_board
             
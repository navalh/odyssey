"""The Game of Hog."""

from dice import four_sided, six_sided, make_test_dice
from ucb import main, trace, log_current_line, interact

GOAL_SCORE = 100 # The goal of Hog is to score 100 points.

######################
# Phase 1: Simulator #
######################

# Taking turns

def roll_dice(num_rolls, dice=six_sided):
    """Roll DICE for NUM_ROLLS times.  Return either the sum of the outcomes,
    or 1 if a 1 is rolled (Pig out). This calls DICE exactly NUM_ROLLS times.

    num_rolls:  The number of dice rolls that will be made; at least 1.
    dice:       A zero-argument function that returns an integer outcome.
    """
    # These assert statements ensure that num_rolls is a positive integer.
    assert type(num_rolls) == int, 'num_rolls must be an integer.'
    assert num_rolls > 0, 'Must roll at least once.'
    
    total = 0
    i = 0
    was1Rolled = False

    while (i < num_rolls):
        roll = dice()
        total = total + roll
        i = i+1
        if (roll==1):
            was1Rolled = True
        
    if was1Rolled:
        return 1
    else:
        return total   


def take_turn(num_rolls, opponent_score, dice=six_sided):
    """Simulate a turn rolling NUM_ROLLS dice, which may be 0 (Free bacon).

    num_rolls:       The number of dice rolls that will be made.
    opponent_score:  The total score of the opponent.
    dice:            A function of no args that returns an integer outcome.
    """
    assert type(num_rolls) == int, 'num_rolls must be an integer.'
    assert num_rolls >= 0, 'Cannot roll a negative number of dice.'
    assert num_rolls <= 10, 'Cannot roll more than 10 dice.'
    assert opponent_score < 100, 'The game should be over.'

    if num_rolls == 0:
       return 1 + max(opponent_score//10, opponent_score%10)
    else:
        return roll_dice(num_rolls, dice)
   

    


# Playing a game

def select_dice(score, opponent_score):
    """Select six-sided dice unless the sum of SCORE and OPPONENT_SCORE is a
    multiple of 7, in which case select four-sided dice (Hog wild).
    """
    dice = six_sided
    if ((score + opponent_score) % 7) == 0:
        dice = four_sided
    return dice



def other(who):
    """Return the other player, for a player WHO numbered 0 or 1.

    >>> other(0)
    1
    >>> other(1)
    0
    """
    return 1 - who

def play(strategy0, strategy1, goal=GOAL_SCORE):
    """Simulate a game and return the final scores of both players, with
    Player 0's score first, and Player 1's score second.

    A strategy is a function that takes two total scores as arguments
    (the current player's score, and the opponent's score), and returns a
    number of dice that the current player will roll this turn.

    strategy0:  The strategy function for Player 0, who plays first.
    strategy1:  The strategy function for Player 1, who plays second.
    """
    who = 0  # Which player is about to take a turn, 0 (first) or 1 (second)
    score, opponent_score = 0, 0

    while score<goal and opponent_score<goal:
        dice = select_dice(score, opponent_score)

        if who == 0:
            score = score + take_turn(strategy0(score, opponent_score), opponent_score, dice)
        else:
            opponent_score = opponent_score + take_turn(strategy1(opponent_score, score), score, dice)

        if score*2 == opponent_score or opponent_score*2 == score:
            score, opponent_score = opponent_score, score

        who = other(who)

    return score, opponent_score  # You may wish to change this line.

#######################
# Phase 2: Strategies #
#######################

# Basic Strategy


def always_roll(n):
    """Return a strategy that always rolls N dice.

    A strategy is a function that takes two total scores as arguments
    (the current player's score, and the opponent's score), and returns a
    number of dice that the current player will roll this turn.

    >>> strategy = always_roll(5)
    >>> strategy(0, 0)
    5
    >>> strategy(99, 99)
    5
    """
    def strategy(score, opponent_score):
        return n
    return strategy

# Experiments

def make_averaged(fn, num_samples=1000):
    """Return a function that returns the average_value of FN when called.

    To implement this function, you will have to use *args syntax, a new Python
    feature introduced in this project.  See the project description.

    >>> dice = make_test_dice(3, 1, 5, 6)
    >>> averaged_dice = make_averaged(dice, 1000)
    >>> averaged_dice()
    3.75
    >>> make_averaged(roll_dice, 1000)(2, dice)
    6.0

    In this last example, two different turn scenarios are averaged.
    - In the first, the player rolls a 3 then a 1, receiving a score of 1.
    - In the other, the player rolls a 5 and 6, scoring 11.
    Thus, the average value is 6.0.
    """
    def averageFunction(*args):
        i,averageValue = 0,0.0
        while i < num_samples:
            averageValue = averageValue + fn(*args)
            i = i +1
        return averageValue/num_samples
    return averageFunction


def max_scoring_num_rolls(dice=six_sided):
    """Return the number of dice (1 to 10) that gives the highest average turn
    score by calling roll_dice with the provided DICE.  Print all averages as in
    the doctest below.  Assume that dice always returns positive outcomes.

    >>> dice = make_test_dice(3)
    >>> max_scoring_num_rolls(dice)
    1 dice scores 3.0 on average
    2 dice scores 6.0 on average
    3 dice scores 9.0 on average
    4 dice scores 12.0 on average
    5 dice scores 15.0 on average
    6 dice scores 18.0 on average
    7 dice scores 21.0 on average
    8 dice scores 24.0 on average
    9 dice scores 27.0 on average
    10 dice scores 30.0 on average
    10
    """
    numberOfDiceForHighestAverage = 0
    highestAverageScore = 0
    i = 1
    while i < 11:
        averageScore = make_averaged(roll_dice, 1000)(i, dice)
        if averageScore > highestAverageScore:
            highestAverageScore = averageScore
            numberOfDiceForHighestAverage = i
        print (i, "dice scores", averageScore, "on average")
        i = i + 1

    return numberOfDiceForHighestAverage

def winner(strategy0, strategy1):
    """Return 0 if strategy0 wins against strategy1, and 1 otherwise."""
    score0, score1 = play(strategy0, strategy1)
    if score0 > score1:
        return 0
    else:
        return 1

def average_win_rate(strategy, baseline=always_roll(5)):
    """Return the average win rate (0 to 1) of STRATEGY against BASELINE."""
    win_rate_as_player_0 = 1 - make_averaged(winner)(strategy, baseline)
    win_rate_as_player_1 = make_averaged(winner)(baseline, strategy)
    return (win_rate_as_player_0 + win_rate_as_player_1) / 2 # Average results

def run_experiments():
    """Run a series of strategy experiments and report results."""
    if False: # Change to False when done finding max_scoring_num_rolls
        six_sided_max = max_scoring_num_rolls(six_sided)
        print('Max scoring num rolls for six-sided dice:', six_sided_max)
        four_sided_max = max_scoring_num_rolls(four_sided)
        print('Max scoring num rolls for four-sided dice:', four_sided_max)

    if False: # Change to True to test always_roll(8)
        print('always_roll(8) win rate:', average_win_rate(always_roll(8)))

    if False: # Change to True to test bacon_strategy
        print('bacon_strategy win rate:', average_win_rate(bacon_strategy))

    if False: # Change to True to test swap_strategy
        print('swap_strategy win rate:', average_win_rate(swap_strategy))

    if True: # Change to True to test final_strategy
        print('final_strategy win rate:', average_win_rate(final_strategy))

    "*** You may add additional experiments as you wish ***"

# Strategies

def bacon_strategy(score, opponent_score, margin=8, num_rolls=5):
    """This strategy rolls 0 dice if that gives at least MARGIN points,
    and rolls NUM_ROLLS otherwise.
    """
    if take_turn(0, opponent_score) >= margin:
        return 0
    else:
        return num_rolls

def swap_strategy(score, opponent_score, margin=8, num_rolls=5):
    """This strategy rolls 0 dice when it would result in a beneficial swap and
    rolls NUM_ROLLS if it would result in a harmful swap. It also rolls
    0 dice if that gives at least MARGIN points and rolls
    NUM_ROLLS otherwise.
    """
    potentialScore = take_turn(0, opponent_score)
   
    if score+potentialScore == 2*opponent_score or 2*(score+potentialScore) == opponent_score:
        if opponent_score > score+potentialScore:
            return 0
        else:
            return num_rolls
    else:
        if take_turn(0, opponent_score) >= margin:
            return 0
        else:
            return num_rolls


def whereAreYou(score, opponent_score):
    """This function returns 1 if you are in the lead, 2 if you are really ahead, 0 if you are around the same, 
    or -1 if you are lagging behind, -2 if you are very behind.
    """
    if score - opponent_score > 40:
        return 2
    if score - opponent_score > 20:
        return 1
    elif opponent_score - score > 20:
        return -1
    elif opponent_score - score > 40:
        return -2
    else:
        return 0

def final_strategy(score, opponent_score):
    """Write a brief description of your final strategy.

    *** 
    This implements the swap_strategy, which takes advantage of swine swap and free bacon. 
    Moreoever, the default values for margin and num_rolls are a little higher than the baseline of 8 and 5 respectively. 
    When the player has a four-sided dice, the values for margin and num_rolls are reduced. 
    The function whereAreYou, defined above, helps determine whether the player is in the lead or behind. If either happens, 
    num_rolls and margin are changed to take better advantage of the player's situation.
    Lastly, if rolling 0 gives a new total that will give the opponent a 4 sided dice, a 4 will be rolled.
    Also, if rolling a 0 would cause the player's points to go above 100, a 0 will be rolled.
    ***

    """
    margin = 9
    num_rolls = 6

    where = whereAreYou(score, opponent_score)
    if where == 2:
        num_rolls = 3
        margin = 8 
        
    elif where == 1:
        num_rolls = 4
        margin = 9

    elif where == -1:
        num_rolls = 7
        margin = 9

    elif where == -2:
        num_rolls = 8
        margin = 9
        
    if (score + opponent_score) % 7 == 0:
        num_rolls = 4
        margin = 5

    potentialScore = take_turn(0, opponent_score)
    willSwap = False
    willGiveOpponent4 = False
    whatToRoll = 0

    if score+potentialScore==2*opponent_score or 2*(score+potentialScore)==opponent_score:
        willSwap = True
    if (score + potentialScore + opponent_score) % 7 == 0:
        willGiveOpponent4 = True

    if willSwap:
        if opponent_score>score+potentialScore:
            whatToRoll = 0
        else:
            whatToRoll = num_rolls
    else:
        if take_turn(0, opponent_score) >= margin or score + potentialScore > 100:
            whatToRoll = 0
        else:
            whatToRoll = num_rolls

    if willGiveOpponent4:
        if willSwap and score+potentialScore>opponent_score:
                whatToRoll = num_rolls
        else:
            whatToRoll = 0

    return whatToRoll
    
##########################
# Command Line Interface #
##########################

# Note: Functions in this section do not need to be changed.  They use features
#       of Python not yet covered in the course.


@main
def run(*args):
    """Read in the command-line argument and calls corresponding functions.

    This function uses Python syntax/techniques not yet covered in this course.
    """
    import argparse
    parser = argparse.ArgumentParser(description="Play Hog")
    parser.add_argument('--run_experiments', '-r', action='store_true',
                        help='Runs strategy experiments')
    args = parser.parse_args()

    if args.run_experiments:
        run_experiments()

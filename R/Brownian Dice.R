# Question: You start with a fair 6-sided die and roll it six times, recording the results of each roll.
# You then write these numbers on the six faces of another, unlabeled fair die. For example, if your six rolls
# were 3, 5, 3, 6, 1 and 2, then your second die wouldn’t have a 4 on it; instead, it would have two 3s.
# Next, you roll this second die six times. You take those six numbers and write them on the faces of yet another
# fair die, and you continue this process of generating a new die from the previous one. Eventually, you’ll have a
# die with the same number on all six faces. What is the average number of rolls it will take to reach this state?

#Helper Functions
get_new_dice <- function(input_dice) {
  sample(input_dice, replace = TRUE)
}
is_dice_1d <- function(input_dice) {
  all(input_dice == rep(1,6))||all(input_dice == rep(2,6))||all(input_dice == rep(3,6))||all(input_dice == rep(4,6))||all(input_dice == rep(5,6))||all(input_dice == rep(6,6))
}
####################
#Initialize global-level variables
n <- 1000000
results <- rep(0, n)

#Run a loop many times and create a distribution of results
for (i in seq(n)) {
  #Initialize loop-level variables
  loop_dice <- c(1,2,3,4,5,6)
  rolls <- 0
  
  #Create a loop to use this function, keep count of how many times it happens
  while(!is_dice_1d(loop_dice)) {
    loop_dice <- get_new_dice(loop_dice)
    rolls <- rolls + 1
  }

  results[i] = rolls
  i = i + 1
}

hist(results)
mean(results)
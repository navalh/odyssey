#Question 21, Chapter 11
#Part a):
type1 <- c(3.03, 5.53, 5.60, 9.30, 9.92, 12.51, 12.95, 15.21, 16.04, 16.84) #Xi
type2 <- c(3.19, 4.26, 4.47, 4.53, 4.67, 4.69, 12.78, 6.79, 9.37, 12.75) #Yi

n <- length(type1)
m <- length(type2)
df <- m + n - 2
sp2<- ((n-1)*var(type1) + (m-1)*var(type2))/df #Assuming variance of type 1 = type 2.
#Notice that sp2 will have the same value if we assuming unequal variances,
#because the sample sizes are equal.


t_statistic <- (mean(type1) - mean(type2))/(sqrt(sp2*(1/n + 1/m)))
p_value <- pt(t_statistic, df, lower.tail = FALSE)*2
#This is a two-sided test, Alternative: Xbar != YBar
#Since p-value > 0.05, we fail to reject H0 at the 0.05 significance level.
check = t.test(type1, type2, alternative = "two.sided")

#Part b):
both <- c(3.03, 5.53, 5.60, 9.30, 9.92, 12.51, 12.95, 15.21, 16.04, 16.84,
          3.19, 4.26, 4.47, 4.53, 4.67, 4.69, 12.78, 6.79, 9.37, 12.75) 
rank_type1 <- rank(both)[1:10]
rank_type2 <- rank(both)[11:20]

rprime <- n*(m + n + 1) - sum(rank_type1)
rstar <- min(rprime, sum(rank_type1))
#Looking at the table, the critical value for a two-sided test with alpha = 0.05 is 78.
#Since R* = 80, we fail to reject at the 0.05 significance level.
check <- wilcox.test(type1, type2, alternative = "two.sided")

#Part c):
#We have no reason to assume the data is normally distributed, and the sample size is small.
#Hence, we should use the non-parametric test.

#Part d):
#Pi is estimated by PiHat.
estimate_pi <- function(x, y) {
  pihat <- 0
  n <- length(x)
  m <- length(y)
  for (i in 1:n) {
    for (j in 1:m) {
      if (x[i] < y[j])
        pihat = pihat + 1
    }
  }
  pihat <- (1/(m*n))*pihat
  return (pihat)
}

pihat <- estimate_pi(type1, type2) #PiHat = 0.25

#Part e):
bootstrap_pihat <- rep(0, 10000)
for (i in 1:10000){
  sample_type1 <- sample(type1, n, replace = TRUE)
  sample_type2 <- sample(type2, m, replace = TRUE)
  bootstrap_pihat[i] = estimate_pi(sample_type1, sample_type2)
}
mean_pihat = mean(bootstrap_pihat)
se_pihat = sd(bootstrap_pihat)

#Part f):
bootstrap_pihat <- sort(bootstrap_pihat)
lower_delta = bootstrap_pihat[0.05*10000] - pihat
upper_delta = bootstrap_pihat[0.950*10000] - pihat
confidence_interval = pihat - c(upper_delta, lower_delta) #(0.04, 0.43)

#Question 39, Chapter 11
#Part a)
phonelines <- read.csv("phonelines.csv", header=TRUE, sep = ",")
differences <- phonelines$control - phonelines$test #Done this way to get positive Dbar.
n <- length(phonelines$test)

plot(phonelines$control, differences, main = "Differences vs Control Rate", ylab = "Differences",
     xlab = "Control Fault Rate")

#We observe that the differences increase as the control fault rate increases,
#implying that the test rate tended to not increase as much (or possibly decreased)
#as the control rate increased.

#Part b)
Dbar <- mean(differences)
SD_Dbar <- sd(differences)/sqrt(n)

bootstrap_Dbar <- rep(0, 10000)
for (i in 1:10000){
  sample_control <- sample(phonelines$control, n, replace = TRUE)
  sample_test <- sample(phonelines$test, n, replace = TRUE)
  bootstrap_Dbar[i] = mean(sample_control - sample_test)
}

bootstrap_Dbar <- sort(bootstrap_Dbar)
lower_delta = bootstrap_Dbar[0.025*10000] - Dbar
upper_delta = bootstrap_Dbar[0.975*10000] - Dbar
confidence_interval = Dbar - c(upper_delta, lower_delta) #(25.1, 828.6), a 95% CI.

#Part c)

Dmedian <- median(differences)

bootstrap_Dmedian <- rep(0, 10000)
for (i in 1:10000){
  sample_control <- sample(phonelines$control, n, replace = TRUE)
  sample_test <- sample(phonelines$test, n, replace = TRUE)
  bootstrap_Dmedian[i] = median(sample_control - sample_test)
}

bootstrap_Dmedian <- sort(bootstrap_Dmedian)
lower_delta = bootstrap_Dmedian[0.025*10000] - Dmedian
upper_delta = bootstrap_Dmedian[0.975*10000] - Dmedian
confidence_interval = Dmedian - c(upper_delta, lower_delta) #(186, 712)
#We can see the 95% CI for the median is tighter than the CI for the mean.
#However, neither interval contains 0.

#Part d)

#We have no reason to assume the data is normally distributed, and the sample size is small.
#Hence, we should use the non-parametric test.
t_statistic = Dbar/SD_Dbar #Under H0
p_value = pt(t_statistic, n-1, lower.tail = FALSE)*2 
#P-value is about 0.04, so we reject at 0.05 significance level.
check <- t.test(phonelines$test, phonelines$control, alternative = "two.sided", paired = TRUE)

ranks <- rank(abs(differences))
signs <- differences/abs(differences)
signed_ranks <- ranks*signs
Wplus <- sum(signed_ranks[signed_ranks > 0])
Wminus <- abs(sum(signed_ranks[signed_ranks < 0]))
#Since W- < W+, we use W- as our test statistic.
#For n = 14, we see W- lies above the critical value for alpha = 0.02 for a two-sided test.
#Hence, the p-value > 0.02 and < 0.05 and we reject at the 0.05 significance level.
check <- wilcox.test(phonelines$test, phonelines$control, alternative = "two.sided", paired = TRUE)


#Question 40
#Technically wrong, the samples are not paired: should have used the non-paired test.
#Part c)
magfield <- read.csv("magfield.csv", header=TRUE, sep = ",")
differences <- magfield$absent - magfield$present #Done this way to get positive Dbar.
n <- length(magfield$present)
Dbar <- mean(differences)
SD_Dbar <- sd(differences)/sqrt(n)
t_statistic = Dbar/SD_Dbar #Under H0
p_value = pt(t_statistic, n-1, lower.tail = FALSE)*2 
#P-value is about 0.01, so we reject at 0.05 significance level.
check <- t.test(magfield$present, magfield$absent, alternative = "two.sided", paired = TRUE)

#Part d)
ranks <- rank(abs(differences))
signs <- differences/abs(differences)
signed_ranks <- ranks*signs
Wplus <- sum(signed_ranks[signed_ranks > 0])
Wminus <- abs(sum(signed_ranks[signed_ranks < 0]))
#Since W- < W+, we use W- as our test statistic.
#For n = 10, we see W- lies exactly on the critical value for alpha = 0.02 for a two-sided test.
#Hence, the p-value is 0.02 and we reject at the 0.05 significance level.
check <- wilcox.test(magfield$present, magfield$absent, alternative = "two.sided", paired = TRUE)

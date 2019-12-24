#Question 58 d), calculating bootstrap samples to get approximate standard deviation of the MLE.
calculateMLE <- function(x) {
  (x[2] + 2*x[3])/(2*sum(x))
}
n <- 10 + 68 + 112
MLETheta <- calculateMLE(c(10, 68, 112))
multinomial_probabilities = c((1 - MLETheta)^2, 2*MLETheta*(1-MLETheta), MLETheta^2)

bootstrap_samples = rmultinom(1000, n, multinomial_probabilities)
bootstrap_MLEThetas = apply(bootstrap_samples, 2, calculateMLE)
approximate_sd = sd(bootstrap_MLEThetas)

#Question 58 e), calculating the approximate 99% confidence interval.
#We need to sort the calculated MLEs and retreive the 5th and 995th entry.
#These values minues MLETheta estimates the 0.005 and 0.995th quantiles of Theta* - MLETheta. 
sorted_bootstrapMLEs <- sort(bootstrap_MLEThetas)
lower_delta = sorted_bootstrapMLEs[5] - MLETheta
upper_delta = sorted_bootstrapMLEs[995] - MLETheta
Confidence_Interval = c(MLETheta - upper_delta, MLETheta - lower_delta)
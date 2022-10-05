gamma.arrivals <- read.csv("gamma-arrivals.csv", header=FALSE, sep = ",")

#Part a): Histogram of Interarrival times. 
hist (gamma.arrivals$V1, freq = FALSE, breaks = 30, xlim = c(0,max(gamma.arrivals$V1)), ylim = c(0,0.011),
      xlab = "Interarrival Times (In Seconds)", main = "Gamma Ray Interarrival Times")

#Part b): We know from class and the textbook that Estimate Lambda = Mu1/(Mu2 - Mu1^2),and 
#Estmate Alpha = Mu1^2/(Mu2 - Mu1^2). These parameters are calculated using the method of 
#moments formulas along with the sample data.
mu1 <- mean(gamma.arrivals$V1)
mu2 <- mean((gamma.arrivals$V1)^2)
eLambda <- mu1/(mu2 - mu1^2)
eAlpha <- mu1^2/(mu2 - mu1^2)

#Part c): This plots the Gamma(eAlpha, eLambda) distribution on top of the sample data histogram.
curve (dgamma(x, shape = eAlpha, rate = eLambda), add = TRUE, col = "red")
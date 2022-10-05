gamma.arrivals <- read.csv("gamma-arrivals.csv", header=FALSE, sep = ",")
hist (gamma.arrivals$V1, freq = FALSE, breaks = 30, xlim = c(0,max(gamma.arrivals$V1)), ylim = c(0,0.011),
      xlab = "Interarrival Times (In Seconds)", main = "Gamma Ray Interarrival Times")
mu1 <- mean(gamma.arrivals$V1)
mu2 <- mean((gamma.arrivals$V1)^2)
MoMLambda <- mu1/(mu2 - mu1^2)
MoMAlpha <- mu1^2/(mu2 - mu1^2)
curve (dgamma(x, shape = MoMAlpha, rate = MoMLambda), add = TRUE, col = "red")

#Part b): We know from class and the textbook that Estimate Lambda = Estimate Alpha/Mu1,and 
#Estimate Alpha is found by solving the nonlinear equation written below. 
f <- function(x) {3935*log(x) - 3935*log(mu1) + sum(log(gamma.arrivals$V1)) - 3935*digamma(x)}
MLEAlpha <- uniroot(f, c(0.01,5))$root
MLELambda <- MLEAlpha/mu1

#Part c): This plots the Gamma(eMLEAlpha, eMLELambda) distribution on top of the sample data histogram.
curve (dgamma(x, shape = MLEAlpha, rate = MLELambda), add = TRUE, col = "blue")

#Part d): This bootstrap finds the Standard Error for our estimates in both the Method of Moments
#and Maximum Likelihood Estimator cases.

#These are the four vectors that will store the bootstrap iteration estimate of our parameter.
BootstrapMoMAlpha <- rep(0, 10000); BootstrapMoMLambda <- rep(0, 10000); 
BootstrapMLEAlpha <- rep(0, 10000); BootstrapMLELambda <- rep(0, 10000);

#Bootstrap for Method of Moments parameters, using our estimated paramaters to generate
#10000 samples of size 3935 each.
for (i in 1:10000){
  GammaSample <- rgamma(3935, MoMAlpha, MoMLambda)
  samplemu1 <- mean(GammaSample)
  samplemu2 <- mean(GammaSample^2)
  BootstrapMoMLambda[i] <- samplemu1/(samplemu2 - samplemu1^2)
  BootstrapMoMAlpha[i] <- samplemu1^2/(samplemu2 - samplemu1^2)
}

#Bootstrap for Maximum Likelihood Estimator parameters, using our estimated paramaters to generate
#10000 samples of size 3935 each.
for (i in 1:10000){
  GammaSample <- rgamma(3935, MLEAlpha, MLELambda)
  samplemu1 <- mean(GammaSample)
  f <- function(x) {3935*log(x) - 3935*log(samplemu1) + sum(log(GammaSample)) - 3935*digamma(x)}
  BootstrapMLEAlpha[i] <- uniroot(f, c(0.01,5))$root
  BootstrapMLELambda[i] <- MLEAlpha/samplemu1
}

#Standard Error of our estimators, calculated as the standard deviation
#of the bootstrap parameter distribution.
SEMoMAlpha <- sd(BootstrapMoMAlpha)
SEMoMLambda <- sd(BootstrapMoMLambda)
SEMLEAlpha <- sd(BootstrapMLEAlpha)
SEMLELambda <- sd(BootstrapMLELambda)
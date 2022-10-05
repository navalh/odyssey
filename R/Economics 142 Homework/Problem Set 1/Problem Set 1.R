#Question 1
n1 = 30; n2 = 60; p1 = 0.05; p2 = 0.25

#11 represents using variables n1 and p1.
#12 represents using variables n1 and p2.
#21 represents using variables n2 and p1.
#22 represents using variables n2 and p2.
Ybar_11 = rep(0, 1000); Ybar_12 = rep(0, 1000); Ybar_21 = rep(0, 1000); Ybar_22 = rep(0, 1000); #Estimate of p
s_11 = rep(0,1000); s_12 = rep(0,1000); s_21 = rep(0,1000); s_22 = rep(0,1000); #Estimate of SD
ci_11 = rep(0,2000); ci_12 = rep(0,2000); ci_21 = rep(0,2000); ci_22 = rep(0,2000); #95% CI stored as two numbers for each interval.
length_ci_11 = rep(0,1000); length_ci_12 = rep(0,1000); length_ci_21 = rep(0,1000); length_ci_22 = rep(0,1000) #Length of CI
mean_in_ci_11 = rep(0,1000); mean_in_ci_12 = rep(0,1000); mean_in_ci_21 = rep(0,1000); mean_in_ci_22 = rep(0,1000); #For each rep, equals 1 if p is in CI

for (i in 1:1000){
  r_11 = rbinom(n1,1,p1) #size = 1 makes this Bernoulli sampling.
  Ybar_11[i] = mean(r_11)
  s_11[i] = (mean(r_11)*(1-mean(r_11)))^0.5
  ci_11[2*i-1] = Ybar_11[i] - 1.96*(s_11[i]/n1^0.5)
  ci_11[2*i] = Ybar_11[i] + 1.96*(s_11[i]/n1^0.5)
  length_ci_11[i] = ci_11[2*i] - ci_11[2*i-1]
  if(ci_11[2*i-1]<=p1 & p1<= ci_11[2*i]) {
    mean_in_ci_11[i] = 1
  }
  
  r_12 = rbinom(n1,1,p2) 
  Ybar_12[i] = mean(r_12)
  s_12[i] = (mean(r_12)*(1-mean(r_12)))^0.5
  ci_12[2*i-1] = Ybar_12[i] - 1.96*(s_12[i]/n1^0.5)
  ci_12[2*i] = Ybar_12[i] + 1.96*(s_12[i]/n1^0.5)
  length_ci_12[i] = ci_12[2*i] - ci_12[2*i-1]
  if(ci_12[2*i-1]<=p2 & p2<= ci_12[2*i]) {
    mean_in_ci_12[i] = 1
  }
  
  r_21 = rbinom(n2,1,p1) 
  Ybar_21[i] = mean(r_21)
  s_21[i] = (mean(r_21)*(1-mean(r_21)))^0.5
  ci_21[2*i-1] = Ybar_21[i] - 1.96*(s_21[i]/n2^0.5)
  ci_21[2*i] = Ybar_21[i] + 1.96*(s_21[i]/n2^0.5)
  length_ci_21[i] = ci_21[2*i] - ci_21[2*i-1]
  if(ci_21[2*i-1]<=p1 & p1<= ci_21[2*i]) {
   mean_in_ci_21[i] = 1
  }

  r_22 = rbinom(n2,1,p2) 
  Ybar_22[i] = mean(r_22)
  s_22[i] = (mean(r_22)*(1-mean(r_22)))^0.5
  ci_22[2*i-1] = Ybar_22[i] - 1.96*(s_22[i]/n2^0.5)
  ci_22[2*i] = Ybar_22[i] + 1.96*(s_22[i]/n2^0.5)
  length_ci_22[i] = ci_22[2*i] - ci_22[2*i-1]
  if(ci_22[2*i-1]<=p2 & p2<= ci_22[2*i]) {
   mean_in_ci_22[i] = 1
  }
}

estimate_p = c(mean(Ybar_11), mean(Ybar_12), mean(Ybar_21), mean(Ybar_22))
estimate_s = c(mean(s_11), mean(s_12), mean(s_21), mean(s_22))
coverage_rate = c(mean(mean_in_ci_11), mean(mean_in_ci_12), mean(mean_in_ci_21), mean(mean_in_ci_22))

#Question 2
atus_sum_2013 <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 1/atus_sum_2013.csv", header = TRUE, sep = ",")
employed_males <- subset.data.frame(atus_sum_2013,TESEX=="Male" & (TELFS == "Employed - at work"), X:t500107)
employed_females <- subset.data.frame(atus_sum_2013,TESEX=="Female" & (TELFS == "Employed - at work"), X:t500107)
nonemployed_males <- subset.data.frame(atus_sum_2013,TESEX=="Male" & !(TELFS == "Employed - at work"), X:t500107)
nonemployed_females <- subset.data.frame(atus_sum_2013,TESEX=="Female" & !(TELFS == "Employed - at work"), X:t500107)

sum_e_males = (mean(employed_males$t050101)+ mean(employed_males$t120101)+ mean(employed_males$t110101)+ mean(employed_males$t120303)+ mean(employed_males$t010201)+mean(employed_males$t120307)+mean(employed_males$t020101)+ mean(employed_males$t010101)) #Avg Time spent on one of the 8 activities.
e_males <- c(mean(employed_males$t050101), mean(employed_males$t120101), mean(employed_males$t110101), mean(employed_males$t120303), mean(employed_males$t010201),mean(employed_males$t120307),mean(employed_males$t020101), mean(employed_males$t010101), 24*60 - sum_e_males)/60

sum_e_females = (mean(employed_females$t050101)+ mean(employed_females$t120101)+ mean(employed_females$t110101)+ mean(employed_females$t120303)+ mean(employed_females$t010201)+mean(employed_females$t120307)+mean(employed_females$t020101)+ mean(employed_females$t010101))
e_females <- c(mean(employed_females$t050101), mean(employed_females$t120101), mean(employed_females$t110101), mean(employed_females$t120303), mean(employed_females$t010201),mean(employed_females$t120307),mean(employed_females$t020101), mean(employed_females$t010101), 24*60 - sum_e_females)/60

sum_n_males = (mean(nonemployed_males$t050101)+ mean(nonemployed_males$t120101)+ mean(nonemployed_males$t110101)+ mean(nonemployed_males$t120303)+ mean(nonemployed_males$t010201)+mean(nonemployed_males$t120307)+mean(nonemployed_males$t020101)+ mean(nonemployed_males$t010101))
n_males <- c(mean(nonemployed_males$t050101), mean(nonemployed_males$t120101), mean(nonemployed_males$t110101), mean(nonemployed_males$t120303), mean(nonemployed_males$t010201),mean(nonemployed_males$t120307),mean(nonemployed_males$t020101), mean(nonemployed_males$t010101), 24*60 - sum_n_males)/60

sum_n_females = (mean(nonemployed_females$t050101)+ mean(nonemployed_females$t120101)+ mean(nonemployed_females$t110101)+ mean(nonemployed_females$t120303)+ mean(nonemployed_females$t010201)+mean(nonemployed_females$t120307)+mean(nonemployed_females$t020101)+ mean(nonemployed_females$t010101))
n_females <- c(mean(nonemployed_females$t050101), mean(nonemployed_females$t120101), mean(nonemployed_females$t110101), mean(nonemployed_females$t120303), mean(nonemployed_females$t010201),mean(nonemployed_females$t120307),mean(nonemployed_females$t020101), mean(nonemployed_females$t010101), 24*60 - sum_n_females)/60

summary <- rbind(e_males, e_females, n_males, n_females)
colnames(summary) <- c("Work, main job", "Socializing and communicating with others", "Eating and drinking","Television and movies (not religious)", "Washing, dressing and grooming oneself", "Playing games", "Interior cleaning", "Sleeping", "Other")
rownames(summary) <- c("Male Employed", "Female Employed", "Male Nonemployed", "Female Nonemployed")
library(ggplot2)
library(reshape2)
to_plot <- melt(summary)
ggplot(to_plot, aes(x = Var1, y = value, fill = Var2)) + geom_bar(stat = "identity") + ylab("Hours") + xlab("Group") + coord_flip() + scale_fill_discrete(name="Type")
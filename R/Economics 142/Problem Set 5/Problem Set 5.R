#Part 1 Question 1
bydegree <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 5/bydegree.csv", header = TRUE, sep = ",")

bydegree$ethnic_race[bydegree$hispanic == 1] <- 1
bydegree$ethnic_race[bydegree$race == 1 & bydegree$hispanic == 0] <- 2
bydegree$ethnic_race[bydegree$race == 2 & bydegree$hispanic == 0] <- 3
bydegree$ethnic_race[bydegree$race == 3 & bydegree$hispanic == 0] <- 4
bydegree$ethnic_race[bydegree$race == 4 & bydegree$hispanic == 0] <- 5

hispanic <- subset(bydegree, hispanic == 1)
white_nonh <- subset(bydegree, hispanic == 0 & race == 1)
black_nonh <- subset(bydegree, hispanic == 0 & race == 2)
asian_nonh <- subset(bydegree, hispanic == 0 & race == 3)
other_nonh <- subset(bydegree, hispanic == 0 & race == 4)
gender_dist_hispanic <- table(hispanic$female) #0 are males, 1 are females
gender_dist_nonh <- table(subset(bydegree, hispanic == 0)$race, subset(bydegree, hispanic == 0)$female)
#Columns are 0-1 for Male/Female, Rows are 1-4 for White/Black/Asian/Other (Non-Hispanics)

#Question 2a)
gender_dist_mfield <- table(bydegree$mfield, bydegree$female)
gender_prop_mfield <- prop.table(gender_dist_mfield, 1)
#Columns are 0-1 for Male/Female, Rows are 1-10 for Field of Study

gender_wages_mfield <- array(0,dim=c(10,2)) #Mean log wage by Gender Group and Education Category
for (i in 1:10) {
  for (j in 0:1){
    gender_wages_mfield[i,j+1] = mean(subset(bydegree, mfield == i & female == j)$logwage)
  }
}

#Question 2b)
male_weights_mfield <- gender_dist_mfield[,1]/sum(gender_dist_mfield[,1])
weighted_mean_wage_male <- weighted.mean(gender_wages_mfield[,1], male_weights_mfield)
female_weights_mfield <- gender_dist_mfield[,2]/sum(gender_dist_mfield[,2])
weighted_mean_wage_female <- weighted.mean(gender_wages_mfield[,2], female_weights_mfield)

gender_wage_gap <- weighted_mean_wage_male - weighted_mean_wage_female #Male-female log wage gap is 0.19165

counterf_weighted_mean_wage_female <- weighted.mean(gender_wages_mfield[,2], male_weights_mfield)
gap_explained_by_mfield_A <- counterf_weighted_mean_wage_female - weighted_mean_wage_female 
#0.044, i.e. 23% of the wage gap is explained by field of study.

#Question 2c)

counterf_weighted_mean_wage_male <- weighted.mean(gender_wages_mfield[,1], female_weights_mfield)
gap_explained_by_mfield_B <- weighted_mean_wage_male - counterf_weighted_mean_wage_male
#0.0417, i.e. 21.8% of the wage gap is explained by field of study.
#The real effect of field of study on gender wage differentials is between 21.8 - 23%.
#The two estimates are different because they inherently bake in the regression coefficient Beta(mfield)
#In the first value, it uses Beta(mfield) estimated for women alone, while the second value uses Beta(mfield) for men alone.
#The real effect of field of study on wage (regardless of gender) can be assumed to be somewhere between these two Beta(mfield) values.

#Question 3
for (k in 1: length(bydegree)) {  
  if (bydegree$female[k] == 0){
    bydegree$male_mi[k] = 1
  } 
  else {
    bydegree$male_mi[k] = 0
  }
}

bydegree$age_squared = bydegree$AGEP^2
logit_reg <- glm(male_mi ~ AGEP + age_squared + as.factor(mfield) + as.factor(mfield)*AGEP + as.factor(ethnic_race), data = bydegree, family = binomial)

bydegree$predicted.logit_reg <- logit_reg$fitted.values
bydegree$weights.logit_reg <- bydegree$predicted.logit_reg/(1 - bydegree$predicted.logit_reg)
bydegree$weights.logit_reg[bydegree$female == 0] <- 1 

#Question 3a)
female_male_logit <- array(0, dim = c(10))
male_female_logit <- array(0, dim = c(10))
for (i in 1:10){ 
  x <- subset(bydegree, mfield == i)
  female_male_logit[i] <- sum(x$female*x$weights.logit_reg)/sum(x$weights.logit_reg)
  male_female_logit[i] <- sum(x$male_mi*x$weights.logit_reg)/sum(x$weights.logit_reg)
}

weighted_mean_wage_male_logit <- weighted.mean(gender_wages_mfield[,1], male_female_logit)
weighted_mean_wage_female_logit <- weighted.mean(gender_wages_mfield[,2], female_male_logit)
wage_gap_logit <- weighted_mean_wage_male_logit - weighted_mean_wage_female_logit

#Question 3b)
regress_wage_female <- lm(logwage ~ female, bydegree) 
#In this regression, the coefficient on the female dummy is the unadjusted gender wage gap.
#The value is -0.191, which matches the value calculated earlier.

#Question 3c)
regress_wage_female_w <- lm(logwage ~ female, weights = weights.logit_reg, bydegree)
#In this new regression, the coefficient on the female dummy has lowered to -0.1287544

#Question 3d)
regress_female <- lm(logwage ~ female + AGEP + age_squared + as.factor(mfield) + as.factor(ethnic_race), data = bydegree)


#Part 2 Question 1

twins142 = read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 5/twins142.csv", header = TRUE)

regress_twins = lm(lw ~ educ + exp + exp^2 + married + female, data = twins142)

#Question 2
regress_male = lm(lw ~ educ + exp + exp^2 + married, data = subset(twins142, twins142$female == 0))
regress_female = lm(lw ~ educ + exp + exp^2 + married, data = subset(twins142, twins142$female == 1))

##It is clear that the model coefficients are not alike.
#The gap between genders reduces with higher levels of education.
#Interestingly, there is a earnings gap between married men and women.

#Question 3
twins142$mean_marriage_rate = (twins142$married + twins142$omarried) / 2
reg_marriage <- lm(omarried ~ mean_marriage_rate, data = twins142)


regress_married_male = lm(lw ~ educ + exp + exp^2 + married + mean_marriage_rate, data = subset(twins142, twins142$female == 0))
regress_married_female= lm(lw ~ educ + exp + exp^2 + married + mean_marriage_rate, data = subset(twins142, twins142$female == 1))
#Given the difference between the regressions including/excluding marriage,there is likely omitted variable bias. 
#The inclusion of mean_marriage_rate turns the coefficient of marriage negative for women, indicating that 
#the mean_marriage_rate acts as a better variable to identidy causal effects on earnings than the married dummy.
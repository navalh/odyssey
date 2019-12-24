#Question 1a)
welfare <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 6/welfare.csv", header = TRUE, sep = ",")
#Replace NA data in ftxx variables with 0 so that the regressions estimate the same number of predicted values as observations.
welfare$ft15[is.na(welfare$ft15)] <- 0; welfare$ft20[is.na(welfare$ft20)] <- 0;
welfare$ft24[is.na(welfare$ft24)] <- 0; welfare$ft48[is.na(welfare$ft48)] <- 0;

first_FT_treat_15 <- lm(ft15 ~ treatment, data = welfare)
first_FT_treat_20 <- lm(ft20 ~ treatment, data = welfare)
first_FT_treat_24 <- lm(ft24 ~ treatment, data = welfare)
first_FT_treat_48 <- lm(ft48 ~ treatment, data = welfare)

#Question 1b)
reduced_IA_treat_15 <- lm(welfare15 ~ treatment, data = welfare)
reduced_IA_treat_20 <- lm(welfare20 ~ treatment, data = welfare)
reduced_IA_treat_24 <- lm(welfare24 ~ treatment, data = welfare)
reduced_IA_treat_48 <- lm(welfare48 ~ treatment, data = welfare)

#Question 1c)
#OLS Model 
ols_IA_FT_15 <- lm(welfare15 ~ ft15, data = welfare)
ols_IA_FT_20 <- lm(welfare20 ~ ft15, data = welfare)
ols_IA_FT_24 <- lm(welfare24 ~ ft15, data = welfare)
ols_IA_FT_48 <- lm(welfare48 ~ ft15, data = welfare)

#First Stage OLS (IV Method) and Reduced Form OLS (IV Method) were estimated in Q1a), Q1b).
#2SLS
twosls_IA_FT_15 <- lm(welfare15 ~ first_FT_treat_15$fitted.values, data = welfare)
# -0.1411/0.1374 = -1.0266 as desired.

twosls_IA_FT_20 <- lm(welfare20 ~ first_FT_treat_20$fitted.values, data = welfare)
# -0.1158/0.1112 = -1.0410 as desired.

twosls_IA_FT_24 <- lm(welfare24 ~ first_FT_treat_24$fitted.values, data = welfare)
# -0.1041/0.1044 = -0.9973 as desired.

twosls_IA_FT_48 <- lm(welfare48 ~ first_FT_treat_48$fitted.values, data = welfare)
# -0.03337/0.04818 = -0.6925 as desired.


#Question 2
#Pr(AT) = Dbar_0 = Pi0, Pr(Complier) = Dbar_1 - Dbar_0 = Pi1, Pr(NT) = 1 - Pr(AT) - Pr(Complier)
always_takers_15 <-  first_FT_treat_15$coefficients[1]
compliers_15 <- first_FT_treat_15$coefficients[2]
never_takers_15 <- 1 - always_takers_15 - compliers_15

always_takers_20 <-  first_FT_treat_20$coefficients[1]
compliers_20 <- first_FT_treat_20$coefficients[2]
never_takers_20 <- 1 - always_takers_20 - compliers_20

always_takers_24 <-  first_FT_treat_24$coefficients[1]
compliers_24 <- first_FT_treat_24$coefficients[2]
never_takers_24 <- 1 - always_takers_24 - compliers_24

always_takers_48 <-  first_FT_treat_48$coefficients[1]
compliers_48 <- first_FT_treat_48$coefficients[2]
never_takers_48 <- 1 - always_takers_48 - compliers_48

#Question 3
#We can get E(xi|C) using the goofy 2sls.
#We can calculate E(xi|AT) = E(xi| zi = 0, Di = 1); E(xi|NT) = E(xi| zi=1, Di = 0).
welfare$goofy_imm <- (welfare$imm)*(welfare$ft15)
welfare$goofy_hsgrad <- (welfare$hsgrad)*(welfare$ft15)
welfare$goofy_agelt25 <- (welfare$agelt25)*(welfare$ft15)
welfare$goofy_age35p <- (welfare$age35p)*(welfare$ft15)
welfare$goofy_working_at_baseline <- (welfare$working_at_baseline)*(welfare$ft15)
welfare$goofy_anykidsu6 <- (welfare$anykidsu6)*(welfare$ft15)
welfare$goofy_nevermarried <- (welfare$nevermarried)*(welfare$ft15)

mean_imm_compliers <- lm(goofy_imm ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_imm_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$imm)
mean_imm_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$imm)
# We see here that mean(AT) < mean(NT) < mean(C)

mean_hsgrad_compliers <- lm(goofy_hsgrad ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_hsgrad_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$hsgrad)
mean_hsgrad_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$hsgrad)
# We see here that mean(NT) < mean(C) < mean(AT)

mean_agelt25_compliers <- lm(goofy_agelt25 ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_agelt25_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$agelt25)
mean_agelt25_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$agelt25)
# We see here that mean(NT) < mean(AT) < mean(C)

mean_age35p_compliers <- lm(goofy_age35p ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_age35p_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$age35p)
mean_age35p_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$age35p)
# We see here that mean(C) < mean(AT) < mean(NT)

mean_working_at_baseline_compliers <- lm(goofy_working_at_baseline ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_working_at_baseline_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$working_at_baseline)
mean_working_at_baseline_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$working_at_baseline)
# We see here that mean(NT) < mean(C) < mean(AT)

mean_anykidsu6_compliers <- lm(goofy_anykidsu6 ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_anykidsu6_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$anykidsu6)
mean_anykidsu6_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$anykidsu6)
# We see here that mean(AT) < mean(NT) < mean(C)

mean_nevermarried_compliers <- lm(goofy_nevermarried ~ first_FT_treat_15$fitted.values, data = welfare)$coefficients[2]
mean_nevermarried_always_takers <- mean(subset(welfare, treatment == 0 & ft15 == 1)$nevermarried)
mean_nevermarried_never_takers <- mean(subset(welfare, treatment == 1 & ft15 == 0)$nevermarried)
# We see here that mean(C) < mean(NT) < mean(AT)

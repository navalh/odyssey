ovb <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 3/ovb.csv", header = TRUE, sep = ",")
#Question 2b)
model1f <- lm(logwage ~ imm, subset = female == 1, data = ovb)
model2f <- lm(logwage ~ educ, subset = female == 1, data = ovb)
model3f <- lm(imm ~ educ, subset = female == 1, data = ovb)
model4f <- lm(educ ~ imm, subset = female == 1, data = ovb)
model5f <- lm(logwage ~ educ + imm, subset = female == 1, data = ovb)

model1m <- lm(logwage ~ imm, subset = female == 0, data = ovb)
model2m <- lm(logwage ~ educ, subset = female == 0, data = ovb)
model3m <- lm(imm ~ educ, subset = female == 0, data = ovb)
model4m <- lm(educ ~ imm, subset = female == 0, data = ovb)
model5m <- lm(logwage ~ educ + imm, subset = female == 0, data = ovb)

#Question 2c)
ovb$asian_imm <- ifelse(ovb$asian == 1 & ovb$hispanic == 0 & ovb$imm == 1, 1, 0) 
ovb$hisp_imm <- ifelse(ovb$hispanic == 1 & ovb$imm == 1, 1, 0) 
ovb$other_imm <- ifelse(ovb$asian == 0 & ovb$hispanic == 0 & ovb$imm == 1, 1, 0) 

dmodel1f <- lm(logwage ~ imm + asian_imm + hisp_imm + other_imm, subset = female == 1, data = ovb)
dmodel2f <- lm(logwage ~ educ + asian_imm + hisp_imm + other_imm, subset = female == 1, data = ovb)
dmodel3f <- lm(imm ~ educ + asian_imm + hisp_imm + other_imm, subset = female == 1, data = ovb)
dmodel4f <- lm(educ ~ imm + asian_imm + hisp_imm + other_imm, subset = female == 1, data = ovb)
dmodel5f <- lm(logwage ~ educ + imm + asian_imm + hisp_imm + other_imm, subset = female == 1, data = ovb)

dmodel1m <- lm(logwage ~ imm + asian_imm + hisp_imm + other_imm, subset = female == 0, data = ovb)
dmodel2m <- lm(logwage ~ educ + asian_imm + hisp_imm + other_imm, subset = female == 0, data = ovb)
dmodel3m <- lm(imm ~ educ + asian_imm + hisp_imm + other_imm, subset = female == 0, data = ovb)
dmodel4m <- lm(educ ~ imm + asian_imm + hisp_imm + other_imm, subset = female == 0, data = ovb)
dmodel5m <- lm(logwage ~ educ + imm + asian_imm + hisp_imm + other_imm, subset = female == 0, data = ovb)

library(stargazer)
stargazer(dmodel1f, dmodel2f, dmodel3f, dmodel4f, dmodel5f, 
          out = "tablef.tex",
          star.char = "",
          omit.stat = c("adj.rsq","f","ser"),
          covariate.labels = c("Immigrant Status", "Education", "Asian Immigrant", "Hispanic Immigrant", "Other Immigrant"),
          dep.var.labels = c("Log Wage", "Immigrant Status", "Education", "Log Wage"))
#Add indep labels

stargazer(dmodel1m, dmodel2m, dmodel3m, dmodel4m, dmodel5m,
          out = "tablem.tex",
          star.char = "",
          omit.stat = c("adj.rsq","f","ser"),
          covariate.labels = c("Immigrant Status", "Education", "Asian Immigrant", "Hispanic Immigrant", "Other Immigrant"),
          dep.var.labels = c("Log Wage", "Immigrant Status", "Education", "Log Wage"))
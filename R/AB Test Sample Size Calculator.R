library(pwr)


#All inputs are given as a percentage out of 100. See examples.
#Lift is the absolute lift from the baseline. For example, if we expect 30% baseline and 35% in the variant, the lift is 5%.

sample_size_calculator_1 <- function (baseline, lift, sig_level, des_power) {
  pwr.2p.test(h = ES.h(p1 = (baseline+lift)/100, p2 = baseline/100),  
                       sig.level = sig_level/100, 
                       power = des_power/100, 
                       alternative = "two.sided")[2]
}

sample_size_calculator_2 <- function (baseline, lift, sig_level, des_power) {
  power.prop.test(p1 = (baseline+lift)/100, 
                  p2 = baseline/100,
                  sig.level = sig_level/100,
                  power = des_power/100,
                  alternative = "two.sided")[1]
}


sample_size_calculator <- function (baseline, lift, sig_level, des_power) {
  c(sample_size_calculator_1(baseline, lift, sig_level, des_power),
    sample_size_calculator_2(baseline, lift, sig_level, des_power))
}

#sample_size_calculator(5, 0.25, 5, 95)
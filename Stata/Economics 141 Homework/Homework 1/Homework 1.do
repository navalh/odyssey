import delimited "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 1\hw1.csv"
generate annual_growth_rate = (rgdp - rgdp[_n-4])/rgdp[_n-4]
mean annual_growth_rate
generate demo_rate = annual_growth_rate if dpresident == 1
generate rep_rate = annual_growth_rate if dpresident == 0
summarize demo_rate
summarize rep_rate

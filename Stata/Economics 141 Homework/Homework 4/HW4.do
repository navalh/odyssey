import excel "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 4\terrorism.xlsx", sheet("Sheet1") firstrow
twoway scatter ftmpop gdppc, title("Terrorism Fatalities vs. GDP per Capita") xtitle("GDP per Capita") ytitle("Terrorist Fatalities per Million of Population")
generate lnftmpop = log(ftmpop)
generate lngdppc = log(gdppc)
twoway scatter lnftmpop lngdppc, title("Log Terrorism Fatalities vs. Log GDP per Capita") xtitle("Log GDP per Capita") ytitle("Log Terrorist Fatalities per Million of Population")
twoway scatter lnftmpop lackpf, title("Log Terrorism Fatalities vs. Lack of Political Freedom") xtitle("Lack of Political Freedom") ytitle("Log Terrorism Fatalities per Million of Population")
regress lnftmpop lngdppc
generate lngdppc_sq = lngdppc^2
generate lackpf_sq = lackpf^2
regress lnftmpop lngdppc lngdppc_sq
regress lnftmpop lngdppc lackpf lackpf_sq ethnic religion
mean lngdppc
mean ethnic
mean religion
twoway function y = -4.649 + 1.466*x - 0.17*(x^2), xtitle("lackpf") ytitle("lnftmpop") range(0 7)

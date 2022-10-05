import delimited "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 5\hw5.csv"
replace fhpolrigaug = "." if fhpolrigaug == "NA"
destring fhpolrigaug, replace
replace lrgdpch = "." if lrgdpch == "NA"
destring lrgdpch, replace
replace laborshare = "." if laborshare == "NA"
destring laborshare, replace
replace lpop = "." if lpop == "NA"
destring lpop, replace
replace medage = "." if medage == "NA"
destring medage, replace
gen fhpolrigaug_lag = fhpolrigaug[_n-1] if code_numeric == code_numeric[_n-1]
gen lrgdpch_lag = lrgdpch[_n-1] if code_numeric == code_numeric[_n-1]
gen laborshare_lag = laborshare[_n-1] if code_numeric == code_numeric[_n-1]
gen lpop_lag = lpop[_n-1] if code_numeric == code_numeric[_n-1]
xtset code_numeric year
regress fhpolrigaug fhpolrigaug_lag lrgdpch_lag
regress fhpolrigaug fhpolrigaug_lag lrgdpch_lag i.year
regress fhpolrigaug fhpolrigaug_lag lrgdpch_lag i.year, cluster(code_numeric)
display e(rss)
display e(tss) 
xtreg fhpolrigaug fhpolrigaug_lag lrgdpch_lag i.year, fe cluster(code_numeric)
display e(rss)
display e(tss) 
xtreg fhpolrigaug fhpolrigaug_lag lrgdpch_lag laborshare_lag lpop_lag socialist i.year, fe cluster(code_numeric)
display e(rss)
display e(tss) 
reg fhpolrigaug fhpolrigaug_lag lrgdpch_lag i.year i.code_numeric
testparm i.code_numeric

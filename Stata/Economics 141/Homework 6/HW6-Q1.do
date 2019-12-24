import delimited "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 6\NYSEdata.csv"
gen returno_lag = returno[_n-1]
gen returno_lag_square = returno_lag*returno_lag
regress returno returno_lag
predict uhat, residual
generate uhat_square = uhat*uhat
regress returno returno_lag returno_lag_square
predict yhat
gen yhat_square = yhat*yhat
regress returno returno_lag returno_lag_square yhat_square
regress returno returno_lag, robust
generate time = _n
twoway scatter uhat time, title("Residuals of Reg 1 over Time") xtitle("Time") ytitle("Resdiuals")
regress uhat_square returno_lag
predict yhat_4
regress uhat_square returno_lag returno_lag_square
predict yhat_5
generate weight = 1/yhat_5
regress returno returno_lag [pweight = weight]

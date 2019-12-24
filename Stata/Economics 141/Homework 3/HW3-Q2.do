import delimited "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 3\Daily Closing Values.csv"
generate rmt = log(sp500close) - log(sp500close[_n-1])
generate rst = log(hasclose) - log(hasclose[_n-1])
generate excess_market_r = rmt - rf
generate excess_stock_r = rst - rf
twoway scatter excess_stock_r excess_market_r, title("CAPM for Hasbro (HAS)") xtitle("Excess Return of Market") ytitle("Excess Return of Hasbro")
regress excess_stock_r excess_market_r
twoway scatter excess_stock_r excess_market_r, title("CAPM for Hasbro (HAS)") xtitle("Excess Return of Market") ytitle("Excess Return of Hasbro") || lfit excess_stock_r excess_market_r
predict residuals, resid
twoway scatter residuals excess_market_r, title("Residuals Under CAPM for HAS") xtitle("Excess Return of Market") ytitle("Resdiuals")
correlate excess_stock_r excess_market_r
generate p_value_beta = ttail(250, (_b[excess_market_r] - 1)/_se[excess_market_r])
generate fitted_excess_stock_r = _b[_cons] + _b[excess_market_r]*0.01

import excel "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 3\BigMac.xlsx", sheet("Sheet1") firstrow
generate predicted_exchange_rate = BigMacpricesinlocalcurrency/4.93
regress ActualdollarexchangerateJan predicted_exchange_rate
generate p_value_beta0 = 2*ttail(53, (_b[_cons] - 0)/_se[_cons])
generate p_value_beta1 = 2*ttail( 53, (_b[predicted_exchange_rate] - 1)/_se[predicted_exchange_rate])

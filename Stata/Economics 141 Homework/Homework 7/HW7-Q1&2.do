import excel "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 7\Movies.xlsx", sheet("Movies_1.csv") firstrow
generate ln_assaults = log(assaults)
regress ln_assaults year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12
generate attend = attend_v + attend_m + attend_n
regress attend year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12
regress ln_assaults attend_v attend_m attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
test (attend_v - attend_m = 0)
test (attend_v - attend_n = 0)
*generate attend_v_m = attend_v + attend_m
*generate attend_v_n = attend_v + attend_n
*regress ln_assaults attend_v_m attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress ln_assaults attend_v_n attend_m year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow

*regress attend_v pr_attend_v pr_attend_m pr_attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress attend_v year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress attend_m pr_attend_v pr_attend_m pr_attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress attend_m year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress attend_n pr_attend_v pr_attend_m pr_attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow
*regress attend_n year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow

ivregress 2sls ln_assaults year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow (attend_v attend_m attend_n = pr_attend_v pr_attend_m pr_attend_n)
estat firststage, all
test (attend_v - attend_m = 0)
test (attend_v - attend_n = 0)
ivregress 2sls ln_assaults year2 year3 year4 year5 year6 year7 year8 year9 year10 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 h_chris h_newyr h_easter h_july4 h_mem h_labor w_maxa w_maxb w_maxc w_mina w_minb w_minc w_rain w_snow (attend_v attend_m attend_n = attend_v_b attend_v_f attend_m_b attend_m_f attend_n_b attend_n_f)
test (attend_v - attend_m = 0)
test (attend_v - attend_n = 0)
estat overid

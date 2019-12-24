import excel "\\Client\C$\Users\Naval\Dropbox\Berkeley Documents\Spring 2016\Econ 141\Homework 5\CEOSAL.xlsx", sheet("CEOSAL") firstrow
regress lsalary lsales roe ros
generate roe_ros = roe + ros
regress lsalary lsales roe_ros

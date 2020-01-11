#This script is distributed under the GNU pulic license GPLv3. It is free (gratis), free (libre) and-open source. It is available at GitHub
#Nopphons or from the corresponding author (Sachs) of the paper "In Silico Predictions on Mixed-Beam Action in Radiation Biology"
#A Cheng, N Siranart and RK Sachs, in preparation for Rad. Res. The 3 authors cooperated in designing, writing, commenting and testing the script.
#The script compares, in a special case, isobole methods ([Berenbaum; Tallarida]; see the paper) with 2 other methods. Each method attempts
#to predict the effect of a mixture from the dose-response relations of its individual components. Only 2 components are considered
#in this script, and it is assumed that both are linear-quadratic (LQ). The Berenbaum isobole prediction is E_B; the average Tallarida isobole prediction is E_T; 
#the dual action prediction is E_Z; simple effect additivity is E_A. E_B and E_T require computer approximation; the other 2 can be calculated directly.
rm(list=ls())
E<-function(d,alph,bet){  #defines LQ effect as function of dose >=0; alph,bet >= 0; alph+bet > 0
  e=alph*d+bet*d^2
}
Ei<-function(e,alph,bet){#inverse function, Ei(E(x))=x, Ei turns an effect back into the dose that made the effect. 
  d=(-alph+sqrt(alph^2+4*e*bet))/(2*bet) #needs bet>0; the other case, bet=0, is simpler; here always take bet1 ne 0.
}

#Next analyze results for 6-D space, starting from the 5-D space bet2=0, where all results are known for E_B, & stepping alph2 values.
d1=.5; d2=.5# doses of the two agents; axes for 2 of the 6 dimensions 
alph1=.63;bet1=1;alph2=rep(0,10000);bet2=.21 #coefficients of 2 LQ curves; alph2 is being initiallized for stepping

#Denote as IA the point (alph1=.997,bet1=.5,d1=.5,alph2=1,d2=.6) in 5-D space. An example
#Denote as IB the point (alph1=.5013,bet1=.1,d1=.5,alph2=1,d2=1) in 5-D space. Another example
#for (bet2 in .000001*(503000:503020)){ #zoom in on bet2 values where E_Z and E_B are equal to within about 1.0e-15 for(IA,bet2)
#for (bet2 in .0000050001*((2*39786):(2*39806))){ #similar to preceeding line, but for (IB,bet2)
#for (bet2 in 1000*(1:1000)){# looks like E_Z --> E_B for bet2 --> infinity
#bet2=.5030132;{# identified as a point where E_B and E_Z are very close; curly brackets for convenience

key=alph1*sqrt(bet2/bet1) #a value of alph2 at which E_B=E_Z=E_T

display_results = function(range = c(1e-11*(1:10),key*(1+.01*(-99:200)),1:20), digits = 6, sci = TRUE,
                           d1=.5, d2=.5, alph1=.63, bet1=1, bet2=.21){
  results = data.frame(matrix(data=NA, nrow = length(range), ncol = 5))
  names(results) = c('alph2/key', 'E_B', '(E_B-E_T)/E_B', '(E_B-E_Z)/E_B', '(E_B-E_A)/E_B')
  for (i in 1:length(range)){
    alph2 = range[i]
    iso=function(D1){ #conditions for (d1,d2) to lie on a linear isobole line is iso=0
      D1 -d1-d2*D1/Ei(E(D1,alph1,bet1),alph2,bet2) #condition on D1 that makes iso=0 when d1,d2, alph1, bet1, alph2, bet2 are given.
    } 
    d1e=Ei(E(d2,alph2,bet2),alph1,bet1); d2e=Ei(E(d1,alph1,bet1),alph2,bet2)
    #"equivalent" doses used in next line
    E_T1=E(d1+d1e,alph1,bet1);E_T2=E(d2+d2e,alph2,bet2); E_T=(1/2)*(E_T1+E_T2)
    
    D1e=uniroot(iso,c(d1+.0001,5*d1),extendInt="upX",tol=1.0e-12) #D1 is always greater than d1, often about twice as much.
    
    E_B=E(D1e$root,alph1,bet1) #The effect of D1e given alone is the same as the effect of (d1,d2) when iso=0
    D2e=Ei(E(D1e[[1]],alph1,bet1),alph2,bet2) #D2e given alone also has the same effect as D1e given alone.
    
    E1=E(d1,alph1,bet1);E2=E(d2,alph2,bet2) #for comparison, the effect of dj given alone, j=1,2.
    E_A=E1+E2 #effect additivity; naively, but NOT in the isobole method, interpreted as neither synergy nor antagonism.
    E_Z=E_A+2*d1*d2*(bet1*bet2)^0.5 #the dual action prediction. >=E_A; equality holds iff d1*d2*bet1*bet2=0
    # print(round(c(bet2,E1,E2,E_EA,E_Z,E_B-E_Z,D1e[[1]],D2e),4),digits=5,print.gap=6,right=TRUE)
    # print(round(c(bet2, E_B-E_Z),9),digits=3,print.gap=16,right=TRUE) #get E_B-E_Z to high precision when line 18 or 19 is used
    results[i,] = c(alph2/key,E_B,(E_B-E_T)/E_B,(E_B-E_Z)/E_B,(E_B-E_A)/E_B)
  }
  # d=c(1,2/3); D=c(0,0) #eventually will generalize to N>2 LQ agents, starting as follows.
  # for (i in c(1,2)) D[i]=Ei(EO,alph[i],bet[i]) #initialize D.
  return(format(results, digits = 6, scientific = sci))
}

results = display_results()

# Uncomment the following line if you want to output the results as a csv file
# write.csv(results, '~/Desktop/LQ1_results.csv') 
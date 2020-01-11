##This is free, open-source software and under GNU GPLv3. It comes with no warranty. Concerns radiogenic mouse HG gland tumorigenesis.
##Uses individual dose-effect relations (IDER) & parameters from Cucinotta1 et al. (2013). Space Radiation Cancer Risk Projections and
##Uncertainties - 2012. ##NASA Center for AeroSpace Information, Hanover, MD; http://ston.jsc.nasa.gov/collections/TRS
##User adjustable parameters are those near line 170 and also limits on x and y axes for some of the graphs.
##Gives main calculations for Siranart, Cheng, Handa, Sachs in preparation for Rad. Res. 
##Main outputs: predictions E_A=S(d) and E_I=I(d) with graphs, for effect of mixtures of ions (fully ionized atomic nuclei)
library(deSolve)
rm(list=ls()) 
###FIXED PARAMETERS###next lines have Cucinotta et al. (2013) table 5.4 IDER parameters for ions. TE=targeted effects, NTE = non-TE.
###Naval: most of this will not be used in your first program but I leave it all in, for later RKS
parameter = list(TE = list(alph0=7.53, alph1=1.261, alph2=0.0037, beta = 0, beta_p = 6.3, lamd0=.25, lamd1=.0051, lamd2=.0034,
                      e_alph0=3.96, e_alph1=0.213, e_alph2=0.00058, e_beta = 0, e_beta_p = 3.41, e_lamd0=.065, e_lamd1=.0029, e_lamd2=.0027), 
                 NTE=list(alph0=10.02,alph1=0.679,alph2=0.0033,beta=0,beta_p=5.08,lamd0=.231,lamd1=.0033,lamd2=.005,k1=0.12,k2=0.0053,
                      e_alph0=2.07,e_alph1=0.187,e_alph2=0.0006,e_beta=0,e_beta_p=3,e_lamd0=.016,e_lamd1=.0042,e_lamd2=.0064,e_k1=0.06,e_k2=0.002))
alph=function(L, param) {with(param,alph0+alph1*L*exp(-alph2*L))} #slope near zero of the OCDER; depends on LET L (keV/micron)
lamd=function(L, param) {with(param,lamd0+lamd1*L*exp(-lamd2*L))}
kappa=function(L,param){with(param, (k1*L)*exp(-k2*L))}#kappa interpreted as NTE, important near d=0; approximated as initial value.
###FUNCTIONS### Used later. Next is function to calculate targeted part T of the effect of an individual radiation (Cucinotta et al. 2013); if Eff=1, T=E_single; 
#if Eff=2, T=E_single-NT, where NT=kappa*exp(-lamd*dose). Uses proton=0 for ion charge Z>2; proton=1 for H, He ions

Eff=1#use this always for your first program; next lines define the IDER
T_single = function(dose, L, Eff, proton, param = parameter[[Eff]]){ #Eff: 1=TE=targeted effect model; 2=NTE=non-targeted (bystander) effect.
  beta = param$beta #initialize to be beta=0 with Z>2, i.e near d=0 TE effect is linear no threshhold (LNT) for Z>2.
  if(proton == 1){ beta= param$beta_p} #ions with Z<3 are approximated as LQ (linear quadratic) near d=0.
  P_E = (alph(L,param)*dose + beta*(dose^2))*exp(-lamd(L,param)*dose) #LQ or LNT modulated by exponentially decreasing factor.
  return(P_E)
}

#Each T_single has a maximum, often around dose=1 Gy. Next is a function to find the maxima and the doses where they occur.
#Naval if you stick to total doses less than about .3 when calculating E_A=S(d) and E_I=I(d) you never need to worry about this R function.
# bound_Ed = function(L,Eff,proton, param){##
#   E = c(); D = c(); ##
#   for(ll in 1:length(L)){#when this function is used, L will be a vector of the LETs of the individual components of a mixed-ion beam
#     p = proton[ll]; l = L[ll]; 
#     b = param[[ll]]$beta; a = alph(l,param[[ll]]); ld = lamd(l,param[[ll]])
#     if(p == 1){ b= param[[ll]]$beta_p}
#     if(b !=0){
#       d = (sqrt((a*ld)^2+4*b^2)-a*ld+2*b)/(2*b*ld);#the derivative of the IDER is zero at maximum, occuring at this dose.
#     }else{d = 1/(ld)} 
#     D = c(D,d)
#     E = T_single(d,L,Eff,parameter[[ll]])
#   }
#     return(list(upper_E,max_d,D))#only D used
# }

#####USER-DEFINED PARAMETERS FOR MIXTURE CALCULATIONS#####
r=c(.8,.2); L=c(50,190); proton = c(0,0); Eff=1
#r=mixture proportions (must sum to 1); L=LETs; proton=1 for H, He, and proton =0 for heavier ions (0 means LQ beta is 0). 
#r=.02*c(9,8,7,6,5,5,4,3,2,1); L=25*(1:10); proton = rep(0,10); Eff=1 #Naval, after you get E_A and E_I to work for the above try two more complex cases below.
#r=c(.1,.2,.7); L=(190,50,.4); proton=c(0,0,1);Eff=1
nL = length(L); end =1.5; by = 0.1; cols = end/by+1; doses <- seq(0, end, by = by); #to increase smoothness decrease "by"


####################GRAPHS####################Comment out unneeded ones
#IDER Plot. Allows adjustment of upper dose limit to less than "end" under user adjsted parameters.
xstart = 0; xend = 1.5; ystart= 0; yend = 60
plot(c(xstart,xend),c(ystart,yend),type='n',bty="l", ylab = 'E', xlab = 'd')
for(l in 1:length(L)){
  lines(doses,T_single(doses,L[l],Eff,proton[l]),type="l", col = colors()[20*l+2]) #automatic choice of colors 
}

#Naval: Now calculate E_A and E_I essentially just as you did for LQ IDER.
###plot E_I, E_A, together in one graph.
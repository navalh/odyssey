
library(ggplot2); library(deSolve)
rm(list=ls()) 
###FIXED PARAMETERS###next line has Cucinotta et al. (2013) table 5.4 IDER parameters for ions. TE=targeted effects, NTE = non-TE.
parameter = list(TE = list(alph0=7.53, alph1=1.261, alph2=0.0037, beta = 0, beta_p = 6.3, lamd0=.25, lamd1=.0051, lamd2=.0034,
                      e_alph0=3.96, e_alph1=0.213, e_alph2=0.00058, e_beta = 0, e_beta_p = 3.41, e_lamd0=.065, e_lamd1=.0029, e_lamd2=.0027), 
                 NTE=list(alph0=10.02,alph1=0.679,alph2=0.0033,beta=0,beta_p=5.08,lamd0=.231,lamd1=.0033,lamd2=.005,k1=0.12,k2=0.0053,
                      e_alph0=2.07,e_alph1=0.187,e_alph2=0.0006,e_beta=0,e_beta_p=3,e_lamd0=.016,e_lamd1=.0042,e_lamd2=.0064,e_k1=0.06,e_k2=0.002))
alph=function(L, param) {
  if (L == -1) {
    return(with(param,alph0*2+alph1*2*100*exp(-alph2*100))) #Using L = 100 instead of L = -1.
  }
  return (with(param,alph0+alph1*L*exp(-alph2*L)))
} 
lamd=function(L, param) {
  if (L == -1) {
    return(with(param,lamd0*2+lamd1*2*100*exp(-lamd2*100)))
  }
  return(with(param,lamd0+lamd1*L*exp(-lamd2*L)))
}


kappa=function(L,param){
  if (L == -1) {
    return(with(param, (k1*100)*exp(-k2*100)))
  }
  return(with(param, (k1*L)*exp(-k2*L)))
}

T_single = function(dose, L, Eff, proton, param = parameter[[Eff]]){ #Eff: 1=TE=targeted effect model; 2=NTE=non-targeted (bystander) effect.
  beta = param$beta #initialize to be beta=0 with Z>2, i.e near d=0 TE effect is linear no threshhold (LNT) for Z>2.
  if(proton == 1){ beta= param$beta_p} #ions with Z<3 are approximated as LQ (linear quadratic) near d=0.
  P_E = (alph(L,param)*dose + beta*(dose^2))*exp(-lamd(L,param)*dose) #LQ or LNT modulated by exponentially decreasing factor.
  return(P_E)
}

E_single = function(dose, L, Eff, proton, param = parameter[[Eff]]){  
  P_E = T_single(doses,L,Eff,proton)
  if (Eff==2){
    P_E = P_E + kappa(L,param)*exp(-lamd(L,param)*dose)#P_E here is sum of targeted and non-targeted effects
  }
  return(P_E)
}

#Each E_single has a maximum, often around dose=1 Gy. Next is a function to find the maxima and the doses where they occur.
bound_Ed = function(L,Eff,proton, param){##
  E = c(); D = c(); ##
  for(ll in 1:length(L)){#when this function is used, L will be a vector of the LETs of the individual components of a mixed-ion beam
    p = proton[ll]; l = L[ll]; 
    b = param[[ll]]$beta; a = alph(l,param[[ll]]); ld = lamd(l,param[[ll]])
    if(p == 1){ b= param[[ll]]$beta_p}
    if(b !=0){
      d = (sqrt((a*ld)^2+4*b^2)-a*ld+2*b)/(2*b*ld);#the derivative of the IDER is zero at maximum, occuring at this dose.
    }else{d = 1/(ld)} 
    D = c(D,d)
    E = c(E,solve_d(d,l,Eff,p,0, param[[ll]]))
  }
  upper_E = min(E)#smallest of the maxima in a mixed beam, no longer used. kept in case needed later.
  max_d = D[which(E==upper_E)]#no longer used
  return(list(upper_E,max_d,D))#only D used
}

#function which uniroot can use to get dose from L,Eff,proton, and T_single;  treats E=T_single as independent and
#d as dependent variable instead of vice versa as in RBE calculations.# now redundant with previous funciton.
solve_d=function(dose,L,Eff,proton,E, param = parameter[[Eff]]) {
  eq = T_single(dose,L,Eff,proton,param)-E
  return(eq)
}

gamma_param = function(Eff){#When calculating 95% CI for mixture, IDER parameters are taken to have gamma distributions (and stay >0)
  param = parameter[[Eff]]
  param_error=with(param,list(alph0=rgamma(1,(alph0/e_alph0)^2,alph0/(e_alph0)^2),
                              alph1=rgamma(1,(alph1/e_alph1)^2,alph1/(e_alph1)^2),
   alph2=rgamma(1,(alph2/e_alph2)^2,alph2/(e_alph2)^2),
   beta=0,
   beta_p=rgamma(1,(beta_p/e_beta_p)^2,beta_p/(e_beta_p)^2),
   lamd0=rgamma(1,(lamd0/e_lamd0)^2,lamd0/(e_lamd0)^2),
   lamd1=rgamma(1,(lamd1/e_lamd1)^2,lamd1/(e_lamd1)^2),
   lamd2=rgamma(1,(lamd2/e_lamd2)^2,lamd2/(e_lamd2)^2)))
  if(Eff ==2){
    param_error1 = with(param,list(k1 = rgamma(1,(k1/e_k1)^2,k1/(e_k1)^2), k2 = rgamma(1,(k2/e_k2)^2,k2/(e_k2)^2)))
    param_error = c(param_error,param_error1)
  }
  return(param_error)
}
gen_param = function(Eff,N, random){
  param = list()
  p = gamma_param(Eff)
  for(ii in 1:N){
    param[[ii]] = p #random parameters
    if (random ==0) param[[ii]] = parameter[[Eff]]
  }
  return(param)
}

#function for d = D_j(E), where D_j will be the compositional inverse function to the jth IDER for the jth ion in a mixture.
dose_E=function(E, L, Eff,proton, param){
  result0 = bound_Ed(L,Eff,proton, param); upper_E = result0[[1]]; d_max = result0[[3]]
  output=c()
  for(i in 1:length(E)){
    e =min(E[i], upper_E-1e-4)#
    dose = (uniroot(solve_d,c(0,.001), upper=d_max, extendInt="upX",tol = 1e-6, L = L, 
                    Eff = Eff, proton=proton, E = e, param = param[[1]]))$root
    output= c(output,dose)
  }
  return(output)
}

#Next is function to get simple effect additivity default prediction E_A=S(d)
E_A <- function(dose, L, Eff, proton, param = parameter[[Eff]]){#use T (i.e subtract out kappa term), manipulate, later add biggest back in. RKS
  output = rep(0,cols); k0=rep(0,nL)
  for(l in 1:nL){
    output = output + T_single(r[l]*doses,L[l],Eff,proton[l],param[[l]])
  }
  if (Eff==2){
    maxx=which.max(kappa(L,param[[l]]))
    output = output + kappa(L[maxx],param[[l]])
  }
  return(output)
}

#Next R function gets linear isobole default prediction; no longer used; kept in case later needed
# E_B <- function(param){
#   result = bound_Ed(L,Eff,proton, param); upper_E = floor(10*result[[1]])/10
#   E_B= .1*(1:(upper_E*10)); d_max = result[[3]]
#   doses = c(); E_B_mean = c();
#   for (e in E_B){
#     D = c()
#     for (l in 1:nL){ 
#       d = (uniroot(solve_d,c(0,.001), upper=d_max[l], extendInt="upX",tol = 1e-4, L = L[l], 
#                    Eff = Eff, proton=proton[l], E = e, param = param[[l]]))$root
#       D = c(D,d)
#     }
#     mdose=1/sum(r/D)# the calculated mixture dose for hypothesis E_B, given mixture effect, i.e. effect treated as the indeopendent variable.
#     EB = e
#     if(Eff == 2){ #Here in case of NTE, we add kappa to E_B and E_A
#       maxx=which.max(kappa(L,param[[1]]))
#       EB = EB + kappa(L[maxx],param[[1]])
#     }
#     #add all values to the lists and continue looping
#     doses = c(doses, mdose);E_B_mean = c(E_B_mean, EB); 
#   }
#   return(list(E_B_mean, doses))
# } 

#R function to get first derivative of function f evaluated at E, using effect rather than dose as independent variable
first_deriv = function(f,E){
  delta = 1e-6
  output = (f(E) - f(E-delta))/delta
  return(output)
}

sum_rE = function(E, param){#used to calculate slopes for incremental effect additivity default prediction E_I=I(d) 
  output = c()
  for(j in 1:length(E)){
    cumrE = 0
    for(i in 1:nL){
      f = function(x) T_single(x,L[i],Eff,proton[i],param[[i]])
      temp = list(); temp[[1]] = param[[i]]
      d = dose_E(E[j],L[i],Eff,proton[i],param=temp)
      cumrE = cumrE + r[i]*first_deriv(f,d)
    }
    output = c(output,cumrE)
  }
  return(output)
}

solve_ode <- function(t, state, parameters) {#R function used when integrating the ordinary differential eq. for I(d)
  with(as.list(c(state, parameters)), {
    dE <- sum_rE(E, parameters) 
    list(c(dE))
  })
}

E_I <- function(state,doses,L, Eff, proton, param){#R function used to actually integrate
  output = ode(y = state, times = doses, func = solve_ode, parms = param)
  result = output[,2]
  if(Eff ==2){
    maxx=which.max(kappa(L,param[[1]]))
    result = result + kappa(L[maxx],param[[1]])*exp(-lamd(L[maxx],param[[1]])*doses)}# BON7. I added the exp; I think we need it. But I am not sure we don't need it earlier, when defining E_single and T_single.
   return(result)
}

#####USER-DEFINED PARAMETERS FOR MIXTURE CALCULATIONS#####
#r=.02*c(9,8,7,6,5,5,4,3,2,1); L=25*(1:10); proton = rep(0,10); Eff=2; N = 100 #use N >= 50 to get 95% CI
r=c(.4,.6); L=c(100, -1); proton = c(0,0); Eff=2; N = 100 #use bigger N  (e.g. N=10000)for more accurate CI
#r=mixture proportions (must sum to 1); L=LETs; proton=1 for H, He, and proton =0 for heavier ions (0 means LQ beta is 0). 
nL = length(L); end =1.5; by = 0.1; cols = end/by+1; doses <- seq(0, end, by = by); #to increase smoothness decrease "by"

############E_A with central values of the parameters##############
E_A_mean = E_A(doses, L ,Eff,proton, gen_param(Eff,nL,0))
############E_I with central values of the parameters###############
state <- c(E = 0);
E_I_mean = E_I(state,doses, L, Eff, proton,gen_param(Eff,nL,0))
#E_B# no longer used because numerically very similar to E_I with smaller domain of validity and with conceptual flaws
#result = E_B(gen_param(Eff,nL,0))
#dose_EB = result[[2]]; E_B_mean = result[[1]]
#y=max(E_B_mean); x=max(dose_EB); z=min(which(doses>x));compare=.5*(E_I_mean[z]+E_I_mean[z-1])#use this line or the next. output for tables 
#x=1.498;z=min(which(doses>x)); u=min(which(dose_EB>x));compare=.5*(E_I_mean[z]+E_I_mean[z-1]);y=E_B_mean[u] #RKS make into if/else statement
#print(c(x,compare, (compare-y)/compare))
print(c(E_A_mean[cols],E_I_mean[cols], (E_A_mean[cols]-E_I_mean[cols])/E_A_mean[cols]))# to get some numerical values rther than graphs

##########95% confidence intervals;  Most CPU intensive part of the calculation; comment out if only want central parameter value results.
E_A_mat = matrix(0, N, cols); ##now do Monte Carlo for error structure; at first without any kappa term even if Eff=2
for(i in 1:N){
    E_A_mat[i,] = E_A(doses, L, Eff,proton, gen_param(Eff,nL,1))
}
E_A_sort = apply(E_A_mat,2,sort,decreasing=F); 
E_A_low = E_A_sort[floor(N*0.025),]; E_A_high = E_A_sort[ceiling(N*0.975),]; print(E_A_high[cols]) 

E_I_mat = matrix(0, N, cols);
for(i in 1:N){
  print(i)
  param = gen_param(Eff,nL,1)
  E_I_mat[i,] = E_I(state,doses,L,Eff,proton, param)
}
E_I_sort = apply(E_I_mat,2,sort,decreasing=F); 
E_I_low = E_I_sort[floor(N*0.025),]; E_I_high = E_I_sort[ceiling(N*0.975),]; 

####################GRAPHS####################Comment out unneeded ones
#IDER Plot. Allows adjustment of upper dose limit to less than "end" under user adjsted parameters.
xstart = 0; xend = 1.5; ystart= 0; yend = 60
plot(c(xstart,xend),c(ystart,yend),type='n',bty="l", ylab = 'E', xlab = 'd')
for(l in 1:length(L)){
  lines(doses,E_single(doses,L[l],Eff,proton[l]),type="l", col = colors()[20*l+2]) #automatic choice of colors 
}

## plot E_I and E_A together in one graph with error bars, allowing the user to adjust the upper dose limit (<2 Gy; if no protons <1)
df= data.frame(md = doses, EI=E_I_mean, EA=E_A_mean)##dev.off()
######Elegant ribbon plots###### 
ggplot(df,aes(md)) + geom_line(aes(y = EI),color ='red') + geom_ribbon(aes(ymin=E_I_low, ymax=E_I_high), alpha=0.2,fill='red')+
geom_line(aes(y = EA),color ='blue') + geom_ribbon(aes(ymin=E_A_low, ymax=E_A_high), alpha=0.2,fill='blue')+ggtitle("95% CI")
ggsave("fig5B.eps", device=cairo_ps)
#####Regular error bar Plots##### Same content as ggplot; clumsier and uglier.
xstart = 0; xend = 1.5; ystart= 0; yend = 105
plot(c(xstart,xend),c(ystart,yend),type='n',bty="l", ylab = 'E', xlab = 'd')
lines(doses,E_I_mean,col='red')
lines(doses,E_I_low,col="red")#,lty="36")
lines(doses,E_I_high,col="red")#,lty="36")
lines(doses,E_A_mean,col='blue')
plot(c(xstart,xend),c(ystart,yend),type='n',bty="l", ylab = 'E', xlab = 'd')
lines(doses,E_I_mean,col='red')
lines(doses,E_A_low,col="blue")#,lty="36")
lines(doses,E_A_high,col="blue")#,lty="36")
lines(doses,E_A_mean,col='blue')

###plot E_I, E_A, (and E_B) together in one graph for the central parameters, without error bars
xstart = 0; xend =1; ystart= 0; yend = 50
plot(c(xstart,xend),c(ystart,yend),type='n',bty="l", ylab = 'E', xlab = 'd', lab=c(3,11,7))
lines(doses,E_I_mean,col='red')
lines(doses,E_A_mean,col='blue')
#lines(dose_EB,E_B_mean,col='black')#Not used. E_B is often so close to E_I it is confusing in graphs.

# check to see that E_I never exceeds maxEmax UNDER CONSTRUCTION
# MM=c()
# for (ll in 1:nL){
#   MM=c(MM,max(E_single(,L[ll],1,0)))
#   MMM=max(MM)  
# }
# mm=max(E_I_mean)
# MMM
# #mmp=max(E_single(,L[ll],1,1))
# print(c(mm,MMM))

families <- read.csv("families.csv", header=TRUE, sep = ",")
bigN <- nrow(families) #Population Size

#The sample function creates a random permutation of 500 numbers that can be between 1 to 43886.
#The bracket notation creates a subset of families that correspond to these indices of the random permutation.
#Column index is blank because we want all columns in our sample.
familiessample <- families[sample(bigN, size = 500, replace = FALSE),]

littleN <- nrow(familiessample) #Sample Size

familiessamplei <- familiessample$TYPE #Sample for part i)
samplemeani <- mean(familiessamplei == 3) #Proportion of Female-head families only
samplesdi <- sqrt(samplemeani*(1 - samplemeani)*(1 - littleN/bigN)/(littleN - 1)) #Estimated Standard Error
sampleconfidenceinti <- samplemeani + c(-1.96*samplesdi, 1.96*samplesdi) #95% Confidence Interval

familiessampleii <- familiessample$CHILDREN #Sample for part ii)
samplemeanii <- mean(familiessampleii) #Mean children per family
samplesdii <- sqrt(var(familiessampleii)*(1 - littleN/bigN)/littleN) 
sampleconfidenceintii <- samplemeanii + c(-1.96*samplesdii, 1.96*samplesdii)

familiessampleiii <- familiessample$EDUCATION #Sample for part iii)
samplemeaniii <- mean(familiessampleiii <= 38) #Proportion of non-HS diploma head of households
samplesdiii <- sqrt(samplemeaniii*(1 - samplemeaniii)*(1 - littleN/bigN)/(littleN - 1))
sampleconfidenceintiii <- samplemeaniii + c(-1.96*samplesdiii, 1.96*samplesdiii)

familiessampleiv <- familiessample$INCOME #Sample for part iv)
samplemeaniv <- mean(familiessampleiv) #Mean of family income 
samplesdiv <- sqrt(var(familiessampleiv)*(1 - littleN/bigN)/littleN) 
sampleconfidenceintiv <- samplemeaniv + c(-1.96*samplesdiv, 1.96*samplesdiv)
# LOGISTIC PRODUCTION FXN
schaefer <- function(B,C,K,r) {
  #function schaefer takes the current biomass, a catch,
  #and the model parameters to compute next year's biomass
  res <- B + B * r * (1 - B/K) - C
  return(max(0.001,res)) # we add a constraint to prevent negative biomass
}


# BIOMASS PRODUCTION FXN
dynamics <- function(pars,C,yrs) {
  # dynamics takes the model parameters, the time series of catch,
  # & the yrs to do the projection over
  # first extract the parameters from the pars vector (we estimate K in log-space)
  K <- exp(pars[1])
  r <- exp(pars[2])
  # find the total number of years
  nyr <- length(C) + 1
  # if the vector of years was not supplied we create
  # a default to stop the program crashing
  if (missing(yrs)) yrs <- 1:nyr
  #set up the biomass vector
  B <- numeric(nyr)
  #intialize biomass at carrying capacity
  B[1] <- K
  # project the model forward using the schaefer model
  for (y in 2:nyr) {
    B[y] <- schaefer(B[y-1],C[y-1],K,r)
  }
  #return the time series of biomass
  return(B[yrs])
  #end function dynamics
}

# function to calculate the negative log-likelihood
nll <- function(pars,C,U) { #this function takes the parameters, the catches, and the index data
  sigma <- exp(pars[3]) # additional parameter, the standard deviation of the observation error
  B <- dynamics(pars,C) #run the biomass dynamics for this set of parameters
  Uhat <- B #calculate the predicted biomass index - here we assume an unbiased absolute biomass estimate
  output <- -sum(dnorm(log(U),log(Uhat),sigma,log=TRUE),na.rm=TRUE) #calculate the negative log-likelihood
  return(output)
  #end function nll
}

# FXN TO PERFORM ASSESSMENT AND ESTIMATE PARAMS
assess <- function(catch,index,calc.vcov=FALSE,pars.init) {
  # assess takes catch and index data, initial values for the parameters,
  # and a flag saying whether to compute uncertainty estimates for the model parameters
  #fit model
  # optim runs the function nll() repeatedly with differnt values for the parameters,
  # to find the values that give the best fit to the index data
  res <- optim(pars.init,nll,C=catch,U=index,hessian=TRUE)
  # store the output from the model fit
  output <- list()
  output$pars <- res$par
  output$biomass <- dynamics(res$par,catch)
  output$convergence <- res$convergence
  output$nll <- res$value
  if (calc.vcov)
    output$vcov <- solve(res$hessian)
  return(output)
  #end function assess
}

# NOW RUN ASSESSMENT
ini.parms <- c(log(1200), log(0.1), log(0.3)) # Initial param vector for log(K), log(r), log(sigma)

# FIT TO DATA
redfish <- assess(harvest,index,calc.vcov=TRUE,ini.parms)
redfish


# EXTRACT MAX LIKELIHOOD AND PARAM ESTIMATES
biomass.mle <- redfish$biomass
# print(biomass.mle)
pars.mle <- redfish$pars
# print(exp(pars.mle))


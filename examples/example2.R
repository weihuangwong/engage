## Simple script
## Originally written by Engaging admin [greg]

## =============================================================================
## Require
library(Rmpi) 
library(snow) 

## =============================================================================
## Initialize
# Initialize SNOW using MPI communication. The first line will get the 
# number of MPI processes the scheduler assigned to us. Everything else 
# is standard SNOW 

np <- mpi.universe.size() 
cluster <- makeMPIcluster(8)            # assumes we requested 2x5 cores
                                        # and because of MPI idiosyncracy,
                                        # are using only 2x(5-1) cores

print(np)

## =============================================================================
## Main
# Print the hostname for each cluster member 
sayhello <- function()  {
    info <- Sys.info()[c("nodename", "machine")]
    paste("Hello from", info[1], "with CPU type", info[2])
} 

names <- clusterCall(cluster, sayhello) 
print(unlist(names)) 

# Run regressions in parallel 
# and display results

## Create data
D <- lapply(1:10, function(...) {
    D <- as.data.frame(matrix(rnorm(1e7), ncol=10))
    names(D) <- LETTERS[1:10]
    return(D)
})

## Function to run
regress <- function(x) {
    formula <- as.formula(paste("A ~ ", paste(LETTERS[2:10], collapse=" + "), sep=""))
    coefs <- lm(formula, data=x)$coefficients
    return(coefs)
}

results <- parLapply(cluster, D, regress)
print(do.call(cbind, results))

stopCluster(cluster) 
mpi.exit() 

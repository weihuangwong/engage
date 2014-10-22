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

## =============================================================================
## Main
# Print the hostname for each cluster member 
sayhello <- function()  {
    info <- Sys.info()[c("nodename", "machine")]
    paste("Hello from", info[1], "with CPU type", info[2])
} 

names <- clusterCall(cluster, sayhello) 
print(unlist(names)) 

# Compute row sums in parallel using all processes, 
# then a grand sum at the end on the master process 
parallelSum <- function(m, n) 
{ 
A <- matrix(rnorm(m*n), nrow = m, ncol = n) 
row.sums <- parApply(cluster, A, 1, sum) 
print(sum(row.sums)) 
} 

parallelSum(500, 500) 

stopCluster(cluster) 
mpi.exit() 

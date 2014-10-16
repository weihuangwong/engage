## A script to test out parallelisation
## on the engage cluster

## Libraries
require(foreach)
require(doMPI)
require(Rmpi)
require(iterators)

## Initialise MPI backend
cl <- startMPIcluster()
registerDoMPI(cl)

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

## Run
system.time(coefs <- foreach(a=iter(D), .combine='cbind') %dopar% regress(a))
save(coefs, file="test_parallel.RData")

## Cleanup
closeCluster(cl)
mpi.quit()

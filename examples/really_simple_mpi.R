## A script to test out parallelisation
## on the engage cluster

## Libraries
require(doMPI)
require(foreach)

## Initialise MPI backend
cl <- startMPIcluster()
registerDoMPI(cl)

## Run
numbers <- foreach(i=1:10, .combine='c') %dopar% return(i)
print(numbers)

## Cleanup
closeCluster(cl)
mpi.quit()

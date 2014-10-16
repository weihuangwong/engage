## A script to test out parallelisation
## on the engage cluster

## Libraries
require(doMPI)
require(foreach)

## Initialise MPI backend
cl <- startMPIcluster()
registerDoMPI(cl)

## Run
foreach(i=1:10, .combine='c') %dopar% print(i)

## Cleanup
closeCluster(cl)
mpi.quit()

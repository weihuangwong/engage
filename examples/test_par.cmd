#!/usr/bin/env bash 
#SBATCH --nodes=2 
#SBATCH --ntasks-per-node=5 
#SBATCH -t 10:00 
#SBATCH -J test_parallel 
#SBATCH -o ./logs/log.%j 
#SBATCH --mail-type=ALL

echo '==========' 
cd ${SLURM_SUBMIT_DIR} 
echo ${SLURM_SUBMIT_DIR} 
echo Running on host $(hostname) 
echo Time is $(date) 
echo SLURM_NODES are $(echo ${SLURM_NODELIST}) 
echo '==========' 
echo -e '\n\n' 

mpirun -n 1 R CMD BATCH --no-save --no-restore example2.R

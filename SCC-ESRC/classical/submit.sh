#!/bin/bash
#$ -e errout
#$ -o errout
#$ -m n
#$ -M nenahuak@gmail.com
#$ -t 1-900

# load R
module load R

# run script
Rscript batch.R --args $SGE_TASK_ID


#!/bin/bash
#SBATCH --job-name=promis
#SBATCH --time=60:00
#SBATCH --mail-type=NONE
#SBATCH --mem=4g
#SBATCH --cpus-per-task=1
#SBATCH --account=precisionhealth_owned2
#SBATCH --partition=precisionhealth
#SBATCH --array=1-489

module load R/4.0.2
R CMD BATCH --no-save --no-restore /home/soumikp/bios629/code/03_11_2021_forSlurm_basal.R arrayscript_$SLURM_ARRAY_TASK_ID.Rout

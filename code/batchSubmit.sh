#!/bin/bash
#SBATCH --job-name=hello_world
#SBATCH --time=60:00
#SBATCH --mail-type=NONE
#SBATCH --mem=2g
#SBATCH --cpus-per-task=1
#SBATCH --account=precisionhealth_owned2
#SBATCH --partition=precisionhealth
#SBATCH --output=/home/soumikp/bios629_output/
#SBATCH --array=1-489

module load R/4.0.2
R CMD BATCH --no-save --no-restore /home/soumikp/bios629/code/03_11_2021_forSlurm.R arrayscript_$SLURM_ARRAY_TASK_ID.Rout

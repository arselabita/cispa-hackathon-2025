#!/bin/bash
#SBATCH --account=training2557
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=128 # JURECA has 128 physical CPU cores
#SBATCH --partition=dc-gpu-devel
#SBATCH --output=output/%j.out
#SBATCH --reservation=cispahack

# set -e  # exit on errors
# #export MASTER_ADDR=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
# #export MASTER_ADDR="$MASTER_ADDR"i
# # Go to the project folder
# cd "$HOME/Desktop/cispa-hackathon"

# # Activate virtual environment
# source .venv/bin/activate

# # Run your Python script directly
# python main.py

# echo "done!"




#### for the sample submission file
set -e

cd "$HOME/Desktop/cispa-hackathon"
source .venv/bin/activate

# Simulate Slurm job ID
JOB_ID=14244901
OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

# Redirect stdout & stderr to the fake Slurm output file
python sample_submission.py > "$OUTPUT_DIR/$JOB_ID.out" 2>&1

echo "done! Job $JOB_ID logged in $OUTPUT_DIR/$JOB_ID.out"
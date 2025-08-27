#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --job-name=job
#SBATCH --error=/vast/bl3021/job_error.log
#SBATCH --output=/vast/bl3021/job_output.log
#SBATCH --gres=gpu:0
#SBATCH --cpus-per-task=4

ENTRYPOINT_FILE=$(mktemp) 
curl -fsSL https://raw.githubusercontent.com/lyob/singit/da4afe79894363e34af8bf2fcdc51b14400642a6/entrypoint.sh -o $ENTRYPOINT_FILE

# Open entrypoint on FD 3 and unlink it
exec 3<"$ENTRYPOINT_FILE"
rm "$ENTRYPOINT_FILE"

singularity exec --nv --containall --no-home --cleanenv \
--overlay /scratch/bl3021/disk.ext3:rw \
--bind /home/bl3021/.ssh,$SLURM_TMPDIR:/tmp \
/scratch/bl3021/test-singbuild.sif bash <&3

exec 3<&-

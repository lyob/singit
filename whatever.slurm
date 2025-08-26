#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=06:00:00
#SBATCH --job-name=job
#SBATCH --error=/vast/bl3021/job_error.log
#SBATCH --output=/vast/bl3021/job_output.log
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4

curl -fsSL https://raw.githubusercontent.com/lyob/singit/da4afe79894363e34af8bf2fcdc51b14400642a6/entrypoint.sh -o $SLURM_TMPDIR/ssh_server.sh

singularity exec --nv --containall --no-home --cleanenv \
--overlay /scratch/bl3021/disk.ext3:rw \
--bind /home/bl3021/.ssh,$SLURM_TMPDIR:/tmp \
docker://lyob/devenv:latest bash $SLURM_TMPDIR/ssh_server.sh

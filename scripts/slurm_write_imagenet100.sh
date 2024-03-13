#!/bin/bash
#SBATCH --account=vulcan-djacobs
#SBATCH --job-name=write-ffcv-imagenet100
#SBATCH --time=1-12:00:00
#SBATCH --partition=vulcan-dpart
#SBATCH --qos=vulcan-medium
#SBATCH --ntasks=1
#SBATCH --gres=gpu:gtx1080ti:1
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm-%j-%x.out
#--SBATCH --mail-type=end          
#--SBATCH --mail-type=fail         
#--SBATCH --mail-user=psando@umd.edu
#--SBATCH --array=0-0
#--SBATCH --dependency=afterok:
#--SBATCH --mem-per-cpu=4G

export IMAGENET_DIR=/fs/vulcan-datasets/imagenet
export WRITE_DIR=/vulcanscratch/psando/imagenet100-ffcv

# Note: To write ImageNet100, you also have to modify write_imagenet.sh and pass --cfg.dataset=imagenet100

module add gcc/11.2.0
# Serialize images with:
# - 500px side length maximum
# - 50% JPEG encoded
# - quality=90 JPEGs
./write_imagenet.sh 500 0.50 90
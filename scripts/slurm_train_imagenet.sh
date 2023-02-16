#!/bin/bash
#SBATCH --account=djacobs
#SBATCH --job-name=rn18_88_epochs-rtxa6000
#SBATCH --time=1-12:00:00
#SBATCH --partition=dpart
#SBATCH --qos=high
#SBATCH --ntasks=1
#SBATCH --gres=gpu:rtxa6000:1
#SBATCH --cpus-per-task=12
#SBATCH --output=slurm-%j-%x.out
#SBATCH --mail-type=end          
#SBATCH --mail-type=fail         
#SBATCH --mail-user=psando@umd.edu
#--SBATCH --array=0-0
#--SBATCH --dependency=afterok:
#--SBATCH --mem-per-cpu=4G

set -x

export CUDA_VISIBLE_DEVICES=0

# Set the visible GPUs according to the `world_size` configuration parameter
# Modify `data.in_memory` and `data.num_workers` based on your machine
export LOGGING_FOLDER=/fs/vulcan-projects/stereo-detection/imagenet-ffcv-logs
python train_imagenet.py --config-file rn18_configs/rn18_88_epochs.yaml \
    --data.train_dataset=/fs/vulcan-projects/stereo-detection/imagenet-ffcv/train_500_0.50_90.ffcv \
    --data.val_dataset=/fs/vulcan-projects/stereo-detection/imagenet-ffcv/val_500_0.50_90.ffcv \
    --data.num_workers=12 --data.in_memory=1 \
    --logging.folder=$LOGGING_FOLDER \
    --logging.subfolder_id=$SLURM_JOB_ID \

# Evaluate on ImageNet-C
export IMAGENET_DIR='/vulcanscratch/psando/val'
export IMAGENET_C_DIR='/fs/vulcan-projects/stereo-detection/imagenet-c/'
export MODEL_DIR='/vulcanscratch/psando/TorchHub'
cd /cfarhomes/psando/Documents/imagenet-c-p/;
python ImageNet-C/test.py --ngpu 1\
                          --model-name 'resnet18'\
                          --ckpt-path ${LOGGING_FOLDER}/${SLURM_JOB_ID}/final_weights.pt
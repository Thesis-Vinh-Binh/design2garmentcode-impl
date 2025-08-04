#! /bin/bash

source /opt/miniforge3/etc/profile.d/conda.sh
conda activate d2g

export PYTHONPATH=/workspace/design2garmentcode-impl

python lmm_utils/test_picture_batch.py \
  --input /workspace/CloSe/data/close_image_scan \
  --output logs/d2g_close

python lmm_utils/inference.py \
  --input /workspace/CloSe/data/close_image_scan \
  --output logs/d2g_close_caption

cd /workspace/design2garmentcode-impl/logs/
zip -r d2g_close.zip d2g_close
zip -r d2g_close_caption.zip d2g_close_caption

rclone copy d2g_close.zip remote:thesis-data-here/
rclone copy d2g_close_caption.zip remote:thesis-data-here/
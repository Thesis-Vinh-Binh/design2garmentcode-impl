#!/bin/bash
# #SBATCH --job-name=setup_CG
# #SBATCH --nodes=1
# #SBATCH --ntasks=1
# #SBATCH --cpus-per-task=4               # more threads may assist loading
# #SBATCH --mem=32G                       # host RAM for data processing
# #SBATCH --gres=gpu:1
# #SBATCH --time=48:00:00
# #SBATCH --output=logs/setup_%j.out  # %j is the job ID
# #SBATCH --error=logs/setup_%j.out   # (optional) separate stderr

# module purge
# module load anaconda3/2023.9
conda init
source ~/.bashrc


conda env create -f environment.yml
source /opt/miniforge3/etc/profile.d/conda.sh
conda activate d2g
echo "Current conda env: $CONDA_DEFAULT_ENV"
if [ "$CONDA_DEFAULT_ENV" != "/venv/d2g" ]; then
    echo "Current conda env is not /venv/d2g, please activate it"
    exit 1
fi

sudo apt-get install git-lfs -y

git lfs install
git clone https://huggingface.co/Qwen/Qwen2-VL-2B-Instruct /workspace/design2garmentcode-impl/lmm_utils/Qwen/Qwen2-VL-2B-Instruct

pip install gdown python-dotenv
mkdir -p lmm_utils/Qwen/qwen2vl_lora_mlp
gdown --id 1CL7OLUq6fYcwoDuLRkBxtKNxJ0_G73U- -O /workspace/design2garmentcode-impl/lmm_utils/Qwen/qwen2vl_lora_mlp/model.pth

pip uninstall openai -y
pip install --upgrade openai

chmod +x /workspace/design2garmentcode-impl/scripts/run.sh
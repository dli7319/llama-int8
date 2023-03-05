#!/bin/bash

TARGET_DIR=$(pwd)/../weights
MODEL="13B"

# Build the docker image
DOCKER_IMAGE=$(docker build -q .)

# If argument is passed, run them in the container
if [ $# -eq 1 ]; then
    docker run -it --rm --gpus all -v "$TARGET_DIR:/weights" "$DOCKER_IMAGE" "$@"
    exit 0
else
    # Run the example
    docker run -it --rm --gpus all -v "$TARGET_DIR:/weights" "$DOCKER_IMAGE" \
        python example.py \
        --ckpt_dir /weights/$MODEL \
        --tokenizer_path /weights/tokenizer.model --max_batch_size=1
fi

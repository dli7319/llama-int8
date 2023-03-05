FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/conda/lib/
RUN ln -s /opt/conda/lib /opt/conda/lib64
RUN apt update && apt install -y git build-essential && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Need to install bitsandbytes from source
RUN pip uninstall -y bitsandbytes
RUN git clone https://github.com/TimDettmers/bitsandbytes && \
    cd bitsandbytes && \
    CUDA_VERSION=116 make cuda11x && \
    python setup.py install

# Copy the rest of the code
COPY . .
RUN pip install -e .

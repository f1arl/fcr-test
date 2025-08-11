# Use CUDA 12.0 with cuDNN 8 and Ubuntu 18.04 as the base image
FROM nvidia/cuda:12.0.0-cudnn8-runtime-ubuntu20.04

# Set non-interactive mode to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive


ENV DockerHOME=/home/app/webapp
RUN mkdir -p $DockerHOME
WORKDIR $DockerHOME

# Install system dependencies
# Install all system dependencies in a single RUN command
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libbz2-dev \
    liblzma-dev \
    libffi-dev \
    libsqlite3-dev \
    wget \
    curl \
    cmake \
    libmysqlclient-dev \
    redis-server \
    libyaml-dev \
    python3-dev \
    cython3 \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*


# First install GCC-10 and G++-10
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y gcc-10 g++-10


# Set non-interactive mode to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install tzdata without interactive prompt
RUN apt-get update && \
    apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Reset DEBIAN_FRONTEND to avoid issues in later steps
ENV DEBIAN_FRONTEND=


# Then set them as alternatives
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

# Download and build Python 3.10 from source
RUN wget https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz && \
    tar -xzf Python-3.10.13.tgz && \
    cd Python-3.10.13 && \
    ./configure --enable-optimizations && \
    make -j $(nproc) && \
    make altinstall && \
    cd .. && \
    rm -rf Python-3.10.13 Python-3.10.13.tgz

# Create symbolic links and ensure pip is available
RUN ln -s /usr/local/bin/python3.10 /usr/local/bin/python3 && \
    ln -s /usr/local/bin/python3.10 /usr/local/bin/python && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# Verify Python and pip versions
RUN python --version && pip --version

# Copy and install requirements

# Upgrade pip to compatible version first
RUN python3 -m pip install --upgrade "pip<24.1"

RUN pip install simsimd>=5.9.2



# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


COPY . .

RUN python3 copy_models.py

EXPOSE 9000


ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:9000"]

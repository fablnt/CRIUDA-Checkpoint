# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update package list and install dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
echo "Etc/UTC" > /etc/timezone && \ 
apt-get update && apt-get install -y \
git \
build-essential \
asciidoc \
xmlto \
libprotobuf-dev \
libprotobuf-c-dev \
protobuf-c-compiler \
protobuf-compiler \
python3 \
python3-pip \
python3-protobuf \
pkg-config \
uuid-dev \
libbsd-dev \
iproute2 \
libnftables-dev \
libcap-dev \
libnet-dev \
libnl-3-dev \
libaio-dev \
libgnutls28-dev \
libdrm-dev \
&& rm -rf /var/lib/apt/lists/*

# Install CRIU from source (version 4.0)
RUN git clone https://github.com/checkpoint-restore/criu.git /criu && \
    cd /criu && \
    git checkout v4.0 && \
    make && \
    make install

# Verify CRIU installation
RUN criu --version

# Set a simple entrypoint (optional, for testing)
CMD ["/bin/bash"]
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Dockerfile
RUN apt update && apt upgrade -y && apt install -y \
    git build-essential curl gcc g++ python3 python3-pip python3-dev \
    autoconf automake autotools-dev libtool texinfo patchutils \
    libmpc-dev libmpfr-dev libgmp-dev zlib1g-dev libexpat-dev bc \
    ninja-build flex bison cmake libglib2.0-dev libpixman-1-dev \
    libslirp-dev pkg-config libcapstone-dev python3-venv \
    libncurses5-dev libgtk-3-dev python3-sphinx \
    python3-sphinx-rtd-theme \
    gcc-riscv64-unknown-elf

# Ensure tomli is available globally for QEMU configure step
RUN pip3 install --no-cache-dir tomli

#  Build riscv32-softmmu for system emulation of bare-metal code ===
RUN git clone https://gitlab.com/qemu-project/qemu.git /qemu
WORKDIR /qemu/build
RUN ../configure --target-list=riscv32-softmmu --enable-plugins && \
    make -j$(nproc) && \
    make install
ENV QEMU_PLUGINS=/qemu/build/contrib/plugins

# Install SimPoint
WORKDIR /
RUN git clone https://github.com/hanhwi/SimPoint.git
WORKDIR /SimPoint
RUN make -j$(nproc)
ENV PATH="/SimPoint/bin:$PATH"



# Clone and build Embench
WORKDIR /
RUN git clone --recursive https://github.com/embench/embench-iot.git
WORKDIR /embench-iot
# The Makefile will automatically find 'riscv32-unknown-elf-gcc' in the PATH
RUN make PORT=baremetal TARGET=rv32

# Collect all .elf files
RUN find work -name "*.elf" > /embench_binaries.txt

# Output directory for use outside the container
RUN mkdir -p /output

# Final working directory
WORKDIR /
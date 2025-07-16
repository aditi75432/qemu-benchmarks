FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update package lists
RUN apt update && apt upgrade -y

# Install all dependencies for QEMU compilation and Embench
RUN apt install -y \
  git-email \
  libaio-dev \
  libbluetooth-dev \
  libcapstone-dev \
  libbrlapi-dev \
  libbz2-dev \
  libcap-ng-dev \
  libcurl4-gnutls-dev \
  libgtk-3-dev \
  libibverbs-dev \
  libjpeg8-dev \
  libncurses5-dev \
  libnuma-dev \
  librbd-dev \
  librdmacm-dev \
  libsasl2-dev \
  libsdl2-dev \
  libseccomp-dev \
  libsnappy-dev \
  libssh-dev \
  libvde-dev \
  libvdeplug-dev \
  libvte-2.91-dev \
  libxen-dev \
  liblzo2-dev \
  valgrind \
  xfslibs-dev \
  libnfs-dev \
  libiscsi-dev \
  gcc \
  binutils \
  python3-pip \
  python3-sphinx \
  python3-sphinx-rtd-theme \
  ninja-build \
  flex \
  bison \
  git \
  python3-tomli \
  autoconf \
  automake \
  autotools-dev \
  curl \
  python3 \
  libmpc-dev \
  libmpfr-dev \
  libgmp-dev \
  gawk \
  build-essential \
  texinfo \
  gperf \
  libtool \
  patchutils \
  bc \
  zlib1g-dev \
  libexpat-dev \
  cmake \
  libglib2.0-dev \
  gcc-riscv64-linux-gnu \
  libslirp-dev \
  pkg-config \
  libpixman-1-dev \
  python3-dev \
  python3-venv

# Clone repositories
RUN git clone https://gitlab.com/qemu-project/qemu.git
RUN git clone https://github.com/embench/embench-iot.git
RUN git clone https://github.com/hanhwi/SimPoint.git

# Build QEMU with RISC-V support and BBV plugin
WORKDIR /qemu/build
RUN ../configure --target-list=riscv32-linux-user,riscv64-linux-user,riscv32-softmmu,riscv64-softmmu --enable-plugins
RUN make -j$(nproc)
RUN make install

# Set environment variable for QEMU plugins
ENV QEMU_PLUGINS=/qemu/build/contrib/plugins

# Build SimPoint
WORKDIR /SimPoint/
RUN make -j$(nproc)
ENV PATH="$PATH:/SimPoint/bin"

# Setup Embench
WORKDIR /embench-iot
RUN python3 -m venv venv
RUN /bin/bash -c "source venv/bin/activate && \
    if [ -f requirements.txt ]; then \
        pip install -r requirements.txt; \
    else \
        echo 'No requirements.txt found - embench-iot uses standard Python libraries'; \
    fi"

# Build Embench for RISC-V
RUN /bin/bash -c "source venv/bin/activate && python3 build_all.py --arch riscv32 --chip generic --board ri5cyverilator --cc riscv64-linux-gnu-gcc --cflags='-march=rv32i -mabi=ilp32 -static' --ldflags='-static'"

# Create output directory
RUN mkdir -p /output

# Create wrapper scripts for embench binaries
RUN find bd -name "*.elf" -type f > /embench_binaries.txt

WORKDIR /
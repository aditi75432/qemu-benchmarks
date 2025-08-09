FROM ribeirovsilva/riscv-toolchain:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Update and install additional dependencies needed for QEMU and Embench
RUN apt-get update && apt-get install -y \
    git build-essential curl python3 python3-pip python3-dev \
    ninja-build flex bison cmake libglib2.0-dev libpixman-1-dev \
    libslirp-dev pkg-config libcapstone-dev python3-venv \
    libncurses5-dev libgtk-3-dev python3-sphinx \
    python3-sphinx-rtd-theme libaio-dev libbluetooth-dev \
    libbrlapi-dev libbz2-dev libcap-ng-dev libcurl4-gnutls-dev \
    libibverbs-dev libjpeg8-dev libnuma-dev librbd-dev \
    librdmacm-dev libsasl2-dev libsdl2-dev libseccomp-dev \
    libsnappy-dev libssh-dev libvde-dev libvdeplug-dev \
    libvte-2.91-dev libxen-dev liblzo2-dev valgrind \
    xfslibs-dev libnfs-dev libiscsi-dev device-tree-compiler \
    libboost-regex-dev libboost-system-dev binutils zstd \
    libzstd-dev autoconf automake autotools-dev texinfo \
    gperf libtool patchutils bc zlib1g-dev libexpat-dev \
    && rm -rf /var/lib/apt/lists/*

# Ensure tomli is available for QEMU configure
RUN pip3 install --no-cache-dir tomli

# Clone and build QEMU with plugin support
RUN git clone https://gitlab.com/qemu-project/qemu.git /qemu
WORKDIR /qemu/build
RUN ../configure \
    --target-list=riscv32-linux-user,riscv64-linux-user,riscv32-softmmu,riscv64-softmmu \
    --enable-plugins \
    && make -j$(nproc) \
    && make install
ENV QEMU_PLUGINS=/qemu/build/contrib/plugins

# Install SimPoint
WORKDIR /
RUN git clone https://github.com/hanhwi/SimPoint.git
WORKDIR /SimPoint
RUN make -j$(nproc)
ENV PATH="/SimPoint/bin:$PATH"

# Clone Embench and apply necessary fixes
WORKDIR /
RUN git clone --recursive https://github.com/embench/embench-iot.git
WORKDIR /embench-iot

# Fix the bool typedef issue in wikisort
RUN sed -i '36s/^typedef uint8_t bool;/\/\/ &/' /embench-iot/src/wikisort/libwikisort.c

# Build Embench for RISC-V 32-bit using the working configuration
RUN python3 ./build_all.py --arch riscv32 --chip generic --board ri5cyverilator \
    --cc riscv32-unknown-elf-gcc \
    --cflags="-c -O2 -ffunction-sections -march=rv32imfdc -mabi=ilp32d" \
    --ldflags="-Wl,-gc-sections" \
    --user-libs="-lm"

# Create a list of built binaries for easy access
RUN find bd -name "*.elf" > /embench_binaries.txt && \
    find bd -name "*" -executable -type f ! -name "*.elf" > /embench_executables.txt

# Create output directory
RUN mkdir -p /output

# Copy helper scripts
COPY scripts/boot.S /boot/boot.S
COPY scripts/linker.ld /boot/linker.ld
COPY scripts/run_benchmark.sh /run_benchmark.sh
COPY scripts/run_all_benchmarks.sh /run_all_benchmarks.sh

# Create boot directory and compile boot stub
RUN mkdir -p /boot && \
    riscv32-unknown-elf-gcc -march=rv32imfdc -mabi=ilp32d -nostdlib \
    -T/boot/linker.ld -o /boot/boot.elf /boot/boot.S

# Make scripts executable
RUN chmod +x /run_benchmark.sh /run_all_benchmarks.sh

# Final working directory
WORKDIR /

# Default command
CMD ["/run_all_benchmarks.sh"]
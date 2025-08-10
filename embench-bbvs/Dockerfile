# FINAL, SIMPLE Dockerfile for Embench with Built-in Tracing
FROM ribeirovsilva/riscv-toolchain:latest

# Install standard QEMU user-mode emulation and other tools
RUN apt-get update && apt-get install -y \
    qemu-user \
    python3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Clone Embench repository
RUN git clone --recursive https://github.com/embench/embench-iot.git

# Fix the wikisort bool typedef issue
RUN sed -i '36s/^typedef uint8_t bool;/\/\/ &/' /workspace/embench-iot/src/wikisort/libwikisort.c

# Set working directory to embench-iot
WORKDIR /workspace/embench-iot

# Build all Embench workloads
RUN python3 ./build_all.py \
    --arch riscv32 \
    --chip generic \
    --board ri5cyverilator \
    --cc riscv64-unknown-elf-gcc \
    --cflags="-c -O2 -ffunction-sections -march=rv32imfdc -mabi=ilp32d" \
    --ldflags="-Wl,-gc-sections -march=rv32imfdc -mabi=ilp32d" \
    --user-libs="-lm"

# Copy our custom scripts into the container
COPY scripts/ /workspace/scripts/
RUN chmod +x /workspace/scripts/*.sh

# Set final working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
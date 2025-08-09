#!/bin/bash
set -e

BENCHMARK="$1"
INTERVAL="${2:-100000}"
OUTPUT_DIR="${3:-/output}"

if [ -z "$BENCHMARK" ]; then
    echo "Usage: $0 <benchmark_path> [interval] [output_dir]"
    exit 1
fi

BENCHMARK_NAME=$(basename "$BENCHMARK" .elf)
echo "Running benchmark: $BENCHMARK_NAME"

# For user-mode emulation (if the binary is linked for Linux)
if file "$BENCHMARK" | grep -q "dynamically linked\|interpreter"; then
    echo "Running in user-mode emulation..."
    qemu-riscv32 -plugin $QEMU_PLUGINS/libbbv.so,interval=$INTERVAL,outfile=$OUTPUT_DIR/${BENCHMARK_NAME}_bbv "$BENCHMARK"
else
    echo "Running in system-mode emulation (bare-metal)..."
    # Try system mode with minimal machine
    timeout 30s qemu-system-riscv32 -M virt -nographic -bios none -no-reboot \
        -kernel "$BENCHMARK" \
        -plugin $QEMU_PLUGINS/libbbv.so,interval=$INTERVAL,outfile=$OUTPUT_DIR/${BENCHMARK_NAME}_bbv \
        || echo "Benchmark completed or timed out"
fi

# Check if BBV was generated
if [ -f "$OUTPUT_DIR/${BENCHMARK_NAME}_bbv.0.bb" ]; then
    echo "BBV generated successfully for $BENCHMARK_NAME"
    # Show first few lines of the BBV
    echo "BBV sample (first 5 lines):"
    head -5 "$OUTPUT_DIR/${BENCHMARK_NAME}_bbv.0.bb"
else
    echo "Warning: No BBV file generated for $BENCHMARK_NAME"
fi
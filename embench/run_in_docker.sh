#!/bin/bash
set -e

IMAGE_NAME="qemu-simpoint-embench"
OUTPUT_DIR="$(pwd)/simpoint_output"
INTERVAL=100
MAX_K=30

mkdir -p "$OUTPUT_DIR"

echo "=========================================="
echo "Running Embench BBV generation and SimPoint analysis"
echo "=========================================="

docker run --rm -v "$OUTPUT_DIR":/output "$IMAGE_NAME" bash -c "
  echo 'Starting Embench execution with BBV generation...'

  while IFS= read -r binary; do
    benchmark_name=\$(basename \"\$binary\" .elf)
    echo \"Processing benchmark: \$benchmark_name\"

    # === CHANGED: Use qemu-system-riscv32 for bare-metal emulation ===
    qemu-system-riscv32 -M virt -nographic -bios none -no-reboot \
      -kernel \"/embench-iot/\$binary\" \
      -plugin \$QEMU_PLUGINS/libbbv.so,interval=$INTERVAL,outfile=/output/\${benchmark_name}_bbv

    if [ -f \"/output/\${benchmark_name}_bbv.0.bb\" ]; then
      simpoint \
        -loadFVFile /output/\${benchmark_name}_bbv.0.bb \
        -maxK $MAX_K \
        -saveSimpoints /output/\${benchmark_name}.simpoints \
        -saveSimpointWeights /output/\${benchmark_name}.weights
    fi

    echo \"Completed: \$benchmark_name\"
  done < /embench_binaries.txt

  echo 'All Embench benchmarks processed!'
  ls -la /output/
"

echo "=========================================="
echo "Embench experiment completed successfully!"
echo "Results saved to $OUTPUT_DIR"
echo "=========================================="
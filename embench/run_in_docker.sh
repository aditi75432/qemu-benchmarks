#!/bin/bash
set -e

# Configuration
IMAGE_NAME="qemu-simpoint-embench"
OUTPUT_DIR="$(pwd)/simpoint_output"
INTERVAL=100
MAX_K=30

echo "=========================================="
echo "Running Embench BBV generation and SimPoint analysis"
echo "=========================================="
echo "Image: $IMAGE_NAME"
echo "Output directory: $OUTPUT_DIR"
echo "BBV interval: $INTERVAL"
echo "Max K clusters: $MAX_K"
echo "=========================================="

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Run the experiment inside the container
docker run --rm \
  -v "$OUTPUT_DIR":/output \
  "$IMAGE_NAME" \
  bash -c "
    echo 'Starting Embench execution with BBV generation...'
    
    # Process each benchmark
    while IFS= read -r binary; do
      benchmark_name=\$(basename \"\$binary\" .elf)
      echo \"Processing benchmark: \$benchmark_name\"
      
      # Run with BBV generation
      qemu-riscv32 -plugin \$QEMU_PLUGINS/libbbv.so,interval=$INTERVAL,outfile=/output/\${benchmark_name}_bbv \"/embench-iot/\$binary\"
      
      # Run SimPoint analysis if BBV file was generated
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
    echo 'Results saved to /output directory'
    ls -la /output/
  "

echo "=========================================="
echo "Embench experiment completed successfully!"
echo "Results are available in: $OUTPUT_DIR"
echo "=========================================="
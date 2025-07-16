#!/bin/bash
set -e

# Configuration
IMAGE_NAME="qemu-simpoint-dhrystone"
OUTPUT_DIR="$(pwd)/simpoint_output"
INTERVAL=100
MAX_K=30

echo "=========================================="
echo "Running BBV generation and SimPoint analysis"
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
    echo 'Starting Dhrystone execution with BBV generation...'
    qemu-riscv64 -plugin \$QEMU_PLUGINS/libbbv.so,interval=$INTERVAL,outfile=/output/dhrystone_bbv \$DHRYSTONE
    
    echo 'BBV generation completed. Starting SimPoint analysis...'
    simpoint \
      -loadFVFile /output/dhrystone_bbv.0.bb \
      -maxK $MAX_K \
      -saveSimpoints /output/dhrystone.simpoints \
      -saveSimpointWeights /output/dhrystone.weights
    
    echo 'SimPoint analysis completed!'
    echo 'Results saved to /output directory'
    ls -la /output/
  "

echo "=========================================="
echo "Experiment completed successfully!"
echo "Results are available in: $OUTPUT_DIR"
echo "=========================================="
#!/bin/bash
set -e

IMAGE_NAME="qemu-simpoint-embench"
OUTPUT_DIR="$(pwd)/simpoint_output"
INTERVAL="${1:-100000}"  # Default interval of 100,000
MAX_K="${2:-30}"         # Default max K of 30

mkdir -p "$OUTPUT_DIR"

echo "=========================================="
echo "Running Embench BBV generation and SimPoint analysis"
echo "Using interval: $INTERVAL, Max K: $MAX_K"
echo "Output directory: $OUTPUT_DIR"
echo "=========================================="

# Run the container with the analysis script
docker run --rm -v "$OUTPUT_DIR":/output "$IMAGE_NAME" /run_all_benchmarks.sh "$INTERVAL" "$MAX_K"

echo ""
echo "=========================================="
echo "Embench experiment completed!"
echo "Results saved to $OUTPUT_DIR"
echo ""
echo "Generated files:"
find "$OUTPUT_DIR" -type f -name "*.bb" -o -name "*.simpoints" -o -name "*.weights" | head -10
if [ $(find "$OUTPUT_DIR" -type f | wc -l) -gt 10 ]; then
    echo "... and more (showing first 10)"
fi
echo "=========================================="
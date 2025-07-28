#!/bin/bash
set -e

BUILD_SCRIPT="./build_docker.sh"
RUN_SCRIPT="./run_in_docker.sh"

echo "=========================================="
echo "QEMU SimPoint Embench Analysis"
echo "=========================================="

echo "[STEP 1] Building Docker image..."
bash "$BUILD_SCRIPT"

echo ""
echo "[STEP 2] Running BBV generation and SimPoint analysis..."
bash "$RUN_SCRIPT"

echo ""
echo "=========================================="
echo "Workflow completed!"
echo "Check the simpoint_output/ directory for results."
echo "=========================================="

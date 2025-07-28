#!/bin/bash
set -e

IMAGE_NAME="qemu-simpoint-embench"

echo "=========================================="
echo "Building Docker image: $IMAGE_NAME"
echo "=========================================="

docker build -t "$IMAGE_NAME" .

echo "=========================================="
echo "Docker image built successfully!"
echo "=========================================="

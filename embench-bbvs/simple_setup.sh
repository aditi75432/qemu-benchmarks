#!/bin/bash
# simple_setup.sh - Final simple setup for Embench

set -e

DOCKER_IMAGE_NAME="embench-simple"

build_image() {
    echo "Building simple Embench Docker image..."
    docker build -f Dockerfile -t "$DOCKER_IMAGE_NAME" .
    echo "Docker image built successfully."
}

run_trace() {
    local workload=${1}
    if [ -z "$workload" ]; then
        echo "Error: Please specify a workload for trace."
        exit 1
    fi
    echo "Tracing workload ($workload)..."
    docker run --rm "$DOCKER_IMAGE_NAME" \
        /workspace/scripts/run_embench_simple.sh "$workload" --trace
}

case "$1" in
    build)
        build_image
        ;;
    trace)
        run_trace "$2"
        ;;
    *)
        echo "Usage: $0 [build|trace] [workload_name]"
        echo "  build            - Builds the Docker container"
        echo "  trace [workload] - Traces a workload (e.g., trace crc32)"
        ;;
esac
#!/bin/bash
# simple_setup.sh - Simple setup for Embench compilation and execution

set -e

DOCKER_IMAGE_NAME="embench-simple"

usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  run         Run interactive Docker container"
    echo "  test        Test with a single workload (crc32)"
    echo "  demo        Run demonstration with multiple workloads"
    echo "  all         Run all workloads"
    echo "  clean       Clean up Docker images"
    echo "  help        Show this help message"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo "Error: Docker daemon is not running"
        exit 1
    fi
}

build_image() {
    echo "Building simple Embench Docker image..."
    
    # Check required files
    if [ ! -f "Dockerfile" ]; then
        echo "Error: Dockerfile not found"
        echo "Please create Dockerfile with the simple embench content"
        exit 1
    fi
    
    if [ ! -f "scripts/run_embench_simple.sh" ]; then
        echo "Error: scripts/run_embench_simple.sh not found"
        echo "Please create the script file"
        exit 1
    fi
    
    # Build with simple dockerfile
    docker build -f Dockerfile -t "$DOCKER_IMAGE_NAME" .
    
    echo "Docker image '$DOCKER_IMAGE_NAME' built successfully"
}

run_container() {
    echo "Starting interactive Embench container..."
    
    docker run -it --rm \
        --name embench-container \
        "$DOCKER_IMAGE_NAME" \
        /bin/bash
}

test_single() {
    echo "Testing single workload (crc32)..."
    
    docker run --rm "$DOCKER_IMAGE_NAME" \
        /workspace/scripts/run_embench_simple.sh crc32 --time
    
    echo "Single workload test completed"
}

run_demo() {
    echo "Running Embench demonstration..."
    
    echo ""
    echo "Step 1: Listing available workloads..."
    docker run --rm "$DOCKER_IMAGE_NAME" \
        /workspace/scripts/run_embench_simple.sh --list
    
    echo ""
    echo "Step 2: Running crc32 workload with timing..."
    docker run --rm "$DOCKER_IMAGE_NAME" \
        /workspace/scripts/run_embench_simple.sh crc32 --time
    
    echo ""
    echo "Step 3: Running a few more workloads..."
    for workload in md5sum cubic nbody; do
        echo ""
        echo "Running $workload..."
        docker run --rm "$DOCKER_IMAGE_NAME" \
            /workspace/scripts/run_embench_simple.sh "$workload"
    done
    
    echo ""
    echo "Demo completed successfully!"
    echo ""
    echo "To run all workloads: $0 all"
    echo "To run interactively: $0 run"
}

run_all() {
    echo "Running all Embench workloads..."
    
    docker run --rm "$DOCKER_IMAGE_NAME" \
        /workspace/scripts/run_embench_simple.sh --all --time
    
    echo "All workloads completed"
}

clean_up() {
    echo "Cleaning up..."
    
    docker stop embench-container 2>/dev/null || true
    docker rm embench-container 2>/dev/null || true
    docker rmi "$DOCKER_IMAGE_NAME" 2>/dev/null || true
    
    echo "Cleanup completed"
}

# Main script
check_docker

case "${1:-help}" in
    build)
        build_image
        ;;
    run)
        run_container
        ;;
    test)
        test_single
        ;;
    demo)
        run_demo
        ;;
    all)
        run_all
        ;;
    clean)
        clean_up
        ;;
    help|*)
        usage
        ;;
esac
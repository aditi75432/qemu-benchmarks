#!/bin/bash
# run_embench_simple.sh - Runs Embench workloads with tracing

set -e

EMBENCH_DIR="/workspace/embench-iot"

run_workload() {
    local workload=$1
    local with_trace=$2
    local executable="${EMBENCH_DIR}/bd/src/${workload}/${workload}"

    if [ ! -f "$executable" ]; then
        echo "Error: Workload '$workload' not found."
        exit 1
    fi

    echo "Running workload: $workload"

    if [ "$with_trace" = "true" ]; then
        echo "Running with execution trace (-d in_asm)..."
        # The -d in_asm flag prints every translated basic block
        # We redirect stderr to stdout (2>&1) to capture the trace
        qemu-riscv32 -d in_asm "$executable" 2>&1
    else
        echo "Running normally..."
        qemu-riscv32 "$executable"
    fi

    echo "Successfully ran $workload"
}

# --- Main execution ---
if [ "$2" = "--trace" ]; then
    run_workload "$1" true
else
    run_workload "$1" false
fi
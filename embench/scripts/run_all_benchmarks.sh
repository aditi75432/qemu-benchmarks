#!/bin/bash
set -e

INTERVAL="${1:-100000}"
MAX_K="${2:-30}"
OUTPUT_DIR="/output"

echo "=========================================="
echo "Running Embench BBV generation and SimPoint analysis"
echo "Interval: $INTERVAL, Max K: $MAX_K"
echo "=========================================="

mkdir -p "$OUTPUT_DIR"

# Process all executables (not just .elf files)
while IFS= read -r binary; do
    if [ -f "$binary" ] && [ -x "$binary" ]; then
        benchmark_name=$(basename "$binary")
        echo ""
        echo "Processing benchmark: $benchmark_name"
        echo "Binary path: $binary"
        
        # Run the benchmark with BBV generation
        /run_benchmark.sh "$binary" "$INTERVAL" "$OUTPUT_DIR"
        
        # If BBV was generated, run SimPoint analysis
        if [ -f "$OUTPUT_DIR/${benchmark_name}_bbv.0.bb" ]; then
            echo "Running SimPoint analysis for $benchmark_name..."
            
            simpoint \
                -loadFVFile "$OUTPUT_DIR/${benchmark_name}_bbv.0.bb" \
                -maxK $MAX_K \
                -saveSimpoints "$OUTPUT_DIR/${benchmark_name}.simpoints" \
                -saveSimpointWeights "$OUTPUT_DIR/${benchmark_name}.weights" \
                || echo "SimPoint analysis failed for $benchmark_name"
                
            if [ -f "$OUTPUT_DIR/${benchmark_name}.simpoints" ]; then
                echo "SimPoint analysis completed for $benchmark_name"
                echo "Number of simulation points: $(wc -l < "$OUTPUT_DIR/${benchmark_name}.simpoints")"
            fi
        else
            echo "Skipping SimPoint analysis for $benchmark_name (no BBV generated)"
        fi
        
        echo "Completed: $benchmark_name"
    fi
done < /embench_executables.txt

echo ""
echo "=========================================="
echo "All benchmarks processed!"
echo "Summary of generated files:"
ls -la "$OUTPUT_DIR"/ | grep -E '\.(bb|simpoints|weights)$' || echo "No output files found"
echo "=========================================="
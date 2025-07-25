# QEMU SimPoint Benchmark Analysis

## Overview

This document describes the complete workflow for running Dhrystone and Embench benchmarks on QEMU with SimPoint analysis using Docker containers for reproducibility.

## System Requirements

- Windows 10/11 with WSL 2
- Docker Desktop for Windows
- Minimum 8GB RAM
- 20GB available disk space

## Project Structure

```
qemu-benchmarks/
├── dhrystone/
│   ├── Dockerfile
│   ├── build_docker.sh
│   ├── run_in_docker.sh
│   └── build_and_run.sh
├── embench/
│   ├── Dockerfile
│   ├── build_docker.sh
│   ├── run_in_docker.sh
│   └── build_and_run.sh
└── documentation/
    └── README.md
```

## Components

### 1. QEMU
- **Purpose**: Emulate RISC-V architecture
- **Version**: Latest from GitLab repository
- **Configuration**: RISC-V 32-bit and 64-bit user-space and system emulation
- **Plugins**: BBV (Basic Block Vector) plugin for execution tracing

### 2. SimPoint
- **Purpose**: Analyze program execution phases
- **Input**: Basic Block Vectors (BBVs) from QEMU
- **Output**: Representative simulation points and weights
- **Algorithm**: K-means clustering on BBVs

### 3. Dhrystone
- **Type**: Baremetal benchmark
- **Purpose**: Integer arithmetic performance measurement
- **Modifications**: Increased iterations to 100,000 for better analysis
- **Compilation**: Static linking with RISC-V GCC

### 4. Embench
- **Type**: IoT benchmark suite
- **Purpose**: Embedded system performance evaluation
- **Benchmarks**: Multiple small programs representing embedded workloads
- **Compilation**: RISC-V 32-bit with static linking

## Workflow

### Dhrystone Analysis

1. **Build Phase**:
   - Install Ubuntu 22.04 base image
   - Install all QEMU dependencies
   - Clone and build QEMU with RISC-V support
   - Clone and build SimPoint
   - Clone and build Dhrystone for RISC-V

2. **Execution Phase**:
   - Run Dhrystone on QEMU with BBV plugin
   - Generate Basic Block Vectors
   - Perform SimPoint analysis
   - Save results to output directory

3. **Results**:
   - `dhrystone_bbv.0.bb`: Basic Block Vector file
   - `dhrystone.simpoints`: Representative simulation points
   - `dhrystone.weights`: Weights for each simulation point

### Embench Analysis

1. **Build Phase**:
   - Install Ubuntu 22.04 base image
   - Install all QEMU dependencies
   - Clone and build QEMU with RISC-V support
   - Clone and build SimPoint
   - Clone and build Embench IoT suite

2. **Execution Phase**:
   - Run each Embench benchmark on QEMU
   - Generate BBVs for each benchmark
   - Perform SimPoint analysis for each benchmark
   - Save results to output directory

3. **Results** (for each benchmark):
   - `{benchmark}_bbv.0.bb`: Basic Block Vector file
   - `{benchmark}.simpoints`: Representative simulation points
   - `{benchmark}.weights`: Weights for each simulation point

## Usage Instructions

### Prerequisites
1. Install Docker Desktop for Windows
2. Enable WSL 2 integration
3. Open PowerShell or Command Prompt as Administrator

### Running Dhrystone Analysis
```bash
cd dhrystone
./build_and_run.sh
```

### Running Embench Analysis
```bash
cd embench
./build_and_run.sh
```

## File Descriptions

### Dockerfiles
- Install all required dependencies
- Build QEMU with RISC-V support and BBV plugin
- Build SimPoint analysis tool
- Build respective benchmarks

### Build Scripts
- Create Docker images with all components
- Tag images appropriately

### Run Scripts
- Execute benchmarks in containers
- Generate BBV files
- Perform SimPoint analysis
- Save results to host filesystem

### Build and Run Scripts
- Combine build and run operations
- Provide complete workflow automation

## Output Analysis

### BBV Files
- Binary format containing execution traces
- One file per benchmark execution
- Used as input for SimPoint analysis

### SimPoint Files
- Text format listing representative intervals
- Each line contains interval ID and cluster assignment
- Used for selecting representative simulation points

### Weight Files
- Text format containing cluster weights
- Indicates relative importance of each simulation point
- Used for weighted performance analysis

## Troubleshooting

### Common Issues

1. **Docker Build Failures**:
   - Ensure Docker Desktop is running
   - Check available disk space
   - Verify internet connectivity

2. **Permission Errors**:
   - Run PowerShell as Administrator
   - Check Docker Desktop permissions

3. **Memory Issues**:
   - Increase Docker memory allocation
   - Reduce MAX_K parameter for SimPoint

### Performance Optimization

1. **Build Time**:
   - Use multi-stage builds
   - Cache intermediate layers
   - Parallel compilation with -j$(nproc)

2. **Analysis Time**:
   - Adjust BBV interval parameter
   - Reduce MAX_K for faster clustering
   - Use smaller benchmark subsets for testing

## Results Interpretation

### SimPoint Analysis
- **Clusters**: Groups of similar execution phases
- **Representatives**: Single intervals representing each cluster
- **Weights**: Relative execution time of each cluster

### Performance Metrics
- **Execution Time**: Total benchmark runtime
- **BBV Generation**: Overhead of tracing
- **Clustering Quality**: Variance within clusters

## Reproducibility

### Docker Images
- All dependencies pinned to specific versions
- Build environment completely specified
- No external dependencies during execution

### Scripts
- Parameterized configuration
- Error handling and logging
- Consistent output formatting

### Results
- Deterministic execution (with fixed seeds)
- Timestamped output directories
- Complete provenance tracking

## Conclusion

This workflow provides a complete, reproducible environment for benchmark analysis using QEMU and SimPoint. The containerized approach ensures consistency across different host systems and enables easy sharing of results.

## References

1. QEMU Project: https://gitlab.com/qemu-project/qemu
2. SimPoint Tool: https://github.com/hanhwi/SimPoint
3. Dhrystone Benchmark: https://github.com/sifive/benchmark-dhrystone
4. Embench IoT Suite: https://github.com/embench/embench-iot
5. Docker Documentation: https://docs.docker.com/

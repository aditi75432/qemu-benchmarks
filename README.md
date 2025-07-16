# QEMU SimPoint Benchmark Analysis

A containerized workflow for running Dhrystone and Embench benchmarks on QEMU with SimPoint analysis for program phase detection and basic block vector generation.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Detailed Setup](#detailed-setup)
- [Usage](#usage)
- [Results](#results)
- [Troubleshooting](#troubleshooting)
- [Technical Details](#technical-details)
- [Contributing](#contributing)

## Overview

This project provides a complete, reproducible environment for:
- **Dhrystone**: Baremetal benchmark execution on QEMU RISC-V
- **Embench**: IoT benchmark suite execution on QEMU RISC-V
- **BBV Generation**: Basic Block Vector creation using QEMU plugins
- **SimPoint Analysis**: Program phase detection and clustering

All components are containerized using Docker for maximum reproducibility across different platforms.

## Prerequisites

### System Requirements
- **OS**: Windows 10/11 (with WSL 2), macOS, or Linux
- **RAM**: Minimum 8GB (16GB recommended)
- **Storage**: 20GB available disk space
- **Network**: Internet connection for Docker image building

### Software Dependencies
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) or Docker Engine (Linux)
- [WSL 2](https://docs.microsoft.com/en-us/windows/wsl/install) (Windows only)
- [Git](https://git-scm.com/downloads)

### Optional (Recommended)
- [VS Code](https://code.visualstudio.com/) with WSL and Docker extensions

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/yourusername/qemu-simpoint-benchmarks.git
cd qemu-simpoint-benchmarks
```

### 2. Run Dhrystone Analysis
```bash
cd dhrystone
./build_and_run.sh
```

### 3. Run Embench Analysis
```bash
cd embench
./build_and_run.sh
```

### 4. View Results
Results will be saved in `simpoint_output/` directories within each benchmark folder.

## Project Structure

```
qemu-simpoint-benchmarks/
├── README.md
├── dhrystone/
│   ├── Dockerfile              # Docker image for Dhrystone analysis
│   ├── build_docker.sh         # Build Docker image
│   ├── run_in_docker.sh        # Run analysis in container
│   ├── build_and_run.sh        # Complete workflow
│   └── simpoint_output/        # Generated results (after execution)
├── embench/
│   ├── Dockerfile              # Docker image for Embench analysis
│   ├── build_docker.sh         # Build Docker image
│   ├── run_in_docker.sh        # Run analysis in container
│   ├── build_and_run.sh        # Complete workflow
│   └── simpoint_output/        # Generated results (after execution)
└── documentation/
    └── technical_details.md    # Comprehensive technical documentation
```

## Detailed Setup

### Windows Setup

1. **Install WSL 2**:
   ```powershell
   # Run in PowerShell as Administrator
   wsl --install
   # Restart computer
   ```

2. **Install Docker Desktop**:
   - Download from [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Enable WSL 2 integration in Docker Desktop settings
   - Restart Docker Desktop

3. **Open WSL 2 Terminal**:
   ```bash
   # Search "Ubuntu" or "WSL" in Start Menu
   ```

4. **Clone and Setup**:
   ```bash
   git clone https://github.com/yourusername/qemu-simpoint-benchmarks.git
   cd qemu-simpoint-benchmarks
   chmod +x dhrystone/*.sh embench/*.sh
   ```

### Linux/macOS Setup

1. **Install Docker**:
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install docker.io
   sudo systemctl start docker
   sudo usermod -aG docker $USER
   # Log out and log back in
   
   # macOS (using Homebrew)
   brew install --cask docker
   ```

2. **Clone and Setup**:
   ```bash
   git clone https://github.com/yourusername/qemu-simpoint-benchmarks.git
   cd qemu-simpoint-benchmarks
   chmod +x dhrystone/*.sh embench/*.sh
   ```

## Usage

### Dhrystone Benchmark

**What it does**: Runs the Dhrystone integer arithmetic benchmark on QEMU RISC-V with BBV generation and SimPoint analysis.

```bash
cd dhrystone

# Option 1: Complete workflow (recommended)
./build_and_run.sh

# Option 2: Step-by-step
./build_docker.sh    # Build Docker image
./run_in_docker.sh   # Run analysis
```

**Expected Output**:
```
==========================================
QEMU SimPoint Dhrystone Analysis
==========================================
[STEP 1] Building Docker image...
[STEP 2] Running BBV generation and SimPoint analysis...
==========================================
Complete workflow finished successfully!
Check the simpoint_output directory for results
==========================================
```

### Embench Benchmark Suite

**What it does**: Runs the complete Embench IoT benchmark suite on QEMU RISC-V with individual BBV generation and SimPoint analysis for each benchmark.

```bash
cd embench

# Option 1: Complete workflow (recommended)
./build_and_run.sh

# Option 2: Step-by-step
./build_docker.sh    # Build Docker image
./run_in_docker.sh   # Run analysis
```

**Expected Output**:
```
==========================================
QEMU SimPoint Embench Analysis
==========================================
[STEP 1] Building Docker image...
[STEP 2] Running BBV generation and SimPoint analysis...
Processing benchmark: aha-mont64
Processing benchmark: crc32
Processing benchmark: cubic
...
==========================================
Complete Embench workflow finished successfully!
Check the simpoint_output directory for results
==========================================
```

### Customization

You can modify the analysis parameters by editing the configuration variables in `run_in_docker.sh`:

```bash
# BBV generation interval (instructions per sample)
INTERVAL=100

# Maximum number of clusters for SimPoint
MAX_K=30

# Output directory
OUTPUT_DIR="$(pwd)/simpoint_output"
```

## Results

### Generated Files

**Dhrystone Results** (`dhrystone/simpoint_output/`):
- `dhrystone_bbv.0.bb` - Basic Block Vector file
- `dhrystone.simpoints` - Representative simulation points
- `dhrystone.weights` - Cluster weights

**Embench Results** (`embench/simpoint_output/`):
- `{benchmark}_bbv.0.bb` - BBV file for each benchmark
- `{benchmark}.simpoints` - Simulation points for each benchmark
- `{benchmark}.weights` - Cluster weights for each benchmark

### File Formats

**BBV Files (.bb)**:
- Binary format containing execution traces
- Each entry represents a basic block execution count
- Used as input for SimPoint clustering

**SimPoint Files (.simpoints)**:
```
# Format: SimPoint_ID Cluster_ID
0 0
1 1
2 0
...
```

**Weight Files (.weights)**:
```
# Format: Cluster_ID Weight
0 0.45
1 0.32
2 0.23
...
```

## Troubleshooting

### Common Issues

#### Docker Build Failures
```bash
# Check Docker is running
docker --version

# Check available space (need ~15GB)
df -h

# Clean Docker cache if needed
docker system prune -a
```

#### Permission Errors (Linux/macOS)
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and log back in

# Make scripts executable
chmod +x dhrystone/*.sh embench/*.sh
```

#### Memory Issues
```bash
# Increase Docker memory limit in Docker Desktop settings
# Or reduce analysis parameters:
# Edit run_in_docker.sh and change:
MAX_K=10  # Reduce from 30
INTERVAL=1000  # Increase from 100
```

### Build Times

**Expected Build Times**:
- Dhrystone Docker image: 30-60 minutes
- Embench Docker image: 45-90 minutes
- Analysis execution: 5-15 minutes

**Tips to Reduce Build Time**:
- Use `docker build --no-cache` only when necessary
- Ensure good internet connection for package downloads
- Use SSD storage for better I/O performance

### Verification

To verify your setup is working:

```bash
# Check Docker installation
docker run hello-world

# Check WSL 2 (Windows only)
wsl --list --verbose

# Test basic functionality
cd dhrystone
./build_docker.sh
docker images | grep qemu-simpoint-dhrystone
```

## Technical Details

### Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Benchmark     │    │      QEMU        │    │    SimPoint     │
│   (Dhrystone/   │───▶│   + BBV Plugin   │───▶│   Analysis      │
│    Embench)     │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
   RISC-V Binary           BBV Files (.bb)         SimPoints + Weights
```

### Components

- **QEMU**: Emulates RISC-V architecture with BBV plugin for execution tracing
- **SimPoint**: Performs k-means clustering on basic block vectors
- **Dhrystone**: Integer arithmetic benchmark (modified for 100,000 iterations)
- **Embench**: IoT benchmark suite with multiple small programs

### Key Features

- **Reproducibility**: All dependencies containerized with pinned versions
- **Cross-platform**: Works on Windows, macOS, and Linux
- **Automation**: Single command execution for complete workflow
- **Scalability**: Parallel processing where possible


### Reporting Issues

Please include:
- Operating system and version
- Docker version
- Complete error messages
- Steps to reproduce


## Acknowledgments

- [QEMU Project](https://gitlab.com/qemu-project/qemu) for the emulation framework
- [SimPoint](https://github.com/hanhwi/SimPoint) for program phase analysis
- [SiFive](https://github.com/sifive/benchmark-dhrystone) for the Dhrystone benchmark
- [Embench](https://github.com/embench/embench-iot) for the IoT benchmark suite
- [Original inspiration](https://github.com/vinicius-r-silva/olympia-mentorship) for the workflow design

```

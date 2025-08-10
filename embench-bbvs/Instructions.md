# Embench Execution Tracing with QEMU

## Introduction
This project provides a complete, containerized environment for compiling the **Embench-IoT** benchmark suite for the **RISC-V 32-bit** architecture and analyzing its execution using **QEMU's** built-in tracing capabilities.

The primary goal is to offer a simple, reliable, and reproducible method for observing the sequence of basic blocks executed by an Embench workload. This is achieved using QEMU's powerful `in_asm` debugging flag, which serves as a robust alternative to building and using external QEMU plugins.

---

## Core Technologies Used
This setup integrates several key technologies to create a seamless workflow:

- **Docker**: Creates a self-contained, consistent environment with fixed toolchain, libraries, and QEMU versions for guaranteed reproducibility.  
- **Embench-IoT**: Industry-standard, open-source benchmark suite for embedded systems. We clone this repository and use its Python-based build system to compile all the C-based workloads.  
- **RISC-V GCC Toolchain**: Uses the pre-built RISC-V cross-compiler (`ribeirovsilva/riscv-toolchain`) to compile Embench C code into RISC-V executables.  
- **QEMU User-Mode Emulation**: Uses `qemu-riscv32` to execute RISC-V binaries on non-RISC-V hosts (e.g., x86_64) without full-system emulation.  
- **QEMU Built-in Tracer (`-d in_asm`)**: Prints disassembled assembly code of every basic block before execution, providing a complete, detailed execution trace without external plugins.

---

## How It Works
The system is automated through scripts that manage the build and execution process:

- **`simple_setup.sh`** – Main control script on the host machine, wrapping Docker commands into simple actions like `build` and `trace`.  
- **`Dockerfile`** – Blueprint for the container environment, installing dependencies (`qemu-user`), cloning Embench, and compiling all 22 workloads.  
- **`run_embench_simple.sh`** – Inside the container, runs workloads with `qemu-riscv32 -d in_asm` and captures trace output.

**Workflow:**
1. Build the environment once.
2. Trace any workload on demand.

---

## How to Reproduce This Work

### Step 1: Create the Directory Structure
```plaintext
.
├── Dockerfile
├── simple_setup.sh
└── scripts/
    └── run_embench_simple.sh
````

Create the above structure and populate the files with the provided content.

---

### Step 2: Make the Setup Script Executable

```bash
chmod +x simple_setup.sh
```

---

### Step 3: Build the Docker Image

```bash
./simple_setup.sh build
```

This will:

* Download the base image
* Install dependencies
* Compile all Embench workloads
  *(Only needs to be done once)*

---

### Step 4: Trace a Workload

```bash
./simple_setup.sh trace [workload_name]
```

#### Example 1: Trace `crc32`

```bash
./simple_setup.sh trace crc32
```

#### Example 2: Trace `huffbench`

```bash
./simple_setup.sh trace huffbench
```

---

## Understanding the Output

The trace output is the **direct execution log from QEMU**.

* Each block starts with `IN:` showing a basic block of RISC-V assembly executed.
* The sequence of blocks represents the program’s **dynamic execution path**.

**Example Output:**

```plaintext
IN: _start
0x000100fe:  00002197    auipc   gp,8192    # 0x120fe

IN: memset
0x00010292:  433d        addi    t1,zero,15
```

This view is invaluable for **performance analysis** and **debugging**, showing the program's behavior at the instruction level.

---


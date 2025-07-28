# Embench + QEMU + SimPoint Automation

This project automates the process of compiling and running the [Embench IoT benchmark suite](https://github.com/embench/embench-iot) on QEMU with basic block vector (BBV) plugin support, and running [SimPoint](https://github.com/hanhwi/SimPoint) clustering for simulation analysis.

---

## 🧱 What's Included

- ✅ Dockerfile with all required tools: QEMU (plugin-enabled), SimPoint, bare-metal RISC-V GCC
- ✅ Automatic Embench compilation
- ✅ BBV generation using QEMU plugin
- ✅ SimPoint analysis using generated BBV traces

---

## 📦 Requirements

- Docker (Linux or WSL2 on Windows)
- ~30–60 minutes for initial build (QEMU, GCC, Embench, etc.)

---

## 🚀 How to Run

```bash
chmod +x build_and_run.sh build_docker.sh run_in_docker.sh
./build_and_run.sh

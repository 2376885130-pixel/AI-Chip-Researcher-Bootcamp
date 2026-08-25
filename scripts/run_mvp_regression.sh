#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"; cd "$ROOT"
mkdir -p Simulation/MVP
COMMON=(RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v)
iverilog -g2012 -s ai_accelerator_system_tb -o Simulation/MVP/ai_accelerator_system_sim RTL/MVP/ai_accelerator_system.v "${COMMON[@]}" Testbench/MVP/ai_accelerator_system_tb.v
vvp Simulation/MVP/ai_accelerator_system_sim
echo "MVP REGRESSION PASS"

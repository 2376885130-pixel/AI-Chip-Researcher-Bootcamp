#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mkdir -p Simulation/Day23 Simulation/Day24

COMMON=(
  RTL/Day19/systolic_matmul.v
  RTL/Day14/Compute/pe_unit.v
  RTL/Day21/fetch16w.v
  RTL/Day14/Memory/weight_buffer.v
  RTL/Day14/Memory/activation_buffer.v
  RTL/Day14/Memory/output_buffer.v
)

iverilog -g2012 -o Simulation/Day23/npu_wstore_sim \
  RTL/Day23/npu_wstore_top.v "${COMMON[@]}" Testbench/Day23/npu_wstore_tb.v
vvp Simulation/Day23/npu_wstore_sim

iverilog -g2012 -o Simulation/Day24/ai_accelerator_mvp_sim \
  RTL/Day24/ai_accelerator_mvp.v RTL/Day23/npu_wstore_top.v \
  "${COMMON[@]}" Testbench/Day24/ai_accelerator_mvp_tb.v
vvp Simulation/Day24/ai_accelerator_mvp_sim

echo "REGRESSION PASS"

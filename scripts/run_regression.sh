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

"$ROOT/scripts/run_mvp_regression.sh"
"$ROOT/scripts/run_python_reference.sh"
mkdir -p Simulation/Phase2 Simulation/Phase3
iverilog -g2012 -s ai_accelerator_top_tb -o Simulation/Phase3/ai_accelerator_top_sim \
  RTL/Top/ai_accelerator_top.v RTL/Control/task_controller.v RTL/Memory/memory_controller.v \
  RTL/Compute/systolic_engine.v RTL/MVP/ai_accelerator_system.v \
  RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v Testbench/Top/ai_accelerator_top_tb.v
vvp Simulation/Phase3/ai_accelerator_top_sim
echo "REGRESSION PASS"

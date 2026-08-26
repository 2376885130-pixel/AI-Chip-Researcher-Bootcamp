#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mkdir -p Simulation/Day23 Simulation/Day24
mkdir -p Simulation/Control
mkdir -p Simulation/Memory Simulation/Compute Simulation/Parameter

iverilog -g2012 -o Simulation/Control/task_controller_start_sim \
  RTL/Control/task_controller.v Testbench/Control/task_controller_start_tb.v
vvp Simulation/Control/task_controller_start_sim

iverilog -g2012 -o Simulation/Memory/memory_controller_protocol_sim \
  RTL/Memory/memory_controller.v Testbench/Memory/memory_controller_protocol_tb.v
vvp Simulation/Memory/memory_controller_protocol_sim

for latency_define in LATENCY_N4; do
  iverilog -g2012 -s systolic_latency_case -D"$latency_define" \
    -o "Simulation/Compute/systolic_latency_${latency_define}_sim" \
    RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v \
    Testbench/Compute/systolic_latency_tb.v
  vvp "Simulation/Compute/systolic_latency_${latency_define}_sim"
done
iverilog -g2012 -s systolic_latency_case \
  -o Simulation/Compute/systolic_latency_LATENCY_N2_sim \
  RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v \
  Testbench/Compute/systolic_latency_tb.v
vvp Simulation/Compute/systolic_latency_LATENCY_N2_sim

iverilog -g2012 -s systolic_matmul -P systolic_matmul.N=1 \
  -o Simulation/Parameter/systolic_n1_elab_sim \
  RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v
echo "PARAMETER ELABORATION PASS MATRIX_SIZE=1"

for matrix_size in 2 4; do
  pe_num=$((matrix_size * matrix_size))
  iverilog -g2012 -s ai_accelerator_top \
    -P "ai_accelerator_top.MATRIX_SIZE=${matrix_size}" \
    -P "ai_accelerator_top.PE_NUM=${pe_num}" \
    -o "Simulation/Parameter/top_n${matrix_size}_sim" \
    RTL/Top/ai_accelerator_top.v RTL/Control/task_controller.v \
    RTL/Memory/memory_controller.v RTL/Compute/systolic_engine.v \
    RTL/MVP/ai_accelerator_system.v RTL/Day19/systolic_matmul.v \
    RTL/Day14/Compute/pe_unit.v
done

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
iverilog -g2012 -s verification_closure_tb -o Simulation/MVP/verification_closure_sim \
  RTL/MVP/ai_accelerator_system.v RTL/Compute/systolic_engine.v RTL/Day19/systolic_matmul.v \
  RTL/Day14/Compute/pe_unit.v Testbench/MVP/verification_closure_tb.v
vvp Simulation/MVP/verification_closure_sim
mkdir -p Simulation/Phase2 Simulation/Phase3
iverilog -g2012 -s ai_accelerator_top_tb -o Simulation/Phase3/ai_accelerator_top_sim \
  RTL/Top/ai_accelerator_top.v RTL/Control/task_controller.v RTL/Memory/memory_controller.v \
  RTL/Compute/systolic_engine.v RTL/MVP/ai_accelerator_system.v \
  RTL/Day19/systolic_matmul.v RTL/Day14/Compute/pe_unit.v Testbench/Top/ai_accelerator_top_tb.v
vvp Simulation/Phase3/ai_accelerator_top_sim
echo "REGRESSION PASS"

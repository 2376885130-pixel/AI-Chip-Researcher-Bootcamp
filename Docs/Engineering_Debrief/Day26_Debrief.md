# Day26 Engineering Debrief

## What was built?

A repeatable Day23/Day24 RTL regression script and an FPGA-ready interface review were added.

## Why was it built?

An accelerator is not ready for hardware mapping if verification depends on manually remembered file lists. A single regression command makes changes reproducible and catches integration regressions before Vivado.

## Architecture explanation

The compute core remains `npu_wstore_top`. `ai_accelerator_mvp` is the protocol-neutral host boundary. Day26 adds only verification orchestration and documents the clock/reset, data width, address, busy, done, and read-latency contracts.

## Design trade-off

The regression uses Icarus and Verilog-2001-compatible RTL at the current project level. AXI and vendor-specific clock IP remain outside the core until the interface contract is stable.

## Verification result

The script compiles and runs the Day23 4-workload test and Day24 MVP test. Expected results are `DAY23 WIDE STORE PASS`, `DAY24 AI ACCELERATOR MVP PASS`, and `REGRESSION PASS`.

## Debugging process

The compile dependency list explicitly includes the Day19 systolic array, Day14 PE and buffers, and Day21 fetch module. This prevents a false impression that the top module is standalone when it has known RTL dependencies.

## AI accelerator connection

This is the handoff point before Vivado: stable RTL, deterministic verification, explicit synchronous control, and a documented path to an AXI adapter.

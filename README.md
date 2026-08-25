# AI Accelerator Research Prototype

An RTL-based INT8 matrix multiplication accelerator for studying NPU compute, dataflow, buffering, scheduling, and verification.

## Motivation

This project investigates how a MAC datapath becomes a usable accelerator: how PE arrays reuse data, how systolic movement controls bandwidth, and how buffering changes end-to-end latency.

## Architecture

```text
Host protocol-neutral interface
              |
      ai_accelerator_top
       /       |        \
  control   memory     compute
 scheduler  buffers   systolic engine
              |
       result ready/valid stream
```

Formal release top: `RTL/Top/ai_accelerator_top.v`. Historical Day12-Day27 implementations remain as design evolution and benchmark evidence. The current MVP compute boundary is `RTL/MVP/ai_accelerator_system.v`.

## Hardware design

- Signed INT8 activation and weight inputs
- Signed INT32 accumulation
- Parameterized matrix size and task count
- Systolic matrix multiplication engine
- Activation, weight, and output buffer abstractions
- Start/busy/done/error/timeout control
- Ready/valid memory and result protocols

## Dataflow

Task-indexed activation and weight data feed the systolic engine. The scheduler launches compute, stores output elements, and streams results with back-pressure support. Day19-Day23 records progressive transfer-overlap improvements.

## Verification methodology

```bash
./scripts/run_regression.sh
```

The flow runs historical baseline workloads, MVP integration, Python-to-RTL comparison, corner/error checks, and formal-top compile smoke. Expected final marker: `REGRESSION PASS`.

## Performance

The historical 4-task 4x4 RTL workload improved from 312 cycles to 92 cycles, a 3.39x speedup. See [Docs/performance_report.md](Docs/performance_report.md). These are simulation cycle counts, not FPGA frequency or throughput claims.

## FPGA roadmap

The core is prepared for a KV260 deployment wrapper. See [Docs/KV260_Register_Map.md](Docs/KV260_Register_Map.md) and [Docs/AXI_Wrapper_Plan.md](Docs/AXI_Wrapper_Plan.md). Future work is Vivado synthesis, AXI-Lite control, DMA/AXI-Stream data movement, timing/resource reports, and board validation.

## Research directions

Tile scheduling, SRAM banking, memory bandwidth analysis, mixed precision, PE utilization, and dataflow comparisons are planned extensions.

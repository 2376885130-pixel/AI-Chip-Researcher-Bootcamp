# Day24 Accelerator Optimization Design

## Goal
Create a synthesizable MVP boundary around the verified Day23 matrix accelerator with a stable interface for later KV260 integration.

## Scope
- Preserve Day23 as the historical performance baseline.
- Add `RTL/Day24/ai_accelerator_mvp.v`.
- Use synchronous `start`, `busy`, `done`, packed buffer writes, and packed result reads.
- Reject a new start while busy and block input writes while running.
- Keep AXI as a later protocol wrapper.

## Verification
The Day24 testbench loads four workloads, checks busy/start behavior, waits with a timeout, reads packed results, and compares them against a reference model.

## FPGA preparation
The boundary uses ordinary synchronous RTL and no vendor-specific primitives. It can later be wrapped by AXI-Lite or AXI-Stream without changing the compute datapath.

# Phase3 AI Accelerator MVP Release Debrief

## What was built?

The repository was organized as an AI Accelerator Research Prototype with a formal top, measured optimization history, unified regression, Python comparison, and KV260/AXI preparation documents.

## Why was it built?

The portfolio must provide reproducible engineering evidence, not only a sequence of learning exercises.

## Architecture decision

Historical Day implementations remain traceable. `RTL/Top/ai_accelerator_top.v` is the formal boundary. Control and memory adapters surround the verified MVP compute core; AXI remains an external deployment wrapper.

## Trade-offs

The release favors a small, understandable prototype over a premature DDR/DMA implementation. Performance claims are cycle-level RTL data and are separated from future FPGA results.

## Verification

Regression runs baseline Day23/Day24, MVP result comparison, Python RTL comparison, and formal-top compile smoke. The suite covers values, signed cases, invalid commands, illegal addresses, timeout, and output back-pressure.

## Future research

Tile-level reuse, PE utilization, SRAM banking, DMA scheduling, mixed precision, and FPGA resource/timing measurement are the next directions.

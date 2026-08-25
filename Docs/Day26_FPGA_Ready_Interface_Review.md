# Day26 FPGA-Ready Interface Review

## Current contract

- Clock: one synchronous `clk` domain.
- Reset: synchronous active-high `reset`.
- Start: accepted only while `busy` is low.
- Busy: high from accepted start until the core completion event.
- Done: one-cycle completion pulse.
- Input writes: packed 32-bit words, accepted only while idle.
- Result reads: packed 64-bit words with synchronous read behavior.
- Numeric format: signed INT8 inputs and signed INT32 accumulators/results.

## Synthesis checks

- No delays, `initial` blocks, file I/O, or testbench constructs are in production RTL.
- Day25 removed the multiple procedural driver for `store_req`.
- The core uses inferred registers and memories that Vivado can map to fabric/BRAM as appropriate.
- Clock generation and board pin constraints are intentionally deferred to the KV260 wrapper project.

## Remaining FPGA work

1. Create the Vivado KV260 project and select the exact board part.
2. Add a board clock/reset wrapper and XDC constraints.
3. Add AXI-Lite control and memory access or a BRAM/VIO bring-up wrapper.
4. Synthesize, implement, inspect timing/resource reports, and generate a bitstream.
5. Download and compare board results with the regression reference.

# Day27 Engineering Debrief

## What was built?

A KV260 Vivado project skeleton was added with a board top-level wrapper, a generator Tcl script, and a timing-preparation XDC file.

## Why was it built?

The accelerator core is now verified and interface-stable. Day27 gives it a reproducible FPGA project boundary without mixing board-specific clocking or AXI protocol logic into the compute core.

## Architecture explanation

`kv260_accelerator_top` receives the project clock and reset, then instantiates `ai_accelerator_mvp`. `create_kv260_project.tcl` adds the complete RTL dependency chain, selects the KV260 part/board, sets the top module, and adds the XDC.

## Design trade-off

The XDC contains timing and I/O standards but deliberately does not guess package pins. KV260 clock and carrier connectivity must be confirmed against the selected Vivado board files and hardware setup.

## Verification result

The wrapper was checked for complete module connectivity and the Day26 regression remains the behavioral reference. Vivado execution is pending on the Windows machine where Vivado is installed.

## AI accelerator connection

This is the transition from portable accelerator RTL to a target FPGA project. The compute IP remains independent, while the board wrapper owns device, clock, reset, and future AXI integration concerns.

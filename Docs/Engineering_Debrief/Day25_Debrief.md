# Day25 Engineering Debrief

## What was built?

The Day23 wide-store controller was refactored so `store_req` has one sequential owner: the store sub-FSM.

## Why was it built?

Multiple clocked processes assigned the same register. That is not a reliable synthesizable RTL pattern and makes request timing ambiguous.

## Architecture explanation

The result-latch process writes completed matrix results and the task selector. The store FSM creates a request when the latch state is observed, consumes it in `ST_IDLE`, and advances the packed output write counter in `ST_RUN`.

## Design trade-off

The existing one-entry request behavior is preserved. No FIFO or throughput change is introduced before the regression baseline is stable.

## Verification result

Day23 and Day24 workload simulations were rerun after the change and both produced PASS.

## Debugging process

The issue was found by tracing procedural assignments to `store_req`. Reset, request creation, and request consumption now live in one clocked process.

## AI accelerator connection

Single-owner control registers are essential in FPGA accelerators: scheduler state, DMA requests, and completion flags must each have one unambiguous clock-domain owner.

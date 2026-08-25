# KV260 Register Map Preparation

| Offset | Name | Access | Meaning |
|---:|---|---|---|
| 0x00 | CONTROL | W | START, SOFT_RESET |
| 0x04 | STATUS | R | BUSY, DONE, ERROR |
| 0x08 | ERROR_CODE | R | illegal address, invalid command, timeout |
| 0x0C | TASK_COUNT | RW | configured task count |
| 0x10 | ACTIVATION_BASE | RW | activation buffer base |
| 0x14 | WEIGHT_BASE | RW | weight buffer base |
| 0x18 | OUTPUT_BASE | RW | output buffer base |
| 0x1C | RESULT_COUNT | R | emitted result words |
| 0x20 | CYCLE_COUNT | R | start-to-done cycles |

An AXI-Lite adapter will translate these registers to the core start/status contract. DDR movement belongs in AXI DMA/AXI-Stream adapters, not in the compute core.

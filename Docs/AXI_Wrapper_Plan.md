# AXI Wrapper Plan

```text
AXI-Lite registers -> control/status adapter -> ai_accelerator_top
AXI DMA/AXI-Stream -> buffer adapter -> memory_controller
```

The wrapper owns AXI handshakes, register side effects, interrupts, and DDR transactions. The accelerator owns scheduling, compute, and result ready/valid behavior.

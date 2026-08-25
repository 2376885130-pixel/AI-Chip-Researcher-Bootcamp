# Phase 2 Architecture Refinement

## Formal release boundary

`RTL/Top/ai_accelerator_top.v` is the only formal Phase 2 entry point. Day12-Day27 and `RTL/MVP` remain historical/reference implementations.

```text
ai_accelerator_top
├── Interface
│   └── host_interface
├── Control
│   └── ai_accelerator_system scheduler boundary
├── Memory
│   ├── activation_buffer
│   ├── weight_buffer
│   └── output_buffer
└── Compute
    └── systolic_matmul / PE array
```

The control path owns start, task sequencing, timeout, busy, done and error. The data path owns activation/weight storage, systolic computation and output streaming. The buffer modules define valid/ready address interfaces that can later be adapted to DMA, AXI or BRAM.

## Parameter contract

`PE_NUM == MATRIX_SIZE*MATRIX_SIZE`, `ACC_WIDTH >= 2*DATA_WIDTH+clog2(MATRIX_SIZE)`, and `ADDR_WIDTH >= clog2(NUM_TASKS*MATRIX_SIZE*MATRIX_SIZE)`. Invalid combinations fail elaboration through a constant parameter check.

## FPGA readiness

Production RTL contains no delays or testbench system tasks. The buffer reset loops are acceptable for the current small prototype, but larger FPGA implementations should use BRAM initialization or explicit clear sequencing to preserve memory inference. The formal top is synchronous and protocol-neutral; AXI remains an external adapter concern.

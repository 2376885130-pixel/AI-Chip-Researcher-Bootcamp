# Day19 Engineering Debrief

## Systolic NPU Integration (4x4 Matrix Multiply)

### 1. Project Objective

What was built:

The Day14 NPU was upgraded: the serial dot_product_engine was
replaced with a parameterized NxN systolic array, producing a
complete matrix-multiply accelerator.

```
npu_systolic_top
├── weight_buffer / activation_buffer   (16 entries each)
├── fetch16                             (reads 16+16 values)
├── systolic_matmul #(.N(4))            (16 PEs)
└── output_buffer                       (16 entries)
```

Verified: C = A x B for 4x4 matrices, end-to-end through the NPU.

### 2. Why was it built

Day14/16 NPU computed matrix multiply by repeated dot products
(~352 cycles for 4x4). Day18 proved the systolic array works for
2x2. Day19 generalized the array to NxN and integrated it into the
NPU, so the whole matrix multiply happens in one task.

### 3. The Parameterized Systolic Array

RTL/Day19/systolic_matmul.v generalizes Day18 using generate loops:

- NxN PE array of reused Day14 pe_unit modules
- N row/column boundaries with a run-state counter
- skew: A[i][k] at cnt=1+i+k, B[k][j] at cnt=1+j+k
- latency = 3N-1 run cycles (N=4 -> 11 cycles)

### 4. NPU Integration

- fetch16: serial SRAM read of 16 weights + 16 activations
  (3 cycles per element = 48 cycles)
- main controller FSM:
  IDLE -> START_FETCH -> WAIT_FETCH -> START_COMPUTE
       -> WAIT_COMPUTE -> STORE -> DONE
- STORE writes the 16 results one per cycle
- CPU interface unchanged in style (write A/B, start, read C)

### 5. The Critical Bug: Result Lifecycle

Symptom: all 16 outputs were 0 in the integrated test.

Investigation: the standalone systolic test passed. The difference
is WHEN the consumer reads the results.

Root cause:
- systolic_matmul used clear_acc = (cnt == 0)
- after done, cnt returns to 0 (idle) -> clear_acc=1 -> the PE
  accumulators were cleared on the next clock edge
- the NPU store phase needs 16 cycles; c became 0 before most
  results were stored

Solution:
- clear_acc = (cnt == 0) && (start)
- results now persist in idle until a NEW task starts

Lesson:
- producer/consumer interface timing: the producer's valid-data
  window must be >= the consumer's read duration
- a standalone unit test may miss bugs that only appear when the
  module is connected to a real consumer

### 6. Verification

Test 1: A = identity, B = [1..16] -> C = B, PASS (16/16)
Test 2: A = B = [1..16] -> C matches reference model, PASS (16/16)

Latency: full task ~78 cycles (fetch 48 + systolic 11 + store 16).

### 7. Latency Analysis: the Memory Wall

| Phase | Cycles | Share |
| ----- | ------ | ----- |
| fetch | 48     | ~62%  |
| systolic compute | 11 | ~14% |
| store | 16     | ~21%  |

The compute dropped from ~352 to 11 cycles, but total is only ~78
because data movement (64 cycles) now dominates.

Insight: this is the classic memory wall. Real NPUs solve it with:
- DMA (large efficient transfers)
- double buffering (overlap load and compute)
- wide memory interfaces (more data per cycle)

### 8. Engineering Insights

1. Parameterized RTL (generate loops) turns a 2x2 demo into an
   NxN engine with one parameter change.
2. Integration changes the timing contract: submodules must hold
   results until consumed.
3. Bottleneck shifts: after optimizing compute, the bottleneck
   moves to memory. Optimization is an iterative process.
4. Hierarchy: the main controller does coarse scheduling
   (fetch/compute/store); the systolic does fine dataflow
   scheduling internally (skew).

### 9. Debugging Record

Problem: all-zero results in integrated NPU test.

Root cause: accumulator clear in idle state destroyed results
before the store phase read them.

Solution: gate clear_acc with start.

General lesson: always verify module timing under integration, not
just standalone.

### 10. Hardware Thinking Transfer

```
Serial dot products (Day14)         ~352 cycles
    |
    v
Parallel MACs (Day17)               2 cycles (2x2)
    |
    v
Systolic array (Day18)              5 cycles (2x2)
    |
    v
Systolic NPU (Day19)                ~78 cycles (4x4, full path)
    |
    v
Double buffering / DMA (Day20)      hide memory latency
```

### 11. Future Improvement

- Double buffering: load next matrix while computing current one
- Widen fetch/store (multiple values per cycle)
- DMA-style bulk transfer between memory and buffers
- Software scheduler for multi-layer inference

### 12. Final Evaluation

Learner can explain:

- how the systolic array scales to NxN via generate
- the memory wall: compute fast, data movement dominates
- the result-lifecycle bug and fix
- producer/consumer timing contract
- why DMA and double buffering are needed

Understanding level: Can modify -> Can independently design.

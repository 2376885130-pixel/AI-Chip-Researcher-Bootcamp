# Day20 Engineering Debrief

## Double Buffering (Hide Fetch Latency)

### 1. Project Objective

What was built:

npu_pipelined_top.v: an extension of the Day19 systolic NPU that
processes NUM_TASKS (4) consecutive 4x4 matrix multiplies with
double buffering - the fetch of task N+1 overlaps with the
compute/store of task N.

Verified: all 4 tasks produced correct results (reference model).

### 2. Why was it built

Day19 exposed the memory wall: fetch (48 cycles) dominated a task
(~78 cycles). The NPU was idle during every fetch. Double buffering
lets the next task's data load while the current task computes.

### 3. Concept: Ping-Pong Buffers

Two register banks (bank0/bank1) hold the a/b matrices:

```
compute uses bank[task%2]
fetch    fills bank[(task+1)%2]
```

When task N finishes, the roles swap. The fetch that used to be
serialized in front of every compute now runs in parallel with it.

### 4. Implementation

- fetch16b: serial fetch with a base address (one task per
  16-entry block of the 64-entry SRAM)
- two a/b register banks (16 entries each)
- bank mux: systolic reads the active bank
- pipelined controller (12 states):
  FETCH -> COPY -> COMP_START (compute + next fetch) -> WAIT_C
        -> STORE -> WAIT_NEXT_F -> COPY2 -> COMP_START -> ...

Key pipeline rule:
- COMP_START starts compute of task_comp AND fetch of task_comp+1
- store of task N overlaps with the wait for fetch of task N+1

### 5. Verification

4 tasks, each verified against a reference model:
- Task 0: A=identity -> C = B, PASS
- Task 1: A=[1..16], B=[16..1], PASS
- Task 2: scaled matrices, PASS
- Task 3: signed negatives, PASS

Latency:
- serial (Day19): ~312 cycles for 4 tasks
- double buffered: 243 cycles (~1.28x)

### 6. Latency Analysis: Why not 2x?

The pipeline has two overlapping stages:
- fetch (48 cycles)
- compute + store (11 + 16 = 27 cycles)

Steady-state interval between task completions:
  max(fetch, compute+store) = max(48, 27) = 48 cycles

The fetch is still the critical path. Compute hides behind it, but
the next task cannot start until its data arrives. So throughput
improved only 1.28x, not 2x.

### 7. Engineering Insights

1. Double buffering hides the SHORTER stage behind the LONGER one.
   The bottleneck is always the longest pipeline stage.

2. The first task's fetch cannot be hidden (pipeline fill). The
   benefit grows with the number of consecutive tasks.

3. To break the 48-cycle bound, the fetch itself must get faster
   (wider bus). Optimization is iterative: fix the longest stage,
   then the bottleneck moves to the next stage.

4. Cost of double buffering: 2x input registers + bank muxes + a
   more complex controller. Classic area-vs-throughput trade-off.

5. The pipeline controller is the same idea as a CPU instruction
   pipeline: stages overlap, throughput rises, latency per task
   stays the same.

### 8. Debugging Record

Compile error: 'state' declared twice (3-bit in module header and
4-bit in the controller). Removed the duplicate.

Width warning: write_address expression wider than the 6-bit port.
Routed it through an explicitly sized combinational reg.

General lesson: keep declarations unique; size expressions to the
destination port to avoid pruning surprises.

### 9. Hardware Thinking Transfer

```
Serial task flow (Day19)            fetch48 | comp11 | store16 = 78
    |
    v
Double buffering (Day20)            fetch overlaps compute
    steady-state interval = max(48, 27) = 48
    |
    v
Wider fetch (Day21)                 cut fetch to ~12 cycles
    steady-state interval = max(12, 27) = 27
```

### 10. Future Improvement

- Wider fetch (4 elements/cycle) to break the 48-cycle bound
- Pipeline the store too (store N+1 overlap)
- DMA-style bulk load from external memory
- Software scheduler to feed many tasks back-to-back

### 11. Final Evaluation

Learner can explain:

- why double buffering helps throughput, not single-task latency
- the steady-state interval formula max(fetch, compute+store)
- why the improvement was ~1.28x, not 2x (fetch still dominates)
- the area cost of double buffering
- what to optimize next (wider fetch)

Understanding level: Can independently design.

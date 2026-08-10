# Day21 Engineering Debrief

## Wider Data Path (4-wide Fetch)

### 1. Project Objective

What was built:

npu_wide_top.v: the Day20 double-buffered NPU with the fetch
widened from 1 element/cycle to 4 elements/cycle by packing four
8-bit elements into a 32-bit SRAM word.

Verified: 4 tasks (same as Day20) all PASS against the reference
model.

### 2. Why was it built

Day20's steady-state interval was max(fetch=48, compute+store=27)
= 48 cycles - the fetch still dominated. Day21 attacks the fetch
directly: read wider instead of reading more often.

### 3. Concept: Wide Memory Access

Instead of 16 reads of 8 bits, do 4 reads of 32 bits:

```
serial (Day20): 16 x 8-bit reads x 3 cycles = 48 cycles
wide   (Day21):  4 x 32-bit reads x 3 cycles = 12 cycles
```

Each 32-bit word holds 4 packed elements. The fetch module reads
a word and unpacks it into 4 elements for the compute banks.

### 4. Implementation

- fetch16w.v: reads NUM_WORDS (4) words, unpacks each into 4
  elements (weight_out[0:15], activation_out[0:15])
- buffers: DATA_WIDTH widened 8 -> 32, ADDR_WIDTH 6 -> 4
  (16 words hold all 4 tasks)
- npu_wide_top.v: same ping-pong pipeline controller as Day20,
  only the memory interface widened
- store side unchanged (16 result writes)

### 5. Verification

4 tasks, each checked against the reference model:
- identity, [1..16]x[16..1], scaled, negatives - all PASS

Latency:
- Day19 serial: 312
- Day20 double buffer: 243
- Day21 wide fetch: 147

### 6. Latency Analysis

Measured per-task interval after the first: ~36 cycles.

Ideal lower bound: max(fetch=12, compute+store=27) = 27.

The gap (~9 cycles) comes from:
- store (16) is serial with the next compute (systolic is busy
  storing results, so the next task cannot start computing)
- FSM transition overhead (~5 cycles: STORE_END, WAIT_NEXT_F,
  COPY2, COMP_START, STORE_START)
- handshake sync cycles (reacting to compute_done / fetch_done)

### 7. Engineering Insights

1. Widening the memory word is the classic way to increase
   memory bandwidth without more cycles.

2. Bottleneck migration is iterative:
   fetch(48) -> hidden by double buffer -> fetch(12) -> now
   store(16) + control overhead dominates.

3. Pipeline bubbles are unavoidable in an FSM-based controller;
   they can be reduced but never fully removed.

4. The store is the next stage to optimize: it is not overlapped
   with the following compute.

### 8. Debugging Record

No functional bugs. One design consideration: the testbench must
pack elements into words with the same byte order the fetch
unpacks (word = {e3,e2,e1,e0}).

Lesson: define the data layout contract clearly between the
software (testbench) and hardware (fetch).

### 9. Hardware Thinking Transfer

```
Narrow SRAM (1 elem/cycle)      fetch = 48
    |
    v
Wide SRAM (4 elem/cycle)        fetch = 12
    |
    v
Output double buffering (Day22)  store hidden behind compute
    |
    v
DMA + burst (real NPUs)         bulk transfers
```

### 10. Future Improvement

- Output double buffering: overlap store(N) with compute(N+1)
- Widen the store path as well
- Reduce FSM overhead (fewer transition states)
- DMA-style bulk load from external memory

### 11. Final Evaluation

Learner can explain:

- why wider memory words speed up fetch
- the fetch 48 -> 12 improvement
- why the total is 147, not the ideal 93 (store serial + FSM overhead)
- where the ~9 cycles of overhead go
- what to optimize next (output double buffering)

Understanding level: Can independently design.

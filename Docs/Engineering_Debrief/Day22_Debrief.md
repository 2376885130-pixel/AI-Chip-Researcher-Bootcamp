# Day22 Engineering Debrief

## Pipelined Store (Output Double Buffer)

### 1. Project Objective

What was built:

npu_storepipe_top.v: the Day21 wide-fetch NPU with the store
decoupled from the compute pipeline. Results are latched into
ping-pong output banks in one cycle; a concurrent store sub-FSM
writes them to the output buffer while the next task computes.

Verified: 4 tasks all PASS. Latency 100 cycles (Day21: 147).

### 2. Why was it built

Day21's per-task interval was ~36 cycles because the store (16
cycles) was serial: the systolic sat idle while results were
written out. Store(16) > compute(11) made the output path the
bottleneck.

### 3. Concept: Decouple the Store

```
Day21: compute(11) -> store(16) -> compute -> store   systolic idles 16
Day22: compute(11) -> [latch 1 cyc] -> compute        store runs in
                          |                              parallel
                        store sub-FSM (16 cyc)
```

Key: results are captured into a register bank in ONE cycle, so
the systolic is immediately free to start the next task.

### 4. Implementation

- Two output banks (out_bank[0:1][0:15]), 32-bit each
- S_LATCH state: copies c[] into the active bank and raises
  store_req (1 cycle)
- Store sub-FSM (ST_IDLE/ST_RUN): writes out_bank[store_task%2]
  to result_mem over 16 cycles, independent of the main FSM
- store_req pending flag: prevents losing a store request when
  the sub-FSM is busy (a 1-entry FIFO handshake)
- Main FSM: S_LATCH -> S_COMP_START/S_WAIT_NEXT_F (no store wait)

### 5. Verification

4 tasks (identity, [1..16]x[16..1], scaled, negatives) all PASS.

Latency:
- Day19: 312, Day20: 243, Day21: 147, Day22: 100

### 6. Latency Analysis

Per-task interval now ~22 cycles (100/4 + first-task amortization).

New throughput bound: the store queue serializes at 16 cycles per
task through the single result-memory write port.

Theoretical for 4 tasks: ~24 (first latch) + 4x16 (stores) = ~88.
Measured 100: ~12 cycles of FSM/handshake overhead remain.

### 7. Engineering Insights

1. Decoupling a slow consumer (store) from a fast producer
   (compute) is the standard way to keep the compute unit busy.

2. The pending flag (store_req) is a minimal handshake / 1-entry
   FIFO: producer asserts, consumer acknowledges, requests never
   lost. This is the foundation of valid/ready handshakes.

3. The bottleneck moved: fetch(48)->12, then store(16) became the
   limiter. Optimization is always chasing the longest stage.

4. Systolic utilization improved dramatically: no more idle
   waiting for the store.

### 8. Debugging Record

Design-time issue caught before simulation: store_req must be a
level (latched) flag, not a pulse, otherwise a store request
arriving while the sub-FSM is busy would be lost. The 2-bank
ping-pong guarantees a bank is never overwritten while being
stored (store of task N finishes before latch of task N+2).

Compile issue: duplicate 'store_state' declaration (part 1 vs
part 3). Removed the duplicate.

### 9. Hardware Thinking Transfer

```
Serial store (Day21)          systolic idles 16 cycles/task
    |
    v
Decoupled store (Day22)       store hidden behind compute
    |
    v
Wider store (Day23)           cut store 16 -> 8 cycles
    |
    v
DMA (Day24)                   bulk transfer to/from external memory
```

### 10. Future Improvement

- Wider store: write 2 results per cycle
- Reduce FSM transition overhead
- Move to DMA + SRAM interface for external memory

### 11. Final Evaluation

Learner can explain:

- why the store was the serial bottleneck in Day21
- how the 1-cycle result latch frees the systolic
- the store_req pending flag as a producer/consumer handshake
- the current theoretical bound (~88) vs measured (100)
- what to optimize next

Understanding level: Can independently design.

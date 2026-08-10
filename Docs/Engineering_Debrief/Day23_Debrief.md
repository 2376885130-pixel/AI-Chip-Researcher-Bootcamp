# Day23 Engineering Debrief

## Wider Store (2-wide Result Write)

### 1. Project Objective

What was built:

npu_wstore_top.v: the Day22 pipelined-store NPU with the result
write widened to 2 results per cycle (two 32-bit results packed
into one 64-bit output-buffer word).

Verified: 4 tasks all PASS. Latency 92 cycles (Day22: 100).

### 2. Why was it built

Day22's store queue serialized at 16 cycles per task through the
single result-memory write port. Packing 2 results per word halves
the store time.

### 3. Concept: Packed Result Words

```
Day22: 16 writes x 1 result  = 16 cycles
Day23:  8 writes x 2 results =  8 cycles
```

Each 64-bit word holds {result[2w+1], result[2w]}.

### 4. Implementation

- OUT_ADDR_WIDTH 6 -> 5 (32 words hold 64 results)
- output_buffer DATA_WIDTH 32 -> 64
- store sub-FSM now counts 8 words per task
- store_waddr = store_task*OUT_WORDS + store_cnt
- read side: CPU reads 64-bit words and unpacks

Debugging: Icarus fails on continuous assigns that index a 2D
unpacked array with a computed expression (store_cnt*2). Fixed by
moving the extraction into an always @(*) procedural block.
Also: the top's result_read_data port was left at 32 bits, so the
upper half (odd results) was truncated. Widened to 64 bits.

### 5. Verification

4 tasks (identity, [1..16]x[16..1], scaled, negatives) all PASS.

Latency:
- Day19: 312, Day20: 243, Day21: 147, Day22: 100, Day23: 92

### 6. Latency Analysis: Diminishing Returns

Store halved (16->8) but total only improved 100->92 (8 cycles).

Why: in Day22 the store (16) was the critical path; in Day23 the
store (8) is shorter than compute+FSM overhead (~21 cycles/task),
so it is now hidden behind the compute pipeline. Optimizing a
stage that is no longer on the critical path gives little gain.

Per-task interval now ~23 cycles, dominated by:
- compute (11) + latch (1)
- FSM transition overhead (~9-11)

### 7. Engineering Insights

1. Optimize only what is on the critical path. The store was the
   limiter in Day22; once shortened, the compute/control path
   became the limiter.

2. Memory widening has diminishing returns once the memory stages
   are hidden behind compute.

3. The bottleneck has moved from data movement to control:
   the FSM transition overhead is now a significant fraction.

4. 3.39x cumulative speedup (312 -> 92) closes the on-chip data
   path optimization; the next big item is external memory (DMA).

### 8. Debugging Record

Two issues:
1. Icarus expr_synth assertion on variable-indexed unpacked array
   access in a continuous assign -> moved to always @(*).
2. result_read_data port width (32 vs 64) truncated odd results
   -> widened the top port.

Lessons: check port widths at every hierarchy level when
widening a datapath; know your simulator's array-indexing limits.

### 9. Hardware Thinking Transfer

```
On-chip data path optimized (Day19-23):  312 -> 92 cycles
    |
    v
DMA + SRAM interface (Day24)             bulk external transfers
    |
    v
Burst / AXI (Day25)                      industrial protocols
    |
    v
Full NPU memory system
```

### 10. Future Improvement

- Reduce FSM transition overhead (pipeline the control)
- DMA controller for external memory <-> buffer transfers
- SRAM interface with proper address generation
- Larger matrices via tiling

### 11. Final Evaluation

Learner can explain:

- why store halving saved only 8 cycles (critical path analysis)
- the new bottleneck (compute + FSM overhead)
- why further memory widening has diminishing returns
- what to do next (DMA / SRAM interface)

Understanding level: Can independently design.

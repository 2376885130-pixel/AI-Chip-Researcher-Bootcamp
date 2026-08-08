# Day17 Engineering Debrief

## Parallel Matrix Multiply (Spatial Parallelism)

### 1. Project Objective

What was built:

A parallel 2x2 matrix multiplier, RTL/Day17/matmul_2x2.v, that computes
all four output elements of C = A x B simultaneously using four
independent MAC units.

```
A = [1 2]      B = [5 6]      C = [19 22]
    [3 4]          [7 8]          [43 50]
```

No external memory interface. Pure compute core with an FSM controller.

### 2. Why was it built

Day16 computed a 2x2 matrix multiply by reusing ONE dot-product unit
4 times in time: about 88 cycles total. This is slow.

Day17 answers the design question:

How do we make the matrix multiply faster in hardware?

Answer: spatial parallelism. Give each output element its own MAC
unit and let all MACs work at the same time.

### 3. Concept: Temporal vs Spatial Parallelism

Day16 (temporal):  1 MAC  x  4 time slots  =  88 cycles
Day17 (spatial):   4 MACs x  1 time step   =   2 cycles (compute)

Key principle:

Latency is determined by the accumulation depth of each output
(K terms per dot product), NOT by the number of outputs.

A 2x2 matrix has K=2, so each MAC needs only 2 multiply-accumulate
operations -> 2 cycles.

### 4. Architecture

```
            a00,a01           a10,a11
              |                  |
   b00,b01 ---+--> MAC00/MAC01   |
   b10,b11 ---+-----------------> MAC10/MAC11
              |                  |
            c00,c01            c10,c11
```

Four MAC units, each computing one output:

```
c00 = a00*b00 + a01*b10
c01 = a00*b01 + a01*b11
c10 = a10*b00 + a11*b10
c11 = a10*b01 + a11*b11
```

FSM: IDLE -> MAC1 (k=0 product) -> MAC2 (k=1 product + result) -> IDLE

### 5. Implementation Details

- 8-bit signed inputs, 16-bit products, 32-bit accumulators
- Eight product wires (p0_c00 ... p1_c11) keep the multiply width
  explicit and avoid truncation issues
- Four independent 32-bit accumulators (acc00..acc11)
- In MAC2, the result is captured in the same cycle the second
  product is added (non-blocking assignment uses the MAC1 value),
  the same technique used in the Day14 dot_product_engine

### 6. Verification

Compile: iverilog -g2012

Test 1: A=[1 2;3 4] B=[5 6;7 8] -> C=[19 22;43 50] PASS
  - same data as Day16, result matches exactly

Test 2: A=[-1 2;3 -4] B=[2 -1;0 3] -> C=[-2 7;6 -15] PASS
  - verifies signed/negative arithmetic

Measured latency: 2 cycles per matrix multiply.

### 7. Latency Comparison

| Implementation | Latency | Hardware |
| -------------- | ------- | -------- |
| Day16 serial   | ~88 cyc | 1 MAC    |
| Day17 parallel | 2 cyc   | 4 MACs   |

Speedup: ~44x. Cost: 4x the multipliers/adders (area).

### 8. Engineering Insights

1. Spatial parallelism: more hardware in exchange for less time.
   This is the fundamental area-speed trade-off of hardware design.

2. Latency formula (simplified):
   serial:  outputs x K cycles
   parallel: K cycles (if outputs have dedicated MACs)

3. Scaling: a 4x4 matrix fully parallel needs 16 MACs. This is why
   real NPUs pack hundreds/thousands of MAC units.

4. The Day17 MACs are independent: each reads its own inputs directly.
   No data is shared between PEs. This is the KEY difference from a
   systolic array, where data flows between neighboring PEs (data
   reuse without re-broadcasting).

### 9. Debugging Record

No RTL bugs were found in this session.

Potential issues to watch (from Day14 experience):
- product width: explicit 16-bit product wires avoid truncation
- non-blocking assignment: result must be captured in the MAC2 cycle
  using the old accumulator value

### 10. Hardware Thinking Transfer

```
Independent parallel MACs (Day17)
    |
    v
Systolic array with data flow (Day18)
    |
    v
NPU compute array
```

Day17 is the stepping stone: same 4 MACs, but no data reuse yet.
Day18 adds dataflow so neighboring PEs share data, reducing input
bandwidth.

### 11. Future Improvement

- Connect the 4-MAC array to the Day14 NPU memory interface
- Generalize to NxN matrices (parameterized generate loops)
- Add dataflow (systolic) for data reuse
- Pipeline the multiply and accumulate stages

### 12. Final Evaluation

Learner can explain:

- temporal vs spatial parallelism
- why latency is 2 cycles (accumulation depth, not output count)
- the area cost of parallelism (4x hardware)
- why 4x4 needs 16 MACs
- the difference between independent PEs and systolic dataflow

Understanding level: Understand -> Can independently design.

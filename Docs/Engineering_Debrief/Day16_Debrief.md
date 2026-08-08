# Day16 Engineering Debrief

## Matrix Multiplication Workload on the NPU

### 1. Project Objective

What was built:

The Day14 NPU (a dot-product accelerator) executed its first real
matrix multiplication workload end-to-end:

```
C = A x B

A = [1 2]      B = [5 6]      C = [19 22]
    [3 4]          [7 8]          [43 50]
```

RTL was NOT modified. Only a new verification environment was created:

- Testbench/Day16/npu_matmuls_tb.v

### 2. Why was it built

A real AI accelerator must compute matrix multiplication. Every neural
network layer is essentially Y = W x X.

The Day14 NPU could only compute ONE dot product per task. Day16
answered the core design question:

How do we turn a dot-product machine into a matrix multiplier?

Answer:

```
Matrix multiplication = a set of dot products.
A 2x2 matrix multiply = 4 dot-product tasks
                        (one per output element).
```

### 3. Key Concept: Matrix Multiply Decomposition

Each output element is one dot product of a row and a column:

```
C[i][j] = A row i . B col j
```

```
C[0][0] = 1*5 + 2*7 = 19
C[0][1] = 1*6 + 2*8 = 22
C[1][0] = 3*5 + 4*7 = 43
C[1][1] = 3*6 + 4*8 = 50
```

### 4. Data Mapping (the critical design decision)

One NPU task computes:

```
result = w[0]*a[0] + w[1]*a[1] + w[2]*a[2] + w[3]*a[3]
```

Therefore:

| NPU interface     | What it stores      | Why                          |
| ----------------- | ------------------- | ---------------------------- |
| activation buffer | a row of A          | rows expand into dot terms   |
| weight buffer     | a column of B       | columns get multiplied       |
| output buffer     | one element of C    | one task = one output        |

Task schedule:

| Task | C element | activation (A row) | weight (B col) | result | output addr |
| ---- | --------- | ------------------ | -------------- | ------ | ----------- |
| 1    | C[0][0]   | [1,2]              | [5,7]          | 19     | 0           |
| 2    | C[0][1]   | [1,2]              | [6,8]          | 22     | 1           |
| 3    | C[1][0]   | [3,4]              | [5,7]          | 43     | 2           |
| 4    | C[1][1]   | [3,4]              | [6,8]          | 50     | 3           |

### 5. Implementation

Reused the Day14 testbench task library:

- write_weight
- write_activation
- load_task
- start_npu_task
- wait_for_done
- read_result

Added:

- four task calls driven by the mapping table above
- four result registers (c00, c01, c10, c11)
- C matrix display
- self-checking verification with expected values

### 6. Verification

Compile flag (required by SystemVerilog unpacked-array ports):

```
iverilog -g2012
```

Simulation output:

```
C = [19 22]
    [43 50]

C[0][0] = 19  PASS (expected 19)
C[0][1] = 22  PASS (expected 22)
C[1][0] = 43  PASS (expected 43)
C[1][1] = 50  PASS (expected 50)

# DAY16 MATRIX MULTIPLY PASS #
```

Waveform: Simulation/Day16/matmuls.vcd

### 7. Timing Analysis

One task takes about 22 cycles:

| Phase  | Cycles | Detail                                    |
| ------ | ------ | ----------------------------------------- |
| Fetch  | ~12    | 4 elements x 3 (issue, SRAM read, capture)|
| Compute| 4      | 1 MAC per cycle (serial accumulation)     |
| Control| ~6     | FSM transitions + result store + done     |

4 tasks executed serially: total about 88 cycles.

Key insight:

The accumulator feedback path (acc <= acc + product) creates a serial
dependency between cycles. This is exactly why real chips parallelize
with systolic arrays instead of serial dot products.

### 8. Engineering Insights

1. Data reuse

   A row 0 [1,2] is reused by tasks 1 and 2.
   B col 0 [5,7] is reused by tasks 1 and 3.

   Keeping reused data on-chip reduces DRAM traffic. This motivates
   buffer hierarchy and dataflow optimization (weight stationary /
   activation stationary / output stationary).

2. Signed arithmetic

   All buffers and the compute path use the signed type, so negative
   numbers multiply correctly using two's complement.

3. Software-hardware co-design

   The workload (task scheduling, data layout) is organized on the
   CPU/testbench side while the hardware stays fixed. Real systems do
   the same: software schedules tiles onto a fixed accelerator.

### 9. Debugging Record

Problem:

```
Ports cannot be unpacked arrays.
Try enabling SystemVerilog support.
```

Cause: Day14 RTL uses SystemVerilog unpacked-array ports.

Solution: compile with iverilog -g2012.

Lesson: always match compile flags to the language features used by
the RTL under test.

### 10. Hardware Thinking Transfer

```
Serial dot product (Day14)
    |
    v
Tiled matrix multiply (Day16)
    |
    v
Parallel systolic array (Day17)
```

Current limitation discovered:

The 4 dot products are executed serially (~88 cycles). Day17 will
integrate systolic_array_4x4.v (already designed in Day12) so the 4
dot products execute in parallel, then verify the result matches the
Day16 serial result.

### 11. Future Improvement

- Widen OUTPUT_ADDR_WIDTH to support 4x4 (and larger) matrices
- Parallelize tasks with the systolic array
- Pipeline fetch and compute to hide latency
- Add a hardware scheduler for the tile loop

### 12. Final Evaluation

Learner can explain:

- how matrix multiply decomposes into dot products
- the data mapping rule (activation = row, weight = column)
- why the accumulator steps one element per cycle
- where data reuse occurs and its benefit
- why signed declarations handle negative numbers

Understanding level: Understand -> Can modify.

# Day18 Engineering Debrief

## Systolic Array Dataflow (2x2 Matrix Multiply)

### 1. Project Objective

What was built:

A 2x2 systolic array that computes C = A x B using four pe_unit
modules reused from Day14. The array is the first real systolic
GEMM dataflow in this bootcamp.

```
A = [1 2]      B = [5 6]      C = [19 22]
    [3 4]          [7 8]          [43 50]
```

### 2. Why was it built

Day17 parallelized the 4 dot products with 4 independent MACs, but
each MAC fetched its own copy of the data (fan-out). This does not
scale: for a 4x4 matrix every input would need to be wired/broadcast
to 4 PEs.

Systolic arrays solve this by moving data through the array: each
input enters the boundary once and flows through neighboring PEs,
so it is reused without extra I/O.

### 3. The Key Insight: Skew Scheduling

A naive array (like the Day12 systolic_array_4x4) holds boundary
inputs constant, so every PE multiplies the same value every cycle.
That is not matrix multiply.

For PE(i,j) to compute C[i][j] = sum_k A[i][k]*B[k][j], the terms
A[i][k] and B[k][j] must arrive at the same PE at the same cycle.
Because data takes one cycle per hop, the boundary feeds must be
skewed:

```
A[i][k] enters row i at cycle  k + i
B[k][j] enters col j at cycle  k + j
```

Derivation: activation needs j hops to reach PE(i,j), weight needs
i hops. At cycle t, PE(i,j) sees activation A[i][t-1-i-j] and
weight B[t-1-i-j][j]. Both use index k = t-1-i-j, so they match.

This single idea turns the array into a real GEMM engine.

### 4. Architecture

```
            b(0,0)  b(0,1)      <- top boundary, skewed
              |       |
 a(row0) --> PE00 --> PE01
              |       |
 a(row1) --> PE10 --> PE11
              |       |
            c(0,0)  c(1,1)
```

- activations flow left -> right
- weights flow top -> down
- each PE accumulates activation_in * weight_in in place

Controller states:
S_CLR (clear) -> S_FEED0 -> S_FEED1 -> S_FEED2 -> S_DRAIN (done)

### 5. Implementation

- Reused Day14 RTL/Day14/Compute/pe_unit.v (IP reuse)
- 4 pe_unit instances wired as a 2x2 grid
- Boundary values are combinational functions of the controller state
- Latency measured: 5 cycles

### 6. Verification

Test 1: A=[1 2;3 4] B=[5 6;7 8] -> C=[19 22;43 50] PASS
  - identical to Day16 and Day17 results

Test 2: A=[-1 2;3 -4] B=[2 -1;0 3] -> C=[-2 7;6 -15] PASS
  - signed/negative arithmetic through the dataflow

### 7. Latency Comparison (2x2 matrix)

| Implementation | Latency | Data sharing |
| -------------- | ------- | ------------ |
| Day16 serial   | ~88 cyc | none         |
| Day17 parallel | 2 cyc   | fan-out      |
| Day18 systolic | 5 cyc   | data flow    |

Systolic is slower on a tiny 2x2 matrix because of pipeline fill
(1 clear + 3 feed + 1 drain). Its advantage appears at scale.

### 8. Engineering Insights

1. Data reuse: one input enters the array once and is used by every
   PE along its path. a00 is used by PE00 and PE01.

2. I/O bandwidth: the boundary only needs N values per cycle,
   independent of array size. A broadcast/parallel design needs
   O(N^2) fan-out. This is why systolic arrays scale.

3. Latency of an NxN systolic GEMM is roughly 3N-1 cycles
   (fill + compute + drain).

4. Day12's systolic_array_4x4 could not compute GEMM because its
   boundary inputs were static (no skew).

5. Honest trade-off: for tiny matrices, parallel MACs (Day17) win
   on latency; systolic wins at scale on bandwidth.

### 9. Debugging Record

No functional bugs in the final design.

Key timing risk understood: the last PE (PE11, the bottom-right
corner) completes one cycle after the others, so the DRAIN state
must exist before asserting done.

### 10. Hardware Thinking Transfer

```
Independent parallel MACs (Day17)
    |
    v
Systolic array with skew dataflow (Day18)
    |
    v
NPU compute array (many PEs, streaming data)
```

This is the compute core pattern used by real systolic NPUs
(e.g., Google TPU).

### 11. Future Improvement

- Scale the array to 4x4 (and parameterize by matrix size)
- Connect the array to the Day14 buffers (weight/activation/output)
- Replace the serial dot_product_engine in the NPU with the array
- Add weight preloading and multi-tile scheduling

### 12. Final Evaluation

Learner can explain:

- why the naive Day12 array failed (no skew)
- the skew schedule A[i][k] at k+i, B[k][j] at k+j
- where data is reused in the array
- why systolic wins at scale (I/O bandwidth)
- why PE11 (corner) finishes last

Understanding level: Understand -> Can independently design.

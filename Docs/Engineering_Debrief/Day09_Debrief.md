# Day09 Engineering Debrief

## Project: Pipeline MAC Unit


## Objective

Implemented a pipelined MAC (Multiply-Accumulate) processing unit.

The goal was to understand:

- Pipeline architecture
- Register-based stage separation
- Latency
- Throughput
- Data alignment between pipeline stages


---

# Architecture


Input:

- activation: INT8
- weight: INT8
- partial_sum: INT32


Computation:

INT8 × INT8 → INT16 product

INT16 + INT32 → INT32 accumulation



Pipeline structure:


Stage 1:

- Multiplier
- Partial sum alignment


Registers:

- product_reg
- partial_sum_reg



Stage 2:

- Adder
- result_reg



---

# Key Learning


## Pipeline does not make one operation faster


A single MAC still requires the same computation:

multiply + accumulate


Pipeline improves throughput by allowing multiple operations to overlap.



Example:


Cycle 1:

MAC1 Multiply


Cycle 2:

MAC2 Multiply

MAC1 Add


Cycle 3:

MAC3 Multiply

MAC2 Add



After pipeline filling:

One MAC result is produced every cycle.



---

# Latency vs Throughput


Latency:

Time from input to corresponding output.


Pipeline MAC latency:

2 cycles



Throughput:

Number of results produced per cycle.


Pipeline MAC throughput:

1 result / cycle after pipeline filling.



---

# Debug Experience


Initial verification failed because:

- Testbench timing did not match RTL pipeline latency
- Inputs were changed at clock edges causing race conditions


Root causes:

1. misunderstanding of non-blocking assignment timing
2. misunderstanding of register boundaries
3. incorrect output checking cycle


Solutions:

- Drive inputs on negedge clk
- Check outputs after clock update
- Build pipeline-aware verification


---

# Important Hardware Insight


Registers are not only storage elements.

In a pipeline:

Registers control when data reaches the next computation stage.


Increasing registers:

- reduces critical path
- allows higher clock frequency
- increases throughput


---

# Connection to AI Accelerator


Pipeline MAC is the fundamental processing element of:

- PE Array
- Systolic Array
- NPU Accelerator


Large AI accelerators achieve performance by:

- replicating many MAC units
- deeply pipelining computation
- maximizing data reuse


---

# Verification Result


Simulation:

PASS=6 FAIL=0


Verified:

- pipeline latency
- continuous input stream
- correct data alignment
- correct MAC computation

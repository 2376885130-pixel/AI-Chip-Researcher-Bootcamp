# AI-Chip-Researcher-Bootcamp


<p align="center">

AI Accelerator / NPU / Digital IC Research Training

</p>


---

# Overview


This repository records my journey
towards becoming an AI hardware researcher.


The goal is not only to learn HDL syntax,
but to develop the ability to:


- Design digital hardware
- Implement RTL architecture
- Verify hardware behavior
- Understand AI accelerator architecture
- Build complete AI hardware systems


Learning philosophy:


> Project-driven learning.
> Understanding before implementation.


---

# Research Direction


## AI Accelerator


Current interests:


- Matrix multiplication acceleration
- Neural network hardware optimization
- Efficient computation architecture



## Digital IC Design


Focus:


- RTL design
- Hardware architecture
- Verification methodology
- Pipelining



## NPU Architecture


Future focus:


- MAC array
- Processing Element (PE)
- Systolic Array
- Memory architecture
- Control architecture


---

# Learning Roadmap


# Phase 1

## Development Environment


Status:

✅ Completed


Completed:


- Linux environment
- WSL2 Ubuntu
- Git workflow
- Verilog simulation environment
- GitHub SSH workflow



---


# Phase 2

## RTL Design Fundamentals


Status:

🚧 In Progress


Completed:


- Verilog module design
- Combinational logic
- MUX design
- Bus signals
- RTL simulation workflow
- Sequential logic
- Clock and reset
- Registers
- Counters


Current:


- Finite State Machine (FSM)
- Hardware controller design



Topics:


- Verilog/SystemVerilog
- Module design
- Combinational logic
- Sequential logic
- Clock and reset
- FSM



---


# Phase 3

## Hardware Verification


Topics:


- Testbench methodology
- Simulation
- Waveform analysis
- Assertions
- Verification strategy



---


# Phase 4

## Digital Hardware Architecture


Topics:


- Register
- FIFO
- Pipeline
- Memory interface
- Controller



---


# Phase 5

## AI Accelerator Design


Target project:


Build a simple AI accelerator.



Architecture path:


Logic Gate


↓


RTL Module


↓


MAC Unit


↓


Processing Element


↓


Systolic Array


↓


Matrix Multiplication Accelerator


↓


NPU Architecture



---

# Completed Projects



# Day01

## First RTL Simulation


Project:


AND Gate


Files:

Day01/

├── and_gate.v

├── and_gate_tb.v

├── and_gate_sim

└── and_gate.vcd



Workflow:


RTL

↓

Compilation

↓

Simulation

↓

Waveform Verification


Key Concepts:


- Basic Verilog module
- Testbench
- Simulation workflow
- GTKWave analysis


Result:


✅ Completed



---


# Day02

## Combinational Logic and Data Path


Projects:


## 1-bit MUX


File:

RTL/Day02/

└── mux2.v



Concepts:


- Multiplexer
- Conditional operator
- Combinational logic



---


## 8-bit MUX


File:

RTL/Day02/

└── mux8.v



Concepts:


- Bus
- Data width
- Vector signals
- Parallel hardware structure



Verification:

Testbench/Day02/

├── mux2_tb.v

└── mux8_tb.v



Simulation:

Simulation/Day02/

├── mux2

└── mux8



Key Understanding:


Verilog describes hardware structure,
not software execution.


Result:


✅ Completed



---


# Day03

## Sequential Logic Fundamentals


Projects:


## D Flip-Flop


File:

RTL/Day03/dff.v



Concepts:


- Clock edge
- always @(posedge clk)
- Non-blocking assignment
- Single bit storage



---


## D Flip-Flop with Reset


File:

RTL/Day03/dff_reset.v



Concepts:


- Synchronous reset
- Hardware initialization
- Known system state



---


## 8-bit Register


File:

RTL/Day03/register8.v



Concepts:


- Data bus
- Parallel storage
- Register design



---


## Counter


File:

RTL/Day03/counter8.v



Concepts:


- Feedback path
- Register + Adder
- State update
- Clock-driven operation



Verification:

Testbench/Day03/

├── dff_tb.v

├── dff_reset_tb.v

├── register8_tb.v

└── counter8_tb.v



Simulation:

Simulation/Day03/

├── dff

├── dff_reset

├── register8

└── counter8



Key Understanding:


Sequential logic introduces:


- Clock
- State
- Memory
- Timing relationship



Result:


✅ Completed
# Day04

## Finite State Machine Controller


Project:

Traffic Light FSM


Completed:


- Moore FSM design
- Three-stage FSM architecture
- State encoding
- State register
- Next state logic
- Output logic
- Testbench verification
- Waveform analysis


Files:


RTL/Day04/

└── traffic_light_fsm.v


Testbench/Day04/

└── traffic_light_tb.v


Simulation:


traffic_light.vcd


Key Understanding:


FSM converts behavioral requirements
into synchronous hardware control logic.


Result:

✅ Completed

# Day05

## Parameterized RTL Counter


Project:

Parameterized Counter


Completed:


- Parameter design
- Configurable data width
- Sequential logic
- Enable control
- Reset control
- Testbench verification
- Waveform analysis


Files:


RTL/Day05/

└── counter_param.v


Testbench/Day05/

└── counter_param_tb.v


Simulation:


counter_param.vcd


Key Understanding:


Parameterized RTL creates reusable hardware IP.


Result:

✅ Completed
---
# Day06

## Parameterized Register Bank IP


Project:

Register Bank Hardware IP


Completed:


- Register bank architecture design
- Parameterized DATA_WIDTH and DEPTH
- Register array implementation
- Synchronous write logic
- Combinational read logic
- Self-checking testbench
- Parameter scalability verification
- Waveform generation and analysis


Files:


RTL/Day06/

└── register_bank.v


Testbench/Day06/

└── register_bank_tb.v


Simulation:


register_bank.vcd


Key Understanding:


Parameterized RTL enables reusable hardware IP design.


Register Bank provides fast internal storage
for processors and AI accelerator architectures.


Verification:


- Multiple register address testing
- Automatic PASS/FAIL checking
- Configurable DATA_WIDTH
- Configurable DEPTH


Result:



✅ Completed

## Day07 - Arithmetic IP Design ✅

Completed:

- Parameterized Adder IP
- Parameterized Multiplier IP
- MAC Unit

Hardware Concepts:

- Arithmetic datapath
- Bit-width expansion
- Carry handling
- Partial product accumulation
- Sequential accumulator register

RTL:

- RTL/Day07/adder_param.v
- RTL/Day07/multiplier_param.v
- RTL/Day07/mac_unit.v

Verification:

- Icarus Verilog simulation
- GTKWave waveform analysis

Git Milestone:

- Adder IP completed
- Multiplier IP completed
- MAC Unit completed
## Day08 - Processing Element (PE) ✅


Implemented the first AI Accelerator compute unit.


Completed:

- PE RTL design
- MAC + accumulator architecture
- Partial sum handling
- Self-checking testbench
- GTKWave waveform verification


Hardware concept:


PE = Multiplier + Adder + Register



The PE performs:


partial_sum = partial_sum + activation × weight



This module is the basic building block for:


PE Array

↓

Systolic Array

↓

AI Accelerator



# Engineering Documentation
# Day09 Progress: Pipeline MAC

## Implemented

A two-stage pipelined MAC unit.


Architecture:


INT8 Activation
|
|
Multiplier
|
v
product_reg
|
|
+------+
|
v
Adder
|
v
result_reg



## Hardware Features

- Parameterized data width
- INT8 multiplication
- INT32 accumulation
- Pipeline registers
- Self-checking verification


## Verification

Simulation environment:


RTL/Day09/pipeline_mac.v

Testbench/Day09/pipeline_mac_tb.v

Simulation/Day09/pipeline_mac.vcd



Result:


PASS=6 FAIL=0



## Key Concepts Learned

- Pipeline latency
- Pipeline throughput
- Register boundaries
- Non-blocking assignment behavior
- Data synchronization


Next:

Day10 - PE Array and parallel MAC architecture

This repository maintains:

### Day10: Parameterized PE Array

Implemented a scalable Processing Element Array.

Features:

- Parameterized PE count using NUM_PE
- Generate-based hardware instantiation
- Independent accumulator for each PE
- Packed input/output bus design
- Parallel MAC computation

Verification:

- NUM_PE = 4
- PE0: 2×3 = 6
- PE1: 4×5 = 20
- PE2: 6×7 = 42
- PE3: 8×9 = 72

All tests passed.

## AI_Mentor_DNA.md


Defines:


- AI teaching rules
- Learning methodology
- Engineering workflow



---


## Bootcamp_Progress.md


Tracks:


- Current learning status
- Completed tasks
- Future objectives

## Latest Progress

### Day11 - Systolic PE Chain

Completed:

- Parameterized PE Unit
- Weight stationary datapath
- Partial sum pipeline
- Activation forwarding
- Parameterized PE Chain

Verification:


PE_CHAIN TEST PASS
Final Result = 14


Hardware concepts:

- Dataflow architecture
- Systolic pipeline
- Weight stationary
- Partial sum accumulation
- Generate-based hardware scaling

## Current Progress


### AI Accelerator Development


Completed:


### RTL IP

- MAC Unit
- Processing Element
- Parameterized PE
- PE Array


### Accelerator Architecture

- Systolic Array structure
- Controller FSM
- Data Loader Framework


Current Stage:


Accelerator integration and memory architecture.


Roadmap:


RTL Design

↓

MAC

↓

PE

↓

Systolic Array

↓

Tile Matrix Engine

↓

NPU Architecture

## Day12 - AI Accelerator Framework Integration ✅

Day12 completed the first complete accelerator framework integration.

Implemented:

* Processing Element (PE)
* 4×4 Systolic Array Framework
* Controller FSM
* Weight Loader
* Activation Loader
* Accelerator Top

Architecture:

```
             START

               |

        Controller FSM

          /        \

         /          \

Weight Loader   Activation Loader

         \          /

          \        /

        Systolic Array

               |

             RESULT

               |

              DONE

```

Verification:

```
PE Unit                    PASS

Systolic Array Framework   PASS

Controller FSM             PASS

Weight Loader              PASS

Activation Loader          PASS

Accelerator Top            PASS
```

Key lessons:

* Non-blocking assignment introduces clock-cycle latency.
* Hardware verification must match architecture intent.
* Systolic arrays rely on controlled data movement.
* Accelerator performance depends on compute, dataflow, and control together.

Day12 milestone:

Completed transition from individual RTL components to an integrated AI Accelerator Framework.

# Day13 - Accelerator Architecture Understanding

Day13 focuses on understanding the architecture behind the Day12 AI Accelerator Framework.

Instead of creating new RTL modules, the goal is to analyze how multiple hardware blocks cooperate to form a complete accelerator.

---

## Architecture Overview

The accelerator consists of:

```
Accelerator

├── Controller FSM
│
├── Weight Loader
│
├── Activation Loader
│
└── Systolic Array
        |
        |
       PE Units
```

---

## Key Concepts Learned

### 1. Control Path vs Data Path

Modern AI accelerators separate:

### Control Path

Responsible for:

* scheduling
* state management
* generating control signals

Implemented by:

```
controller_fsm
```

---

### Data Path

Responsible for:

* moving data
* performing computation

Implemented by:

```
weight_loader

activation_loader

systolic_array

PE
```

---

## 2. FSM Role

FSM does not perform computation.

It controls:

```
IDLE

LOAD_WEIGHT

COMPUTE

OUTPUT

CLEAR
```

The FSM decides when computation happens, while PE units execute MAC operations.

---

## 3. Systolic Array

A 4×4 Systolic Array contains:

```
16 Processing Elements
```

Each PE performs:

```
Multiply + Accumulate
```

Data movement:

Activation:

```
horizontal flow
```

Weight:

```
vertical flow
```

This enables massive parallel computation.

---

## 4. Future NPU Upgrade Direction

The current accelerator is a learning framework.

Future improvements:

```
CPU Interface

↓

Memory Controller

↓

SRAM Buffer

↓

Scheduler

↓

Systolic Array

↓

Result
```

Important future topics:

* DMA
* SRAM architecture
* Tile scheduling
* Pipeline control
* Compute handshake
* NPU architecture

Day14

✔ NPU Controller

✔ Data Fetch Controller

✔ Weight Buffer

✔ Activation Buffer

✔ Output Buffer

✔ Dot Product Engine

✔ NPU Top

✔ Complete Verification

✔ GTKWave Verification

Status

PASS

## Day15 - Verification and Waveform Debugging


Day15 focuses on understanding the verification environment and RTL debugging.


### Key Concepts


#### DUT Hierarchy

The testbench instantiates the NPU:

```verilog
npu_top dut();

The hierarchy becomes:

npu_tb

└── dut

    ├── Controller

    ├── Fetch Controller

    ├── Compute Engine

    ├── Memory Blocks

    └── Output Buffer

GTKWave displays this hierarchy because the testbench exports the simulation hierarchy using:

$dumpvars(0,npu_tb);
Debug Workflow

Verify system handshake

start → processing → done

Verify controller FSM

Verify memory data movement

Verify MAC computation

Verify output storage

Day15 milestone:

Understanding how RTL modules become a complete simulated hardware system.

## Day16 - Matrix Multiplication Workload

Status: PASS ✅

Completed:

- First real AI workload on the NPU: C = A x B
- Decomposed 2x2 matrix multiply into 4 dot-product tasks
- Designed data mapping: activation <- row of A, weight <- column of B
- Created Testbench/Day16/npu_matmuls_tb.v
- Verified C = [19 22; 43 50] end-to-end
- Reused Day14 NPU RTL without any modification
- Analyzed dataflow and task timing

Verification:

- C[0][0] = 19 PASS
- C[0][1] = 22 PASS
- C[1][0] = 43 PASS
- C[1][1] = 50 PASS

Key engineering understanding:

1. Matrix multiplication = a set of dot products
2. One NPU task = one dot product = one output element
3. Data reuse: A row reused across columns, B column reused across rows
4. Serial MAC latency: one element per cycle, VECTOR_LEN=4 -> 4 cycles
5. One task latency ~22 cycles (fetch ~12 + compute 4 + control ~6)
6. signed types enable correct negative-number arithmetic
7. Serial execution is slow -> motivates systolic array parallelism

Next:

Day17 - Parallel Matrix Multiply

## Day17 - Parallel Matrix Multiply

Status: PASS ✅

Completed:

- Designed parallel 2x2 matrix multiply with 4 independent MACs
- Spatial parallelism: one MAC per output element
- Created RTL/Day17/matmul_2x2.v
- Created Testbench/Day17/matmul_2x2_tb.v
- Verified C = [19 22; 43 50] (matches Day16 serial result)
- Verified signed negatives: C = [-2 7; 6 -15]
- Measured latency: 2 cycles vs Day16 ~88 cycles (~44x speedup)

Key engineering understanding:

1. Latency = accumulation depth per output (K=2), not output count (4)
2. Area-speed trade-off: 4x hardware for 44x speedup
3. 4x4 full parallel needs 16 MACs
4. Day17 PEs are independent (no data sharing)
5. Next step: systolic array dataflow for data reuse

Next:

Day18 - Systolic Array Dataflow

## Day18 - Systolic Array Dataflow

Status: PASS ✅

Completed:

- Built 2x2 systolic array reusing Day14 pe_unit IP (4 PEs)
- Applied skew scheduling: A[i][k] enters row i at cycle k+i, B[k][j] enters col j at cycle k+j
- Dataflow: activations flow left->right, weights flow top->down
- Created RTL/Day18/systolic_matmul_2x2.v
- Created Testbench/Day18/systolic_matmul_2x2_tb.v
- Verified C = [19 22; 43 50] (matches Day16/17 results)
- Verified signed negatives: C = [-2 7; 6 -15]
- Latency: 5 cycles (clear + fill + compute + drain)

Key engineering understanding:

1. Skew scheduling is the key to systolic GEMM
2. Data reuse: each input enters the array once and flows through multiple PEs
3. Latency ~3N-1 for NxN (pipeline fill + compute + drain)
4. Systolic wins at scale: I/O bandwidth stays O(N), not O(N^2)
5. Day12 array failed GEMM because boundary data was static (no skew)
6. For tiny matrices parallel MACs (Day17) beat systolic on latency

Next:

Day19 - Systolic NPU Integration

## Day19 - Systolic NPU Integration

Status: PASS ✅

Completed:

- Generalized systolic array to parameterized NxN (generate loops)
- Built RTL/Day19/systolic_matmul.v (N=4, 16 PEs)
- Built RTL/Day19/fetch16.v (16-element fetch)
- Built RTL/Day19/npu_systolic_top.v (buffers + fetch + systolic + output)
- Verified full 4x4 matrix multiply through the NPU
- Test1 (A=identity): C = B PASS (16/16)
- Test2 (A=B=1..16): matches reference PASS (16/16)
- Latency ~78 cycles (fetch 48 + systolic 11 + store 16)

Key engineering understanding:

1. Compute dropped from ~352 to 11 cycles; memory now dominates (memory wall)
2. Fetch (48) + store (16) = 64 cycles is the new bottleneck
3. Debug: results must persist after done (clear only at new task start)
4. Interface timing: producer valid window must cover consumer read duration
5. Real NPUs use DMA, double buffering, wide buses to hide memory latency

Next:

Day20 - Double Buffering

## Day20 - Double Buffering

Status: PASS ✅

Completed:

- Built npu_pipelined_top.v: 4 consecutive 4x4 matrix multiplies
- Ping-pong banks: compute uses bank[task%2], fetch fills the other
- Built fetch16b.v (fetch with per-task base address)
- Overlapped fetch of task N+1 with compute/store of task N
- Verified 4 tasks against reference model (16/16 each, all PASS)
- Serial: ~312 cycles, double buffered: 243 cycles (~1.28x)

Key engineering understanding:

1. Double buffering hides the shorter stage behind the longer one
2. Steady-state interval = max(fetch, compute+store) = max(48, 27) = 48
3. Fetch is still the bottleneck -> need a wider fetch next
4. First task fetch is pipeline fill (cannot be hidden)
5. Cost: 2x input register banks + pipelined controller

Next:

Day22 - Pipelined Store (Output Double Buffer)

## Day21 - Wider Data Path (4-wide fetch)

Status

PASS

Completed:

- 32-bit wide SRAM words (4 packed 8-bit elements)
- fetch16w: 4 reads x 3 cycles = 12 (was 48)
- npu_wide_top: wide fetch + double buffer pipeline
- 4 tasks all PASS (same as Day20)
- 147 cycles (Day19: 312, Day20: 243)

Key understanding:

- Wider memory word = more data per access
- New bottleneck: store (16) + FSM overhead
- Next: output double buffering

Day21 milestone:

Fetch dropped 48->12 cycles; total 312->243->147.
Next: Day24 DMA + SRAM interface.

## Day22 - Pipelined Store (Output Double Buffer)

Status

PASS

Completed:

- Decoupled store from the compute pipeline
- 1-cycle result latch + concurrent store sub-FSM
- store_req pending flag (1-entry FIFO handshake)
- 4 tasks all PASS
- 100 cycles (Day21: 147, Day20: 243)

Key understanding:

- Store(16) > compute(11) was the serial bottleneck
- store_req = producer/consumer handshake
- New bound: store queue 16/task
- Next: wider store

Day22 milestone:

Store now runs in parallel with compute; 312->100 cycles.
Next: Day24 DMA + SRAM interface.

## Day23 - Wider Store (2-wide result write)

Status

PASS

Completed:

- 2 results packed per 64-bit output word
- Store 16 -> 8 cycles per task
- 4 tasks all PASS
- 92 cycles (Day22: 100)

Key understanding:

- Store no longer on the critical path (hidden behind compute)
- Diminishing returns of memory widening
- Bottleneck: compute + FSM overhead (~21/task)
- Next: DMA + SRAM interface

Day23 milestone:

On-chip data path optimized 312->92 (3.39x).
Next: Day24 DMA controller + SRAM interface.

## Day24 - Accelerator MVP Interface

Status

PASS

Completed:

- Added `RTL/Day24/ai_accelerator_mvp.v`
- Defined synchronous `start`, `busy`, and `done` control signals
- Prevented host buffer writes while the accelerator is busy
- Added `Testbench/Day24/ai_accelerator_mvp_tb.v`
- Generated `Simulation/Day24/ai_accelerator_mvp.vcd`

Verification:

`DAY24 AI ACCELERATOR MVP PASS`

The MVP interface is intentionally protocol-neutral. A future AXI-Lite or AXI-Stream wrapper can connect to this boundary without changing the systolic compute core.

## Day25 - Synthesizable Store Controller Cleanup

Status

PASS

Completed:

- Removed the multiple procedural driver for `store_req` in the Day23 controller
- Made the store FSM the single sequential owner of request state
- Preserved the Day23 packed-store timing behavior
- Reran Day23 and Day24 workload regressions

Verification:

Day23 wide-store PASS and Day24 MVP PASS.

## Day26 - Regression and FPGA-Ready Interface Review

Status

PASS

Completed:

- Added `scripts/run_regression.sh` for repeatable Day23/Day24 verification
- Documented clock, reset, control, memory, and numeric contracts
- Reviewed production RTL for common non-synthesizable constructs
- Documented remaining KV260 integration work

Verification:

`REGRESSION PASS`

## Day27 - KV260 Vivado Project Skeleton

Status

READY FOR VIVADO

Completed:

- Added `FPGA/KV260/kv260_accelerator_top.v`
- Added `FPGA/KV260/create_kv260_project.tcl`
- Added `FPGA/KV260/kv260_accelerator.xdc`
- Selected KV260 part `xck26-sfvc784-2LV-c`
- Reserved board-specific pin mapping for the final carrier configuration

## Day28-Day35 - AI Accelerator MVP Release

The Ubuntu project now includes `RTL/MVP/ai_accelerator_system.v`, a parameterized accelerator core with task buffers, a scheduler FSM, memory ready/valid writes, result ready/valid back-pressure, timeout/error handling, and a Python signed reference model.

Run the core regression:

```bash
./scripts/run_mvp_regression.sh
./scripts/run_python_reference.sh
```

Expected output includes `MVP SYSTEM PASS`, `MVP REGRESSION PASS`, and `PYTHON REFERENCE PASS`.

## Phase 1 Verification Improvement

The MVP verification now performs per-element signed result comparison, Python-to-RTL CSV comparison, illegal-address and invalid-command checks, forced-timeout verification, and ready/valid back-pressure stability checks. See `Docs/Phase1_Verification_Report.md`.

## Phase 2 Architecture Refinement

Formal release top: `RTL/Top/ai_accelerator_top.v`

Supporting boundaries:

- `RTL/Interface/host_interface.v`
- `RTL/Memory/activation_buffer.v`
- `RTL/Memory/weight_buffer.v`
- `RTL/Memory/output_buffer.v`
- `Docs/Phase2_Architecture.md`

Historical Day implementations remain available for traceability. The formal top adds parameter consistency checks and keeps the host, memory, control, and compute boundaries explicit.

---


## Environment_Log.md


Records:


- Installation history
- Configuration changes
- Debugging cases



---


## Engineering_Debrief/


Records:


- Project analysis
- Code understanding
- Design decisions
- Debugging lessons
- Hardware thinking



---

# Engineering Principles



## 1. Understand before copying


Code execution is not equal to knowledge.



---


## 2. Debug by layers


Problem

↓

Locate layer

↓

Verify hypothesis

↓

Fix

↓

Confirm



---


## 3. Hardware thinking


Software:


Instruction execution


Hardware:


Structure and timing



---


## 4. Verification matters


A design is incomplete
until it is verified.



---

# Repository Structure

AI-Chip-Researcher-Bootcamp

├── RTL

│ ├── Day02

│ └── Day03

├── Testbench

│ ├── Day02

│ └── Day03

├── Simulation

│ ├── Day02

│ └── Day03

├── Python

├── Papers

├── Docs

│
├── AI_Mentor_DNA.md

├── Bootcamp_Progress.md

├── Environment_Log.md

├── Engineering_Debrief.md

└── README.md




---

# Git Workflow


This repository uses:


SSH authentication



Remote:

git@github.com:2376885130-pixel/
AI-Chip-Researcher-Bootcamp.git



Workflow:


```bash
git pull --rebase

git status

git add .

git commit -m "message"

git push
Future Goals
Build capability to independently:

Design RTL systems

Develop hardware accelerators

Understand NPU architecture

Conduct AI hardware research

Final goal:

Design and implement

a complete AI accelerator system.

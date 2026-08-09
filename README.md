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

闂?Completed


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

婵☆偓绲介崯顖炴儊?In Progress


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


闂?

RTL Module


闂?

MAC Unit


闂?

Processing Element


闂?

Systolic Array


闂?

Matrix Multiplication Accelerator


闂?

NPU Architecture



---

# Completed Projects



# Day01

## First RTL Simulation


Project:


AND Gate


Files:

Day01/

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?and_gate.v

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?and_gate_tb.v

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?and_gate_sim

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?and_gate.vcd



Workflow:


RTL

闂?
Compilation

闂?
Simulation

闂?
Waveform Verification


Key Concepts:


- Basic Verilog module
- Testbench
- Simulation workflow
- GTKWave analysis


Result:


闂?Completed



---


# Day02

## Combinational Logic and Data Path


Projects:


## 1-bit MUX


File:

RTL/Day02/

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?mux2.v



Concepts:


- Multiplexer
- Conditional operator
- Combinational logic



---


## 8-bit MUX


File:

RTL/Day02/

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?mux8.v



Concepts:


- Bus
- Data width
- Vector signals
- Parallel hardware structure



Verification:

Testbench/Day02/

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?mux2_tb.v

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?mux8_tb.v



Simulation:

Simulation/Day02/

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?mux2

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?mux8



Key Understanding:


Verilog describes hardware structure,
not software execution.


Result:


闂?Completed



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

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?dff_tb.v

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?dff_reset_tb.v

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?register8_tb.v

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?counter8_tb.v



Simulation:

Simulation/Day03/

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?dff

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?dff_reset

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?register8

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?counter8



Key Understanding:


Sequential logic introduces:


- Clock
- State
- Memory
- Timing relationship



Result:


闂?Completed
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

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?traffic_light_fsm.v


Testbench/Day04/

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?traffic_light_tb.v


Simulation:


traffic_light.vcd


Key Understanding:


FSM converts behavioral requirements
into synchronous hardware control logic.


Result:

闂?Completed

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

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?counter_param.v


Testbench/Day05/

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?counter_param_tb.v


Simulation:


counter_param.vcd


Key Understanding:


Parameterized RTL creates reusable hardware IP.


Result:

闂?Completed
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

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?register_bank.v


Testbench/Day06/

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?register_bank_tb.v


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



闂?Completed

## Day07 - Arithmetic IP Design 闂?
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
## Day08 - Processing Element (PE) 闂?

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


partial_sum = partial_sum + activation 闂?weight



This module is the basic building block for:


PE Array

闂?
Systolic Array

闂?
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
- PE0: 2闂? = 6
- PE1: 4闂? = 20
- PE2: 6闂? = 42
- PE3: 8闂? = 72

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

闂?
MAC

闂?
PE

闂?
Systolic Array

闂?
Tile Matrix Engine

闂?
NPU Architecture

## Day12 - AI Accelerator Framework Integration 闂?
Day12 completed the first complete accelerator framework integration.

Implemented:

* Processing Element (PE)
* 4闂? Systolic Array Framework
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

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Controller FSM
闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Weight Loader
闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Activation Loader
闂?闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?Systolic Array
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

A 4闂? Systolic Array contains:

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

闂?
Memory Controller

闂?
SRAM Buffer

闂?
Scheduler

闂?
Systolic Array

闂?
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

闂?NPU Controller

闂?Data Fetch Controller

闂?Weight Buffer

闂?Activation Buffer

闂?Output Buffer

闂?Dot Product Engine

闂?NPU Top

闂?Complete Verification

闂?GTKWave Verification

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

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?dut

    闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Controller

    闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Fetch Controller

    闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Compute Engine

    闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Memory Blocks

    闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?Output Buffer

GTKWave displays this hierarchy because the testbench exports the simulation hierarchy using:

$dumpvars(0,npu_tb);
Debug Workflow

Verify system handshake

start 闂?processing 闂?done

Verify controller FSM

Verify memory data movement

Verify MAC computation

Verify output storage

Day15 milestone:

Understanding how RTL modules become a complete simulated hardware system.

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
## Day16 - Matrix Multiplication Workload

Status

PASS

Completed:

- First real AI workload on the NPU: C = A x B
- Decomposed 2x2 matrix multiply into 4 dot-product tasks
- Designed data mapping: activation <- row of A, weight <- column of B
- Created Testbench/Day16/npu_matmuls_tb.v
- Reused Day14 NPU RTL without modification
- GTKWave dataflow analysis

Verification:

- C[0][0] = 19 PASS
- C[0][1] = 22 PASS
- C[1][0] = 43 PASS
- C[1][1] = 50 PASS

Key understanding:

- Matrix multiplication = a set of dot products
- One NPU task = one dot product = one output element
- Data reuse motivates buffer hierarchy design
- Serial MAC latency motivates systolic array parallelism

Day16 milestone:

The NPU executed its first real matrix multiplication workload end-to-end.

- Design decisions
- Debugging lessons
- Hardware thinking



## Day17 - Parallel Matrix Multiply

Status

PASS

Completed:

- Parallel 2x2 matrix multiply with 4 independent MAC units
- Spatial parallelism: one MAC per output element
- RTL/Day17/matmul_2x2.v
- Testbench/Day17/matmul_2x2_tb.v
- Verified C = [19 22; 43 50] (matches Day16 serial result)
- Verified signed negatives: C = [-2 7; 6 -15]

Latency:

- Day16 serial: ~88 cycles
- Day17 parallel: 2 cycles (~44x speedup)

Key understanding:

- Latency = accumulation depth per output, not output count
- Area-speed trade-off: 4x hardware for 44x speedup
- Independent PEs (no data sharing) vs systolic array dataflow

Day17 milestone:

The matrix multiply was parallelized 44x with 4 MAC units.
Next: Day19 systolic NPU integration.

## Day18 - Systolic Array Dataflow

Status

PASS

Completed:

- 2x2 systolic array reusing Day14 pe_unit IP (4 PEs)
- Skew scheduling: A[i][k] enters row i at cycle k+i, B[k][j] enters col j at cycle k+j
- Activations flow left->right, weights flow top->down
- RTL/Day18/systolic_matmul_2x2.v
- Verified C = [19 22; 43 50] (matches Day16/17)
- Verified negatives: C = [-2 7; 6 -15]

Latency:

- Day18 systolic: 5 cycles (clear + fill + compute + drain)
- vs Day16 serial: ~88, Day17 parallel: 2

Key understanding:

- Skew scheduling is the key to systolic GEMM
- Data reuse: one input in, reused by many PEs
- Systolic wins at scale: I/O bandwidth O(N) not O(N^2)
- Tiny matrices: parallel MACs beat systolic on latency

Day18 milestone:

The 2x2 matrix multiply ran through a real systolic dataflow
with data reuse, matching Day16/17 results.
Next: Day20 double buffering.

## Day19 - Systolic NPU Integration

Status

PASS

Completed:

- Parameterized NxN systolic array (generate loops)
- RTL/Day19/systolic_matmul.v, fetch16.v, npu_systolic_top.v
- Full 4x4 matrix multiply through the NPU
- Verified C = A x B against a software reference (16/16, two tests)

Latency:

- Full NPU task ~78 cycles (fetch 48 + systolic 11 + store 16)
- vs Day14 serial 16 dot products ~352 cycles

Key understanding:

- Memory wall: compute is fast, data movement dominates
- Fetch (48) + store (16) = 64 cycles is now the bottleneck
- Producer/consumer timing: results must persist until consumed
- Real NPUs hide memory with DMA + double buffering

Day19 milestone:

The NPU now computes a full 4x4 matrix multiply with a systolic
compute core. Next: Day21 wider fetch.

## Day20 - Double Buffering

Status

PASS

Completed:

- npu_pipelined_top.v: 4 consecutive 4x4 matrix multiplies
- Ping-pong banks + overlapped fetch/compute/store
- Verified 4 tasks (all PASS)
- Serial 312 -> double buffered 243 cycles (~1.28x)

Key understanding:

- Steady-state interval = max(fetch, compute+store) = max(48,27) = 48
- Double buffering hides the shorter stage behind the longer one
- Fetch is still the bottleneck -> wider fetch next

Day20 milestone:

Fetch of task N+1 overlapped with compute/store of task N.
Next: Day21 wider fetch (4-wide) to break the 48-cycle bound.

---

# Engineering Principles



## 1. Understand before copying


Code execution is not equal to knowledge.



---


## 2. Debug by layers


Problem

闂?
Locate layer

闂?
Verify hypothesis

闂?
Fix

闂?
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

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?RTL

闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Day02

闂?闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?Day03

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Testbench

闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Day02

闂?闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?Day03

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Simulation

闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Day02

闂?闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?Day03

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Python

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Papers

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Docs

闂?闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?AI_Mentor_DNA.md

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Bootcamp_Progress.md

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Environment_Log.md

闂備礁鐤囬～澶嬬珶閺囥垹缁╅柕蹇嬪€曢悡姗€鏌?Engineering_Debrief.md

闂備礁鐤囬～澶愬蓟閿熺姴缁╅柕蹇嬪€曢悡姗€鏌?README.md




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

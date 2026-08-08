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

鉁?Completed


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

馃毀 In Progress


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


鈫?

RTL Module


鈫?

MAC Unit


鈫?

Processing Element


鈫?

Systolic Array


鈫?

Matrix Multiplication Accelerator


鈫?

NPU Architecture



---

# Completed Projects



# Day01

## First RTL Simulation


Project:


AND Gate


Files:

Day01/

鈹溾攢鈹€ and_gate.v

鈹溾攢鈹€ and_gate_tb.v

鈹溾攢鈹€ and_gate_sim

鈹斺攢鈹€ and_gate.vcd



Workflow:


RTL

鈫?
Compilation

鈫?
Simulation

鈫?
Waveform Verification


Key Concepts:


- Basic Verilog module
- Testbench
- Simulation workflow
- GTKWave analysis


Result:


鉁?Completed



---


# Day02

## Combinational Logic and Data Path


Projects:


## 1-bit MUX


File:

RTL/Day02/

鈹斺攢鈹€ mux2.v



Concepts:


- Multiplexer
- Conditional operator
- Combinational logic



---


## 8-bit MUX


File:

RTL/Day02/

鈹斺攢鈹€ mux8.v



Concepts:


- Bus
- Data width
- Vector signals
- Parallel hardware structure



Verification:

Testbench/Day02/

鈹溾攢鈹€ mux2_tb.v

鈹斺攢鈹€ mux8_tb.v



Simulation:

Simulation/Day02/

鈹溾攢鈹€ mux2

鈹斺攢鈹€ mux8



Key Understanding:


Verilog describes hardware structure,
not software execution.


Result:


鉁?Completed



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

鈹溾攢鈹€ dff_tb.v

鈹溾攢鈹€ dff_reset_tb.v

鈹溾攢鈹€ register8_tb.v

鈹斺攢鈹€ counter8_tb.v



Simulation:

Simulation/Day03/

鈹溾攢鈹€ dff

鈹溾攢鈹€ dff_reset

鈹溾攢鈹€ register8

鈹斺攢鈹€ counter8



Key Understanding:


Sequential logic introduces:


- Clock
- State
- Memory
- Timing relationship



Result:


鉁?Completed
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

鈹斺攢鈹€ traffic_light_fsm.v


Testbench/Day04/

鈹斺攢鈹€ traffic_light_tb.v


Simulation:


traffic_light.vcd


Key Understanding:


FSM converts behavioral requirements
into synchronous hardware control logic.


Result:

鉁?Completed

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

鈹斺攢鈹€ counter_param.v


Testbench/Day05/

鈹斺攢鈹€ counter_param_tb.v


Simulation:


counter_param.vcd


Key Understanding:


Parameterized RTL creates reusable hardware IP.


Result:

鉁?Completed
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

鈹斺攢鈹€ register_bank.v


Testbench/Day06/

鈹斺攢鈹€ register_bank_tb.v


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



鉁?Completed

## Day07 - Arithmetic IP Design 鉁?
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
## Day08 - Processing Element (PE) 鉁?

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


partial_sum = partial_sum + activation 脳 weight



This module is the basic building block for:


PE Array

鈫?
Systolic Array

鈫?
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
- PE0: 2脳3 = 6
- PE1: 4脳5 = 20
- PE2: 6脳7 = 42
- PE3: 8脳9 = 72

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

鈫?
MAC

鈫?
PE

鈫?
Systolic Array

鈫?
Tile Matrix Engine

鈫?
NPU Architecture

## Day12 - AI Accelerator Framework Integration 鉁?
Day12 completed the first complete accelerator framework integration.

Implemented:

* Processing Element (PE)
* 4脳4 Systolic Array Framework
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

鈹溾攢鈹€ Controller FSM
鈹?鈹溾攢鈹€ Weight Loader
鈹?鈹溾攢鈹€ Activation Loader
鈹?鈹斺攢鈹€ Systolic Array
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

A 4脳4 Systolic Array contains:

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

鈫?
Memory Controller

鈫?
SRAM Buffer

鈫?
Scheduler

鈫?
Systolic Array

鈫?
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

鉁?NPU Controller

鉁?Data Fetch Controller

鉁?Weight Buffer

鉁?Activation Buffer

鉁?Output Buffer

鉁?Dot Product Engine

鉁?NPU Top

鉁?Complete Verification

鉁?GTKWave Verification

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

鈹斺攢鈹€ dut

    鈹溾攢鈹€ Controller

    鈹溾攢鈹€ Fetch Controller

    鈹溾攢鈹€ Compute Engine

    鈹溾攢鈹€ Memory Blocks

    鈹斺攢鈹€ Output Buffer

GTKWave displays this hierarchy because the testbench exports the simulation hierarchy using:

$dumpvars(0,npu_tb);
Debug Workflow

Verify system handshake

start 鈫?processing 鈫?done

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



---

# Engineering Principles



## 1. Understand before copying


Code execution is not equal to knowledge.



---


## 2. Debug by layers


Problem

鈫?
Locate layer

鈫?
Verify hypothesis

鈫?
Fix

鈫?
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

鈹溾攢鈹€ RTL

鈹?鈹溾攢鈹€ Day02

鈹?鈹斺攢鈹€ Day03

鈹溾攢鈹€ Testbench

鈹?鈹溾攢鈹€ Day02

鈹?鈹斺攢鈹€ Day03

鈹溾攢鈹€ Simulation

鈹?鈹溾攢鈹€ Day02

鈹?鈹斺攢鈹€ Day03

鈹溾攢鈹€ Python

鈹溾攢鈹€ Papers

鈹溾攢鈹€ Docs

鈹?鈹溾攢鈹€ AI_Mentor_DNA.md

鈹溾攢鈹€ Bootcamp_Progress.md

鈹溾攢鈹€ Environment_Log.md

鈹溾攢鈹€ Engineering_Debrief.md

鈹斺攢鈹€ README.md




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

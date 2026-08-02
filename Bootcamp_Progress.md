# AI Chip Researcher Bootcamp
# Progress Snapshot


Version:

3.0


Last Update:

2026-07-28



================================
# 1. Current Identity
================================


Researcher:

AI Chip Researcher Bootcamp Participant



Background:


Electronic Information Engineering undergraduate student.



Current Stage:


Completed second-year undergraduate study.

Summer learning phase.



Long-term Goal:


Develop independent AI hardware research capability.


Target areas:


- AI Accelerator
- NPU Architecture
- Digital IC Design
- Hardware Software Co-design



================================
# 2. Current Learning Status
================================


Current Phase:


Phase 2

RTL Design Fundamentals



Current Day:


Day 06 Completed



Current Mission:


Develop reusable hardware IP design capability.



Overall Status:


In Progress.



================================
# 3. Operating Environment
================================


Host System:


Windows 11



Virtual Environment:


WSL2



Linux Distribution:


Ubuntu



Linux User:


aichip



Permission:


sudo enabled



Current Home:


/home/aichip



Current Project:


/home/aichip/AI-Chip-Researcher-Bootcamp



================================
# 4. Development Tools Status
================================


## Git


Version:


2.43.0



Status:


✅ Installed



Purpose:


Version control and engineering workflow.



---


## Icarus Verilog


Version:


12.0



Status:


✅ Installed



Purpose:


RTL simulation.



---


## GTKWave


Version:


3.3.116



Status:


✅ Installed



Purpose:


Waveform visualization.



---


## Tree


Version:


2.1.1



Status:


✅ Installed



Purpose:


Project structure visualization.



================================
# 5. Git Configuration
================================


Global User:


Name:


2376885130-pixel



Email:


2376885130@qq.com



Current Branch:


main



Repository Status:


Active



================================
# 6. GitHub Configuration
================================


Repository:


AI-Chip-Researcher-Bootcamp



GitHub Account:


2376885130-pixel



Remote:


git@github.com:2376885130-pixel/
AI-Chip-Researcher-Bootcamp.git



Protocol:


SSH



Authentication:


SSH Key



SSH Key Location:


~/.ssh/id_ed25519



Status:


✅ Verified



Important Rule:


Future GitHub operations use SSH.



Do not use HTTPS remote.



Reason:


HTTPS push encountered:


GnuTLS recv error (-110)



Solution:


Switched to SSH authentication.



Engineering Lesson:


Debug problems by layers.



================================
# 7. Repository Structure
================================


Current Structure:


AI-Chip-Researcher-Bootcamp


├── RTL

│   ├── Day02

│   ├── Day03

│   ├── Day04

│   ├── Day05

│   └── Day06


├── Testbench

│   ├── Day02

│   ├── Day03

│   ├── Day04

│   ├── Day05

│   └── Day06


├── Simulation

│   ├── Day02

│   ├── Day03

│   ├── Day04

│   ├── Day05

│   └── Day06


├── Python

├── Papers

├── Docs


├── README.md

├── Bootcamp_Progress.md

├── Environment_Log.md

└── Engineering_Debrief.md



================================
# 8. Git History
================================


Repository contains:


- Environment setup commits
- RTL development commits
- Verification commits
- Hardware IP design milestones



Important milestones:


Day01:

Environment and first RTL simulation



Day05:

Parameterized RTL Counter



Day06:

Parameterized Register Bank IP



================================
# 9. Completed Learning Record
================================



# Day 0

## Environment Setup


Completed:


✅ WSL2


✅ Ubuntu


✅ Linux user


✅ sudo permission



Understanding:


Linux is the foundation of hardware
development environment.
---

# Day01

## Development Environment + First RTL Experiment



Completed:



## Linux Commands


Learned:


pwd


Meaning:

Check current directory.



ls


Meaning:

View files.



cd


Meaning:

Change directory.



mkdir


Meaning:

Create directory.



touch


Meaning:

Create file.



Engineering meaning:


Linux workflow is based on
file organization and command control.



---


## Git Workflow


Learned:


git init


Create repository.



git add


Add changes to staging area.



git commit


Create version snapshot.



git remote


Connect remote repository.



git push


Synchronize with GitHub.



Engineering meaning:


Git records engineering evolution.



---


## RTL Experiment


Project:


AND Gate



Files:


RTL:


and_gate.v



Testbench:


and_gate_tb.v



Simulation:


and_gate_sim



Waveform:


and_gate.vcd



Verification:


Simulation passed.



Understanding:


RTL describes hardware structure,
not software execution flow.



Result:


✅ Completed



---


# Day02 Completed


## Topic


Combinational Logic and Data Path



## Completed Modules


### mux2


Location:


RTL/Day02/mux2.v



Learned:


- 2-to-1 multiplexer
- conditional operator
- combinational logic



---


### mux8


Location:


RTL/Day02/mux8.v



Learned:


- bus
- vector signal
- data width
- parallel hardware structure



---


## Verification


Completed:


- mux2_tb
- mux8_tb



Tools:


- Icarus Verilog
- GTKWave



## Key Engineering Understanding


Verilog describes hardware structure,
not software execution.



assign creates combinational hardware.



wire represents hardware connection.



Result:


✅ Completed



---


# Day03 Completed


## Topic


Sequential Logic Fundamentals



Completed:


- D Flip-Flop
- Synchronous Reset
- 8-bit Register
- Counter



Key Concepts:


- Clock
- Register
- State
- Non-blocking assignment
- Sequential circuit



Result:


✅ Completed



---


# Day04 Completed


## Topic


Finite State Machine and Hardware Controller



Project:


Traffic Light FSM Controller



Completed:


Implemented:


- Moore FSM
- Three-stage FSM
- State encoding
- State register
- Next state logic
- Output logic



Verification:


Completed:


- Testbench
- Icarus Verilog simulation
- GTKWave waveform verification



Engineering Understanding:


FSM consists of:


Current State


+


Next State Logic


+


Output Logic



Hardware connection:


FSM


↓


Controller


↓


Accelerator Scheduler



Result:


✅ Completed



---


# Day05 Completed


## Topic


Parameterized RTL Design



Project:


Parameterized Counter



Completed:


Implemented:


- parameterized counter
- configurable WIDTH
- synchronous reset
- enable control



Files:


RTL/Day05/counter_param.v



Verification:


Testbench:


Testbench/Day05/counter_param_tb.v



Simulation:


Icarus Verilog


GTKWave



Key Engineering Understanding:


Parameterized RTL allows reusable hardware IP design.



Parameter controls hardware generation,
not runtime software behavior.



Hardware connection:


Parameterized Module


↓


Reusable IP


↓


MAC/FIFO/Buffer


↓


AI Accelerator



Result:


✅ Completed



---


# Day06 Completed


## Topic


Reusable Hardware IP Design



Project:


Parameterized Register Bank IP



Completed:


Implemented:


- Register bank architecture
- Parameterized DATA_WIDTH
- Parameterized DEPTH
- Register array design
- Synchronous write logic
- Combinational read logic



Files:


RTL/Day06/


└── register_bank.v



Testbench/Day06/


└── register_bank_tb.v



Verification:


Completed:


- Multiple register address testing
- Parameter-driven verification
- Self-checking testbench
- Automatic PASS/FAIL checking
- Waveform generation



Verification Result:


TEST PASSED



Key Engineering Understanding:


Register Bank:


Multiple Registers


+


Address Selection


+


Read/Write Control



Parameterized RTL:


Parameter


↓


Hardware Configuration


↓


Reusable Hardware IP



Hardware connection:


Register Bank


↓


Processing Element


↓


MAC Unit


↓


AI Accelerator



Result:


✅ Completed
## Day07 - Arithmetic IP Design

Status: Completed

Completed:

- Parameterized Adder IP
- Parameterized Multiplier IP
- MAC Unit Design

Implemented:

- Configurable DATA_WIDTH arithmetic modules
- Carry-aware adder output width design
- Multiplier output width expansion
- Multiply-Accumulate datapath
- Accumulator register with clock control
- RTL verification with Icarus Verilog
- Waveform inspection with GTKWave

Key Concepts:

- Bit-width planning
- Overflow prevention
- Full Adder and carry propagation
- Partial products in multiplication
- Sequential logic and accumulator design
- MAC architecture for AI accelerators

Engineering Result:

Arithmetic datapath foundation completed.

Next:

Day08 - Processing Element / Datapath Architecture
# Day08 - Processing Element (PE)

Status: Completed ✅

## Completed Work

### RTL Design

Implemented:

- RTL/Day08/processing_element.v


Architecture:


activation
|
v
Multiplier
|
v
Adder <---- accumulator register
|
v
partial_sum



## Hardware Concepts Learned

- Processing Element (PE)
- MAC vs PE
- Accumulator Register
- Partial Sum
- Feedback data path
- Sequential accumulation


## AI Accelerator Connection

Learned that:

PE = MAC + Register


A PE performs:

partial_sum = partial_sum + activation × weight


Multiple PE units can form:

Systolic Array


Systolic Array enables:

- massive parallel computation
- efficient matrix multiplication
- low data movement


## Verification

Created:

Testbench/Day08/processing_element_tb.v


Verified:

Test1:

2 × 3

Result:

partial_sum = 6


Test2:

4 × 5

Result:

partial_sum = 26


Test3:

10 × 2

Result:

partial_sum = 46


Simulation:

PASS ✅


## Debug Experience

Issue:

TEST1 initially failed.


Root Cause:

Testbench checked partial_sum before the first clock edge.


Lesson:

Sequential hardware requires:

Input setup

↓

Clock edge

↓

Register update

↓

Output verification


## Tools Used

- Ubuntu WSL2
- Icarus Verilog
- GTKWave
- Git


## Key Achievement

First AI Accelerator hardware block completed.

A single PE was designed, simulated, and verified.

================================
# 10. Problems Solved
================================


## Reset Control Debugging


Problem:


Register Bank simulation returned:


Reg0 = xx


Reg1 = xx



Investigation:


Checked write behavior.



Cause:


Reset remained active during write operation.



Solution:


Released reset before write test.



Engineering Lesson:


Control signals determine hardware behavior.

Timing and signal priority must be verified.



---


## Parameterized Verification Design


Problem:


Manual test cases were difficult to scale.



Solution:


Created parameter-driven self-checking testbench.



Result:


Different DATA_WIDTH and DEPTH configurations
can use the same verification environment.



Engineering Lesson:


Reusable hardware requires reusable verification.

# Day09 Completed


## Topic

Pipeline MAC Design


## Completed Tasks


[x] Designed pipelined MAC RTL

[x] Implemented INT8 × INT8 → INT16 multiplication

[x] Implemented INT32 accumulation path

[x] Added pipeline registers

[x] Created parameterized Testbench

[x] Debugged pipeline timing issues

[x] Verified with GTKWave waveform


## Key Understanding


### Pipeline

Pipeline increases throughput by overlapping operations.


### Latency

Pipeline MAC latency:

2 cycles


### Throughput

After pipeline filling:

1 MAC result / cycle


### Registers

Registers:

- store intermediate results
- separate timing stages
- improve maximum frequency


## Simulation Result


PASS=6 FAIL=0


## Current Architecture Level


Completed:

Single MAC Unit


Next:

Multiple MAC units → PE Array


Future:

PE Array → Systolic Array → NPU Accelerator

## Day10: PE Array and Parallel Computation

Status: Completed ✅

Completed:

- Reviewed Processing Element IP
- Improved accumulator width handling
- Designed parameterized PE Array
- Implemented generate-based PE instantiation
- Verified NUM_PE scalability

RTL:


RTL/Day10/pe_array.v


Testbench:


Testbench/Day10/pe_array_tb.v


Simulation:


NUM_PE = 4

PE0 PASS
PE1 PASS
PE2 PASS
PE3 PASS


Key concepts:

- Hardware generation
- Module reuse
- Parallel MAC architecture
- Parameterized RTL design

## Day11 - Systolic PE Chain Architecture

Status: PASS

Completed:

- Designed parameterized PE Unit
- Added weight register with load_weight control
- Implemented partial sum accumulation datapath
- Implemented activation forwarding path
- Built parameterized PE Chain using generate loop
- Supported configurable NUM_PE
- Supported parameterized weight input bus

Architecture:


Activation
|
v

PE0 ---> PE1 ---> PE2 ---> PE3

|
v

Partial Sum Accumulation


Verification:

- pe_unit_tb.v
    - TEST1 PASS
    - TEST2 PASS

- pe_chain_tb.v
    - PE_CHAIN TEST PASS
    - Final Result = 14

Simulation:

- Icarus Verilog PASS
- GTKWave VCD generated

Key Learning:

Day11 moved from independent PE computation to dataflow architecture.

Learned:

- Weight Stationary concept
- Partial Sum propagation
- PE pipeline structure
- Systolic Array basic data movement
- Parameterized hardware generation

================================
# 11. Engineering Habits Learned
================================


## Habit 1


Always verify results.


Example:


RTL


↓


Simulation


↓


Waveform


↓


Confirmation



---


## Habit 2


Debug by layers.



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


## Habit 3


Documentation is part of engineering.


Important milestones should include:


- Code
- Verification
- Explanation
- Version control



================================
# 12. Current Knowledge Level
================================


## Linux


Can:


- navigate filesystem
- create/manage files
- understand directory structure
- use Linux development workflow



Need to learn:


- shell scripting
- permissions deeply
- environment automation



---


## Git


Can:


- create repository
- commit changes
- connect GitHub
- use SSH workflow
- maintain engineering history



Need to learn:


- branch workflow
- merge
- conflict resolution



---


## Verilog / RTL


Can:


- write RTL modules
- design combinational logic
- design sequential logic
- implement FSM controller
- create parameterized RTL
- write testbench
- simulate with Icarus Verilog
- analyze waveform with GTKWave
- build self-checking verification environment



Need to learn:


- SystemVerilog
- pipeline architecture
- memory interface
- arithmetic IP design
- AI accelerator architecture



================================
# 13. Current Blocker
================================


None



================================
# 14. Pending Task
================================


Continue RTL architecture development.



Future topics:


- Arithmetic IP
- MAC Unit
- Processing Element
- Pipeline design
- Memory architecture



================================
# 15. Next Mission
================================


Day07:


Arithmetic IP Design



Goal:


Understand:


- Adder architecture
- Multiplier architecture
- MAC operation
- Datapath design



Expected Project:


Design and verify first arithmetic hardware IP.



================================
# 16. Recovery Instruction
================================


When restoring from lost conversation:


AI should read this file first.



Recovery order:


1.

Check Current Phase



2.

Check Completed Tasks



3.

Check Environment



4.

Check Git Status



5.

Continue Current Mission



AI should not:


- reinstall tools
- repeat completed experiments
- ignore previous decisions



================================
# 17. Update Rules
================================


After each learning session:


Update:


Current Day


Completed Tasks


New Knowledge


Problems Solved


Environment Changes


Git Commit


Engineering Debrief Status


Next Action

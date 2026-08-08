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

Current Mission:

Develop AI accelerator compute core architecture.

Completed:

- MAC Unit
- PE Design
- PE Array
- Systolic Array Structure
- Controller FSM Framework
- NPU Dot Product Framework (Day14)
- Matrix Multiplication Workload (Day16)
- Parallel Matrix Multiply (Day17)

Current Focus:

Accelerator integration, dataflow scheduling and workload verification.


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


Day 17 Completed



Current Mission:


Design, verify and optimize AI accelerator workload execution.



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


闁?Installed



Purpose:


Version control and engineering workflow.



---


## Icarus Verilog


Version:


12.0



Status:


闁?Installed



Purpose:


RTL simulation.



---


## GTKWave


Version:


3.3.116



Status:


闁?Installed



Purpose:


Waveform visualization.



---


## Tree


Version:


2.1.1



Status:


闁?Installed



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


闁?Verified



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


闁宠澹曢弨銏ゅ煘閳?RTL

闁?  闁宠澹曢弨銏ゅ煘閳?Day02

闁?  闁宠澹曢弨銏ゅ煘閳?Day03

闁?  闁宠澹曢弨銏ゅ煘閳?Day04

闁?  闁宠澹曢弨銏ゅ煘閳?Day05

闁?  闁宠鏌￠弨銏ゅ煘閳?Day06


闁宠澹曢弨銏ゅ煘閳?Testbench

闁?  闁宠澹曢弨銏ゅ煘閳?Day02

闁?  闁宠澹曢弨銏ゅ煘閳?Day03

闁?  闁宠澹曢弨銏ゅ煘閳?Day04

闁?  闁宠澹曢弨銏ゅ煘閳?Day05

闁?  闁宠鏌￠弨銏ゅ煘閳?Day06


闁宠澹曢弨銏ゅ煘閳?Simulation

闁?  闁宠澹曢弨銏ゅ煘閳?Day02

闁?  闁宠澹曢弨銏ゅ煘閳?Day03

闁?  闁宠澹曢弨銏ゅ煘閳?Day04

闁?  闁宠澹曢弨銏ゅ煘閳?Day05

闁?  闁宠鏌￠弨銏ゅ煘閳?Day06


闁宠澹曢弨銏ゅ煘閳?Python

闁宠澹曢弨銏ゅ煘閳?Papers

闁宠澹曢弨銏ゅ煘閳?Docs


闁宠澹曢弨銏ゅ煘閳?README.md

闁宠澹曢弨銏ゅ煘閳?Bootcamp_Progress.md

闁宠澹曢弨銏ゅ煘閳?Environment_Log.md

闁宠鏌￠弨銏ゅ煘閳?Engineering_Debrief.md



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


闁?WSL2


闁?Ubuntu


闁?Linux user


闁?sudo permission



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


闁?Completed



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


闁?Completed



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


闁?Completed



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


闁?

Controller


闁?

Accelerator Scheduler



Result:


闁?Completed



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


闁?

Reusable IP


闁?

MAC/FIFO/Buffer


闁?

AI Accelerator



Result:


闁?Completed



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


闁宠鏌￠弨銏ゅ煘閳?register_bank.v



Testbench/Day06/


闁宠鏌￠弨銏ゅ煘閳?register_bank_tb.v



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


闁?

Hardware Configuration


闁?

Reusable Hardware IP



Hardware connection:


Register Bank


闁?

Processing Element


闁?

MAC Unit


闁?

AI Accelerator



Result:


闁?Completed
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

Status: Completed 闁?
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

partial_sum = partial_sum + activation 閼?weight


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

2 閼?3

Result:

partial_sum = 6


Test2:

4 閼?5

Result:

partial_sum = 26


Test3:

10 閼?2

Result:

partial_sum = 46


Simulation:

PASS 闁?

## Debug Experience

Issue:

TEST1 initially failed.


Root Cause:

Testbench checked partial_sum before the first clock edge.


Lesson:

Sequential hardware requires:

Input setup

闁?
Clock edge

闁?
Register update

闁?
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

[x] Implemented INT8 閼?INT8 闁?INT16 multiplication

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

Multiple MAC units 闁?PE Array


Future:

PE Array 闁?Systolic Array 闁?NPU Accelerator

## Day10: PE Array and Parallel Computation

Status: Completed 闁?
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

# Bootcamp Progress Update

## Day12 - AI Accelerator Framework Integration

Status:

```
Completed 闁?```

## Completed Modules

### Compute

* Processing Element
* 4x4 Systolic Array Framework

### Control

* Controller FSM
* Start / Compute / Output / Clear sequencing

### Data Loading

* Weight Loader
* Activation Loader

### Integration

* Accelerator Top

---

## Verification Results

| Test                             | Result |
| -------------------------------- | ------ |
| PE Unit Simulation               | PASS   |
| Systolic Array Dataflow Test     | PASS   |
| Controller FSM Test              | PASS   |
| Weight Loader Test               | PASS   |
| Activation Loader Test           | PASS   |
| Accelerator Top Integration Test | PASS   |

---

## Key Engineering Concepts Learned

### 1. Non-blocking Assignment Timing

Understanding:

```
<=

clock edge

pipeline latency
```

### 2. Systolic Dataflow

Understanding:

```
activation movement

weight movement

PE pipeline
```

### 3. Accelerator Architecture

Completed architecture:

```
Controller

闁?
Loader

闁?
Compute Array

闁?
Result
```

---

## Day12 Completion

The project has progressed from individual RTL blocks into a complete AI Accelerator Framework prototype.


## Engineering Understanding

Learned:


Computation is only one part of AI accelerator.

A complete accelerator requires:

Compute

+

Memory movement

+

Control scheduling



## Current Level


Can:

- design MAC hardware
- design PE
- build PE array
- understand systolic architecture
- create accelerator hierarchy


Need to learn:

- SRAM interface
- Tile scheduling
- Matrix mapping
- DMA
- Pipeline optimization


## Next Mission

Accelerator integration verification.

# AI-Chip-Researcher-Bootcamp Progress

## Day13 - AI Accelerator Architecture Analysis

### Goal

婵烇絽宕崣鍡涙偠閸℃?Day12 Accelerator Integration 闁哄鍩栭悗顖炴晬鐏炶偐鐭?RTL 婵☆垪鈧櫕鍋ラ悹浣瑰礃椤撳憡娼诲☉妯哄汲 AI 闁间警鍨虫晶鏍寲閼姐倗鍩犻柡瀣煐閻庮垶鎮堕崱姣挎帡濡?
闁哄牜鍓氬Λ鈺呮煂瀹ュ洤浠☉鎾崇У濡插憡鏅堕悙鎻掝潱闁哄倹澹嗗▓?RTL闁挎稑鐭侀埀顒€鏈Σ鎼佸礆閸℃鈧棄顔忛崣澶嬬畳 Accelerator Framework 濞戞搩鍘奸幃鍥熼垾铏仴闁汇劌瀚禍瀵告嫻閿濆啠鍋撴担瑙勬闁硅鍠楃粊锕傚椽鐏炴儳浠橀柛鎺曟硾閸櫻呭寲濮瑰洠鍋?
---

# Day13 Learning Summary

## 1. Accelerator Top Architecture

闁告帒妫欓悗浠嬫晬?
```
accelerator_top.v
```

闁荤偛妫滆閻庣懓鏈弳?Accelerator 闁汇劌瀚惇鏉库枎閿涘嫮娉㈤柡瀣缁?
```
Accelerator

闁宠澹曢弨銏ゅ煘閳?Controller FSM
闁?闁宠澹曢弨銏ゅ煘閳?Weight Loader
闁?闁宠澹曢弨銏ゅ煘閳?Activation Loader
闁?闁宠鏌￠弨銏ゅ煘閳?Systolic Array
        |
        |
       PE Array
```

闁哄秶顭堢缓楣冨箑濠靛洤鍘掗柨?
濞戞挴鍋撳☉?AI Accelerator 闁汇垺鍞荤槐?
* Control Path
* Data Path
* Compute Engine

闁稿繐宕幃鎾剁磼閸曨剙鐏囬柕?
---

# 2. Controller FSM Analysis

閻庢冻缂氱弧鍕晬?
```
controller_fsm.v
```

闁荤偛妫滆 FSM 闁?Accelerator 濞戞搩鍘惧▓鎴炴媴濠婂懏鏆忛柨?
闁绘鍩栭埀顑跨筏缁?
```
IDLE

闁?
LOAD_WEIGHT

闁?
COMPUTE

闁?
OUTPUT

闁?
CLEAR
```

FSM 閻犳劗鍠曢惌妤呮晬?
* 闁绘鍩栭埀顑胯兌椤撴悂鎮?* 闁硅矇鍐ㄧ厬濞ｅ洠鈧啿濞囬柣銏㈠枑閸?* 閻犱緤绱曢悾璇裁规担琛℃煠閻犲鍟€?
FSM 濞戞挸绉风粈瀣嫻閿濆繒绐?
* 濞戞梹蓱绾?* 闁告梻濮电涵?* MAC閻犱緤绱曢悾?
閻庡湱鍋熼獮鍥晬?
Control Path 濞?Data Path 闁告帒妫涢‖鍥Υ?
---

# 3. Weight Loader Analysis

閻庢冻缂氱弧鍕晬?
```
weight_loader.v
```

闁荤偛妫滆闁?
Weight Loader 閻忕偟鍋樼花顒勫极閻楀牆绁﹂悹渚灠缁剁偤濡?
濞达絾绮庨弫銈夋晬?
闁?Compute Engine 闁圭粯鍔掔欢鐢稿级閸愵喖娅㈤柡浣哄瀹撲線濡?
鐟滅増鎸告晶鐘绘偋閸喐鎷遍柨?
闁搞儱鎼悾楣冨级閸愵喖娅㈤弶鍫熸尭閸欏棝鏁?
```
weight = [5,7,0,0]
```

閻忕偟鍋樼花顒勫极濞嗗浚鍔呴柣?Buffer/Register 婵☆垪鈧磭鈧兘濡?
闁哄牜浜濆鐢稿础閸モ晠鐛撻柡鍌滄嚀閹粓鏁?
```
DRAM

闁?
DMA

闁?
SRAM Weight Buffer

闁?
Compute Engine
```

---

# 4. Activation Loader Analysis

閻庢冻缂氱弧鍕晬?
```
activation_loader.v
```

闁荤偛妫滆 Activation 濞?Weight 闁汇劌瀚亸顖炲礆椤愵剛绐?
|      | Weight        | Activation        |
| ---- | ------------- | ----------------- |
| 闁哄鍎茬花?  | 婵☆垪鈧磭鈧兘宕ｉ崒娑欐          | 濞戞搩鍙冨Λ璺ㄦ媼閿涘嫮鏆紓浣规尰閻?           |
| 闁告瑦锚鐎?  | 闁搞儱鎼悾?           | 闁告柣鍔嶉埀?               |
| 濠㈣泛绉堕弫?  | 濡?            | 濞?                |
| 閻庢稒锚閸嬪秶绮甸弽顐ｆ | Weight Buffer | Activation Buffer |

闁搞儳濮甸婵嬫儑閻旈鏉?NPU 闂侇偅鑹鹃悥鍫曞礆閸℃纾荤紒鐙呯磿閹﹪濡?
---

# 5. Systolic Array Analysis

閻庢冻缂氱弧鍕晬?
```
systolic_array_4x4.v
```

闁荤偛妫滆闁?
4閼? Systolic Array闁?
```
16 PE
```

闁轰胶澧楀畵浣该规笟濠勭獥

Activation:

```
鐎?闁?闁?```

Weight:

```
濞?闁?濞?```

婵絽绻嬮柌?PE 闁告艾鏈鍌炲箥瑜戦、鎴︽晬?
```
MAC
+
Data Forwarding
```

---

# 6. PE Unit Analysis

閻庢冻缂氱弧鍕晬?
```
pe_unit.v
```

闁荤偛妫滆 PE 闁?Accelerator 闁哄牃鍋撻柛鈺冨劋濠€鎵媼閿涘嫮鏆柛妤佹礀閸樻捇濡?
闁告梻鍠曢崗姗€鏁?
```
Multiply

+

Accumulate

+

Forward
```

闁哄秶顭堢缓鍓ф媼閿涘嫮鏆柨?
```
accumulator =
accumulator + activation * weight
```

---

# Day13 Architecture Insights

## Control Path

閻犳劗鍠曢惌妤呮晬?
```
濞寸姭鍋撳☉鏂跨墛濡炲倿宕愬▎鎺濆悁缂?濞寸姭鍋撳☉鏂跨墛濡炲倿宕愬▎蹇擃潱閺?濞寸姭鍋撳☉鏂跨墛濡炲倿宕愬▎鎺旂炕闁?```

婵☆垪鈧櫕鍋ラ柨?
```
Controller FSM
```

---

## Data Path

閻犳劗鍠曢惌妤呮晬?
```
闁轰胶澧楀畵浣逛繆閸屾瑧绉跨紒澶庮嚙婵?闁轰胶澧楀畵浣逛繆閸屾瑧绉块悹渚婄磿閻?```

婵☆垪鈧櫕鍋ラ柨?
```
Loader

Systolic Array

PE
```

---

# Engineering Improvements Identified

鐟滅増鎸告晶?Day12 Accelerator闁?
* Fixed latency
* Fixed weight
* Fixed activation
* No memory interface
* No compute done handshake

闁哄牜浜濆鐢稿础閸モ晠鐛撻柡鍌滄嚀閹粓鏁?
```
Memory Interface

+

SRAM Buffer

+

DMA

+

Compute Done Signal

+

Pipeline Control
```

---

# Day13 Achievement

閻庣懓鏈崹姘舵晬?
濞?RTL Module Designer

闁?
AI Accelerator Architecture Designer

闁汇劌瀚幃濠勬喆閿濆懎纾崇紒鐙欎讲鍋?
## Day14

Status

闁?Completed

Implemented

- NPU Controller
- Data Fetch Controller
- Weight Buffer
- Activation Buffer
- Output Buffer
- Dot Product Engine
- NPU Top
- Full Testbench

Verification

PASS

Simulation

PASS

Waveform

PASS

Final Result

26

Skills Learned

- Controller integration
- Memory hierarchy
- Fetch scheduling
- SRAM timing
- Dot-product accelerator
- Output buffering
- Full-chip verification

## Day15 Progress

Completed Day15 deep understanding phase.

Topics:

- RTL hierarchy understanding
- DUT instance concept
- Testbench and DUT relationship
- VCD waveform generation
- GTKWave signal selection methodology

Key learning:

The DUT instance is created by the testbench:

```verilog
npu_top dut();

The name dut represents the Design Under Test.

Waveform hierarchy reflects Verilog module instantiation hierarchy.

Debugging strategy:

CPU interface
闁?Controller FSM
闁?Data Fetch
闁?Compute Engine
闁?Output Buffer

Current milestone:

Able to trace a complete NPU task from start command to result storage.

## Day16 - Matrix Multiplication Workload

Status: PASS 鉁?Completed:

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


## Day17 - Parallel Matrix Multiply

Status: PASS

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

Day18 - Systolic Array Dataflow (weight stationary)

================================
# 11. Engineering Habits Learned
================================


## Habit 1


Always verify results.


Example:


RTL


闁?

Simulation


闁?

Waveform


闁?

Confirmation



---


## Habit 2


Debug by layers.



Problem


闁?

Locate layer


闁?

Verify hypothesis


闁?

Fix


闁?

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


Continue AI accelerator architecture development.



Future topics:


- Systolic array dataflow (Day18)
- Weight stationary scheduling
- 4x4 matrix multiply scaling
- Memory hierarchy / output buffer widening
- Full NPU architecture



================================
# 15. Next Mission
================================


Day18:


Systolic Array Dataflow



Goal:


- Connect systolic_array_4x4 into a matrix multiply dataflow
- Understand weight stationary scheduling
- Achieve data reuse between PEs
- Verify systolic result against Day17 parallel result
- Scale toward 4x4 matrix multiply



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

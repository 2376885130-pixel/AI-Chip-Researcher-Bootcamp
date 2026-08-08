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


Day 16 Completed



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


閴?Installed



Purpose:


Version control and engineering workflow.



---


## Icarus Verilog


Version:


12.0



Status:


閴?Installed



Purpose:


RTL simulation.



---


## GTKWave


Version:


3.3.116



Status:


閴?Installed



Purpose:


Waveform visualization.



---


## Tree


Version:


2.1.1



Status:


閴?Installed



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


閴?Verified



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


閳规壕鏀㈤埞鈧?RTL

閳?  閳规壕鏀㈤埞鈧?Day02

閳?  閳规壕鏀㈤埞鈧?Day03

閳?  閳规壕鏀㈤埞鈧?Day04

閳?  閳规壕鏀㈤埞鈧?Day05

閳?  閳规柡鏀㈤埞鈧?Day06


閳规壕鏀㈤埞鈧?Testbench

閳?  閳规壕鏀㈤埞鈧?Day02

閳?  閳规壕鏀㈤埞鈧?Day03

閳?  閳规壕鏀㈤埞鈧?Day04

閳?  閳规壕鏀㈤埞鈧?Day05

閳?  閳规柡鏀㈤埞鈧?Day06


閳规壕鏀㈤埞鈧?Simulation

閳?  閳规壕鏀㈤埞鈧?Day02

閳?  閳规壕鏀㈤埞鈧?Day03

閳?  閳规壕鏀㈤埞鈧?Day04

閳?  閳规壕鏀㈤埞鈧?Day05

閳?  閳规柡鏀㈤埞鈧?Day06


閳规壕鏀㈤埞鈧?Python

閳规壕鏀㈤埞鈧?Papers

閳规壕鏀㈤埞鈧?Docs


閳规壕鏀㈤埞鈧?README.md

閳规壕鏀㈤埞鈧?Bootcamp_Progress.md

閳规壕鏀㈤埞鈧?Environment_Log.md

閳规柡鏀㈤埞鈧?Engineering_Debrief.md



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


閴?WSL2


閴?Ubuntu


閴?Linux user


閴?sudo permission



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


閴?Completed



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


閴?Completed



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


閴?Completed



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


閳?

Controller


閳?

Accelerator Scheduler



Result:


閴?Completed



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


閳?

Reusable IP


閳?

MAC/FIFO/Buffer


閳?

AI Accelerator



Result:


閴?Completed



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


閳规柡鏀㈤埞鈧?register_bank.v



Testbench/Day06/


閳规柡鏀㈤埞鈧?register_bank_tb.v



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


閳?

Hardware Configuration


閳?

Reusable Hardware IP



Hardware connection:


Register Bank


閳?

Processing Element


閳?

MAC Unit


閳?

AI Accelerator



Result:


閴?Completed
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

Status: Completed 閴?
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

partial_sum = partial_sum + activation 鑴?weight


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

2 鑴?3

Result:

partial_sum = 6


Test2:

4 鑴?5

Result:

partial_sum = 26


Test3:

10 鑴?2

Result:

partial_sum = 46


Simulation:

PASS 閴?

## Debug Experience

Issue:

TEST1 initially failed.


Root Cause:

Testbench checked partial_sum before the first clock edge.


Lesson:

Sequential hardware requires:

Input setup

閳?
Clock edge

閳?
Register update

閳?
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

[x] Implemented INT8 鑴?INT8 閳?INT16 multiplication

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

Multiple MAC units 閳?PE Array


Future:

PE Array 閳?Systolic Array 閳?NPU Accelerator

## Day10: PE Array and Parallel Computation

Status: Completed 閴?
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
Completed 閴?```

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

閳?
Loader

閳?
Compute Array

閳?
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

濞ｅ崬鍙嗛悶鍡毿?Day12 Accelerator Integration 閺嬭埖鐎敍灞肩矤 RTL 濡€虫健鐠佹崘顓告潻娑樺弳 AI 閼侯垳澧栫化鑽ょ埠閺嬭埖鐎悶鍡毿掗妴?
閺堫剚妫╅柌宥囧仯娑撳秵妲告晶鐐插閺傛壆娈?RTL閿涘矁鈧本妲搁崚鍡樼€藉鍙夋箒 Accelerator Framework 娑擃厼鎮囧Ο鈥虫健閻ㄥ嫯浜寸拹锝冣偓浣规殶閹诡喗绁﹂崪灞惧付閸掕泛鍙х化姹団偓?
---

# Day13 Learning Summary

## 1. Accelerator Top Architecture

閸掑棙鐎介敍?
```
accelerator_top.v
```

閻炲棜袙鐎瑰本鏆?Accelerator 閻ㄥ嫬鐪板▎锛勭波閺嬪嫸绱?
```
Accelerator

閳规壕鏀㈤埞鈧?Controller FSM
閳?閳规壕鏀㈤埞鈧?Weight Loader
閳?閳规壕鏀㈤埞鈧?Activation Loader
閳?閳规柡鏀㈤埞鈧?Systolic Array
        |
        |
       PE Array
```

閺嶇绺鹃幀婵囧厒閿?
娑撯偓娑?AI Accelerator 閻㈡唻绱?
* Control Path
* Data Path
* Compute Engine

閸忓崬鎮撶紒鍕灇閵?
---

# 2. Controller FSM Analysis

鐎涳缚绡勯敍?
```
controller_fsm.v
```

閻炲棜袙 FSM 閸?Accelerator 娑擃厾娈戞担婊呮暏閿?
閻樿埖鈧緤绱?
```
IDLE

閳?
LOAD_WEIGHT

閳?
COMPUTE

閳?
OUTPUT

閳?
CLEAR
```

FSM 鐠愮喕鐭楅敍?
* 閻樿埖鈧胶顓搁悶?* 閹貉冨煑娣団€冲娇閻㈢喐鍨?* 鐠侊紕鐣诲ù浣衡柤鐠嬪啫瀹?
FSM 娑撳秷绀嬬拹锝忕窗

* 娑旀ɑ纭?* 閸旂姵纭?* MAC鐠侊紕鐣?
鐎圭偟骞囬敍?
Control Path 娑?Data Path 閸掑棛顬囬妴?
---

# 3. Weight Loader Analysis

鐎涳缚绡勯敍?
```
weight_loader.v
```

閻炲棜袙閿?
Weight Loader 鐏炵偘绨弫鐗堝祦鐠侯垰绶為妴?
娴ｆ粎鏁ら敍?
閸?Compute Engine 閹绘劒绶甸弶鍐櫢閺佺増宓侀妴?
瑜版挸澧犻悧鍫熸拱閿?
閸ュ搫鐣鹃弶鍐櫢鏉堟挸鍙嗛敍?
```
weight = [5,7,0,0]
```

鐏炵偘绨弫娆忣劅閻?Buffer/Register 濡€崇€烽妴?
閺堫亝娼甸崡鍥╅獓閺傜懓鎮滈敍?
```
DRAM

閳?
DMA

閳?
SRAM Weight Buffer

閳?
Compute Engine
```

---

# 4. Activation Loader Analysis

鐎涳缚绡勯敍?
```
activation_loader.v
```

閻炲棜袙 Activation 娑?Weight 閻ㄥ嫬灏崚顐窗

|      | Weight        | Activation        |
| ---- | ------------- | ----------------- |
| 閺夈儲绨?  | 濡€崇€烽崣鍌涙殶          | 娑擃參妫跨拋锛勭暬缂佹挻鐏?           |
| 閸欐ê瀵?  | 閸ュ搫鐣?           | 閸斻劍鈧?               |
| 婢跺秶鏁?  | 妤?            | 娴?                |
| 鐎涙ê鍋嶇粵鏍殣 | Weight Buffer | Activation Buffer |

閸ョ姵顒濋惇鐔风杽 NPU 闁艾鐖堕崚鍡楃磻缁狅紕鎮婇妴?
---

# 5. Systolic Array Analysis

鐎涳缚绡勯敍?
```
systolic_array_4x4.v
```

閻炲棜袙閿?
4鑴? Systolic Array閿?
```
16 PE
```

閺佺増宓佸ù渚婄窗

Activation:

```
瀹?閳?閸?```

Weight:

```
娑?閳?娑?```

濮ｅ繋閲?PE 閸氬本妞傞幍褑顢戦敍?
```
MAC
+
Data Forwarding
```

---

# 6. PE Unit Analysis

鐎涳缚绡勯敍?
```
pe_unit.v
```

閻炲棜袙 PE 閺?Accelerator 閺堚偓閸╃儤婀扮拋锛勭暬閸楁洖鍘撻妴?
閸旂喕鍏橀敍?
```
Multiply

+

Accumulate

+

Forward
```

閺嶇绺剧拋锛勭暬閿?
```
accumulator =
accumulator + activation * weight
```

---

# Day13 Architecture Insights

## Control Path

鐠愮喕鐭楅敍?
```
娴犫偓娑斿牊妞傞崐娆掝吀缁?娴犫偓娑斿牊妞傞崐娆忓鏉?娴犫偓娑斿牊妞傞崐娆掔翻閸?```

濡€虫健閿?
```
Controller FSM
```

---

## Data Path

鐠愮喕鐭楅敍?
```
閺佺増宓佹俊鍌欑秿缁夎濮?閺佺増宓佹俊鍌欑秿鐠侊紕鐣?```

濡€虫健閿?
```
Loader

Systolic Array

PE
```

---

# Engineering Improvements Identified

瑜版挸澧?Day12 Accelerator閿?
* Fixed latency
* Fixed weight
* Fixed activation
* No memory interface
* No compute done handshake

閺堫亝娼甸崡鍥╅獓閺傜懓鎮滈敍?
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

鐎瑰本鍨氶敍?
娴?RTL Module Designer

閸?
AI Accelerator Architecture Designer

閻ㄥ嫮鎮婄憴锝呭磳缁狙佲偓?
## Day14

Status

閴?Completed

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
閳?Controller FSM
閳?Data Fetch
閳?Compute Engine
閳?Output Buffer

Current milestone:

Able to trace a complete NPU task from start command to result storage.

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

================================
# 11. Engineering Habits Learned
================================


## Habit 1


Always verify results.


Example:


RTL


閳?

Simulation


閳?

Waveform


閳?

Confirmation



---


## Habit 2


Debug by layers.



Problem


閳?

Locate layer


閳?

Verify hypothesis


閳?

Fix


閳?

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


- Systolic array integration
- Parallel matrix multiply
- Pipeline optimization
- Memory hierarchy
- Full NPU architecture



================================
# 15. Next Mission
================================


Day17:


Parallel Matrix Multiplication



Goal:


- Integrate systolic array into NPU compute path
- Parallelize the 4 dot products of a 2x2 matrix multiply
- Understand dataflow scheduling (weight stationary)
- Compare serial vs parallel latency
- Verify parallel result against Day16 serial result



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

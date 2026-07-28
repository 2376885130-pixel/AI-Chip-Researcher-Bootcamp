================================
# Day06 Engineering Debrief
================================


Date:

2026-07-28


Day:

Day06


Project:

Parameterized Register Bank IP


Version:

1.0


Git Commit:

(To be updated after commit)



================================
# 1. Project Objective
================================


## What did we build?


Implemented a parameterized Register Bank hardware IP.


The design contains:


- Multiple registers
- Write control logic
- Address selection
- Read data path



The final hardware block can store and retrieve
configurable width data.



---


## Why did we build it?


A processor or AI accelerator requires
fast local storage structures.


Register Bank introduces the concept of:

- Internal hardware storage
- Address-based data access
- Reusable IP design



The purpose is not only creating memory,
but understanding how configurable hardware blocks
are designed.



---


## Where is this used?


Register Bank


↓


Processing Element


↓


MAC Unit


↓


Systolic Array


↓


AI Accelerator



Possible applications:


- Weight storage
- Activation buffer
- Intermediate result storage



================================
# 2. Engineering Background
================================


Modern digital systems require fast access
to frequently used data.


External memory has limited speed,
therefore processors and accelerators use
small high-speed storage structures.


Register Bank solves this problem by providing:


- Multiple storage locations
- Fast read access
- Controlled write operation



Without Register Bank:


- Data access becomes slower
- Hardware datapath efficiency decreases
- Accelerator throughput is limited



================================
# 4. Code Deep Explanation
================================


## File:


RTL/Day06/register_bank.v



---


## Module Purpose:


Create a configurable register storage IP.



Parameters:


DATA_WIDTH:


Controls data size.



DEPTH:


Controls number of registers.



---


## Storage Array:


```verilog
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

Hardware meaning:

Creates:

DEPTH

number of registers,

each register has:

DATA_WIDTH

bits.

Example:

DATA_WIDTH=16

DEPTH=8

Hardware:

8 registers

×

16 bits

Write Logic:
always @(posedge clk)

Hardware representation:

Clock edge triggers register update.

When:

write_enable = 1

Data is stored into selected register.

Read Logic:
assign read_data = mem[read_addr];

Hardware representation:

Address decoder

Multiplexer

The selected register value
appears at output.

================================

5. Design Decision Analysis

================================

Why use parameterized design?

Alternative:

Create separate modules:

register_bank_8bit

register_bank_16bit

register_bank_32bit

Problem:

Code duplication

Difficult maintenance

Poor scalability

Parameterized RTL provides:

One design

↓

Multiple hardware configurations

Trade-off:

Advantages:

Reusable IP

Less duplicated code

Easier verification

Cost:

Requires careful parameter validation

================================

6. Simulation and Verification Analysis

================================

Verification included:

Multiple address write test

Multiple address read test

Parameter-driven testbench

Self-checking comparison

Test configuration:

DATA_WIDTH = 16

DEPTH = 8

Expected:

Each register stores unique data.

Result:

PASS : addr=0 expected=0001 actual=0001

PASS : addr=1 expected=0002 actual=0002

...

TEST PASSED

Verification confidence:

The RTL correctly implements
parameterized storage and retrieval.

================================

7. Debugging Record

================================

Problem:

Read output returned:

Reg0 = xx

Initial Hypothesis:

Possible memory initialization problem.

Investigation:

Checked:

Write enable

Clock behavior

Reset timing

Root Cause:

Reset remained active during write operation.

The write logic priority was:

Reset

Write Enable

Therefore:

write operation was blocked.

Solution:

Released reset before starting write test.

General Lesson:

Control signals define hardware behavior.

Always verify:

Reset sequence

Enable timing

Clock relationship

================================

8. Hardware Thinking Transfer

================================

Current concept:

Register Bank

↓

Digital hardware:

Storage array

Address selection

Control logic

↓

AI accelerator:

Register Bank

↓

Processing Element

↓

MAC pipeline

↓

Systolic Array

Register Bank provides
local data access for computation.

================================

9. Personal Understanding

================================

Before this project:

I thought a register bank was only
a group of variables.

After this project:

I understand it is a hardware structure
consisting of multiple physical registers,
address selection logic,
and control timing.

The most important concept:

Parameterized RTL creates reusable hardware IP.

The most confusing part:

Understanding the relationship between
reset timing and write operation.

================================

10. Knowledge Verification

================================

Questions:

Why does DATA_WIDTH parameter
change hardware structure?

Why does DEPTH determine address width?

If read_data becomes incorrect,
which signal should be checked first?

Where would Register Bank appear
inside an AI accelerator?

================================

11. Remaining Questions

================================

Questions:

How should dual-port Register Bank be designed?

How can Register Bank support simultaneous
read and write?

How does SRAM replace register arrays
in larger accelerators?

================================

12. Engineering Lessons

================================

Learned:

Parameterized RTL improves hardware reuse.

Verification must scale with design complexity.

Reset behavior is part of hardware design.

Documentation is part of engineering delivery.

Debugging follows observation → hypothesis → verification.

================================

13. Final Evaluation

================================

AI Evaluation:

Understanding level:

☑ Understand

☑ Can modify

Next improvement:

Design arithmetic IP
and connect storage with computation.

================================

14. Completion Checklist

================================

Project completed:

☑ Code finished

☑ Simulation passed

☑ Git committed

☑ Engineering Debrief completed

☑ Learner can explain design


---

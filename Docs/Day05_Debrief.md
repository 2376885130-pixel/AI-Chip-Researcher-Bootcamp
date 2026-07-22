# AI Chip Researcher Bootcamp
# Engineering Debrief Day05


Version:

1.0


================================
# Project Information
================================


Date:

2026-07-22


Day:

Day05


Project:

Parameterized RTL Counter


Version:

1.0


Git Commit:

34d61df



================================
# 1. Project Objective
================================


## What did we build?


Implemented a parameterized synchronous counter RTL module.


The module supports:


- configurable bit width
- clock-driven state update
- synchronous reset
- enable-controlled counting



Files:


RTL/Day05/counter_param.v



Verification:


Testbench/Day05/counter_param_tb.v



Simulation:


Simulation/Day05/counter_param.vcd



---


## Why did we build it?


The purpose was not only to implement a counter.


The engineering goal was to understand:


How to design reusable hardware IP using parameterized RTL.



A fixed counter:


8-bit Counter


can only support one hardware configuration.


A parameterized counter:


parameter WIDTH


can generate different hardware sizes:


WIDTH=8

↓

8-bit counter


WIDTH=32

↓

32-bit counter



---

## Where is it used?


Counter is a fundamental hardware component.


Applications:


Counter

↓

Address Generation

↓

Memory Controller

↓

Pipeline Control

↓

AI Accelerator Scheduler



================================
# 2. Engineering Background
================================


Digital hardware systems require state storage
and controlled state transition.


A counter solves problems such as:


- cycle counting
- address generation
- control timing
- operation scheduling



Without a counter:


Hardware cannot easily track:


- computation steps
- memory positions
- pipeline stages



A counter consists of:


Current State

+

Next State Logic

+

Clock Update



Hardware structure:


Register

+

Adder

+

Feedback Path



================================
# 3. Command Deep Explanation
================================



## Command:

mkdir


## Function:


Create directories.



## Why is it needed?


Hardware projects require organized structures.


Example:


RTL

Testbench

Simulation

Documentation



## Future usage:


Large AI chip projects also separate:


RTL

Verification

Scripts

Reports



---


## Command:

iverilog


## Function:


Compile Verilog RTL code.



## Why is it needed?


Check whether RTL description can be interpreted
by simulation tools.



## Future usage:


Used for:


RTL verification

Regression testing

Hardware development workflow



---


## Command:

vvp


## Function:


Execute compiled Verilog simulation.



## Why is it needed?


Generate simulation results.



---


## Command:

gtkwave


## Function:


View waveform files.



## Why is it needed?


Hardware behavior must be analyzed through signals
and timing.



================================
# 4. Code Deep Explanation
================================



## File:


RTL/Day05/counter_param.v



---


## Module Purpose:


Implement a configurable synchronous counter.



---


## Parameter:


```verilog
parameter WIDTH = 8
````

Function:

Controls hardware data width.

Hardware meaning:

WIDTH determines:

Number of Flip-Flops

and

Adder width.

Example:

WIDTH=8

generates:

8-bit register

*

8-bit adder

---

## Register Output:

```verilog
output reg [WIDTH-1:0] count
```

Hardware meaning:

Creates WIDTH-bit storage.

Example:

WIDTH=8

means:

8 Flip-Flops.

---

## Clock Logic:

```verilog
always @(posedge clk)
```

Hardware meaning:

Register updates on clock rising edge.

Equivalent hardware:

Clock

↓

Flip-Flop Trigger

---

## Reset:

```verilog
if(reset)

    count <= 0;
```

Hardware meaning:

Initialize register state.

---

## Enable:

```verilog
else if(enable)

    count <= count + 1;
```

Hardware meaning:

Adder calculates next state.

Register stores new value
at next clock edge.

================================

# 5. Design Decision Analysis

================================

## Why parameterized design?

Because hardware IP should be reusable.

Alternative:

Create separate modules:

counter8

counter16

counter32

Problem:

* duplicate code
* difficult maintenance
* poor scalability

Parameterized design provides:

* flexibility
* reuse
* easier architecture exploration

---

## Trade-offs

Advantages:

Area:

Configurable hardware size.

Complexity:

One design supports multiple versions.

Verification:

Need to test different parameter values.

================================

# 6. Simulation and Verification Analysis

================================

Tested:

## Reset

Expected:

count becomes 0.

Result:

Passed.

---

## Enable Counting

Expected:

count increases every clock.

Result:

Passed.

---

## Disable

Expected:

count keeps current value.

Result:

Passed.

---

Verification Flow:

RTL

↓

Icarus Verilog

↓

VCD waveform

↓

GTKWave

Hardware confidence comes from:

simulation matching design intention.

================================

# 7. Debugging Record

================================

## Problem:

No major RTL errors.

---

## Investigation:

Checked:

* Verilog compilation
* simulation output
* waveform generation

---

## Result:

Simulation completed successfully.

---

## General Lesson:

Do not assume code correctness.

Always verify:

syntax

↓

simulation

↓

waveform

↓

hardware behavior

================================

# 8. Hardware Thinking Transfer

================================

Current Concept:

Parameterized Counter

Connection:

Counter

↓

Address Generator

↓

Memory Controller

↓

AI Accelerator Control

Parameterized RTL

↓

Reusable Hardware IP

↓

MAC Unit

↓

Processing Element

↓

Systolic Array

↓

NPU Architecture

================================

# 9. Personal Understanding

================================

Before this project:

I thought a counter was only a simple counting circuit.

After this project:

I understand that a counter is a state machine
with register storage and next-state calculation.

Most important concept:

Parameter is hardware configuration,
not a software variable.

Most confusing part:

Understanding the difference between
software execution and hardware structure.

================================

# 10. Knowledge Verification

================================

## Question 1:

Why is parameter WIDTH not a runtime variable?

Answer:

Because parameter changes hardware generation,
not hardware operation.

---

## Question 2:

How to add up/down counting?

Answer:

Add direction control logic
and select between count+1 and count-1.

---

## Question 3:

If waveform skips a count value,
what should be checked first?

Answer:

Check clock, reset, enable timing
before modifying RTL.

---

## Question 4:

Why does AI hardware use parameterized design?

Answer:

Because MAC, FIFO and Buffer require
different data widths and sizes.

================================

# 11. Remaining Questions

================================

1.

How does parameterized RTL become optimized hardware after synthesis?

2.

How are parameters managed in large AI accelerator projects?

3.

How do SystemVerilog interfaces improve reusable IP design?

================================

# 12. Engineering Lessons

================================

Learned:

* Design reusable hardware modules.
* Verify before trusting RTL.
* Analyze waveform, not only simulation result.
* Separate design, verification and documentation.
* Record engineering decisions.

================================

# 13. Final Evaluation

================================

AI Evaluation:

Understanding level:

☑ Familiar

☑ Understand

☑ Can modify

□ Can independently design

Next improvement:

Practice more reusable hardware blocks:

* FIFO
* Pipeline Register
* Data Buffer
* Handshake Interface

================================

# 14. Completion Checklist

================================

Project completed:

☑ Code finished

☑ Simulation passed

☑ Git committed

☑ Engineering Debrief completed

☑ Learner can explain design


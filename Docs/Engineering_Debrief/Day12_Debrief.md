# Day12 Engineering Debrief

## 1. What was built?

Completed the first AI Accelerator architecture framework.

Implemented:

- Streaming MAC PE
- PE Array
- Systolic Array structure
- Controller FSM
- Weight Loader
- Activation Loader
- Accelerator Top


Architecture:

Controller

↓

Loader

↓

Systolic Array

↓

Processing Element


---

## 2. Why was it built?

The goal was moving from isolated RTL modules
to a complete accelerator architecture.

A real AI accelerator requires:

- computation unit
- data movement
- control logic


MAC alone cannot perform matrix multiplication efficiently.


---

## 3. Important Commands

iverilog -g2012

Purpose:

Compile SystemVerilog RTL and testbench.


vvp

Purpose:

Run RTL simulation.


GTKWave

Purpose:

Analyze waveform timing.


---

## 4. Design Understanding


### PE v4

A PE contains:

- multiplier
- accumulator
- data forwarding


Operation:

accumulator =
accumulator + activation × weight


### Systolic Array

Multiple PE units form parallel computation.


Data movement:

Activation:

left → right


Weight:

top → bottom


Partial computation:

inside PE accumulator


---

## 5. Debugging Analysis


Problem:

Matrix multiplication result incorrect.


Observation:

Output:

15 21
35 49


Expected:

19 22
43 50


Cause:

Weight scheduling and data timing were incorrect.


Lesson:

AI accelerator design requires:

- computation design
- dataflow design
- control scheduling


---

## 6. Hardware Connection


CPU:

general control


GPU:

many parallel compute units


NPU:

optimized MAC array + memory movement


Today's design is the foundation of NPU compute core.


---

## 7. Next Step

Implement:

- Accelerator top testbench
- Tile based matrix multiplication
- SRAM buffer model
- Data scheduler


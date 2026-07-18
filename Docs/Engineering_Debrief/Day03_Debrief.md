# Day03 Engineering Debrief

## Topic

Sequential Logic Fundamentals


---

# Completed Modules


## 1. D Flip-Flop


File:

RTL/Day03/dff.v


Concepts:

- Clock edge
- always @(posedge clk)
- Non-blocking assignment


Key understanding:


A flip-flop stores data only at the clock edge.


---

# 2. D Flip-Flop with Reset


File:

RTL/Day03/dff_reset.v


Concepts:

- Synchronous reset
- Initialization
- Known hardware state


Key understanding:


Reset forces the register into a predictable state.


---

# 3. 8-bit Register


File:

RTL/Day03/register8.v


Concepts:

- Data bus
- Register array
- Parallel storage


Key understanding:


An 8-bit register is built from multiple flip-flops working together.


---

# 4. Counter


File:

RTL/Day03/counter8.v


Concepts:

- Feedback path
- Register + Adder
- State update


Key understanding:


A counter is a sequential circuit that updates its state every clock cycle.


---

# Hardware Thinking


Combinational Logic:


Input

↓

Logic

↓

Output



Sequential Logic:


Input

↓

Register

↓

Output



Combinational logic calculates.


Sequential logic remembers.


---

# AI Hardware Connection


Registers are fundamental building blocks in:


- CPU pipelines
- GPU execution units
- NPU datapaths


Counters are used for:


- Address generation
- Control logic
- Data scheduling


---

# Debug Experience


Problem:

Understanding why output does not immediately follow input.


Cause:

Sequential logic depends on clock edges.


Solution:

Analyze the relationship between:

- Clock
- Input
- Register state


Lesson:


Hardware behavior is determined by structure and timing.


---

# Next Goal


Day04:

Finite State Machine (FSM)


Topics:

- State
- Transition
- Controller design
- Hardware control flow

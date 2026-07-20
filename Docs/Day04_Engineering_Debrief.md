# Day04 Engineering Debrief

## Project Information

Day:

Day04

Project:

Traffic Light FSM Controller


---

# 1. Project Objective


## What did we build?


Implemented a synchronous traffic light controller
using a Moore Finite State Machine.


The FSM contains three states:

RED

GREEN

YELLOW



## Why did we build it?


The purpose is to understand
hardware control logic design.


FSM is the foundation of many hardware controllers.


Examples:

CPU controller

UART controller

Memory controller

AI accelerator controller



## Where is it used?


FSM

↓

Control Logic

↓

System Controller

↓

AI Accelerator Scheduling



---

# 2. Engineering Background


Digital hardware often needs
different behaviors at different times.


Examples:


CPU:

FETCH

↓

DECODE

↓

EXECUTE


AI Accelerator:

IDLE

↓

LOAD DATA

↓

MAC COMPUTATION

↓

WRITE BACK



FSM provides a hardware method
to describe these behaviors.



---

# 3. Design Architecture


The design uses
three-stage FSM architecture:


1. State Register


Stores current state.


Implemented using flip-flops.



2. Next State Logic


Calculates next state
using combinational logic.



3. Output Logic


Generates outputs
according to current state.



---

# 4. Design Decision Analysis


## Why Moore FSM?


Because output only depends on current state.


Advantages:

- Stable output
- Easier verification
- No asynchronous output changes



## Why three-process FSM?


Advantages:


- Clear structure
- Easier debugging
- Industry common style



---

# 5. Verification Analysis


Tested:


- Reset behavior
- Clock operation
- State transition
- Output correctness



Expected sequence:


RED

↓

GREEN

↓

YELLOW

↓

RED



Simulation:


Icarus Verilog


Waveform:


GTKWave



---

# 6. Hardware Thinking Transfer


FSM

↓

Controller


Controller

↓

MAC scheduling


Controller

↓

Systolic Array operation control


AI accelerator requires FSM
to coordinate computation flow.



---

# 7. Personal Understanding


Before this project:


I thought FSM was only a coding pattern.


After this project:


I understand FSM is a hardware architecture
used to control state transitions.



Most important concept:


Current state represents reality.

Next state represents future decision.



---

# 8. Knowledge Verification


Questions:


1.

Why does output logic use current_state
instead of next_state?



2.

What hardware does
always @(posedge clk)
represent?



3.

How would you add an ERROR state?



4.

Where would FSM appear inside an NPU?



---

# 9. Engineering Lessons


Learned:


- Design state diagram before RTL
- Separate sequential and combinational logic
- Verify every hardware module
- Think in hardware timing


---

# Final Evaluation


Understanding level:


☐ Familiar

☑ Understand

☐ Can modify

☐ Can independently design



Next improvement:


Implement more complex controllers.

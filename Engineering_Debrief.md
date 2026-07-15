# AI Chip Researcher Bootcamp
# Engineering Debrief


Version:

1.0


Purpose:


This document records deep understanding
after completing engineering tasks.



The goal is not:


"Remember what was done."



The goal is:


Understand why it was done,
how it works,
and how it connects to AI hardware.



================================
# Debrief Workflow
================================


After completing:


- experiment
- RTL module
- debugging task
- project milestone



AI should conduct a complete engineering debrief.



Completion requires:


Implementation

+

Verification

+

Understanding

+

Reflection



================================
# Project Information
================================


Date:


Day:


Project:


Version:


Git Commit:



================================
# 1. Project Objective
================================



## What did we build?


Describe:


The final result.



Example:


Implemented a synchronous counter RTL module.



---

## Why did we build it?


Explain:


The engineering purpose.



Not:


"Because the tutorial asked."



Instead:


"This module teaches how sequential logic
stores state using clock-driven registers."



---

## Where is this used?


Connect to real systems.



Example:


Counter


↓

Control logic


↓

Address generation


↓

Memory controller


↓

AI accelerator scheduling



================================
# 2. Engineering Background
================================



Before implementation:


Explain the underlying problem.



Questions:


Why does this hardware exist?


What problem does it solve?


What would happen without it?



================================
# 3. Command Deep Explanation
================================



For every important command:



## Command:


Example:


mkdir


---


## Function:


What does this command do?



---


## Why is it needed?


Engineering reason.



---


## Future usage:


Where will this appear later?



Example:


mkdir


Today:


Create project folder.



Future:


Organize:


RTL

Testbench

Simulation

Scripts



================================
# 4. Code Deep Explanation
================================



For every important code:



## File:


example.v



---


## Module Purpose:


What hardware block does it represent?



---


## Code:


```verilog

Line-by-line explanation:
Explain:
syntax
function
hardware meaning

Hardware Representation:
Convert:
Code
↓
Circuit structure
Example:
always @(posedge clk)
means:
A flip-flop updates on clock edge.
================================
5. Design Decision Analysis
================================
For every design:
Explain:
Why this architecture?
What alternatives exist?
Why not choose alternatives?
Trade-offs:
Consider:
Area
Speed
Power
Complexity
Verification difficulty
================================
6. Simulation and Verification Analysis
================================
Explain:
What was tested?
Why is the testbench designed this way?
What signals should be observed?
How do we know it is correct?
Connect:
Simulation result
↓
Hardware confidence
================================
7. Debugging Record
================================
Every important error becomes
a learning case.
Problem:
Describe the symptom.

Error Message:
Exact error.

Initial Hypothesis:
What did we think first?

Investigation:
What tests were performed?

Root Cause:
Why did it happen?

Solution:
How was it fixed?

General Lesson:
How to handle similar problems?
================================
8. Hardware Thinking Transfer
================================
Every concept must connect
to future AI hardware.
Explain:
Current concept
↓
Digital hardware
↓
AI accelerator
Example:
Register
↓
Pipeline stage
↓
MAC pipeline
↓
Systolic Array
================================
9. Personal Understanding
================================
The learner writes:
Before this project:
I thought:
After this project:
I understand:
The most important concept:
The most confusing part:
================================
10. Knowledge Verification
================================
AI asks questions.
Examples:
Understanding
Explain this design
without looking at code.
Modification
How would you change it?
Debugging
If this signal fails,
where would you check first?
Architecture
Where would this appear
in an AI accelerator?
================================
11. Remaining Questions
================================
Questions:
1.
2.
3.
These questions become
future learning tasks.
================================
12. Engineering Lessons
================================
Record:
New engineering habits.
Examples:
Always verify output.
Always commit milestones.
Separate design and verification.
Debug by layers.
================================
13. Final Evaluation
================================
AI Evaluation:
Understanding level:
□ Familiar
□ Understand
□ Can modify
□ Can independently design
Next improvement:
================================
14. Completion Checklist
================================
Project completed:
□ Code finished
□ Simulation passed
□ Git committed
□ Engineering Debrief completed
□ Learner can explain design

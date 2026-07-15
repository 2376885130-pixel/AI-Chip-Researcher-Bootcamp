# AI Chip Researcher Bootcamp


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


Current interests:


## AI Accelerator


- Matrix multiplication acceleration
- Neural network hardware optimization
- Efficient computation architecture



## Digital IC Design


- RTL design
- Hardware architecture
- Verification methodology
- Pipelining



## NPU Architecture


Future focus:


- MAC array
- Processing Element
- Systolic Array
- Memory architecture
- Control architecture



---

# Learning Roadmap


## Phase 1

## Development Environment


Status:

✅ Completed



Contents:


- Linux environment
- WSL2 Ubuntu
- Git workflow
- Verilog simulation environment
- GitHub SSH workflow



---

## Phase 2

## RTL Design Fundamentals


Status:

🚧 In Progress



Topics:


- Verilog/SystemVerilog
- Module design
- Combinational logic
- Sequential logic
- Clock and reset
- FSM



Projects:


Coming soon.



---

## Phase 3

## Hardware Verification


Topics:


- Testbench methodology
- Simulation
- Waveform analysis
- Assertions



---

## Phase 4

## Digital Hardware Architecture


Topics:


- Register
- FIFO
- Pipeline
- Memory interface
- Controller



---

## Phase 5

## AI Accelerator Design


Target project:


Build a simple AI accelerator.



Architecture path:


Logic Gate


↓

RTL Module


↓

MAC Unit


↓

Processing Element


↓

Systolic Array


↓

Matrix Multiplication Accelerator


↓

NPU Architecture



---

# Current Environment


## Platform


Windows 11

+

WSL2 Ubuntu



## Tools


| Tool | Version |
|-|-|
| Git | 2.43.0 |
| Icarus Verilog | 12.0 |
| GTKWave | 3.3.116 |
| Tree | 2.1.1 |



---

# Completed Projects


## Day01

## First RTL Simulation


Project:


AND Gate


Files:
Day01/
├── and_gate.v
├── and_gate_tb.v
├── and_gate_sim
└── and_gate.vcd


Workflow:


RTL


↓

Compilation


↓

Simulation


↓

Waveform Verification



Result:


✅ Completed



---

# Engineering Documentation


This repository maintains:


## AI_Mentor_DNA.md


Defines:


- AI teaching rules
- Learning methodology
- Engineering workflow



---

## Bootcamp_Progress.md


Tracks:


- Current learning status
- Environment state
- Completed tasks
- Next objectives



---

## Environment_Log.md


Records:


- Installation history
- Configuration changes
- Debugging cases



---

## Engineering_Debrief.md


Records:


- Project analysis
- Code understanding
- Design decisions
- Debugging lessons
- Hardware thinking



---

# Engineering Principles


## 1. Understand before copying


Code execution is not equal to knowledge.



## 2. Debug by layers


Problem:


↓

Locate layer


↓

Verify hypothesis


↓

Fix


↓

Confirm



## 3. Hardware thinking


Software:


Instruction execution


Hardware:


Structure and timing



## 4. Verification matters


A design is incomplete
until it is verified.



---

# Repository Structure
AI-Chip-Researcher-Bootcamp
│
├── Day01
├── RTL
├── Testbench
├── Simulation
├── Python
├── Papers
├── Docs
│
├── AI_Mentor_DNA.md
├── Bootcamp_Progress.md
├── Environment_Log.md
├── Engineering_Debrief.md
└── README.md



---

# Git Workflow


This repository uses:


SSH authentication


Remote:
git@github.com:2376885130-pixel/
AI-Chip-Researcher-Bootcamp.git


Workflow:


```bash
git status

git add .

git commit -m "message"

git push
________________________________________
Future Goals
Build capability to independently:
•	Design RTL systems
•	Develop hardware accelerators
•	Understand NPU architecture
•	Conduct AI hardware research
Final goal:
Design and implement
a complete AI accelerator system.



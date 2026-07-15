# AI Chip Research Environment Log


Version:

1.0


Last Update:

2026-07-15



================================
# Purpose
================================


This document records:


- environment setup
- software installation
- configuration changes
- debugging cases
- solutions


Purpose:


Maintain a reproducible AI chip development environment.



================================
# Environment Overview
================================


Host System:


Windows 11



Virtual Environment:


WSL2



Linux Distribution:


Ubuntu



Linux User:


aichip



Project Location:


/home/aichip/AI-Chip-Researcher-Bootcamp



================================
# 2026-07-14
# Initial Environment Setup
================================



## Linux Environment


Completed:


Installed WSL2.


Installed Ubuntu.


Created Linux user.


Enabled sudo permission.



Purpose:


Provide Linux environment for:


- RTL development
- simulation
- AI hardware research



Engineering Understanding:


Linux is the standard environment
for digital IC and EDA workflows.



================================
# Development Tool Installation
================================



## Git


Installed:


Git 2.43.0



Purpose:


Version control for:


- RTL code
- experiments
- documentation



Verification:


Command:


git --version



Result:


git version 2.43.0



---


## Icarus Verilog


Installed:


Version 12.0



Purpose:


RTL simulation.



Verification:


Command:


iverilog -V



Result:


Icarus Verilog version 12.0



---


## GTKWave


Installed:


Version 3.3.116



Purpose:


Waveform visualization.



Verification:


Command:


gtkwave --version



Result:


GTKWave Analyzer v3.3.116



---


## Tree


Installed:


Version 2.1.1



Purpose:


Visualize project structure.



Verification:


Command:


tree --version



Result:


tree v2.1.1



================================
# First RTL Experiment
================================



Date:


2026-07-14



Project:


AND Gate Simulation



Files:


and_gate.v


and_gate_tb.v



Tools:


Icarus Verilog


GTKWave



Process:


RTL


↓

Compilation


↓

Simulation


↓

Generate VCD


↓

Waveform inspection



Result:


Simulation successful.



Engineering Meaning:


Completed first hardware verification workflow.



================================
# Git Environment Setup
================================



## Repository Creation


Created:


AI-Chip-Researcher-Bootcamp



Structure:


RTL

Testbench

Simulation

Python

Docs

Papers



Purpose:


Create long-term AI chip research archive.



---


## Git Identity Configuration


Configured:


Name:


2376885130-pixel



Email:


2376885130@qq.com



Purpose:


Identify commit author.



================================
# GitHub Connection Debug Case
================================



Date:


2026-07-15



Problem:


GitHub push failed.



Initial Method:


HTTPS



Remote:


https://github.com/2376885130-pixel/
AI-Chip-Researcher-Bootcamp.git



Error:


GnuTLS recv error (-110)



================================
# Debug Process
================================



## Step 1


Check Git configuration.



Result:


Git configuration correct.



Conclusion:


Not Git identity problem.



---


## Step 2


Check network connectivity.



Command:


ping github.com



Result:


Successful.



Conclusion:


Network reachable.



---


## Step 3


Check HTTPS connection.



Command:


curl -I https://github.com



Result:


TLS connection failed.



Conclusion:


Problem located at HTTPS/TLS layer.



================================
# Solution
================================



Changed:


GitHub HTTPS


to:


GitHub SSH



Created SSH key:


Algorithm:


ED25519



Location:


~/.ssh/id_ed25519



Configured remote:


git@github.com:2376885130-pixel/
AI-Chip-Researcher-Bootcamp.git



Verification:


git push -u origin main



Result:


Successful.



================================
# Engineering Lesson
================================



Problem solving method:


Do not randomly change settings.



Use:


Symptom

↓

Layer identification

↓

Experiment

↓

Root cause

↓

Solution



This debugging method applies to:


- Linux
- Git
- FPGA tools
- EDA environment
- RTL simulation



================================
# Future Environment Records
================================



When installing new tools, record:


Date:


Tool:


Version:


Installation method:


Purpose:


Verification command:


Problems:


Solution:



================================
# Planned Future Tools
================================



Future environment may include:


RTL:


- Verilator
- Yosys



ASIC Flow:


- OpenROAD
- OpenLane



AI:


- Python
- PyTorch
- CUDA



FPGA:


- Vivado
- Quartus



Each installation should be recorded here.

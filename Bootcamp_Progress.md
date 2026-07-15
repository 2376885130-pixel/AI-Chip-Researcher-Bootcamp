# AI Chip Researcher Bootcamp
# Progress Snapshot


Version:

2.0


Last Update:

2026-07-15



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


Develop independent AI hardware research capability.


Target areas:


- AI Accelerator
- NPU Architecture
- Digital IC Design
- Hardware Software Co-design



================================
# 2. Current Learning Status
================================


Current Phase:


Phase 1

Development Environment



Current Day:


Day 1 Completed



Current Mission:


Build complete AI chip development environment.



Overall Status:


Completed.



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


✅ Installed



Purpose:


Version control and engineering workflow.



---


## Icarus Verilog


Version:


12.0



Status:


✅ Installed



Purpose:


RTL simulation.



---


## GTKWave


Version:


3.3.116



Status:


✅ Installed



Purpose:


Waveform visualization.



---


## Tree


Version:


2.1.1



Status:


✅ Installed



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


Clean



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


✅ Verified



Important Rule:


Future GitHub operations use SSH.



Do not use HTTPS remote.



Reason:


HTTPS push encountered:


GnuTLS recv error (-110)



Solution:


Switched to SSH authentication.



================================
# 7. Repository Structure
================================


Current Structure:


AI-Chip-Researcher-Bootcamp


├── Day01

├── RTL

├── Testbench

├── Simulation

├── Python

├── Papers

├── Docs

└── README.md



================================
# 8. Git History
================================


First Commit:


Commit ID:


2e3a3bd



Message:


Day01: Initialize AI Chip Research Environment



Commit Content:


Included:


- README.md

- hello.v

- and_gate.v

- and_gate_tb.v

- simulation files

- waveform files



================================
# 9. Completed Learning Record
================================



# Day 0

## Environment Setup


Completed:


✅ WSL2


✅ Ubuntu


✅ Linux user


✅ sudo permission



Understanding:


Linux is the foundation of hardware
development environment.



---


# Day 1

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



================================
# 10. Problems Solved
================================


## GitHub HTTPS Push Failure


Problem:


Cannot push repository.



Error:


GnuTLS recv error (-110)



Investigation:


Step 1:


Checked network.


Result:

github.com reachable.



Step 2:


Checked HTTPS connection.


Result:

TLS connection unstable.



Conclusion:


Problem was HTTPS/TLS layer.



Solution:


Changed:


HTTPS remote


↓

SSH remote



Result:


Push successful.



Engineering Lesson:


Debug problems by layers.



================================
# 11. Engineering Habits Learned
================================


## Habit 1


Always verify results.


Example:


After command:


pwd


ls



Confirm state before continuing.



---


## Habit 2


Backup/configuration awareness.



Example:


Before changing system configuration:


Create backup.



---


## Habit 3


Version control.


Important engineering milestones
should be committed.



================================
# 12. Current Knowledge Level
================================


## Linux


Can:


- navigate filesystem
- create/manage files
- understand directory structure



Need to learn:


- shell scripting
- permissions deeply
- environment variables



---


## Git


Can:


- create repository
- commit changes
- connect GitHub
- use SSH



Need to learn:


- branch workflow
- merge
- conflict resolution



---


## Verilog


Can:


- write simple module
- write testbench
- simulate
- view waveform



Need to learn:


- combinational logic
- sequential logic
- clock/reset
- FSM
- pipeline



================================
# 13. Current Blocker
================================


None



================================
# 14. Pending Task
================================


VS Code + WSL Integration


Status:


Not completed.



Goal:


Create complete RTL development workflow:


VS Code

↓

WSL Ubuntu

↓

Verilog

↓

Simulation

↓

GTKWave



================================
# 15. Next Mission
================================


Day 2:


RTL Design Fundamentals



Goal:


Understand:


- module
- port
- wire
- reg
- always block
- combinational logic
- sequential logic
- clock
- reset



Expected Project:


Design and verify first synchronous RTL module.



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

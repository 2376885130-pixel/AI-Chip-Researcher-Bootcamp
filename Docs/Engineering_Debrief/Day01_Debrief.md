很好，验收通过。现在你的仓库状态非常健康：

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

说明：

✅ 本地仓库正常
✅ GitHub同步正常
✅ 文档体系已经提交
✅ 当前没有未保存修改

你的工程环境已经达到一个比较规范的状态。

---

不过在进入 Day02 之前，我们先完成一个非常重要的步骤：

# 创建第一个 Engineering Debrief

也就是：

> Day01 工程复盘

这是你以后所有学习的模板。

---

## 先创建目录

目前：

```text
Docs
```

为空。

我们把复盘文件放这里：

执行：

```bash
mkdir -p Docs/Engineering_Debrief
```

解释：

```bash
mkdir
```

创建目录。

```bash
-p
```

表示：

如果父目录不存在，一起创建。

例如：

本来：

```
Docs
```

创建：

```
Docs/Engineering_Debrief
```

---

然后检查：

```bash
tree
```

应该看到：

```text
Docs
└── Engineering_Debrief
```

---

# 创建 Day01 复盘文件

执行：

```bash
nano Docs/Engineering_Debrief/Day01_Debrief.md
```

然后写入下面内容。

---

# Day01_Debrief.md

````markdown
# Day01 Engineering Debrief

## Project

AI Chip Research Environment Setup

First RTL Simulation

Date:

2026-07-14



# 1. Project Objective


## What did we build?


Today we built the first complete digital hardware development environment.


Completed:


- Linux development environment
- Git version control workflow
- Verilog simulation environment
- First RTL design and verification flow



The first RTL project:

AND Gate



---

## Why did we build it?


The purpose was not only to create an AND gate.


The real goal:


Understand the basic workflow used by digital IC engineers:


Design

↓

Simulation

↓

Verification

↓

Version Control



This workflow will be used later for:


- MAC Unit
- Processing Element
- Systolic Array
- AI Accelerator



---

# 2. Linux Engineering Understanding



## mkdir


Command:


```bash
mkdir
````

Function:

Create directory.

Why needed:

Hardware projects contain many files.

Example future project:

```
NPU_Project

├── RTL

├── Testbench

├── Simulation

├── Scripts

└── Docs
```

A good project structure is necessary
for large engineering projects.

---

## cd

Command:

```bash
cd
```

Function:

Change current directory.

Engineering meaning:

Linux operations always happen
inside a specific location.

Before modifying files:

Always know:

Where am I?

Related command:

```bash
pwd
```

Meaning:

Print current working directory.

---

## ls

Command:

```bash
ls
```

Function:

View files.

Engineering meaning:

Before operating:

Observe current environment.

This habit is important in debugging.

---

# 3. Git Engineering Understanding

## Why Git?

Git is not only a code upload tool.

In hardware development:

Design changes constantly.

Example:

MAC Unit:

Version 1:

Basic multiplication

Version 2:

Pipeline added

Version 3:

Quantization added

Git allows:

* tracking changes
* comparing versions
* recovering previous designs

---

## git add

Command:

```bash
git add .
```

Meaning:

Move changed files into staging area.

Concept:

Working directory

↓

Staging area

↓

Commit

---

## git commit

Command:

```bash
git commit -m "message"
```

Meaning:

Create a permanent version snapshot.

Engineering meaning:

A commit represents:

"A known state of the project."

---

## git push

Command:

```bash
git push
```

Meaning:

Synchronize local repository
with remote repository.

Purpose:

Backup and collaboration.

---

# 4. GitHub HTTPS Debug Case

## Problem

GitHub push failed.

Error:

```
GnuTLS recv error (-110)
```

---

## Debug Process

### Step 1

Check network.

Command:

```bash
ping github.com
```

Result:

Network reachable.

Conclusion:

Not basic network failure.

---

### Step 2

Check HTTPS.

Command:

```bash
curl -I https://github.com
```

Result:

TLS connection failed.

Conclusion:

Problem was HTTPS/TLS layer.

---

### Step 3

Solution

Changed:

HTTPS

to:

SSH

Created:

ED25519 SSH key.

Result:

Git push successful.

---

## Engineering Lesson

Debugging should follow layers:

Application

↓

Protocol

↓

Network

↓

Hardware

Do not randomly change settings.

---

# 5. Verilog Understanding

## Module

Example:

```verilog
module and_gate(
input a,
input b,
output y
);
```

Meaning:

Create a hardware module.

Important:

module is not a software function.

Software:

Function executes instructions.

Hardware:

Module describes physical circuit structure.

---

# 6. assign Understanding

Code:

```verilog
assign y = a & b;
```

Meaning:

Create continuous logic connection.

Hardware:

Equivalent to:

```
a ----\
       AND ---- y
b ----/
```

The circuit exists continuously.

It does not execute once.

---

# 7. Testbench Understanding

Why separate testbench?

RTL:

Describe hardware.

Testbench:

Verify hardware.

Similar to:

Engineer designs a circuit.

Another process tests the circuit.

Purpose:

Avoid designing and judging yourself.

---

# 8. Simulation Flow

Complete flow:

```
Verilog RTL

↓

Testbench

↓

Icarus Verilog compilation

↓

Simulation

↓

VCD waveform

↓

GTKWave analysis
```

Meaning:

Before building real hardware:

Verify behavior digitally.

---

# 9. Hardware Thinking Connection

Today's AND gate:

Logic gate

↓

Combinational circuit

↓

ALU operation

↓

Processing Element

↓

AI Accelerator

Simple concepts become
building blocks of complex chips.

---

# 10. My Understanding

Before Day01:

I thought:

Linux is just a command environment.

Git is just uploading code.

Verilog is another programming language.

After Day01:

I understand:

Linux provides engineering workflow.

Git manages hardware evolution.

Verilog describes hardware structures.

---

# 11. Questions Remaining

1.

What is the difference between
combinational and sequential logic?

2.

How does Verilog code become real hardware?

3.

Why do AI accelerators need MAC units?

---

# 12. Engineering Lessons

1.

Always verify results after commands.

2.

Debug problems by layers.

3.

Version control is part of engineering,
not only software development.

4.

Hardware design requires verification.

---

# 13. Completion Status

Environment:

✅

Git:

✅

RTL simulation:

✅

Understanding:

In progress

Next:

Day02 RTL Design Fundamentals

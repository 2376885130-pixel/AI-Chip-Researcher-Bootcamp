# Day07 Engineering Debrief

## Topic

Arithmetic IP Design


## What was built

Implemented three arithmetic hardware IP blocks:

1. Parameterized Adder IP

Function:

A + B

Design focus:

- DATA_WIDTH parameterization
- Carry preservation
- Overflow prevention


2. Parameterized Multiplier IP

Function:

A × B

Design focus:

- Output width expansion
- Partial product understanding
- Hardware resource awareness


3. MAC Unit

Function:

ACC = ACC + (A × B)

Design focus:

- Multiplier and Adder integration
- Accumulator register
- Sequential datapath


## Key Hardware Understanding

RTL arithmetic operators represent hardware structures.

Addition:

RTL:

+

Hardware:

Full Adders and carry propagation.


Multiplication:

RTL:

*

Hardware:

Partial product generation and adder structures.


MAC:

Combination of:

Multiplier

+

Adder

+

Register


## AI Accelerator Connection

MAC is the fundamental computation unit in AI hardware.

Large numbers of MAC units form:

- Processing Elements
- Systolic Arrays
- Neural Network Accelerators


## Engineering Lessons

1. Bit width determines numerical accuracy.

2. Combinational logic and sequential logic have different hardware behavior.

3. Registers provide state storage for iterative computation.

4. Parallel hardware improves throughput by increasing computation units.

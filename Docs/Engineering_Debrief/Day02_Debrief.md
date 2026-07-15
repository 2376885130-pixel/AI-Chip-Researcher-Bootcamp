# Day02 Engineering Debrief

## Topic

RTL Design Fundamentals

Combinational Logic and Data Path



---

# 1. What did we build?


Today we designed and verified two RTL modules:


## mux2

A 1-bit 2-to-1 multiplexer.


Inputs:

- a
- b
- sel


Output:

- y


Function:


sel=0:

y=a


sel=1:

y=b



---


## mux8


An 8-bit 2-to-1 multiplexer.


Inputs:

- a[7:0]
- b[7:0]
- sel


Output:

- y[7:0]



---

# 2. What is RTL?


RTL means:

Register Transfer Level.


RTL describes:

How digital hardware structures operate.


It is not a software program.


Verilog code does not execute instructions.


Instead:


Verilog

↓

Hardware structure

↓

Logic gates

↓

Physical circuit



---

# 3. Why assign is used?


Example:


assign y = sel ? b : a;



This describes combinational logic.


Meaning:


Output continuously depends on input.


Hardware:


Input changes

↓

Logic propagation

↓

Output changes



No clock is required.



---

# 4. Combinational Logic


Definition:


Output only depends on current input.



Examples:


AND gate:

y=a&b


MUX:

y=f(a,b,sel)



Characteristics:


- No memory
- No clock
- Immediate response



---

# 5. Sequential Logic Preview


Sequential logic has memory.


Example:


Register:


Input

↓

Clock

↓

Stored value



Verilog usually uses:


always @(posedge clk)



Used in:


- counters
- pipelines
- accumulators
- processors



---

# 6. wire and reg


## wire


Represents hardware connection.


Driven by:


- assign
- module output



Example:


wire y;



## reg


Used in simulation/testbench to store assigned values.


Driven by:


initial


always blocks



Example:


reg a;



---

# 7. Bus and Data Width


A single signal:


a


means:


1 bit.


A bus:


a[7:0]


means:


8 bits.



Example:


10101010



Hardware:


8 parallel wires.



AI chips use:


- 8-bit data
- 16-bit data
- 32-bit accumulation



---

# 8. Why MUX is important for AI Chips?


AI accelerators contain many data paths.


Example:


Memory

↓

MUX

↓

MAC Unit



MUX selects:

which data enters computation.



Large AI chips contain many MUX structures.



---

# 9. Simulation Flow


Complete RTL workflow:


Design RTL

↓

Write Testbench

↓

Compile with Icarus Verilog

↓

Run simulation

↓

Generate VCD waveform

↓

Analyze with GTKWave



---

# 10. Debug Experience


Problem:


iverilog:

No such file or directory


Cause:


Incorrect relative path.


Solution:


Understand directory hierarchy.


Engineering lesson:


Before debugging code:

Check environment and paths.



---

# 11. Key Understanding


Before Day02:


Verilog was considered as programming language.



After Day02:


Verilog is hardware description language.



The goal is:


Describe hardware behavior,

not write software instructions.



---

# 12. Next Learning Goal


Day03:


Sequential Logic


Topics:


- Clock
- Reset
- Register
- Counter
- always block
- Non-blocking assignment

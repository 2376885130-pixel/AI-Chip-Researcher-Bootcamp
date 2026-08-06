Day14 Engineering Debrief
Objective

Build the first complete NPU datapath capable of:

loading weights

loading activations

fetching data

performing INT8 dot-product computation

storing computation results

allowing CPU readback

Implemented Modules
Controller

npu_controller

data_fetch_controller

Responsibilities:

coordinate fetch

start computation

store result

generate done signal

Memory

Implemented three SRAM-like buffers.

Weight Buffer

Stores weight vectors.

Activation Buffer

Stores activation vectors.

Output Buffer

Stores completed accumulation results.

Compute Engine

Implemented a four-element INT8 dot-product engine.

Computation:

Result = Σ(Activation × Weight)

Example:

Activation:

[1,3,0,0]

Weight:

[5,7,0,0]

Output:

26
Top-Level Integration

Integrated all modules into

npu_top

Complete datapath:

CPU

↓

Weight Buffer

↓

Activation Buffer

↓

Data Fetch

↓

Compute Engine

↓

Output Buffer

↓

CPU Read

Verification

Simulation passed.

Verified:

✓ Buffer write

✓ Buffer fetch

✓ Controller handshake

✓ Compute engine

✓ Output buffer

✓ CPU readback

Final simulation output:

Expected result = 26

Output buffer result = 26

DAY14 OUTPUT BUFFER PASS
Lessons Learned

Main debugging issues:

SystemVerilog unpacked-array ports

Solution:

Compile using

iverilog -g2012

Synchronous SRAM timing

Needed one extra wait state before capture.

Unknown X propagation

Resolved by

buffer initialization

proper address width

stable fetch timing

Day14 Result

Status:

PASS

A complete mini NPU datapath was successfully implemented and verified.

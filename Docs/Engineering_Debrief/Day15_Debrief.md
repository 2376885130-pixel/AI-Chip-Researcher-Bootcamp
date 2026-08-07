# Day15 Engineering Debrief

## Waveform Debugging and RTL Hierarchy Understanding

### DUT Instance Understanding

During waveform debugging, the simulation hierarchy was analyzed.

The DUT (Design Under Test) is created in the testbench:

```verilog
npu_top dut (...);

The instance name dut is not a Verilog keyword.
It is simply the instance identifier chosen by the verification environment.

The hierarchy is:

npu_tb
|
└── dut
|
├── controller_inst
├── fetch_inst
├── compute_inst
├── weight_mem
├── activation_mem
└── result_mem

GTKWave displays this hierarchy because:

$dumpvars(0,npu_tb);

dumps the complete simulation hierarchy into the VCD waveform file.

Debug Methodology

The NPU waveform analysis follows a hierarchical debugging strategy:

System level

clk

reset

start

done

Controller level

FSM state transition

fetch/compute/store handshake

Data movement level

buffer read/write

fetch index

Compute level

MAC accumulation

computation completion

Output level

result storage and CPU readback

This approach follows real hardware verification methodology.

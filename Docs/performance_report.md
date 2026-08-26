# AI Accelerator Performance Report

The figures below are measured in the historical Day19-Day23 4-task 4x4 RTL workload. They are cycle counts, not FPGA timing results.

| Version | Optimization | Total cycles | Cycles/task | Total MACs | MAC/cycle |
|---|---|---:|---:|---:|---:|
| Day19 | serial baseline | 312 | 78.0 | 256 | 0.82 |
| Day20 | ping-pong input buffering | 243 | 60.75 | 256 | 1.05 |
| Day21 | 4-wide fetch | 147 | 36.75 | 256 | 1.74 |
| Day22 | pipelined output store | 100 | 25.0 | 256 | 2.56 |
| Day23 | 2-wide output store | 92 | 23.0 | 256 | 2.78 |

The workload performs four 4x4 products, each containing 64 MAC operations. Day23 is 3.39x faster than Day19. With a 16-PE ideal rate, the measured Day23 interval represents about 17.4% average PE utilization; this includes fetch, control, fill, drain, and store overhead.

The bottleneck moved from fetch/store toward compute and control. No LUT, DSP, BRAM, clock-frequency, power, or FPGA throughput claim is made until Vivado implementation and board measurement exist.

## Passive Phase Instrumentation

Day23 now has a verification-only instrumentation layer in
`Testbench/Day23/npu_wstore_tb.v`. It observes DUT state and handshake signals
without driving or changing the accelerator. The measured optimized workload is
the existing four-task 4x4 regression:

| Metric | Day19 baseline | Day23 optimized |
|---|---:|---:|
| Total cycles | 312 (historical measurement) | 92 |
| Instrumentation window | not captured | 93 sampled cycles |
| Compute-state cycles | not captured | 48 |
| Load/copy cycles | not captured | 18 |
| Store-active cycles | not captured | 32 |
| Stall/overhead cycles | not captured | 13 |
| MAC operations | 256 | 256 |
| Observed memory transactions | not captured | 48 |
| Output transactions | not captured | 32 |

The instrumentation window is one cycle larger than the externally reported
92-cycle latency because it counts both sampling boundaries. The externally
visible `done_cycle - start_cycle` value remains the authoritative latency.
The 48 MACs per task and 256 total MACs are unchanged between baseline and
optimized workloads.

## Interpretation

- The 3.39x speedup is `312 / 92`.
- The optimized 16-PE array performs 256 MACs over 92 externally measured
  cycles, or 2.78 MACs/cycle average.
- Four 4x4 products require 32 packed output transactions in Day23; widening
  the store reduces the output-store work relative to the historical serial
  store.
- Load, compute and store counters are phase-occupancy counters and may overlap
  with other pipeline activity; they are not an additive decomposition of total
  latency.
- Baseline phase counters were not present in the historical Day19 testbench,
  so they are intentionally reported as not captured rather than inferred.

## Scaling Check

The direct systolic latency checks measured:

| MATRIX_SIZE | Start-to-done | Run states (`3N-1`) |
|---:|---:|---:|
| 2 | 4 | 5 |
| 4 | 10 | 11 |

The difference is the launch-edge convention: the run-state formula includes
the launch/clear state, while start-to-done counts subsequent clock intervals.

## Phase 5: Cycle-Level Characterization

The Day23 testbench now emits `Simulation/Day23/day23_cycle_trace.csv` with one
record per sampled cycle. Fields include controller state, task id, result
handshake fields, internal memory-read activity, output-read activity,
store-active state, the systolic clock-active proxy, and compute/store overlap.

Measured Day23 trace summary:

| Metric | Measured value |
|---|---:|
| External execution latency | 92 cycles |
| Instrumentation sample window | 93 cycles |
| Compute-state cycles | 48 |
| Load/copy state cycles | 18 |
| Store-active cycles | 32 |
| Stall/overhead events | 13 |
| Activation/weight internal load transactions | 48 combined in the observed run |
| Output transactions | 32 |
| Load/compute overlap | 12 cycles |
| Compute/store overlap | 15 cycles |

The trace categories overlap by design. They are observations of concurrent
activities, not a partition, so their sum must not be compared with total
latency.

### PE Activity

The current PE interface has no per-PE valid/activity signal. The trace therefore
uses `systolic_matmul.compute_inst.cnt != 0` as a clock-active proxy: during
those cycles all 16 PE instances receive `compute_enable`. This is not a claim
that every PE performs a useful nonzero MAC on every cycle.

Measured proxy values:

- clock-active PE cycles: 40
- active PE-cycle proxy: 640
- maximum active PE proxy: 16
- minimum active PE proxy: 0
- average active PE proxy over the 92-cycle execution: `640 / 92 = 6.96`
- proxy occupancy: `640 / (16 * 92) = 43.48%`

The useful-MAC PE utilization remains not measured because the design does not
expose valid activity per PE. The earlier `256/(16*92)` ratio is retained only
as MAC throughput normalized to the PE array, not named PE utilization.

### Timeline Interpretation

The trace shows that load and compute overlap for 12 cycles, while compute and
store overlap for 15 cycles. This is evidence that the double-buffered and
pipelined structure hides part of the movement cost. The 13 stall/overhead
events are controller or non-active intervals observed by the passive state
classifier; they are not additional cycles outside the 92-cycle latency.

### Limitations

- Day19 has a historical 312-cycle total but no saved cycle-level trace, so
  baseline phase counters and baseline overlap are not measured.
- The current Day23 memory transaction counter combines observed preload and
  internal read events; the trace identifies internal read activity but does
  not claim a unique DRAM/BRAM transaction model.
- No output back-pressure exists in the historical Day23 interface; result
  valid/ready fields in the trace are fixed placeholders for that interface.
- No RTL or benchmark behavior was changed for this characterization.

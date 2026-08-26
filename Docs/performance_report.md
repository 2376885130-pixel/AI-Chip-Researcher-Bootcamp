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

## Phase 6A: Compute Bottleneck Characterization

### Per-PE Activity Availability

The existing `pe_unit` exposes `compute_enable` but does not expose a
per-PE valid, MAC-enable, or input-valid signal. The array therefore cannot
distinguish a useful MAC from a clocked zero/flush value without changing the
RTL interface. This phase uses the array-level `cnt != 0` signal only as a
clock-active proxy.

### Active PE Histogram

For the measured four-task 4x4 trace:

| Active PE count proxy | Cycles |
|---:|---:|
| 0 | 52 |
| 16 | 40 |

Derived proxy metrics:

- average active PE proxy over 92 cycles: `640 / 92 = 6.96`
- maximum proxy-active PEs: 16
- minimum proxy-active PEs: 0
- proxy occupancy: `640 / (16 * 92) = 43.48%`

This is not true PE utilization. It is a clock-active array proxy. No claim is
made about the number of useful MACs issued by an individual PE in a cycle.

### Task-Level Timeline

The controller trace uses these states:

| State | Meaning |
|---:|---|
| 1 | fetch start |
| 2 | fetch wait |
| 3/8 | input copy |
| 4 | compute start |
| 5 | compute wait |
| 6 | result latch |
| 7 | wait for next fetch |
| 9 | final store drain |
| 10 | done |

Measured state histogram:

| State | Cycles |
|---:|---:|
| 1 | 1 |
| 2 | 14 |
| 3 | 1 |
| 4 | 4 |
| 5 | 48 |
| 6 | 4 |
| 7 | 6 |
| 8 | 3 |
| 9 | 10 |
| 10 | 1 |

The four task compute windows account for the 48 state-5 cycles. Fetch/copy
for later tasks is overlapped with earlier compute where the scheduler has the
next bank ready. The trace measured 12 load/compute-overlap cycles and 15
compute/store-overlap cycles. The trace does not show output back-pressure in
this historical Day23 interface; its result read interface is not ready/valid.

### Bottleneck Classification

The strongest conclusion supported by the trace is **A: systolic per-task
execution window including fill/drain and control boundaries**, combined with
some **B: inter-task scheduling boundaries**. Evidence:

- 48 compute-state cycles are exactly four repeated 12-cycle windows in the
  optimized controller observation.
- The 16-PE proxy is active for only 40 of the 92-cycle window.
- Load and store activity overlaps compute, so memory movement is not the sole
  explanation for the 48 compute-state cycles.
- The current trace has no per-PE valid signal, so input-valid gaps and useful
  MAC bubbles cannot be separated from systolic fill/drain behavior.

This does not prove that all 48 cycles are pure systolic fill/drain; it rules
out claiming a more specific cause without additional RTL-visible activity
signals.

### Compute Efficiency

- MAC count: 256
- external execution latency: 92 cycles
- MAC throughput: `256 / 92 = 2.78 MAC/cycle`
- nominal array capacity over the external window: `16 * 92 = 1472 PE-cycles`
- clock-active proxy: `640 / 1472 = 43.48%`

The 16-cycle lower bound is only a work/capacity bound that assumes all 16 PEs
perform one useful MAC every cycle with no fill, drain, data movement or task
boundary cost. The measured trace does not satisfy those assumptions.

### Limitations

- True per-PE MAC-valid activity is not measurable without adding a PE-level
  signal or assertion point; neither was added in this phase.
- Baseline Day19 has no equivalent saved trace, so baseline task timelines and
  histograms are not measured.
- State occupancy is an observation of the existing controller and is not a
  mutually exclusive performance decomposition.
- No architecture, scheduler, PE, systolic engine, workload or expected result
  was changed.

## Phase 6B: Wait-State Root Cause Analysis

The cycle trace was extended with fetch FSM state, `fetch_done`, `store_req`,
`store_state`, and `store_cnt`. The Day23 interface has no memory `ready/valid`
or output `ready/valid`; those fields are therefore reported as unavailable,
not inferred.

| State | Cycles | Root cause | Confidence |
|---|---:|---|---|
| Fetch wait | 14 | fixed fetch FSM read/capture latency | measured/inferred |
| Wait next fetch | 6 | synchronization on `fetch_done` before next bank copy/compute | measured |
| Final store drain | 10 | store request startup plus packed store pipeline drain | measured |

### Fetch Wait Decomposition

The trace shows the 14 controller `S_FETCH_WAIT` samples distributed across the
fetch FSM's ISSUE, WAIT_READ and CAPTURE observations. The fetch RTL explicitly
issues a read, waits one cycle for the buffer read, then captures the returned
word. There is no buffer-ready input or protocol retry in this path.

Therefore:

- memory-ready wait: unknown/unobservable
- buffer-ready wait: not present as an interface signal
- protocol wait: not present as an interface signal
- scheduler wait: the controller is waiting for the fetch module's fixed
  `fetch_done` contract
- root cause classification: fixed fetch/capture latency, measured in state
  progression and inferred from the fetch FSM implementation

The 14 cycles should not be called external memory stalls. The current RTL only
exposes synchronous buffer read enables and a one-cycle capture sequence.

### Wait-Next-Fetch Decomposition

The six `S_WAIT_NEXT_F` samples split into three samples before `fetch_done`
and three samples at the completion boundary in the sampled trace. This is
consistent with the double-buffer synchronization path: compute continues with
the current bank while the next task is fetched, then the controller waits for
the next bank's `fetch_done` before `COPY2` and the next compute start.

Classification:

- double-buffer synchronization: measured/inferred, high confidence
- next-task data not ready: measured through `fetch_done=0`
- deliberate arbitrary delay: not observed
- memory protocol stall: unknown, because no ready/valid exists

The trace therefore shows that double buffering hides part of the fetch work,
but not all of the next-task synchronization boundary.

### Final Store Drain Decomposition

The final drain contains 10 controller samples. The store sub-FSM has a request
handoff from `store_req` to `ST_RUN`, followed by `OUT_WORDS=8` packed store
counts. The trace observes the store state and counter advancing; no output
ready signal exists to introduce a back-pressure explanation.

Classification:

- output bandwidth bound: not directly proven; the historical interface has no
  ready/valid consumer
- ready/valid stall: not measurable and not present in this interface
- store pipeline drain: measured/inferred, high confidence
- controller sequencing overhead: measured at the request handoff boundary

The most defensible explanation is store pipeline drain plus startup/handshake
overhead, not output back-pressure.

### Remaining Limitation

The 30-cycle total is a state-occupancy observation:

```text
14 Fetch wait + 6 Wait next fetch + 10 Final store drain = 30 cycles
```

It is not a mutually exclusive decomposition of all latency causes. The trace
cannot distinguish physical memory latency from synchronous buffer latency, and
it cannot measure output consumer stalls because the historical Day23 interface
does not implement ready/valid. No RTL or benchmark behavior was changed.

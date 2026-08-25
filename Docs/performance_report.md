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

# Day11 Engineering Debrief

## Topic

Parameterized Systolic PE Chain Design


## Goal

Transform a single Processing Element into a pipelined dataflow architecture.

Previous:


Independent PE Array


Current:


PE0 -> PE1 -> PE2 -> PE3


---

## Architecture Decision

### Weight Storage

Implemented:


Weight Register + load_weight


Reason:

Weights remain stable during computation.

Benefits:

- Reduced data movement
- Lower memory bandwidth requirement
- Better energy efficiency


---

## Dataflow Design

Three important paths:

### Activation Flow


activation_in

↓

PE0

↓

PE1

↓

PE2


Activation moves through the pipeline.


### Partial Sum Flow


0

↓

PE0

↓

PE1

↓

PE2

↓

Result


Each PE performs:


partial_sum_out =
partial_sum_in +
activation * weight



---

## Verification

### PE Unit

Test:


weight = 3

2*3 = 6

6+4*3 = 18


Result:

PASS


### PE Chain

Configuration:


PE0 weight=2
PE1 weight=3
PE2 weight=4
PE3 weight=5


Input:


activation=1


Expected:


2+3+4+5=14


Result:


PE_CHAIN TEST PASS


---

## Key Insight

Systolic architecture improves throughput by allowing:

- computation overlap
- local data reuse
- reduced external memory access

Tradeoff:

- increased latency
- more pipeline control
- additional registers


---

## Next Direction

Continue toward:

PE Chain

↓

2D Systolic Array

↓

Matrix Multiplication Accelerator

↓

NPU Architecture

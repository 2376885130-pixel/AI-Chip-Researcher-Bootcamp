# Day13 Engineering Debrief

## Topic

AI Accelerator Architecture Analysis

---

# 1. Objective

Analyze the Day12 Accelerator Framework from a hardware architecture perspective.

The goal was to understand how individual RTL modules combine into a complete AI compute engine.

---

# 2. Architecture Understanding

The accelerator contains three major parts:

## Control

Module:

```
controller_fsm
```

Responsibilities:

* manage states
* schedule operations
* generate control signals

---

## Data Movement

Modules:

```
weight_loader

activation_loader
```

Responsibilities:

* provide input data
* prepare computation data

---

## Compute Engine

Modules:

```
systolic_array_4x4

pe_unit
```

Responsibilities:

* execute MAC operations
* perform parallel matrix computation

---

# 3. Important Design Principle

## Control Path and Data Path Separation

A good accelerator design separates:

```
Control

and

Computation
```

FSM should not contain arithmetic operations.

Instead:

FSM controls:

```
when to compute
```

PE performs:

```
how to compute
```

---

# 4. Systolic Array Understanding

A Systolic Array improves throughput through spatial parallelism.

Example:

```
4×4 Array

=

16 PE Units
```

Each cycle multiple PE units perform MAC operations simultaneously.

Therefore:

The array size determines compute throughput.

---

# 5. Compute Completion Design

Current implementation:

```
compute_count == 3
```

The controller assumes a fixed latency.

Limitation:

If the array size or pipeline depth changes, the FSM must change.

Better architecture:

```
Systolic Array

        |

     compute_done

        |

       FSM
```

The compute engine should report completion.

---

# 6. Current Limitations

The current accelerator uses:

* fixed weights
* fixed activations
* fixed computation latency
* no external memory interface

It is suitable for learning architecture concepts.

---

# 7. Future Improvements

Planned upgrades:

1. SRAM Buffer
2. Memory Controller
3. DMA Interface
4. Parameterized Compute Latency
5. Done Handshake
6. Pipeline Scheduling

---

# Conclusion

Day13 completed the transition from:

RTL coding

to

AI Accelerator Architecture Thinking.

The main lesson:

A high-performance AI chip is not only computation.

It requires:

```
Control

+

Memory Movement

+

Parallel Compute
```

working together.

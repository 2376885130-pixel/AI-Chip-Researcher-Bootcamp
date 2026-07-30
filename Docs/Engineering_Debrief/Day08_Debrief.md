# Day08 Engineering Debrief
## Processing Element (PE)

---

## 1. Module Goal

Design a basic Processing Element for AI Accelerator.

The PE performs:

partial_sum = partial_sum + activation * weight

It contains:

- Multiplier
- Adder
- Accumulator Register

---

# 2. Why AI Needs PE

Modern AI models require massive matrix multiplication.

Examples:

- CNN convolution
- Transformer attention
- Linear layers


The basic operation is:

A × B + accumulation


This operation is called MAC:

Multiply And Accumulate.


A single MAC is not enough because AI models require billions of MAC operations.

Therefore:

many PE units are connected together to provide massive parallel computation.

---

# 3. MAC vs PE

MAC:

A × B + C

The input C is provided externally.


PE:

A × B + previous partial_sum

The previous result is stored internally.


Therefore:

PE = MAC + Register

---

# 4. Meaning of partial_sum

partial_sum is the intermediate accumulation result.

Example:

2×3 + 4×5 + 10×2


Cycle 1:

partial_sum = 6


Cycle 2:

partial_sum = 26


Cycle 3:

partial_sum = 46


The register stores the current calculation state.

---

# 5. RTL Architecture


activation
    |
    v
Multiplier
    |
    v
Adder <------ Register output
    |
    v
Accumulator Register
    |
    v
partial_sum


The register creates feedback:

old result + new multiplication result

---

# 6. Data Width Design


activation:

8 bit


weight:

8 bit


multiply result:

16 bit


accumulator:

32 bit


Reason:

multiplication increases bit width.

Repeated accumulation requires larger storage.

---

# 7. Verification


Test sequence:

Test1:

2 × 3

Expected:

6


Test2:

4 × 5

Expected:

6 + 20 = 26


Test3:

10 × 2

Expected:

26 + 20 = 46


All tests passed.

---

# 8. Debug Experience

Problem:

TEST1 failed while TEST2 and TEST3 passed.


Root Cause:

The testbench checked output before the first clock edge.

The register updates only on posedge clk.


Lesson:

Sequential logic requires correct timing between:

input

clock

output observation


---

# 9. Waveform Observation


The waveform confirmed:


Cycle 1:

partial_sum:

0 -> 6


Cycle 2:

6 -> 26


Cycle 3:

26 -> 46


This proves the accumulator behavior.

---

# 10. AI Accelerator Connection


A single PE performs one small MAC task.

Many PE units form:

Systolic Array


Systolic Array enables:

- high parallelism
- efficient data reuse
- low memory movement


This architecture is widely used in AI accelerators.

---

# 11. Key Learning


Before Day08:

MAC was understood as a calculation unit.


After Day08:

PE is understood as:

computation + state + dataflow.


This is the basic building block of AI hardware accelerators.

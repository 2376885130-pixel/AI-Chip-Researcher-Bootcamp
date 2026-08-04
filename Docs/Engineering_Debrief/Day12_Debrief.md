# Day12 Engineering Debrief

# AI Accelerator Framework Integration

## 1. Day12 Objective

Day12 的目标不是实现完整矩阵乘法 NPU，而是完成一个 AI Accelerator Framework 的系统级搭建。

本日完成：

* Processing Element (PE)
* 4×4 Systolic Array Framework
* Controller FSM
* Weight Loader
* Activation Loader
* Accelerator Top Integration
* RTL Simulation Verification

最终形成：

```
                START

                  |
                  v

          Controller FSM

          /            \

         /              \

Weight Loader     Activation Loader

         \              /

          \            /

             Systolic Array

                  |

                  v

               RESULT

                  |

                  v

                DONE
```

---

# 2. Day12 Architecture Review

## 2.1 Processing Element

PE 是 Systolic Array 的基本计算单元。

功能：

* activation × weight
* accumulator accumulation
* activation forwarding
* weight forwarding

核心计算：

```
psum <= psum + activation * weight
```

PE 同时承担：

1. Compute node
2. Pipeline forwarding node

---

# 3. Systolic Array Framework

完成 4×4 PE Array：

```
          weight

            |

PE00 ---> PE01 ---> PE02 ---> PE03

 |

 v

PE10 ---> PE11 ---> PE12 ---> PE13

 |

 v

PE20 ---> PE21 ---> PE22 ---> PE23

 |

 v

PE30 ---> PE31 ---> PE32 ---> PE33

```

验证内容：

## Activation propagation

验证：

```
activation_wire[row][col]
```

能够横向传播。

## Weight propagation

验证：

```
weight_wire[row][col]
```

能够纵向传播。

## PE computation

验证：

每个 PE 能执行：

```
activation * weight
```

并累计。

---

# 4. Important Debug Experience

## 4.1 Non-blocking Assignment Pipeline Delay

Day12 最大的时序理解：

在时钟 always block 中：

```verilog
<=
```

不会立即更新。

例如：

```verilog
activation_out <= activation_in;
```

实际：

```
cycle N:

PE receives input


cycle N+1:

next PE receives forwarded data

```

因此：

Systolic Array 是时间展开的数据流结构。

---

# 4.2 Verification Must Match Architecture

最初使用矩阵乘法结果：

```
19 22
43 50
```

验证失败。

原因：

当前 Day12 PE Framework：

* 没有 psum forwarding
* 没有 input skew scheduling
* 不是完整 GEMM accelerator

正确验证方式：

验证：

```
data movement

+

MAC behavior

+

control flow

```

而不是直接验证最终 GEMM。

---

# 5. Controller FSM

完成五状态控制：

```
IDLE

 |

LOAD_WEIGHT

 |

COMPUTE

 |

OUTPUT

 |

CLEAR

 |

IDLE
```

控制信号：

| State       | Signal         |
| ----------- | -------------- |
| LOAD_WEIGHT | load_weight=1  |
| COMPUTE     | compute=1      |
| OUTPUT      | output_valid=1 |
| CLEAR       | clear_acc=1    |

后续 Debug 发现：

原 FSM：

```
COMPUTE only 1 cycle
```

无法匹配 Loader 和 PE pipeline latency。

修改后：

COMPUTE 保持多个 cycle：

```
LOAD_WEIGHT

      |

COMPUTE

      |

COMPUTE

      |

COMPUTE

      |

OUTPUT
```

使 Accelerator Top 正常工作。

---

# 6. Loader Verification

## Weight Loader

输出：

```
weight=[5,7,0,0]
```

验证 PASS。

## Activation Loader

输出：

```
activation=[1,3,0,0]
```

验证 PASS。

---

# 7. Accelerator Top Integration

最终连接：

```
Controller

    |

Loader

    |

Systolic Array

    |

Result

    |

Done
```

验证结果：

```
DONE DETECTED

result00 = 10
result01 = 7
result10 = 30
result11 = 21
```

说明：

完整控制链：

```
START

↓

Controller

↓

Loader

↓

Compute

↓

DONE

```

运行成功。

---

# 8. Day12 Final Verification Status

| Module                   | Status |
| ------------------------ | ------ |
| PE Unit                  | PASS   |
| Systolic Array Framework | PASS   |
| Controller FSM           | PASS   |
| Weight Loader            | PASS   |
| Activation Loader        | PASS   |
| Accelerator Top          | PASS   |

---

# 9. Engineering Lessons

Day12 学习重点：

1. AI Accelerator 不只是 MAC 单元，而是：

```
Compute

+

Dataflow

+

Control

+

Memory Interface
```

2. Hardware verification 必须匹配架构目标。

3. Pipeline latency 是硬件设计核心因素。

4. Controller 必须根据 datapath latency 设计。

Day12 完成了从单个 RTL module 到完整 Accelerator Framework 的跨越。

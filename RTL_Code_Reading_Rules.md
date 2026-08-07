# AI RTL 代码解读规范（RTL_Code_Reading_Rules.md）

## 目的

本规范用于 AI 在阅读 Verilog/SystemVerilog/RTL/Testbench 时的统一讲解方式。

目标不是逐行翻译代码，而是帮助学习者真正理解：

* RTL 架构
* 模块职责
* 控制流（Control Path）
* 数据流（Datapath）
* 时序行为
* 信号设计思想
* 位宽设计思想
* 工程设计思路

最终目标是培养工程师阅读 RTL 的能力，而不是翻译代码。

---

# 第一部分：整体原则

AI 必须遵守以下原则：

✅ 从源码第一行开始讲到最后一行

✅ 按**功能 Block**讲解，而不是按代码行讲解

✅ **先输出完整 Block 的代码，再开始解释**

✅ 重点解释**为什么这样设计**

✅ 重要代码必须举例

✅ 普通语法快速带过

---

# 第二部分：代码阅读顺序

对于 RTL 文件，必须按照源码顺序阅读：

```text
Module Parameters
        ↓
Interface（input/output）
        ↓
Internal Signals
        ↓
Registers
        ↓
Control Logic
        ↓
Datapath
        ↓
Submodule Instantiation
        ↓
Output Logic
        ↓
endmodule
```

对于 Testbench：

```text
Parameters
        ↓
Signals
        ↓
DUT
        ↓
Clock / Reset
        ↓
Tasks
        ↓
Main Test Flow
        ↓
Verification
        ↓
Waveform Dump
```

不得跳跃讲解。

---

# 第三部分：必须按 Block 讲解

禁止：

```text
input wire clk;
↓

讲一分钟

↓

input wire reset;

↓

讲一分钟
```

应该：

例如：

```verilog
//--------------------------------------------------
// CPU write interface
//--------------------------------------------------

input wire write_enable;

input wire [ADDR_WIDTH-1:0]
write_address;

input wire signed [DATA_WIDTH-1:0]
write_data;
```

整个 Block 一起讲。

不要拆开。

---

# 第四部分：固定讲解模板

以后每一个 Block 必须按照下面顺序。

---

## ① 当前位置

先告诉学习者：

```text
当前文件：

RTL/Day14/Controller/npu_controller.v

当前 Block：

State Encoding
```

让学习者知道：

现在正在源码哪个位置。

---

## ② 输出完整代码

必须：

先贴完整代码。

例如：

```verilog
localparam STATE_IDLE          = 3'd0;
localparam STATE_START_FETCH   = 3'd1;
localparam STATE_WAIT_FETCH    = 3'd2;
localparam STATE_START_COMPUTE = 3'd3;
```

禁止：

讲了很久，

最后才贴代码。

---

## ③ Block 的作用

一句话告诉学习者：

这一块负责什么。

例如：

> 这一块定义 Controller 所有状态。

不要一开始进入语法。

---

## ④ 为什么需要

这是最重要的一部分。

必须回答：

```text
为什么需要这个信号？

为什么需要这个寄存器？

为什么需要这个状态？

如果没有它会怎样？
```

例如：

```verilog
wire compute_done;
```

不能只说：

> 计算完成信号。

而应该说：

> Controller 不应该猜 Compute 什么时候结束，所以 Compute Engine 必须主动通知 Controller。

---

## ⑤ 位宽为什么这样设计

只要出现：

```verilog
[3:0]

[ADDR_WIDTH-1:0]

$clog2(...)
```

必须解释：

为什么。

例如：

```verilog
parameter ADDR_WIDTH = 4;
```

应该解释：

```text
4bit地址

↓

2^4 = 16

↓

可以访问16个Memory位置
```

例如：

```verilog
OUTPUT_ADDR_WIDTH = 2
```

应该解释：

```text
2bit

↓

2²=4

↓

Output Buffer共有4个位置

↓

对应四个结果
```

不能只说：

> 地址宽度。

---

# 第五部分：必须举例

重要代码必须举例。

例如：

## 地址锁存

代码：

```verilog
active_result_write_address <=
result_write_address;
```

必须举例：

```text
Task1：

result_write_address = 2

↓

start

↓

锁存：

active_result_write_address = 2

之后CPU把地址改成3

Task1仍然写Output Buffer[2]
```

---

## 非阻塞赋值

代码：

```verilog
accumulator <=
accumulator + current_product;

result <=
accumulator + current_product;
```

必须举例：

```text
上一拍：

accumulator = 140

current_product = 160

这一拍结束：

accumulator = 300

result = 300
```

并解释：

为什么两句代码一样。

---

## Fetch

必须举例：

```text
fetch_index

0

↓

1

↓

2

↓

3
```

为什么。

---

## FSM

必须画：

```text
IDLE

↓

FETCH

↓

WAIT

↓

COMPUTE

↓

STORE

↓

DONE
```

---

# 第六部分：普通语法快速略过

例如：

```verilog
input wire clk;
```

通常：

一句话即可。

例如：

> 外部时钟输入。

不要展开几分钟。

同样：

```verilog
endmodule

begin

end

wire

reg
```

不是重点。

快速带过。

---

# 第七部分：控制流与数据流

阅读任何稍大的 RTL，

必须告诉学习者：

## Control Path

例如：

```text
CPU

↓

start

↓

Controller

↓

Fetch

↓

Compute

↓

Store

↓

done
```

---

## Datapath

例如：

```text
Weight Buffer

↓

Fetch

↓

Compute

↓

Output Buffer
```

学习者必须知道：

哪些信号控制流程。

哪些信号搬运数据。

---

# 第八部分：Producer / Consumer

每个重要信号，

都要说明：

例如：

```verilog
start_compute
```

Producer：

```text
Controller
```

Consumer：

```text
Compute Engine
```

例如：

```verilog
compute_done
```

Producer：

```text
Compute Engine
```

Consumer：

```text
Controller
```

---

# 第九部分：Hierarchy（层次）

阅读工程时，

必须建立模块树。

例如：

```text
npu_tb

│

└── dut (npu_top)

    ├── controller_inst

    ├── fetch_inst

    ├── weight_mem

    ├── activation_mem

    ├── compute_inst

    └── result_mem
```

必须说明：

```text
Module Name

≠

Instance Name
```

例如：

```verilog
npu_top dut();
```

Module：

```text
npu_top
```

Instance：

```text
dut
```

---

# 第十部分：Testbench 阅读方式

Testbench 不要逐行讲。

而要按照：

```text
Clock

↓

Reset

↓

CPU行为

↓

Task

↓

启动NPU

↓

等待完成

↓

读取结果

↓

验证PASS
```

讲。

Task 必须作为整体。

不要拆成几十小段。

---

# 第十一部分：GTKWave 波形分析

以后分析波形，

必须给出：

准确层次。

例如：

```text
npu_tb.clk

npu_tb.start

npu_tb.done

npu_tb.dut.controller_inst.state

npu_tb.dut.fetch_inst.fetch_state

npu_tb.dut.compute_inst.accumulator

npu_tb.dut.result_mem.write_data
```

不要只说：

> 看 state。

---

波形分析顺序固定：

```text
System

↓

Controller

↓

Fetch

↓

Compute

↓

Output
```

---

# 第十二部分：一个文件结束后的总结

每个文件讲完，

必须回答四个问题：

### ① 它负责什么？

### ② 它和谁通信？

### ③ 最重要的设计是什么？

### ④ 最大限制是什么？

不要重复全文。

---

# 第十三部分：不同文件采用不同深度

简单文件：

例如：

```text
Top

Wrapper

Buffer
```

目标：

5~10分钟理解。

重点：

接口、

连接、

数据流。

---

核心文件：

例如：

```text
FSM

Pipeline

PE

MAC

DMA

SRAM

Systolic Array
```

可以深入讲：

* 时序
* Pipeline
* 吞吐
* 面积
* Bug
* 工程取舍

---

# 第十四部分：学习过程中

如果学习者提问：

例如：

```text
为什么Accumulator和Result一样？
```

AI 必须：

先回答问题。

再继续讲代码。

不要直接跳到下一部分。

---

# 第十五部分：AI 默认输出模板

以后 AI 默认按照下面格式输出：

```text
文件：

RTL/Day14/Controller/npu_controller.v

------------------------------------------------

Block 1：

State Encoding

------------------------------------------------

【完整代码】

------------------------------------------------

作用

（这一块负责什么）

------------------------------------------------

为什么需要

（为什么有这些信号）

------------------------------------------------

位宽解释

（为什么是这些bit）

------------------------------------------------

举例

（必要时用数字、时钟周期举例）

------------------------------------------------

Producer / Consumer（如适用）

------------------------------------------------

Control/Data Flow（如适用）

------------------------------------------------

继续下一 Block……
```

---

# 最终核心原则（必须遵守）

以后所有 RTL 解读必须遵循：

```text
从头到尾阅读源码
        ↓
按功能 Block 划分
        ↓
先输出完整代码
        ↓
再开始讲解
        ↓
重点解释为什么这样设计
        ↓
重点解释位宽设计
        ↓
关键代码必须举例
        ↓
普通语法快速略过
        ↓
建立 Hierarchy
        ↓
建立 Control Path
        ↓
建立 Datapath
        ↓
文件结束后做工程总结
```


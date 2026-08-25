# AI Accelerator MVP Architecture

```text
memory ready/valid
        |
        v
+-----------------------+
| Activation / Weight   |
| On-chip task buffers  |
+-----------+-----------+
            |
            v
     +------+------+
     | Task FSM    |  start/busy/done/error/timeout
     +------+------+
            |
            v
     +------+------+
     | Systolic   |
     | Matrix MAC |  MATRIX_SIZE x MATRIX_SIZE
     +------+------+
            |
            v
 result ready/valid stream
```

The core is protocol-neutral. AXI-Lite, AXI-Stream, BRAM, or DMA adapters can be added outside this boundary.

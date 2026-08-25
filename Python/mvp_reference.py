#!/usr/bin/env python3
"""Small signed matrix reference model for the MVP regression flow."""
from typing import Sequence, List

def matmul(a: Sequence[Sequence[int]], b: Sequence[Sequence[int]], acc_bits: int = 32) -> List[List[int]]:
    n = len(a)
    mask = (1 << acc_bits) - 1
    out = [[0 for _ in range(n)] for _ in range(n)]
    for i in range(n):
        for j in range(n):
            value = sum(int(a[i][k]) * int(b[k][j]) for k in range(n))
            value &= mask
            out[i][j] = value - (1 << acc_bits) if value & (1 << (acc_bits - 1)) else value
    return out

if __name__ == "__main__":
    result = matmul([[1, 2], [3, 4]], [[4, 3], [2, 1]])
    assert result == [[8, 5], [20, 13]], result
    print("PYTHON REFERENCE PASS")

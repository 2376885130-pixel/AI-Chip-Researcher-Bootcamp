#!/usr/bin/env python3
"""Generate the MVP golden vectors and verify RTL result records."""
from pathlib import Path
import csv
import subprocess

ROOT = Path(__file__).resolve().parents[1]

def matmul(a, b, acc_bits=32):
    n = len(a); mask = (1 << acc_bits) - 1
    out = [[0] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            value = sum(a[i][k] * b[k][j] for k in range(n)) & mask
            out[i][j] = value - (1 << acc_bits) if value & (1 << (acc_bits - 1)) else value
    return out

def expected_records():
    tasks = [
        ([[1, 0], [0, 1]], [[1, 2], [3, 4]]),
        ([[-3, 2], [-3, 2]], [[-4, 0], [0, 5]]),
    ]
    records = []
    for task, (a, b) in enumerate(tasks):
        result = matmul(a, b)
        for index, value in enumerate(result[0] + result[1]):
            records.append((task, index, value))
    return records

def main():
    subprocess.run(["./scripts/run_mvp_regression.sh"], cwd=ROOT, check=True)
    result_file = ROOT / "Simulation/MVP/rtl_results.csv"
    with result_file.open(newline="") as stream:
        actual = [(int(row["task"]), int(row["index"]), int(row["actual"])) for row in csv.DictReader(stream)]
    expected = expected_records()
    if actual != expected:
        print("PYTHON RTL COMPARE FAIL")
        for index, (want, got) in enumerate(zip(expected, actual)):
            if want != got:
                print(f"task={want[0]} index={want[1]} expected={want[2]} actual={got[2]}")
        raise SystemExit(1)
    print(f"PYTHON RTL COMPARE PASS records={len(actual)}")

if __name__ == "__main__":
    main()

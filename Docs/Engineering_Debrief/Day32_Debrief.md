# Day32 Engineering Debrief

Added `Python/mvp_reference.py` as the golden signed matrix model. It applies fixed-width two's-complement wrapping, matching RTL accumulator semantics. The script is deterministic and returns a nonzero status on mismatch through assertions.

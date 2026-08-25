# Day30 Engineering Debrief

The scheduler FSM sequences `IDLE -> COMPUTE -> STORE`, repeats for `NUM_TASKS`, then enters `STREAM`. Each task reuses the same systolic array and writes a private output range, demonstrating continuous multi-task execution without duplicating compute hardware.

Verification: two consecutive tasks complete and produce a final done pulse.

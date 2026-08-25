# Day33 Engineering Debrief

The MVP interface exposes `busy`, `done`, `error`, `start_ready`, `result_valid`, and `result_ready`. A timeout counter moves the controller to a sticky error state if compute does not complete. Result data remains stable until accepted, providing back-pressure handling.

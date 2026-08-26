`timescale 1ns/1ps

module task_controller_start_tb;
    reg clk = 0;
    reg reset = 1;
    reg start = 0;
    reg core_ready = 1;
    reg core_done = 0;
    reg core_error = 0;
    wire core_start;
    wire accept_start;
    wire busy;
    wire done;
    wire error;
    integer starts_seen;
    integer failures;

    always #5 clk = ~clk;

    ai_task_controller dut (
        .clk(clk), .reset(reset), .start(start), .core_ready(core_ready),
        .core_start(core_start), .accept_start(accept_start), .busy(busy),
        .done(done), .core_done(core_done), .core_error(core_error), .error(error)
    );

    always @(posedge clk) begin
        if (core_start)
            starts_seen = starts_seen + 1;
    end

    initial begin
        starts_seen = 0;
        failures = 0;
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // One level-held request must represent one transaction.
        @(negedge clk);
        start = 1;
        @(posedge clk);
        @(negedge clk);
        core_done = 1;
        @(posedge clk);
        @(negedge clk);
        core_done = 0;
        repeat (2) @(posedge clk);

        if (starts_seen != 1) begin
            $display("START HOLD FAIL expected=1 actual=%0d", starts_seen);
            failures = failures + 1;
        end

        @(negedge clk);
        start = 0;
        @(posedge clk);
        @(negedge clk);
        start = 1;
        @(posedge clk);
        #1;
        if (starts_seen != 2) begin
            $display("START REARM FAIL expected=2 actual=%0d", starts_seen);
            failures = failures + 1;
        end

        if (failures == 0)
            $display("TASK CONTROLLER START HOLD PASS");
        else begin
            $display("TASK CONTROLLER START HOLD FAILURES=%0d", failures);
            $fatal(1);
        end
        #10 $finish;
    end
endmodule

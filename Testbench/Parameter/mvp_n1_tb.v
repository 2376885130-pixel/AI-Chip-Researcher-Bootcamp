`timescale 1ns/1ps
module mvp_n1_tb;
    reg clk = 0, reset = 1, start = 0, mem_valid = 0, mem_write = 0, mem_region = 0;
    reg [7:0] mem_addr = 0;
    reg signed [7:0] mem_wdata = 0;
    reg result_ready = 1;
    wire start_ready, busy, done, error, mem_ready, result_valid;
    wire signed [31:0] result_data;
    wire [7:0] result_addr;
    integer cycles;
    always #5 clk = ~clk;
    ai_accelerator_top #(.MATRIX_SIZE(1), .PE_NUM(1), .NUM_TASKS(1), .TIMEOUT_CYCLES(32)) dut (.*);

    task write_one;
        input integer region;
        input integer value;
        begin
            @(negedge clk); mem_valid = 1; mem_write = 1; mem_region = region;
            mem_addr = 0; mem_wdata = value;
            @(negedge clk); mem_valid = 0; mem_write = 0;
        end
    endtask

    initial begin
        repeat (2) @(posedge clk);
        @(negedge clk); reset = 0;
        write_one(0, -128);
        write_one(1, -1);
        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        cycles = 0;
        while (!done && cycles < 100) begin @(posedge clk); #1; cycles = cycles + 1; end
        if (!done || error) $fatal(1, "N1 CONTROL FAIL done=%b error=%b", done, error);
        if (result_data !== 32'sd128) $fatal(1, "N1 RESULT FAIL expected=128 actual=%0d", result_data);
        $display("PARAMETER PASS MATRIX_SIZE=1 NUM_TASKS=1 latency=%0d result=%0d", cycles, result_data);
        $finish;
    end
endmodule

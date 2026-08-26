`timescale 1ns/1ps
module memory_controller_protocol_tb;
    reg valid = 0, write_en = 1, region = 0;
    reg [7:0] addr = 0;
    reg signed [7:0] wdata = 0;
    reg core_ready = 1;
    wire ready, core_valid, core_write, core_region, fault;
    wire [7:0] core_addr;
    wire signed [7:0] core_wdata;
    integer failures = 0;

    ai_memory_controller dut (
        .clk(1'b0), .reset(1'b0), .valid(valid), .ready(ready),
        .write_en(write_en), .region(region), .addr(addr), .wdata(wdata),
        .core_valid(core_valid), .core_ready(core_ready), .core_write(core_write),
        .core_region(core_region), .core_addr(core_addr), .core_wdata(core_wdata),
        .fault(fault)
    );

    initial begin
        #1;
        if (!ready) begin
            $display("MEM READY FAIL ready must not depend on valid");
            failures = failures + 1;
        end
        valid = 1;
        #1;
        if (!ready || !core_valid) begin
            $display("MEM WRITE HANDSHAKE FAIL");
            failures = failures + 1;
        end
        write_en = 0;
        #1;
        if (!fault || core_valid) begin
            $display("MEM READ-ONLY SPEC FAIL");
            failures = failures + 1;
        end
        if (failures != 0) $fatal(1, "MEMORY CONTROLLER FAILURES=%0d", failures);
        $display("MEMORY CONTROLLER PROTOCOL PASS");
        $finish;
    end
endmodule

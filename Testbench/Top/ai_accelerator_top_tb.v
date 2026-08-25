`timescale 1ns/1ps
module ai_accelerator_top_tb;
 reg clk=0,reset=1,start=0,mem_valid=0,mem_write=0,mem_region=0,result_ready=1; reg [7:0] mem_addr=0; reg signed [7:0] mem_wdata=0; wire start_ready,busy,done,error,mem_ready,result_valid; wire signed [31:0] result_data; wire [7:0] result_addr;
 always #5 clk=~clk;
 ai_accelerator_top dut(.*);
 initial begin $dumpfile("Simulation/Phase2/ai_accelerator_top.vcd");$dumpvars(0,ai_accelerator_top_tb); repeat(3) @(posedge clk); reset=0; $display("FORMAL TOP COMPILE PASS"); #10 $finish; end
endmodule

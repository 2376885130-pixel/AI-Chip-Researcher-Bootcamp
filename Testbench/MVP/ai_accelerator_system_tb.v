`timescale 1ns/1ps
module ai_accelerator_system_tb;
  localparam N=2; localparam E=4; localparam T=2;
  reg clk=0,reset=1,start=0,mem_valid=0,mem_write=0,mem_region=0; reg [7:0] mem_addr=0; reg signed [7:0] mem_wdata=0; wire mem_ready,start_ready,busy,done,error,result_valid; reg result_ready=1; wire signed [31:0] result_data; wire [7:0] result_addr; integer i,t,timeout,fails;
  always #5 clk=~clk;
  ai_accelerator_system #(.MATRIX_SIZE(N),.PE_NUM(E),.NUM_TASKS(T),.ADDR_WIDTH(8),.TIMEOUT_CYCLES(100)) dut(.*);
  task write_mem; input integer region; input integer addr; input integer value; begin @(negedge clk); mem_valid=1;mem_write=1;mem_region=region;mem_addr=addr;mem_wdata=value;@(negedge clk);mem_valid=0;mem_write=0;end endtask
  initial begin
    fails=0;$dumpfile("Simulation/MVP/ai_accelerator_system.vcd");$dumpvars(0,ai_accelerator_system_tb);
    repeat(3) @(posedge clk);reset=0;
    for(t=0;t<T;t=t+1) for(i=0;i<E;i=i+1) begin write_mem(0,t*E+i,(i==0||i==3)?1:0); write_mem(1,t*E+i,i+1); end
    @(negedge clk);start=1;@(negedge clk);start=0;timeout=0;while(!done && timeout<500) begin @(posedge clk);timeout=timeout+1;end
    if(timeout>=500) begin $display("MVP FAIL timeout");fails=fails+1;end
    if(error) begin $display("MVP FAIL error");fails=fails+1;end
    if(fails==0)$display("MVP SYSTEM PASS");else $display("MVP SYSTEM FAIL=%0d",fails);#20 $finish;
  end
endmodule

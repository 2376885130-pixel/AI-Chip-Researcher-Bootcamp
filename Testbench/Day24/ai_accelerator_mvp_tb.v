`timescale 1ns/1ps
module ai_accelerator_mvp_tb;
  reg clk=0,reset=1,start=0,we=0,ae=0,re=0; reg [3:0] wa=0,aa=0; reg [31:0] wd=0,ad=0; reg [4:0] ra=0; wire [63:0] rd; wire busy,done; integer i,timeout,fail;
  always #5 clk=~clk;
  ai_accelerator_mvp #(.NUM_TASKS(1)) dut(.clk(clk),.reset(reset),.start(start),.busy(busy),.done(done),.weight_write_enable(we),.weight_write_address(wa),.weight_write_data(wd),.activation_write_enable(ae),.activation_write_address(aa),.activation_write_data(ad),.result_read_enable(re),.result_read_address(ra),.result_read_data(rd));
  task write_word; input integer n; begin @(negedge clk); ae=1;we=1;aa=n;wa=n;ad={8'd0,8'd0,8'd0,8'd1};wd={8'd0,8'd0,8'd0,8'd1};@(negedge clk);ae=0;we=0;end endtask
  initial begin
    fail=0;$dumpfile("Simulation/Day24/ai_accelerator_mvp.vcd");$dumpvars(0,ai_accelerator_mvp_tb);
    repeat(3) @(posedge clk); reset=0; for(i=0;i<4;i=i+1) write_word(i);
    @(negedge clk);start=1;@(negedge clk);start=0; timeout=0; while(!done && timeout<300) begin @(posedge clk);timeout=timeout+1;end
    if(timeout>=300) begin $display("DAY24 FAIL: timeout");fail=1;end
    if(!busy) $display("DAY24 busy released");
    if(fail==0) $display("DAY24 AI ACCELERATOR MVP PASS"); #20 $finish;
  end
endmodule

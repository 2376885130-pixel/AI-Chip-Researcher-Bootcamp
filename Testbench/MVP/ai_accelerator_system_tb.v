`timescale 1ns/1ps
module ai_accelerator_system_tb;
  localparam N=2; localparam E=4; localparam T=2;
  reg clk=0,reset=1,start=0,mem_valid=0,mem_write=0,mem_region=0; reg [7:0] mem_addr=0; reg signed [7:0] mem_wdata=0;
  wire mem_ready,start_ready,busy,done,error,result_valid; reg result_ready=1; wire signed [31:0] result_data; wire [7:0] result_addr;
  reg timeout_start=0; wire timeout_error; wire timeout_busy;
  integer i,j,k,t,timeout,fails,seen,result_fd; reg signed [7:0] a[0:T-1][0:E-1]; reg signed [7:0] b[0:T-1][0:E-1]; reg signed [31:0] golden[0:T-1][0:E-1]; reg signed [31:0] held_data; reg [7:0] held_addr;
  always #5 clk=~clk;
  ai_accelerator_system #(.MATRIX_SIZE(N),.PE_NUM(E),.NUM_TASKS(T),.ADDR_WIDTH(8),.TIMEOUT_CYCLES(100)) dut(.*);
  ai_accelerator_system #(.MATRIX_SIZE(N),.PE_NUM(E),.NUM_TASKS(T),.ADDR_WIDTH(8),.TIMEOUT_CYCLES(1)) timeout_dut(
    .clk(clk),.reset(reset),.start(timeout_start),.start_ready(),.busy(timeout_busy),.done(),.error(timeout_error),
    .mem_valid(1'b0),.mem_ready(),.mem_write(1'b0),.mem_region(1'b0),.mem_addr(8'd0),.mem_wdata(8'sd0),
    .result_valid(),.result_ready(1'b1),.result_data(),.result_addr());
  task write_mem; input integer region; input integer addr; input integer value; begin @(negedge clk); mem_valid=1;mem_write=1;mem_region=region;mem_addr=addr;mem_wdata=value;@(negedge clk);mem_valid=0;mem_write=0;end endtask
  task reset_dut; begin reset=1; start=0; mem_valid=0; mem_write=0; result_ready=1; repeat(3) @(posedge clk); reset=0; end endtask
  initial begin
    fails=0;seen=0;result_fd=$fopen("Simulation/MVP/rtl_results.csv","w");$fwrite(result_fd,"task,index,actual\n");$dumpfile("Simulation/MVP/ai_accelerator_system.vcd");$dumpvars(0,ai_accelerator_system_tb);
    reset_dut(); write_mem(0, T*E+1, 7); if(!error) begin $display("ERROR FAIL illegal address");fails=fails+1;end
    reset_dut(); @(negedge clk);mem_valid=1;mem_write=0;mem_addr=0;@(negedge clk);mem_valid=0; if(!error) begin $display("ERROR FAIL invalid command");fails=fails+1;end
    reset_dut();
    @(negedge clk); timeout_start=1; @(negedge clk); timeout_start=0; repeat(5) @(posedge clk);
    if(!timeout_error) begin $display("ERROR FAIL timeout path");fails=fails+1;end
    reset_dut();
    for(t=0;t<T;t=t+1) for(i=0;i<E;i=i+1) begin a[t][i]=(t==0)?((i==0||i==3)?1:0):((i%2==0)?-8'sd3:8'sd2); b[t][i]=(t==0)?(i+1):((i==0)?-8'sd4:((i==3)?8'sd5:0)); write_mem(0,t*E+i,a[t][i]); write_mem(1,t*E+i,b[t][i]); end
    for(t=0;t<T;t=t+1) for(i=0;i<N;i=i+1) for(j=0;j<N;j=j+1) begin golden[t][i*N+j]=0; for(k=0;k<N;k=k+1) golden[t][i*N+j]=golden[t][i*N+j]+a[t][i*N+k]*b[t][k*N+j]; end
    @(negedge clk);start=1;@(negedge clk);start=0;timeout=0;
    while(!done && timeout<500) begin @(posedge clk); #1; timeout=timeout+1;
      if(result_valid && !result_ready && (result_data!==held_data || result_addr!==held_addr)) begin $display("HANDSHAKE FAIL data changed while stalled");fails=fails+1;end
      if(result_valid && seen==0) begin result_ready=0; held_data=result_data; held_addr=result_addr; seen=1; end else if(result_valid && seen<3) seen=seen+1; else if(seen==3) result_ready=1;
      if(result_valid && result_ready) begin t=result_addr/E; i=result_addr%E; $fwrite(result_fd,"%0d,%0d,%0d\n",t,i,result_data); if(result_data!==golden[t][i]) begin $display("RESULT FAIL task=%0d index=%0d expected=%0d actual=%0d",t,i,golden[t][i],result_data);fails=fails+1;end end
    end
    if(timeout>=500) begin $display("ERROR FAIL timeout");fails=fails+1;end if(error) begin $display("ERROR FAIL during valid workload");fails=fails+1;end if(seen<3) begin $display("HANDSHAKE FAIL stall was not exercised");fails=fails+1;end
    $fclose(result_fd); if(fails==0)$display("PHASE1 VERIFICATION PASS");else $display("PHASE1 VERIFICATION FAIL=%0d",fails);#20 $finish;
  end
endmodule

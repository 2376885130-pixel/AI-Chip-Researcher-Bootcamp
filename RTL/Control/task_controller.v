`timescale 1ns/1ps
module ai_task_controller (
 input wire clk,input wire reset,input wire start,input wire core_ready,
 output wire core_start,output wire accept_start,output reg busy,output reg done,
 input wire core_done,input wire core_error,output reg error);
 reg start_armed;
 assign accept_start=start && core_ready && !busy && !error && start_armed;
 assign core_start=accept_start;
 always @(posedge clk) begin
  if(reset) begin busy<=0;done<=0;error<=0;start_armed<=1'b1; end
  else begin
   done<=0;
   if(!start) start_armed<=1'b1;
   if(accept_start) start_armed<=1'b0;
   if(core_error) begin error<=1; busy<=0; end
   else if(accept_start) busy<=1;
   else if(core_done) begin busy<=0; done<=1; end
  end
 end
endmodule

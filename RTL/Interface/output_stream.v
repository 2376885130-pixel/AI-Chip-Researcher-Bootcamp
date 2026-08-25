`timescale 1ns/1ps
module ai_output_stream #(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=8) (
 input wire clk,input wire reset,input wire source_valid,output wire source_ready,
 input wire signed [DATA_WIDTH-1:0] source_data,input wire [ADDR_WIDTH-1:0] source_addr,
 output reg valid,input wire ready,output reg signed [DATA_WIDTH-1:0] data,
 output reg [ADDR_WIDTH-1:0] addr);
 assign source_ready=!valid || ready;
 always @(posedge clk) begin
  if(reset) begin valid<=0;data<=0;addr<=0;end
  else if(source_ready) begin valid<=source_valid; if(source_valid) begin data<=source_data;addr<=source_addr;end end
 end
endmodule

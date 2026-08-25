`timescale 1ns/1ps
module ai_activation_buffer #(parameter DATA_WIDTH=8, parameter DEPTH=64, parameter ADDR_WIDTH=8) (
 input wire clk,input wire reset,input wire valid,output wire ready,input wire write_en,
 input wire [ADDR_WIDTH-1:0] addr,input wire signed [DATA_WIDTH-1:0] write_data,
 input wire read_en,output reg signed [DATA_WIDTH-1:0] read_data);
 reg signed [DATA_WIDTH-1:0] mem [0:DEPTH-1]; integer i;
 assign ready=valid && (addr<DEPTH);
 always @(posedge clk) begin
  if(reset) begin read_data<=0; for(i=0;i<DEPTH;i=i+1) mem[i]<=0; end
  else begin if(valid && ready && write_en) mem[addr]<=write_data; if(read_en && addr<DEPTH) read_data<=mem[addr]; end
 end
endmodule

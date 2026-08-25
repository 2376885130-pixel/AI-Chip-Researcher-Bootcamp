`timescale 1ns/1ps
module ai_output_buffer #(parameter DATA_WIDTH=32, parameter DEPTH=64, parameter ADDR_WIDTH=8) (
 input wire clk,input wire reset,input wire write_valid,output wire write_ready,
 input wire [ADDR_WIDTH-1:0] write_addr,input wire signed [DATA_WIDTH-1:0] write_data,
 input wire read_valid,output wire read_ready,input wire [ADDR_WIDTH-1:0] read_addr,
 output reg signed [DATA_WIDTH-1:0] read_data);
 reg signed [DATA_WIDTH-1:0] mem [0:DEPTH-1]; integer i;
 assign write_ready=write_valid && (write_addr<DEPTH); assign read_ready=read_valid && (read_addr<DEPTH);
 always @(posedge clk) begin
  if(reset) begin read_data<=0; for(i=0;i<DEPTH;i=i+1) mem[i]<=0; end
  else begin if(write_valid && write_ready) mem[write_addr]<=write_data; if(read_valid && read_ready) read_data<=mem[read_addr]; end
 end
endmodule

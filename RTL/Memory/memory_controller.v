`timescale 1ns/1ps
module ai_memory_controller #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8) (
 input wire clk,input wire reset,input wire valid,output wire ready,input wire write_en,
 input wire region,input wire [ADDR_WIDTH-1:0] addr,input wire signed [DATA_WIDTH-1:0] wdata,
 output wire core_valid,input wire core_ready,output wire core_write,output wire core_region,
 output wire [ADDR_WIDTH-1:0] core_addr,output wire signed [DATA_WIDTH-1:0] core_wdata,
 output wire fault);
 // Write-only preload interface: ready advertises capacity independently
 // of valid; a write transfers only on valid && ready.
 assign ready=core_ready; assign core_valid=valid && !fault; assign core_write=write_en;
 assign core_region=region; assign core_addr=addr; assign core_wdata=wdata;
 assign fault=valid && !write_en;
endmodule

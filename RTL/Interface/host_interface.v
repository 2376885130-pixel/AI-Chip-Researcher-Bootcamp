`timescale 1ns/1ps
module host_interface #(
    parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8
) (
    input wire clk, input wire reset,
    input wire host_mem_valid, output wire host_mem_ready,
    input wire host_mem_write, input wire host_mem_region,
    input wire [ADDR_WIDTH-1:0] host_mem_addr,
    input wire signed [DATA_WIDTH-1:0] host_mem_wdata,
    output wire core_mem_valid, input wire core_mem_ready,
    output wire core_mem_write, output wire core_mem_region,
    output wire [ADDR_WIDTH-1:0] core_mem_addr,
    output wire signed [DATA_WIDTH-1:0] core_mem_wdata
);
    assign core_mem_valid=host_mem_valid; assign host_mem_ready=core_mem_ready;
    assign core_mem_write=host_mem_write; assign core_mem_region=host_mem_region;
    assign core_mem_addr=host_mem_addr; assign core_mem_wdata=host_mem_wdata;
endmodule

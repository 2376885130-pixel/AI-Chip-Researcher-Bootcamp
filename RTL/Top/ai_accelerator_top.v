`timescale 1ns/1ps
// Formal Phase 2 release boundary. Day/MVP implementations remain historical.
module ai_accelerator_top #(
 parameter DATA_WIDTH=8, parameter ACC_WIDTH=32, parameter MATRIX_SIZE=2,
 parameter PE_NUM=4, parameter NUM_TASKS=2, parameter ADDR_WIDTH=8,
 parameter TIMEOUT_CYCLES=4095
) (
 input wire clk,input wire reset,input wire start,output wire start_ready,output wire busy,
 output wire done,output wire error,input wire mem_valid,output wire mem_ready,
 input wire mem_write,input wire mem_region,input wire [ADDR_WIDTH-1:0] mem_addr,
 input wire signed [DATA_WIDTH-1:0] mem_wdata,output wire result_valid,
 input wire result_ready,output wire signed [ACC_WIDTH-1:0] result_data,
 output wire [ADDR_WIDTH-1:0] result_addr);
 localparam integer MIN_ACC_WIDTH=2*DATA_WIDTH+$clog2(MATRIX_SIZE);
 // Constant elaboration check: invalid parameter combinations fail synthesis/elaboration.
 localparam integer PARAMETER_CHECK = 1 / ((PE_NUM==MATRIX_SIZE*MATRIX_SIZE) && (ACC_WIDTH>=MIN_ACC_WIDTH) && (ADDR_WIDTH>=$clog2(NUM_TASKS*MATRIX_SIZE*MATRIX_SIZE)));
 ai_accelerator_system #(.DATA_WIDTH(DATA_WIDTH),.ACC_WIDTH(ACC_WIDTH),.MATRIX_SIZE(MATRIX_SIZE),.PE_NUM(PE_NUM),.NUM_TASKS(NUM_TASKS),.ADDR_WIDTH(ADDR_WIDTH),.TIMEOUT_CYCLES(TIMEOUT_CYCLES)) core (
  .clk(clk),.reset(reset),.start(start),.start_ready(start_ready),.busy(busy),.done(done),.error(error),
  .mem_valid(mem_valid),.mem_ready(mem_ready),.mem_write(mem_write),.mem_region(mem_region),.mem_addr(mem_addr),.mem_wdata(mem_wdata),
  .result_valid(result_valid),.result_ready(result_ready),.result_data(result_data),.result_addr(result_addr));
endmodule

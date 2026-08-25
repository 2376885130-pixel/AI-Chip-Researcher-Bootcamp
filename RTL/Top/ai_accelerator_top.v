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
 wire core_start, core_done, core_error, core_busy, core_mem_valid, core_mem_ready, mem_fault;
 wire core_mem_write, core_mem_region; wire [ADDR_WIDTH-1:0] core_mem_addr; wire signed [DATA_WIDTH-1:0] core_mem_wdata;
 ai_memory_controller #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) memory_controller (
  .clk(clk),.reset(reset),.valid(mem_valid),.ready(mem_ready),.write_en(mem_write),.region(mem_region),.addr(mem_addr),.wdata(mem_wdata),
  .core_valid(core_mem_valid),.core_ready(core_mem_ready),.core_write(core_mem_write),.core_region(core_mem_region),.core_addr(core_mem_addr),.core_wdata(core_mem_wdata),.fault(mem_fault));
 ai_task_controller controller (.clk(clk),.reset(reset),.start(start),.core_ready(!core_busy && !mem_fault),.core_start(core_start),.accept_start(start_ready),.busy(busy),.done(done),.core_done(core_done),.core_error(core_error|mem_fault),.error(error));
 ai_accelerator_system #(.DATA_WIDTH(DATA_WIDTH),.ACC_WIDTH(ACC_WIDTH),.MATRIX_SIZE(MATRIX_SIZE),.PE_NUM(PE_NUM),.NUM_TASKS(NUM_TASKS),.ADDR_WIDTH(ADDR_WIDTH),.TIMEOUT_CYCLES(TIMEOUT_CYCLES)) core (
  .clk(clk),.reset(reset),.start(core_start),.start_ready(),.busy(core_busy),.done(core_done),.error(core_error),
  .mem_valid(core_mem_valid),.mem_ready(core_mem_ready),.mem_write(core_mem_write),.mem_region(core_mem_region),.mem_addr(core_mem_addr),.mem_wdata(core_mem_wdata),
  .result_valid(result_valid),.result_ready(result_ready),.result_data(result_data),.result_addr(result_addr));
endmodule

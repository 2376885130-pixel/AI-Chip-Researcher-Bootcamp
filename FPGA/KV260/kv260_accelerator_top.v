`timescale 1ns/1ps

// Day27 KV260 bring-up boundary.
// The board clock/reset pins are intentionally kept external to this wrapper;
// the Vivado project supplies the physical clocking and constraints.
module kv260_accelerator_top #(
    parameter DATA_WIDTH=8, parameter WORD_WIDTH=32, parameter ACC_WIDTH=32,
    parameter ADDR_WIDTH=4, parameter OUT_ADDR_WIDTH=5, parameter MAT_N=4, parameter NUM_TASKS=4
) (
    input wire clk_100mhz,
    input wire reset,
    input wire start,
    output wire busy,
    output wire done,
    input wire weight_write_enable,
    input wire [ADDR_WIDTH-1:0] weight_write_address,
    input wire signed [WORD_WIDTH-1:0] weight_write_data,
    input wire activation_write_enable,
    input wire [ADDR_WIDTH-1:0] activation_write_address,
    input wire signed [WORD_WIDTH-1:0] activation_write_data,
    input wire result_read_enable,
    input wire [OUT_ADDR_WIDTH-1:0] result_read_address,
    output wire signed [2*ACC_WIDTH-1:0] result_read_data
);
    ai_accelerator_mvp #(
        .DATA_WIDTH(DATA_WIDTH), .WORD_WIDTH(WORD_WIDTH), .ACC_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH), .OUT_ADDR_WIDTH(OUT_ADDR_WIDTH),
        .MAT_N(MAT_N), .NUM_TASKS(NUM_TASKS)
    ) accelerator (
        .clk(clk_100mhz), .reset(reset), .start(start), .busy(busy), .done(done),
        .weight_write_enable(weight_write_enable), .weight_write_address(weight_write_address),
        .weight_write_data(weight_write_data), .activation_write_enable(activation_write_enable),
        .activation_write_address(activation_write_address), .activation_write_data(activation_write_data),
        .result_read_enable(result_read_enable), .result_read_address(result_read_address),
        .result_read_data(result_read_data)
    );
endmodule

`timescale 1ns/1ps
module ai_accelerator_mvp #(
    parameter DATA_WIDTH=8, parameter WORD_WIDTH=32, parameter ACC_WIDTH=32,
    parameter ADDR_WIDTH=4, parameter OUT_ADDR_WIDTH=5, parameter MAT_N=4, parameter NUM_TASKS=4
) (
    input wire clk, input wire reset, input wire start, output wire busy, output wire done,
    input wire weight_write_enable, input wire [ADDR_WIDTH-1:0] weight_write_address,
    input wire signed [WORD_WIDTH-1:0] weight_write_data,
    input wire activation_write_enable, input wire [ADDR_WIDTH-1:0] activation_write_address,
    input wire signed [WORD_WIDTH-1:0] activation_write_data,
    input wire result_read_enable, input wire [OUT_ADDR_WIDTH-1:0] result_read_address,
    output wire signed [2*ACC_WIDTH-1:0] result_read_data
);
    reg running; wire core_start = start && !running; wire core_done;
    assign busy=running; assign done=core_done;
    npu_wstore_top #(.DATA_WIDTH(DATA_WIDTH),.WORD_WIDTH(WORD_WIDTH),.ACC_WIDTH(ACC_WIDTH),.ADDR_WIDTH(ADDR_WIDTH),.OUT_ADDR_WIDTH(OUT_ADDR_WIDTH),.MAT_N(MAT_N),.NUM_TASKS(NUM_TASKS)) core (
      .clk(clk),.reset(reset),.start(core_start),
      .weight_write_enable(weight_write_enable && !running),.weight_write_address(weight_write_address),.weight_write_data(weight_write_data),
      .activation_write_enable(activation_write_enable && !running),.activation_write_address(activation_write_address),.activation_write_data(activation_write_data),
      .result_read_enable(result_read_enable),.result_read_address(result_read_address),.result_read_data(result_read_data),.done(core_done));
    always @(posedge clk) begin
      if (reset) running<=1'b0; else if (core_start) running<=1'b1; else if (core_done) running<=1'b0;
    end
endmodule

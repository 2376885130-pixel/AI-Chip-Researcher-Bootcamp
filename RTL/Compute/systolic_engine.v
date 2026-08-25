`timescale 1ns/1ps
// Formal compute-path wrapper. Keeps the array implementation replaceable.
module ai_systolic_engine #(
    parameter DATA_WIDTH=8, parameter ACC_WIDTH=32, parameter MATRIX_SIZE=2
) (
    input wire clk,input wire reset,input wire start,
    input wire signed [DATA_WIDTH-1:0] activation [0:MATRIX_SIZE*MATRIX_SIZE-1],
    input wire signed [DATA_WIDTH-1:0] weight [0:MATRIX_SIZE*MATRIX_SIZE-1],
    output wire signed [ACC_WIDTH-1:0] result [0:MATRIX_SIZE*MATRIX_SIZE-1],
    output wire done
);
    systolic_matmul #(.DATA_WIDTH(DATA_WIDTH),.ACC_WIDTH(ACC_WIDTH),.N(MATRIX_SIZE)) array (
        .clk(clk),.reset(reset),.start(start),.a(activation),.b(weight),.c(result),.done(done));
endmodule

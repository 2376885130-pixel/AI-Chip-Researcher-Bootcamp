`timescale 1ns/1ps


module multiplier_tb;


parameter DATA_WIDTH = 8;


reg [DATA_WIDTH-1:0] A;
reg [DATA_WIDTH-1:0] B;


wire [2*DATA_WIDTH-1:0] PRODUCT;



multiplier_param #(
    .DATA_WIDTH(DATA_WIDTH)
)
dut(
    .A(A),
    .B(B),
    .PRODUCT(PRODUCT)
);



initial begin


    $dumpfile("../../Simulation/Day07/multiplier.vcd");

    $dumpvars(0,multiplier_tb);



    $monitor(
        "A=%d B=%d PRODUCT=%d",
        A,
        B,
        PRODUCT
    );


    A = 8'd5;
    B = 8'd3;

    #10;


    A = 8'd255;
    B = 8'd255;

    #10;


    $finish;


end


endmodule

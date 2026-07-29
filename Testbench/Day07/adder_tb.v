`timescale 1ns/1ps

module adder_tb;


parameter DATA_WIDTH = 8;


reg [DATA_WIDTH-1:0] A;
reg [DATA_WIDTH-1:0] B;

wire [DATA_WIDTH:0] SUM;


adder_param #(
    .DATA_WIDTH(DATA_WIDTH)
)
dut(
    .A(A),
    .B(B),
    .SUM(SUM)
);


initial begin
$dumpfile("adder.vcd");
$dumpvars;
    $monitor(
        "A=%d B=%d SUM=%d",
        A,
        B,
        SUM
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


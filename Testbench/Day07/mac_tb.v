`timescale 1ns/1ps


module mac_tb;


parameter DATA_WIDTH = 8;


reg clk;
reg reset;


reg [DATA_WIDTH-1:0] A;
reg [DATA_WIDTH-1:0] B;


wire [2*DATA_WIDTH-1:0] ACC;



mac_unit #(
    .DATA_WIDTH(DATA_WIDTH)
)
dut(
    .clk(clk),
    .reset(reset),

    .A(A),
    .B(B),

    .ACC(ACC)
);



/*
    Clock generation

    period = 10ns
*/
always #5 clk = ~clk;



initial begin


    // waveform
    $dumpfile("../../Simulation/Day07/mac.vcd");
    $dumpvars(0,mac_tb);


    // monitor
    $monitor(
        "time=%0t A=%d B=%d ACC=%d",
        $time,
        A,
        B,
        ACC
    );


    // initial state

    clk = 0;
    reset = 1;

    A = 0;
    B = 0;


    #10;


    // release reset

    reset = 0;


    // Cycle 1
    // ACC = 3*4 = 12

    A = 8'd3;
    B = 8'd4;


    #10;


    // Cycle 2
    // ACC = 12 + 2*5 = 22

    A = 8'd2;
    B = 8'd5;


    #10;


    // Cycle 3
    // ACC = 22 + 1*10 = 32

    A = 8'd1;
    B = 8'd10;


    #10;


    $finish;


end


endmodule

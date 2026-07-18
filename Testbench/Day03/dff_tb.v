`timescale 1ns/1ps

module dff_tb;

reg clk;
reg d;

wire q;


dff uut(
    .clk(clk),
    .d(d),
    .q(q)
);


// Clock generation
initial begin
    clk = 0;

    forever #5 clk = ~clk;

end


// Test stimulus
initial begin

    $dumpfile("dff.vcd");
    $dumpvars(0,dff_tb);


    d = 0;


    #12;

    d = 1;


    #10;

    d = 0;


    #10;

    d = 1;


    #10;


    $finish;

end


endmodule

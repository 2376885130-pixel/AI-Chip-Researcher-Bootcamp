`timescale 1ns/1ps

module dff_reset_tb;

reg clk;
reg reset;
reg d;

wire q;


dff_reset uut(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);


// clock
initial begin

    clk = 0;

    forever #5 clk = ~clk;

end



initial begin

    $dumpfile("dff_reset.vcd");
    $dumpvars(0,dff_reset_tb);


    // Test 1: reset active
    reset = 1;
    d = 1;


    #10;


    // Test 2: release reset
    reset = 0;


    #10;


    // Test 3
    d = 0;


    #10;


    $finish;

end


endmodule

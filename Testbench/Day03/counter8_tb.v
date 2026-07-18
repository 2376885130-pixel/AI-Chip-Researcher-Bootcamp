`timescale 1ns/1ps

module counter8_tb;


reg clk;
reg reset;

wire [7:0] count;


counter8 uut(
    .clk(clk),
    .reset(reset),
    .count(count)
);


// Clock

initial begin

    clk = 0;

    forever #5 clk = ~clk;

end



// Test

initial begin

    $dumpfile("counter8.vcd");
    $dumpvars(0,counter8_tb);


    // Reset
    reset = 1;


    #10;


    // Start counting
    reset = 0;


    #80;


    $finish;

end


endmodule


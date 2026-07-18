`timescale 1ns/1ps

module register8_tb;


reg clk;
reg reset;
reg [7:0] d;

wire [7:0] q;



register8 uut(
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q)
);



// Clock
initial begin

    clk = 0;

    forever #5 clk = ~clk;

end



// Test
initial begin

    $dumpfile("register8.vcd");
    $dumpvars(0,register8_tb);


    // Reset
    reset = 1;
    d = 8'hAA;


    #10;


    // Release reset
    reset = 0;


    #10;


    // Load new data
    d = 8'h55;


    #10;


    // Load another value
    d = 8'hFF;


    #10;


    $finish;

end


endmodule

`timescale 1ns/1ps

module counter_param_tb;

    reg clk;
    reg reset;
    reg enable;

    wire [7:0] count;


    // DUT (Device Under Test)
    counter_param #(
        .WIDTH(8)
    ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );


    // Clock generation
    always #5 clk = ~clk;


    // Test sequence
    initial
    begin

        // Generate waveform
        $dumpfile("Simulation/Day05/counter_param.vcd");
        $dumpvars(0, counter_param_tb);


        // Initial state
        clk = 0;
        reset = 1;
        enable = 0;


        // Test reset
        #10;
        reset = 0;


        // Test counting
        enable = 1;

        #50;


        // Test hold
        enable = 0;

        #30;


        // Test reset again
        reset = 1;

        #10;


        reset = 0;

        #20;


        $finish;

    end


endmodule

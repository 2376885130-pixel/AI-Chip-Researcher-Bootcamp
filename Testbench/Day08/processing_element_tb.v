`timescale 1ns/1ps

module processing_element_tb;


reg clk;
reg reset;

reg signed [7:0] activation;
reg signed [7:0] weight;


wire signed [31:0] partial_sum;



processing_element dut(

    .clk(clk),
    .reset(reset),

    .activation(activation),
    .weight(weight),

    .partial_sum(partial_sum)

);



always #5 clk = ~clk;



initial begin

    $dumpfile("Simulation/Day08/processing_element.vcd");
    $dumpvars(0, processing_element_tb);



    clk = 0;
    reset = 1;

    activation = 0;
    weight = 0;


    #10;


    reset = 0;


    // Test 1
    activation = 8'd2;
    weight = 8'd3;
    #10;
if(partial_sum != 32'd6)
    $display("TEST1 FAIL");
else
    $display("TEST1 PASS");

    // Test 2
    activation = 8'd4;
    weight = 8'd5;
activation = 8'd4;
weight = 8'd5;

#10;

if(partial_sum != 32'd26)
    $display("TEST2 FAIL");
else
    $display("TEST2 PASS");
    #10;


    // Test 3
    activation = 8'd10;
    weight = 8'd2;
if(partial_sum != 32'd46)
    $display("TEST3 FAIL");
else
    $display("TEST3 PASS");
    #10;


    $finish;


end


endmodule

`timescale 1ns/1ps


module pe_unit_tb;


parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;


reg clk;
reg rst;
reg enable;


reg load_weight;

reg [DATA_WIDTH-1:0] weight_in;


reg [DATA_WIDTH-1:0] activation_in;

wire [DATA_WIDTH-1:0] activation_out;


reg [ACC_WIDTH-1:0] partial_sum_in;

wire [ACC_WIDTH-1:0] partial_sum_out;



// DUT

pe_unit #(
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
dut
(

    .clk(clk),

    .rst(rst),

    .enable(enable),


    .load_weight(load_weight),

    .weight_in(weight_in),


    .activation_in(activation_in),

    .activation_out(activation_out),


    .partial_sum_in(partial_sum_in),

    .partial_sum_out(partial_sum_out)

);




// clock

always #5 clk = ~clk;



initial begin


    $dumpfile("Simulation/Day11/pe_unit.vcd");
    $dumpvars(0, pe_unit_tb);



    clk = 0;

    rst = 1;

    enable = 0;

    load_weight = 0;


    weight_in = 0;

    activation_in = 0;

    partial_sum_in = 0;



    // reset

    #20;

    rst = 0;



    //---------------------
    // Load weight
    //---------------------

    load_weight = 1;

    weight_in = 8'd3;


    #10;


    load_weight = 0;



    //---------------------
    // Test 1
    //---------------------

    enable = 1;


    activation_in = 8'd2;

    partial_sum_in = 32'd0;


    #10;


    if(partial_sum_out == 6)

        $display("TEST1 PASS");

    else

        $display("TEST1 FAIL result=%d",
                  partial_sum_out);



    //---------------------
    // Test 2
    //---------------------


    activation_in = 8'd4;

    partial_sum_in = partial_sum_out;


    #10;


    if(partial_sum_out == 18)

        $display("TEST2 PASS");

    else

        $display("TEST2 FAIL result=%d",
                  partial_sum_out);



    $finish;


end


endmodule

`timescale 1ns/1ps


module pe_chain_tb;


parameter NUM_PE = 4;
parameter DATA_WIDTH = 8;
parameter ACC_WIDTH = 32;


reg clk;
reg rst;
reg enable;

reg load_weight;


reg [DATA_WIDTH-1:0] activation_in;


reg [NUM_PE*DATA_WIDTH-1:0] weight_in;


wire [ACC_WIDTH-1:0] result;



pe_chain #(
    .NUM_PE(NUM_PE),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
dut
(
    .clk(clk),
    .rst(rst),
    .enable(enable),

    .load_weight(load_weight),

    .activation_in(activation_in),

    .weight_in(weight_in),

    .result(result)
);



always #5 clk = ~clk;



initial begin


    $dumpfile("Simulation/Day11/pe_chain.vcd");
    $dumpvars(0, pe_chain_tb);



    clk = 0;

    rst = 1;

    enable = 0;

    load_weight = 0;

    activation_in = 0;

    weight_in = 0;



    // reset

    #20;

    rst = 0;



    //---------------------------------
    // Load weights
    //---------------------------------

    load_weight = 1;


    /*
       PE0 = 2
       PE1 = 3
       PE2 = 4
       PE3 = 5

       注意：
       高位 -> PE3
       低位 -> PE0

    */

    weight_in = {
        8'd5,
        8'd4,
        8'd3,
        8'd2
    };


    #10;


    load_weight = 0;



    //---------------------------------
    // Start pipeline
    //---------------------------------

    enable = 1;


    activation_in = 8'd1;



    #60;



    $display("Final Result = %d", result);



    if(result == 14)

        $display("PE_CHAIN TEST PASS");

    else

        $display("PE_CHAIN TEST FAIL");



    $finish;


end


endmodule

`timescale 1ns/1ps


module pe_array_tb;


parameter NUM_PE = 4;
parameter DATA_WIDTH = 8;
parameter ACC_WIDTH = 32;


reg clk;
reg reset;


reg signed [NUM_PE*DATA_WIDTH-1:0] activation;
reg signed [NUM_PE*DATA_WIDTH-1:0] weight;


wire signed [NUM_PE*ACC_WIDTH-1:0] result;



pe_array #(
    .NUM_PE(NUM_PE),
    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)
)
dut
(
    .clk(clk),
    .reset(reset),

    .activation(activation),
    .weight(weight),

    .result(result)
);



always #5 clk = ~clk;



initial
begin

    $dumpfile("Simulation/Day10/pe_array.vcd");
    $dumpvars(0, pe_array_tb);



    clk = 0;

    reset = 1;

    activation = 0;

    weight = 0;



    // reset

    #10;


    reset = 0;



    /*
        PE0:
        2 * 3 = 6

        PE1:
        4 * 5 = 20

        PE2:
        6 * 7 = 42

        PE3:
        8 * 9 = 72
    */


    activation[7:0]    = 8'sd2;
    activation[15:8]   = 8'sd4;
    activation[23:16]  = 8'sd6;
    activation[31:24]  = 8'sd8;



    weight[7:0]    = 8'sd3;
    weight[15:8]   = 8'sd5;
    weight[23:16]  = 8'sd7;
    weight[31:24]  = 8'sd9;



    // wait one clock

    #10;



    if(result[31:0] == 32'sd6)

        $display("PE0 PASS");

    else

        $display("PE0 FAIL result=%d",
                 result[31:0]);




    if(result[63:32] == 32'sd20)

        $display("PE1 PASS");

    else

        $display("PE1 FAIL result=%d",
                 result[63:32]);




    if(result[95:64] == 32'sd42)

        $display("PE2 PASS");

    else

        $display("PE2 FAIL result=%d",
                 result[95:64]);




    if(result[127:96] == 32'sd72)

        $display("PE3 PASS");

    else

        $display("PE3 FAIL result=%d",
                 result[127:96]);



    #10;


    $finish;


end


endmodule

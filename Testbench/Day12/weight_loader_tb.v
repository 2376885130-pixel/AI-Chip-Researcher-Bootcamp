`timescale 1ns/1ps


module weight_loader_tb;


parameter DATA_WIDTH=8;



reg clk;

reg reset;

reg load;



wire signed [DATA_WIDTH-1:0]
weight_out [0:3];





weight_loader #(

    .DATA_WIDTH(DATA_WIDTH)

)

dut

(

    .clk(clk),

    .reset(reset),

    .load(load),

    .weight_out(weight_out)

);





always #5 clk = ~clk;



initial begin


    $dumpfile("weight_loader.vcd");

    $dumpvars(0,weight_loader_tb);



    clk=0;

    reset=1;

    load=0;



    //--------------------
    // Reset
    //--------------------

    #20;


    reset=0;



    //--------------------
    // Load weight
    //--------------------


    #10;


    load=1;


    #10;


    load=0;



    //--------------------
    // wait
    //--------------------

    #20;



    //--------------------
    // display
    //--------------------


    $display("----------------------");

    $display("weight0=%d",weight_out[0]);

    $display("weight1=%d",weight_out[1]);

    $display("weight2=%d",weight_out[2]);

    $display("weight3=%d",weight_out[3]);

    $display("----------------------");




    if(weight_out[0]==5 &&
       weight_out[1]==7 &&
       weight_out[2]==0 &&
       weight_out[3]==0)

        $display("WEIGHT LOADER PASS");

    else

        $display("WEIGHT LOADER FAIL");



    $finish;


end



endmodule

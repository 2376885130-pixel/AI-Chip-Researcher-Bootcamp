`timescale 1ns/1ps


module systolic_array_tb;


parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;



reg clk;

reg reset;

reg enable;

reg clear_acc;



reg signed [DATA_WIDTH-1:0]
activation_in [0:3];


reg signed [DATA_WIDTH-1:0]
weight_in [0:3];



wire signed [ACC_WIDTH-1:0]
result [0:3][0:3];





//================================================
// DUT
//================================================

systolic_array_4x4 #(


    .DATA_WIDTH(DATA_WIDTH),

    .ACC_WIDTH(ACC_WIDTH)


)

dut

(

    .clk(clk),

    .reset(reset),


    .enable(enable),

    .clear_acc(clear_acc),


    .activation_in(activation_in),

    .weight_in(weight_in),


    .result(result)

);





//================================================
// Clock
//================================================

always #5 clk = ~clk;



integer i;



//================================================
// Test
//================================================

initial begin


    //------------------------------------------------
    // waveform
    //------------------------------------------------

    $dumpfile("systolic_array.vcd");

    $dumpvars(0,systolic_array_tb);




    //------------------------------------------------
    // Initial state
    //------------------------------------------------

    clk = 0;

    reset = 1;

    enable = 0;

    clear_acc = 0;



    for(i=0;i<4;i=i+1)

    begin

        activation_in[i]=0;

        weight_in[i]=0;

    end





    //------------------------------------------------
    // Reset
    //------------------------------------------------

    #20;


    reset = 0;




    //------------------------------------------------
    // Clear accumulator
    //------------------------------------------------

    clear_acc = 1;


    #10;


    clear_acc = 0;





    //------------------------------------------------
    // Enable PE array
    //------------------------------------------------

    enable = 1;





    //------------------------------------------------
    // Inject data into all rows and columns
    //
    // Activation:
    //
    // row0 = 2
    // row1 = 2
    // row2 = 2
    // row3 = 2
    //
    //
    // Weight:
    //
    // col0 = 3
    // col1 = 3
    // col2 = 3
    // col3 = 3
    //
    //
    // Every PE receives:
    //
    // 2 * 3 = 6
    //
    //------------------------------------------------


    activation_in[0]=2;

    activation_in[1]=2;

    activation_in[2]=2;

    activation_in[3]=2;



    weight_in[0]=3;

    weight_in[1]=3;

    weight_in[2]=3;

    weight_in[3]=3;




    //------------------------------------------------
    // Hold input
    //------------------------------------------------


    repeat(6)

    begin

        #10;

    end





    //------------------------------------------------
    // Stop input
    //------------------------------------------------


    for(i=0;i<4;i=i+1)

    begin

        activation_in[i]=0;

        weight_in[i]=0;

    end




    //------------------------------------------------
    // Pipeline flush
    //------------------------------------------------


    #120;





    //------------------------------------------------
    // Display
    //------------------------------------------------


    $display("--------------------------------");

    $display("PE00 = %d",result[0][0]);

    $display("PE01 = %d",result[0][1]);

    $display("PE10 = %d",result[1][0]);

    $display("PE11 = %d",result[1][1]);

    $display("--------------------------------");





    //------------------------------------------------
    // Check
    //------------------------------------------------


    if(result[0][0] > 0)

        $display("PE00 PASS");

    else

        $display("PE00 FAIL");



    if(result[0][1] > 0)

        $display("PE01 PASS");

    else

        $display("PE01 FAIL");



    if(result[1][0] > 0)

        $display("PE10 PASS");

    else

        $display("PE10 FAIL");




    $finish;


end



endmodule

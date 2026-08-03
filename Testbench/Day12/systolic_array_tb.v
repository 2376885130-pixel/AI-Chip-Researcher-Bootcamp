`timescale 1ns/1ps


module systolic_array_tb;


parameter DATA_WIDTH = 8;

parameter ACC_WIDTH = 32;



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





always #5 clk = ~clk;



integer i;



initial begin



    $dumpfile("systolic_array.vcd");

    $dumpvars(0,systolic_array_tb);




    clk=0;


    reset=1;


    enable=0;

    clear_acc=0;



    for(i=0;i<4;i=i+1)

    begin

        activation_in[i]=0;

        weight_in[i]=0;

    end




    // --------------------
    // Reset
    // --------------------

    #20;


    reset=0;



    // --------------------
    // Clear accumulator
    // --------------------

    clear_acc=1;


    #10;


    clear_acc=0;




    // --------------------
    // Load weights
    //
    // B:
    //
    // [5 6]
    // [7 8]
    //
    // --------------------


    weight_in[0]=5;

    weight_in[1]=7;


    #10;



    // --------------------
    // Feed activations
    //
    // A:
    //
    // [1 2]
    // [3 4]
    //
    // --------------------


    enable=1;



    // Row0

    activation_in[0]=1;


    #10;


    activation_in[0]=2;


    #10;


    activation_in[0]=0;



    // Row1


    activation_in[1]=3;


    #10;


    activation_in[1]=4;


    #10;


    activation_in[1]=0;




    // wait pipeline


    #50;



    enable=0;




    $display("---------------------");


    $display("C00 = %d",result[0][0]);

    $display("C01 = %d",result[0][1]);

    $display("C10 = %d",result[1][0]);

    $display("C11 = %d",result[1][1]);


    $display("---------------------");





    if(result[0][0]==19)

        $display("C00 PASS");

    else

        $display("C00 FAIL");





    if(result[0][1]==22)

        $display("C01 PASS");

    else

        $display("C01 FAIL");





    if(result[1][0]==43)

        $display("C10 PASS");

    else

        $display("C10 FAIL");





    if(result[1][1]==50)

        $display("C11 PASS");

    else

        $display("C11 FAIL");





    $finish;



end



endmodule

`timescale 1ns/1ps


module activation_loader_tb;


parameter DATA_WIDTH=8;



reg clk;

reg reset;

reg load;



wire signed [DATA_WIDTH-1:0]
activation_out [0:3];





activation_loader #(

    .DATA_WIDTH(DATA_WIDTH)

)

dut

(

    .clk(clk),

    .reset(reset),

    .load(load),

    .activation_out(activation_out)

);





always #5 clk = ~clk;




initial begin



    $dumpfile("activation_loader.vcd");

    $dumpvars(0,activation_loader_tb);




    clk=0;

    reset=1;

    load=0;



    //--------------------
    // Reset
    //--------------------

    #20;


    reset=0;




    //--------------------
    // Load activation
    //--------------------


    #10;


    load=1;


    #10;


    load=0;




    //--------------------
    // Wait
    //--------------------

    #20;




    //--------------------
    // Display
    //--------------------


    $display("----------------------");

    $display("activation0=%d",activation_out[0]);

    $display("activation1=%d",activation_out[1]);

    $display("activation2=%d",activation_out[2]);

    $display("activation3=%d",activation_out[3]);

    $display("----------------------");





    if(
        activation_out[0]==1 &&
        activation_out[1]==3 &&
        activation_out[2]==0 &&
        activation_out[3]==0
    )

        $display("ACTIVATION LOADER PASS");

    else

        $display("ACTIVATION LOADER FAIL");




    $finish;



end



endmodule

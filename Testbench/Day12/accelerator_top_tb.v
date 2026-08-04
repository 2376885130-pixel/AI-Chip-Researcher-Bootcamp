`timescale 1ns/1ps


module accelerator_top_tb;


parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;



reg clk;

reg reset;

reg start;



wire done;


wire signed [ACC_WIDTH-1:0]
result [0:3][0:3];





//================================================
// DUT
//================================================

accelerator_top #(


    .DATA_WIDTH(DATA_WIDTH),

    .ACC_WIDTH(ACC_WIDTH)


)

dut

(

    .clk(clk),

    .reset(reset),

    .start(start),

    .done(done),

    .result(result)

);





//================================================
// Clock
//================================================

always #5 clk = ~clk;




//================================================
// Monitor done pulse
//================================================

always @(posedge clk)

begin

    if(done)

    begin

        $display("=========================");

        $display("DONE DETECTED");

        $display("result00 = %d", result[0][0]);

        $display("result01 = %d", result[0][1]);

        $display("result10 = %d", result[1][0]);

        $display("result11 = %d", result[1][1]);

        $display("=========================");

    end

end





//================================================
// Test sequence
//================================================

initial begin



    $dumpfile("accelerator_top.vcd");

    $dumpvars(0,accelerator_top_tb);




    clk = 0;

    reset = 1;

    start = 0;



    //----------------------------
    // Reset
    //----------------------------

    #20;

    reset = 0;



    //----------------------------
    // Start pulse
    //----------------------------

    #10;

    start = 1;


    #10;

    start = 0;



    //----------------------------
    // Wait FSM
    //----------------------------

    #120;



    $display("=========================");

    $display("ACCELERATOR TOP TEST END");

    $display("=========================");



    $finish;



end



endmodule

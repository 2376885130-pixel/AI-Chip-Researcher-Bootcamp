`timescale 1ns/1ps


module pe_unit_tb;


parameter DATA_WIDTH = 8;

parameter ACC_WIDTH = 32;



reg clk;

reg reset;


reg enable;

reg clear_acc;



reg signed [DATA_WIDTH-1:0] activation_in;

reg signed [DATA_WIDTH-1:0] weight_in;



wire signed [DATA_WIDTH-1:0] activation_out;

wire signed [DATA_WIDTH-1:0] weight_out;


wire signed [ACC_WIDTH-1:0] psum_out;





pe_unit #(

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



    .activation_out(activation_out),

    .weight_out(weight_out),



    .psum_out(psum_out)

);





always #5 clk=~clk;




initial begin


    $dumpfile("pe_unit.vcd");

    $dumpvars(0,pe_unit_tb);



    clk=0;


    reset=1;


    enable=0;

    clear_acc=0;


    activation_in=0;

    weight_in=0;



    // reset

    #20;


    reset=0;



    // clear accumulator

    clear_acc=1;


    #10;


    clear_acc=0;



    // ===================
    // MAC 1
    //
    // 3*4=12
    //
    // ===================


    enable=1;


    activation_in=3;

    weight_in=4;



    #10;



    // ===================
    // MAC 2
    //
    // 2*5=10
    //
    // total=22
    //
    // ===================


    activation_in=2;

    weight_in=5;



    #10;


    enable=0;



    #10;



    $display("----------------");

    $display("psum=%d",psum_out);

    $display("----------------");



    if(psum_out==22)

        $display("PE TEST PASS");

    else

        $display("PE TEST FAIL");



    $finish;


end



endmodule

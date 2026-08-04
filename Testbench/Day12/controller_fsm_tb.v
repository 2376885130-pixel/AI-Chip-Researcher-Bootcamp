`timescale 1ns/1ps


module controller_fsm_tb;


reg clk;

reg reset;

reg start;


wire load_weight;

wire compute;

wire output_valid;

wire clear_acc;



controller_fsm dut
(

    .clk(clk),

    .reset(reset),

    .start(start),

    .load_weight(load_weight),

    .compute(compute),

    .output_valid(output_valid),

    .clear_acc(clear_acc)

);





always #5 clk = ~clk;




initial begin


    $dumpfile("controller_fsm.vcd");

    $dumpvars(0,controller_fsm_tb);



    clk = 0;

    reset = 1;

    start = 0;



    //----------------
    // reset
    //----------------

    #20;

    reset = 0;



    //----------------
    // start pulse
    //----------------

    #10;

    start = 1;


    #10;

    start = 0;



    //----------------
    // observe FSM
    //----------------


    #80;



    $finish;


end




always @(posedge clk)

begin

    $display(
    "time=%0t load=%b compute=%b output=%b clear=%b",
    $time,
    load_weight,
    compute,
    output_valid,
    clear_acc
    );

end



endmodule

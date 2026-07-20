`timescale 1ns/1ps


module traffic_light_tb;


    //--------------------------------
    // Testbench Signals
    //--------------------------------

    reg clk;
    reg rst_n;


    wire red;
    wire yellow;
    wire green;



    //--------------------------------
    // DUT Instance
    //--------------------------------

    traffic_light_fsm dut (

        .clk(clk),
        .rst_n(rst_n),

        .red(red),
        .yellow(yellow),
        .green(green)

    );



    //--------------------------------
    // Clock Generation
    //--------------------------------

    always #5 clk = ~clk;



    //--------------------------------
    // Simulation
    //--------------------------------

    initial begin


        // waveform
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, traffic_light_tb);



        // initial value

        clk = 0;

        rst_n = 0;



        // reset period

        #20;


        rst_n = 1;



        // run simulation

        #100;



        $finish;


    end



endmodule

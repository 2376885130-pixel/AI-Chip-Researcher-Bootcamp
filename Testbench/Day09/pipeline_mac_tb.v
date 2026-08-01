`timescale 1ns/1ps


module pipeline_mac_tb;


parameter DATA_WIDTH = 8;
parameter ACC_WIDTH  = 32;



// Clock

reg clk;
reg rst;



// Input

reg [DATA_WIDTH-1:0] activation;
reg [DATA_WIDTH-1:0] weight;

reg [ACC_WIDTH-1:0] partial_sum;



// Output

wire [ACC_WIDTH-1:0] result;



// Expected pipeline

reg [ACC_WIDTH-1:0] expected_stage1;
reg [ACC_WIDTH-1:0] expected_stage2;



integer pass_count;
integer fail_count;



// DUT

pipeline_mac #(

    .DATA_WIDTH(DATA_WIDTH),
    .ACC_WIDTH(ACC_WIDTH)

)

dut
(

    .clk(clk),
    .rst(rst),

    .activation(activation),
    .weight(weight),

    .partial_sum(partial_sum),

    .result(result)

);



// Clock 10ns period

always #5 clk = ~clk;



// VCD

initial
begin

    $dumpfile("Simulation/Day09/pipeline_mac.vcd");

    $dumpvars(0,pipeline_mac_tb);

end





// Automatic checker

task check_output;

input [ACC_WIDTH-1:0] expected;


begin


    if(result == expected)

    begin

        $display(
        "PASS time=%0t result=%d expected=%d",
        $time,
        result,
        expected
        );


        pass_count = pass_count + 1;


    end

    else

    begin

        $display(
        "FAIL time=%0t result=%d expected=%d",
        $time,
        result,
        expected
        );


        fail_count = fail_count + 1;

    end


end

endtask





// Expected model pipeline

always @(posedge clk)

begin

    if(!rst)

    begin

        // Stage2 output check

        #1;

        check_output(expected_stage2);


        // shift expected values

        expected_stage2 <= expected_stage1;


    end


end





// Main stimulus

initial
begin


    clk = 0;

    rst = 1;



    activation = 0;

    weight = 0;

    partial_sum = 0;



    expected_stage1 = 0;

    expected_stage2 = 0;


    pass_count = 0;

    fail_count = 0;



    // Reset

    repeat(2)

        @(posedge clk);



    rst = 0;



    /*
        Input stream


        MAC1:
        2*3+10=16


        MAC2:
        4*5+20=40


        MAC3:
        10*2+30=50

    */



    @(negedge clk);

    activation = 8'd2;

    weight = 8'd3;

    partial_sum = 32'd10;

    expected_stage1 = 32'd16;




    @(negedge clk);

    activation = 8'd4;

    weight = 8'd5;

    partial_sum = 32'd20;

    expected_stage1 = 32'd40;




    @(negedge clk);

    activation = 8'd10;

    weight = 8'd2;

    partial_sum = 32'd30;

    expected_stage1 = 32'd50;




    // stop input

    @(negedge clk);

    activation = 0;

    weight = 0;

    partial_sum = 0;

    expected_stage1 = 0;




    // wait pipeline drain

    repeat(3)

        @(posedge clk);



    #5;


    $display("----------------------");

    $display(
    "PASS=%d FAIL=%d",
    pass_count,
    fail_count
    );

    $display("----------------------");


    $finish;


end





// Monitor

initial
begin


    $monitor(

    "time=%0t | act=%d weight=%d ps=%d | product=%d ps_reg=%d result=%d",

    $time,

    activation,

    weight,

    partial_sum,

    dut.product_reg,

    dut.partial_sum_reg,

    result

    );


end



endmodule

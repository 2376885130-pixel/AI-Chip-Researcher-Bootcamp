`timescale 1ns/1ps


module register_bank_tb;


////////////////////////////////////////////////
// IP Configuration
////////////////////////////////////////////////

parameter DATA_WIDTH = 16;
parameter DEPTH = 8;

localparam ADDR_WIDTH = $clog2(DEPTH);



////////////////////////////////////////////////
// Testbench Signals
////////////////////////////////////////////////

reg clk;

reg reset;


reg write_enable;

reg [ADDR_WIDTH-1:0] write_addr;

reg [DATA_WIDTH-1:0] write_data;


reg [ADDR_WIDTH-1:0] read_addr;


wire [DATA_WIDTH-1:0] read_data;



////////////////////////////////////////////////
// Expected Memory
// Used for self-checking
////////////////////////////////////////////////

reg [DATA_WIDTH-1:0] expected [0:DEPTH-1];



integer i;

integer errors;



////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////

register_bank
#(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
dut
(
    .clk(clk),

    .reset(reset),

    .write_enable(write_enable),

    .write_addr(write_addr),

    .write_data(write_data),

    .read_addr(read_addr),

    .read_data(read_data)
);



////////////////////////////////////////////////
// Clock
////////////////////////////////////////////////

always #5 clk = ~clk;



////////////////////////////////////////////////
// Test Sequence
////////////////////////////////////////////////

initial
begin


    //////////////////////////////////////////////////
    // Waveform
    //////////////////////////////////////////////////

    $dumpfile("Simulation/Day06/register_bank.vcd");

    $dumpvars(0, register_bank_tb);



    //////////////////////////////////////////////////
    // Initialize
    //////////////////////////////////////////////////

    clk = 0;

    reset = 1;

    write_enable = 0;

    write_addr = 0;

    write_data = 0;

    read_addr = 0;

    errors = 0;



    //////////////////////////////////////////////////
    // Reset Release
    //////////////////////////////////////////////////

    #10;

    reset = 0;



    //////////////////////////////////////////////////
    // Write Test
    //////////////////////////////////////////////////

    #10;


    write_enable = 1;


    for(i=0;i<DEPTH;i=i+1)
    begin

        write_addr = i;

        write_data = i + 1;


        // Save expected result

        expected[i] = write_data;


        #10;

    end



    write_enable = 0;



    //////////////////////////////////////////////////
    // Read And Check
    //////////////////////////////////////////////////

    #10;


    for(i=0;i<DEPTH;i=i+1)
    begin


        read_addr = i;


        #5;


        if(read_data == expected[i])
        begin

            $display(
            "PASS : addr=%0d expected=%h actual=%h",
            read_addr,
            expected[i],
            read_data
            );

        end


        else
        begin

            $display(
            "FAIL : addr=%0d expected=%h actual=%h",
            read_addr,
            expected[i],
            read_data
            );


            errors = errors + 1;

        end


    end



    //////////////////////////////////////////////////
    // Summary
    //////////////////////////////////////////////////

    #10;


    if(errors == 0)
    begin

        $display("====================");
        $display("TEST PASSED");
        $display("====================");

    end


    else
    begin

        $display("====================");
        $display("TEST FAILED");
        $display("ERROR COUNT = %0d", errors);
        $display("====================");

    end



    #20;

    $finish;


end


endmodule

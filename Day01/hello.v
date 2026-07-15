`timescale 1ns/1ps

module hello;

    reg clk;

    initial begin
        $dumpfile("hello.vcd");
        $dumpvars(0, hello);

        clk = 0;

        #50;
        $display("Hello, AI Chip!");
        $finish;
    end

    always #5 clk = ~clk;

endmodule

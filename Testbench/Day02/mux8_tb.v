`timescale 1ns/1ps

module mux8_tb;

reg [7:0] a;
reg [7:0] b;
reg sel;

wire [7:0] y;


mux8 uut(
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);


initial begin

    $dumpfile("mux8.vcd");
    $dumpvars(0,mux8_tb);


    // Test 1
    a = 8'b10101010;
    b = 8'b01010101;
    sel = 0;

    #10;


    // Test 2
    sel = 1;

    #10;


    // Test 3
    a = 8'hFF;
    b = 8'h00;
    sel = 0;

    #10;


    $finish;

end

endmodule

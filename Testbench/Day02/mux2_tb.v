`timescale 1ns/1ps

module mux2_tb;

reg a;
reg b;
reg sel;

wire y;


mux2 uut(
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);


initial begin

    $dumpfile("mux2.vcd");
    $dumpvars(0,mux2_tb);


    a = 0;
    b = 1;
    sel = 0;

    #10;

    sel = 1;

    #10;

    a = 1;
    b = 0;
    sel = 0;

    #10;


    $finish;

end


endmodule

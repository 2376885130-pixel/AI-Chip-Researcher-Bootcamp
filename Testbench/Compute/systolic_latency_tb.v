`timescale 1ns/1ps
`ifdef LATENCY_N1
module systolic_latency_case;
    localparam N = 1;
`elsif LATENCY_N4
module systolic_latency_case;
    localparam N = 4;
`else
module systolic_latency_case;
    localparam N = 2;
`endif
    localparam EXPECTED = 3*N-1;
    reg clk = 0, reset = 1, start = 0;
    reg signed [7:0] a [0:N*N-1];
    reg signed [7:0] b [0:N*N-1];
    wire signed [31:0] c [0:N*N-1];
    wire done;
    integer i, cycles;
    always #5 clk = ~clk;
    systolic_matmul #(.DATA_WIDTH(8), .ACC_WIDTH(32), .N(N)) dut (
        .clk(clk), .reset(reset), .start(start), .a(a), .b(b), .c(c), .done(done)
    );
    initial begin
        for (i = 0; i < N*N; i = i + 1) begin
            a[i] = (i == 0) ? 8'sd1 : 8'sd0;
            b[i] = (i == 0) ? 8'sd1 : 8'sd0;
        end
        repeat (2) @(posedge clk);
        @(negedge clk); reset = 0; start = 1;
        @(posedge clk); #1; start = 0;
        cycles = 0;
        while (!done && cycles < EXPECTED + 3) begin
            @(posedge clk); #1; cycles = cycles + 1;
        end
        if (!done || cycles != EXPECTED-1)
            $fatal(1, "LATENCY FAIL N=%0d expected=%0d observed=%0d", N, EXPECTED-1, cycles);
        $display("LATENCY PASS N=%0d start_to_done=%0d run_states=%0d", N, cycles, EXPECTED);
        #1 $finish;
    end
endmodule

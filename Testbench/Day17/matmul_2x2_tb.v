`timescale 1ns/1ps

//==========================================================
// Day 17 : Parallel 2x2 Matrix Multiply - Testbench
//==========================================================
//
// Test 1: A=[1 2;3 4]  B=[5 6;7 8]   -> C=[19 22;43 50]
// Test 2: A=[-1 2;3 -4] B=[2 -1;0 3] -> C=[-2 7;6 -15]
//
// Also measures latency (cycles) from start to done, and
// compares it with Day16 serial execution (~88 cycles).
//==========================================================

module matmul_2x2_tb;

    localparam DATA_WIDTH = 8;
    localparam ACC_WIDTH  = 32;

    //--------------------------------------------------
    // Clock and reset
    //--------------------------------------------------

    reg clk;
    reg reset;
    reg start;

    //--------------------------------------------------
    // Matrix inputs
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0] a00, a01, a10, a11;
    reg signed [DATA_WIDTH-1:0] b00, b01, b10, b11;

    //--------------------------------------------------
    // Result outputs
    //--------------------------------------------------

    wire signed [ACC_WIDTH-1:0] c00, c01, c10, c11;
    wire done;

    //--------------------------------------------------
    // Latency measurement
    //--------------------------------------------------

    reg [31:0] cycle;
    reg [31:0] start_cycle;
    reg [31:0] done_cycle;
    reg [31:0] latency;
    reg [31:0] latency1;
    reg [31:0] latency2;

    //--------------------------------------------------
    // Pass/fail counters
    //--------------------------------------------------

    integer pass_count;
    integer fail_count;

    //--------------------------------------------------
    // DUT : the parallel matrix multiplier
    //--------------------------------------------------

    matmul_2x2 #(

        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)

    ) dut (

        .clk(clk),
        .reset(reset),
        .start(start),

        .a00(a00), .a01(a01), .a10(a10), .a11(a11),

        .b00(b00), .b01(b01), .b10(b10), .b11(b11),

        .c00(c00), .c01(c01), .c10(c10), .c11(c11),

        .done(done)

    );

    //--------------------------------------------------
    // Clock generation : 10 ns period
    //--------------------------------------------------

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end

    //--------------------------------------------------
    // Cycle counter
    //--------------------------------------------------

    always @(posedge clk) cycle <= cycle + 1'b1;

    //--------------------------------------------------
    // Drive one matrix multiply and measure latency
    //--------------------------------------------------

    task automatic do_matmul (

        input signed [DATA_WIDTH-1:0] pa00, pa01, pa10, pa11,
        input signed [DATA_WIDTH-1:0] pb00, pb01, pb10, pb11,

        input [3:0] test_id

    );

        begin

            @(negedge clk);

            a00 = pa00; a01 = pa01; a10 = pa10; a11 = pa11;
            b00 = pb00; b01 = pb01; b10 = pb10; b11 = pb11;

            start = 1'b1;

            @(negedge clk);

            start = 1'b0;

            @(posedge clk);       // DUT samples start here
            start_cycle = cycle;

            @(posedge done);      // completion pulse
            done_cycle  = cycle;

            latency = done_cycle - start_cycle;

            $display("");
            $display("Test %0d:", test_id);
            $display("  A = [%0d %0d]     B = [%0d %0d]",
                a00, a01, b00, b01);
            $display("      [%0d %0d]         [%0d %0d]",
                a10, a11, b10, b11);
            $display("  C = [%0d %0d]", c00, c01);
            $display("      [%0d %0d]", c10, c11);
            $display("  latency = %0d cycles", latency);

        end

    endtask

    //--------------------------------------------------
    // Check helper
    //--------------------------------------------------

    task automatic check_matrix (

        input signed [ACC_WIDTH-1:0] e00, e01, e10, e11,
        input [3:0] test_id

    );

        begin

            if (
                c00 === e00 &&
                c01 === e01 &&
                c10 === e10 &&
                c11 === e11
            ) begin

                $display("  TEST%0d PASS : C = [%0d %0d; %0d %0d]",
                    test_id, e00, e01, e10, e11);

                pass_count = pass_count + 1;

            end
            else begin

                $display("  TEST%0d FAIL : got [%0d %0d; %0d %0d], expected [%0d %0d; %0d %0d]",
                    test_id, c00, c01, c10, c11, e00, e01, e10, e11);

                fail_count = fail_count + 1;

            end

        end

    endtask
    //--------------------------------------------------
    // Main test sequence
    //--------------------------------------------------

    initial begin

        $dumpfile("Simulation/Day17/matmul_2x2.vcd");
        $dumpvars(0, matmul_2x2_tb);

        reset = 1'b1;
        start = 1'b0;

        a00 = 0; a01 = 0; a10 = 0; a11 = 0;
        b00 = 0; b01 = 0; b10 = 0; b11 = 0;

        cycle = 0;
        pass_count = 0;
        fail_count = 0;

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY17 PARALLEL MATMUL TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Test 1 : same data as Day16
        // A=[1 2;3 4]  B=[5 6;7 8]  C=[19 22;43 50]
        //--------------------------------------------------

        do_matmul(
            8'sd1, 8'sd2, 8'sd3, 8'sd4,
            8'sd5, 8'sd6, 8'sd7, 8'sd8,
            4'd1
        );

        latency1 = latency;

        check_matrix(32'sd19, 32'sd22, 32'sd43, 32'sd50, 4'd1);

        //--------------------------------------------------
        // Test 2 : signed negative numbers
        // A=[-1 2;3 -4]  B=[2 -1;0 3]
        //
        // C[0][0] = -1*2 + 2*0 = -2
        // C[0][1] = -1*-1 + 2*3 = 7
        // C[1][0] =  3*2 + -4*0 = 6
        // C[1][1] =  3*-1 + -4*3 = -15
        //--------------------------------------------------

        do_matmul(
            -8'sd1, 8'sd2, 8'sd3, -8'sd4,
            8'sd2, -8'sd1, 8'sd0, 8'sd3,
            4'd2
        );

        latency2 = latency;

        check_matrix(-32'sd2, 32'sd7, 32'sd6, -32'sd15, 4'd2);

        //--------------------------------------------------
        // Summary
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("LATENCY COMPARISON");
        $display("  Day16 serial   : ~88 cycles (4 tasks x ~22)");
        $display("  Day17 parallel : %0d cycles (test1)", latency1);
        $display("  Day17 parallel : %0d cycles (test2)", latency2);

        $display("");
        if (fail_count == 0) begin

            $display("###############################");
            $display("#  DAY17 PARALLEL MATMUL PASS #");
            $display("###############################");

        end
        else begin

            $display("###############################");
            $display("#  DAY17 PARALLEL MATMUL FAIL #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule


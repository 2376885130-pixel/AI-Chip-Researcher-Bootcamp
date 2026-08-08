`timescale 1ns/1ps

//==========================================================
// Day 19 : Parameterized 4x4 Systolic Matmul - Standalone TB
//==========================================================
//
// A reference model (nested loops) computes the expected C.
// The DUT result is compared element by element.
//
// Test 1: A = identity, B = [1..16]  ->  C must equal B
// Test 2: A = B = [1..16]            ->  computed by reference
//==========================================================

module systolic_matmul_tb;

    localparam N          = 4;
    localparam DATA_WIDTH = 8;
    localparam ACC_WIDTH  = 32;

    reg clk;
    reg reset;
    reg start;

    reg signed [DATA_WIDTH-1:0] a [0:N*N-1];
    reg signed [DATA_WIDTH-1:0] b [0:N*N-1];

    wire signed [ACC_WIDTH-1:0] c [0:N*N-1];
    wire done;

    reg signed [ACC_WIDTH-1:0] cref [0:N*N-1];

    integer i, j, k;
    integer fail_count;
    integer total_fail;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    systolic_matmul #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .N(N)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .c(c),
        .done(done)
    );

    //--------------------------------------------------
    // Clock
    //--------------------------------------------------

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Reference model : C = A x B (software emulation)
    //--------------------------------------------------

    task automatic ref_matmul;

        begin

            for (i = 0; i < N; i = i + 1)
                for (j = 0; j < N; j = j + 1) begin

                    cref[i*N + j] = 0;

                    for (k = 0; k < N; k = k + 1)
                        cref[i*N + j] =
                            cref[i*N + j] + a[i*N + k] * b[k*N + j];

                end

        end

    endtask

    //--------------------------------------------------
    // Run one multiply and compare with reference
    //--------------------------------------------------

    task automatic run_test (
        input [3:0] test_id
    );

        begin

            fail_count = 0;

            @(negedge clk);

            start = 1'b1;

            @(negedge clk);

            start = 1'b0;

            @(posedge done);

            $display("");
            $display("Test %0d:", test_id);

            for (i = 0; i < N; i = i + 1) begin

                $display("  C row %0d = [%0d %0d %0d %0d]  ref = [%0d %0d %0d %0d]",
                    i,
                    c[i*N+0], c[i*N+1], c[i*N+2], c[i*N+3],
                    cref[i*N+0], cref[i*N+1], cref[i*N+2], cref[i*N+3]);

            end

            for (i = 0; i < N*N; i = i + 1) begin

                if (c[i] !== cref[i]) begin

                    $display("  C[%0d] FAIL : got %0d, expected %0d",
                        i, c[i], cref[i]);

                    fail_count = fail_count + 1;

                end

            end

            if (fail_count == 0)
                $display("  TEST%0d PASS (all %0d elements match)",
                    test_id, N*N);
            else
                $display("  TEST%0d FAIL : %0d mismatches", test_id, fail_count);

            total_fail = total_fail + fail_count;

        end

    endtask
    //--------------------------------------------------
    // Main test sequence
    //--------------------------------------------------

    initial begin

        $dumpfile("Simulation/Day19/systolic_matmul.vcd");
        $dumpvars(0, systolic_matmul_tb);

        reset = 1'b1;
        start = 1'b0;
        total_fail = 0;

        for (i = 0; i < N*N; i = i + 1) begin
            a[i] = 0;
            b[i] = 0;
            cref[i] = 0;
        end

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY19 SYSTOLIC 4x4 TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Test 1 : A = identity, B = 1..16
        // C must equal B exactly.
        //--------------------------------------------------

        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                a[i*N + j] = (i == j) ? 8'sd1 : 8'sd0;

        for (i = 0; i < N*N; i = i + 1)
            b[i] = i + 1;

        ref_matmul();

        run_test(4'd1);

        //--------------------------------------------------
        // Test 2 : A = B = 1..16 (row-major)
        // Reference model computes the expected C.
        //--------------------------------------------------

        for (i = 0; i < N*N; i = i + 1) begin
            a[i] = i + 1;
            b[i] = i + 1;
        end

        ref_matmul();

        run_test(4'd2);

        //--------------------------------------------------
        // Summary
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("LATENCY: systolic 4x4 compute = 11 cycles");
        $display("vs Day14 NPU serial (16 dot products) ~352 cycles");

        $display("");
        if (total_fail == 0) begin

            $display("###############################");
            $display("#   DAY19 SYSTOLIC 4x4 PASS   #");
            $display("###############################");

        end
        else begin

            $display("###############################");
            $display("#   DAY19 SYSTOLIC 4x4 FAIL   #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule


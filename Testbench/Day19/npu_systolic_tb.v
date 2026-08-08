`timescale 1ns/1ps

//==========================================================
// Day 19 : npu_systolic_top - Integration Testbench
//==========================================================
//
// CPU writes A into activation buffer, B into weight buffer,
// asserts start, waits done, reads all 16 results back and
// compares against a software reference model.
//
// Test 1: A = identity, B = [1..16]      -> C must equal B
// Test 2: A = B = [1..16]                -> reference model
//==========================================================

module npu_systolic_tb;

    localparam DATA_WIDTH     = 8;
    localparam ACC_WIDTH      = 32;
    localparam ADDR_WIDTH     = 4;
    localparam OUT_ADDR_WIDTH = 4;
    localparam N              = 4;

    //--------------------------------------------------
    // CPU interface signals
    //--------------------------------------------------

    reg clk;
    reg reset;
    reg start;

    reg weight_write_enable;
    reg [ADDR_WIDTH-1:0] weight_write_address;
    reg signed [DATA_WIDTH-1:0] weight_write_data;

    reg activation_write_enable;
    reg [ADDR_WIDTH-1:0] activation_write_address;
    reg signed [DATA_WIDTH-1:0] activation_write_data;

    reg result_read_enable;
    reg [OUT_ADDR_WIDTH-1:0] result_read_address;
    wire signed [ACC_WIDTH-1:0] result_read_data;

    wire done;

    //--------------------------------------------------
    // Matrices and results
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0] ma [0:N*N-1];
    reg signed [DATA_WIDTH-1:0] mb [0:N*N-1];

    reg signed [ACC_WIDTH-1:0] cref [0:N*N-1];
    reg signed [ACC_WIDTH-1:0] cgot [0:N*N-1];

    integer i, j, k;
    integer fail_count;
    integer total_fail;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    npu_systolic_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .OUT_ADDR_WIDTH(OUT_ADDR_WIDTH),
        .MAT_N(N)
    ) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .weight_write_enable(weight_write_enable),
        .weight_write_address(weight_write_address),
        .weight_write_data(weight_write_data),
        .activation_write_enable(activation_write_enable),
        .activation_write_address(activation_write_address),
        .activation_write_data(activation_write_data),
        .result_read_enable(result_read_enable),
        .result_read_address(result_read_address),
        .result_read_data(result_read_data),
        .done(done)
    );

    //--------------------------------------------------
    // Clock generation
    //--------------------------------------------------

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end

    //--------------------------------------------------
    // Write one weight-buffer entry
    //--------------------------------------------------

    task automatic write_weight (
        input [ADDR_WIDTH-1:0] addr,
        input signed [DATA_WIDTH-1:0] data
    );

        begin

            @(negedge clk);

            weight_write_enable  = 1'b1;
            weight_write_address = addr;
            weight_write_data    = data;

            @(negedge clk);

            weight_write_enable = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Write one activation-buffer entry
    //--------------------------------------------------

    task automatic write_activation (
        input [ADDR_WIDTH-1:0] addr,
        input signed [DATA_WIDTH-1:0] data
    );

        begin

            @(negedge clk);

            activation_write_enable  = 1'b1;
            activation_write_address = addr;
            activation_write_data    = data;

            @(negedge clk);

            activation_write_enable = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Load both matrices into the buffers
    //--------------------------------------------------

    task automatic load_matrices;

        begin

            for (i = 0; i < N*N; i = i + 1)
                write_activation(i, ma[i]);

            for (i = 0; i < N*N; i = i + 1)
                write_weight(i, mb[i]);

        end

    endtask

    //--------------------------------------------------
    // Start the NPU
    //--------------------------------------------------

    task automatic start_npu;

        begin

            @(negedge clk);

            start = 1'b1;

            @(negedge clk);

            start = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Reference model : C = A x B
    //--------------------------------------------------

    task automatic ref_matmul;

        begin

            for (i = 0; i < N; i = i + 1)
                for (j = 0; j < N; j = j + 1) begin

                    cref[i*N + j] = 0;

                    for (k = 0; k < N; k = k + 1)
                        cref[i*N + j] =
                            cref[i*N + j] + ma[i*N + k] * mb[k*N + j];

                end

        end

    endtask
    //--------------------------------------------------
    // Read all 16 results back
    //--------------------------------------------------

    task automatic read_all;

        begin

            for (i = 0; i < N*N; i = i + 1) begin

                @(negedge clk);

                result_read_enable  = 1'b1;
                result_read_address = i;

                @(negedge clk);

                result_read_enable = 1'b0;

                cgot[i] = result_read_data;

            end

        end

    endtask

    //--------------------------------------------------
    // Run one NPU task and check against reference
    //--------------------------------------------------

    task automatic run_test (
        input [3:0] test_id
    );

        begin

            fail_count = 0;

            load_matrices();

            ref_matmul();

            start_npu();

            @(posedge done);

            read_all();

            $display("");
            $display("Test %0d :", test_id);

            for (i = 0; i < N; i = i + 1) begin

                $display("  C row %0d = [%0d %0d %0d %0d]  ref = [%0d %0d %0d %0d]",
                    i,
                    cgot[i*N+0], cgot[i*N+1], cgot[i*N+2], cgot[i*N+3],
                    cref[i*N+0], cref[i*N+1], cref[i*N+2], cref[i*N+3]);

            end

            for (i = 0; i < N*N; i = i + 1) begin

                if (cgot[i] !== cref[i]) begin

                    $display("  C[%0d] FAIL : got %0d, expected %0d",
                        i, cgot[i], cref[i]);

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

        $dumpfile("Simulation/Day19/npu_systolic.vcd");
        $dumpvars(0, npu_systolic_tb);

        reset = 1'b1;
        start = 1'b0;

        weight_write_enable     = 1'b0;
        weight_write_address    = 0;
        weight_write_data       = 0;

        activation_write_enable = 1'b0;
        activation_write_address = 0;
        activation_write_data   = 0;

        result_read_enable  = 1'b0;
        result_read_address = 0;

        total_fail = 0;

        for (i = 0; i < N*N; i = i + 1) begin
            ma[i]   = 0;
            mb[i]   = 0;
            cref[i] = 0;
            cgot[i] = 0;
        end

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY19 NPU SYSTOLIC TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Test 1 : A = identity, B = 1..16 -> C = B
        //--------------------------------------------------

        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                ma[i*N + j] = (i == j) ? 8'sd1 : 8'sd0;

        for (i = 0; i < N*N; i = i + 1)
            mb[i] = i + 1;

        run_test(4'd1);

        //--------------------------------------------------
        // Test 2 : A = B = [1..16]
        //--------------------------------------------------

        for (i = 0; i < N*N; i = i + 1) begin
            ma[i] = i + 1;
            mb[i] = i + 1;
        end

        run_test(4'd2);

        //--------------------------------------------------
        // Summary
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("LATENCY: full NPU task (fetch 48 + systolic 11 + store 16)");
        $display("vs Day14 NPU serial 16 dot products ~352 cycles");
        $display("");

        if (total_fail == 0) begin

            $display("###############################");
            $display("#  DAY19 NPU SYSTOLIC PASS    #");
            $display("###############################");

        end
        else begin

            $display("###############################");
            $display("#  DAY19 NPU SYSTOLIC FAIL    #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule


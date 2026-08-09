`timescale 1ns/1ps

//==========================================================
// Day 20 : npu_pipelined_top - Double Buffer Testbench
//==========================================================
//
// Loads NUM_TASKS (4) matrix pairs, starts the NPU once, and
// verifies all results against a software reference model.
// Measures total cycles and compares with serial execution.
//
// Tasks:
//   0: A=identity, B=[1..16]          -> C = B
//   1: A=[1..16],   B=[16..1]
//   2: A=[2,4..32], B=[3,6..48]
//   3: A=-[1..16],  B=[1..16]         (signed)
//==========================================================

module npu_pipelined_tb;

    localparam DATA_WIDTH     = 8;
    localparam ACC_WIDTH      = 32;
    localparam ADDR_WIDTH     = 6;
    localparam OUT_ADDR_WIDTH = 6;
    localparam N              = 4;
    localparam NUM_TASKS      = 4;
    localparam BLOCK          = N*N;

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

    reg signed [DATA_WIDTH-1:0] ma [0:NUM_TASKS-1][0:BLOCK-1];
    reg signed [DATA_WIDTH-1:0] mb [0:NUM_TASKS-1][0:BLOCK-1];

    reg signed [ACC_WIDTH-1:0] cref [0:NUM_TASKS-1][0:BLOCK-1];
    reg signed [ACC_WIDTH-1:0] cgot [0:NUM_TASKS-1][0:BLOCK-1];

    integer i, j, k, t;
    integer fail_count;
    integer total_fail;

    reg [31:0] cycle;
    reg [31:0] start_cycle;
    reg [31:0] done_cycle;
    reg [31:0] total_cycles;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    npu_pipelined_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .OUT_ADDR_WIDTH(OUT_ADDR_WIDTH),
        .MAT_N(N),
        .NUM_TASKS(NUM_TASKS)
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
    // Clock and cycle counter
    //--------------------------------------------------

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    always @(posedge clk) cycle <= cycle + 1'b1;

    //--------------------------------------------------
    // Write helpers
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
    // Load all tasks into the buffers
    //--------------------------------------------------

    task automatic load_all;
        begin
            for (t = 0; t < NUM_TASKS; t = t + 1) begin
                for (i = 0; i < BLOCK; i = i + 1)
                    write_activation(t*BLOCK + i, ma[t][i]);
                for (i = 0; i < BLOCK; i = i + 1)
                    write_weight(t*BLOCK + i, mb[t][i]);
            end
        end
    endtask

    //--------------------------------------------------
    // Reference model per task
    //--------------------------------------------------

    task automatic ref_matmul;
        begin
            for (t = 0; t < NUM_TASKS; t = t + 1)
                for (i = 0; i < N; i = i + 1)
                    for (j = 0; j < N; j = j + 1) begin
                        cref[t][i*N + j] = 0;
                        for (k = 0; k < N; k = k + 1)
                            cref[t][i*N + j] =
                                cref[t][i*N + j] + ma[t][i*N + k] * mb[t][k*N + j];
                    end
        end
    endtask

    //--------------------------------------------------
    // Read back all results
    //--------------------------------------------------

    task automatic read_all;
        begin
            for (t = 0; t < NUM_TASKS; t = t + 1)
                for (i = 0; i < BLOCK; i = i + 1) begin
                    @(negedge clk);
                    result_read_enable  = 1'b1;
                    result_read_address = t*BLOCK + i;
                    @(negedge clk);
                    result_read_enable = 1'b0;
                    cgot[t][i] = result_read_data;
                end
        end
    endtask
    //--------------------------------------------------
    // Main test sequence
    //--------------------------------------------------

    initial begin

        $dumpfile("Simulation/Day20/npu_pipelined.vcd");
        $dumpvars(0, npu_pipelined_tb);

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

        cycle = 0;
        total_fail = 0;

        for (t = 0; t < NUM_TASKS; t = t + 1)
            for (i = 0; i < BLOCK; i = i + 1) begin
                ma[t][i]   = 0;
                mb[t][i]   = 0;
                cref[t][i] = 0;
                cgot[t][i] = 0;
            end

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY20 DOUBLE BUFFER TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Build the 4 tasks
        //--------------------------------------------------

        // Task 0 : A = identity, B = [1..16]
        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                ma[0][i*N + j] = (i == j) ? 8'sd1 : 8'sd0;

        for (i = 0; i < BLOCK; i = i + 1)
            mb[0][i] = i + 1;

        // Task 1 : A = [1..16], B = [16..1]
        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[1][i] = i + 1;
            mb[1][i] = 16 - i;
        end

        // Task 2 : A = [2,4..32], B = [3,6..48]
        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[2][i] = 2*(i + 1);
            mb[2][i] = 3*(i + 1);
        end

        // Task 3 : A = -[1..16], B = [1..16]
        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[3][i] = -8'sd1*(i + 1);
            mb[3][i] = i + 1;
        end

        load_all();

        ref_matmul();

        //--------------------------------------------------
        // Start the pipelined NPU
        //--------------------------------------------------

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;

        @(posedge clk);       // start sampled
        start_cycle = cycle;

        @(posedge done);      // all tasks done
        done_cycle = cycle;

        total_cycles = done_cycle - start_cycle;

        read_all();

        //--------------------------------------------------
        // Verify every task
        //--------------------------------------------------

        for (t = 0; t < NUM_TASKS; t = t + 1) begin

            fail_count = 0;

            $display("");
            $display("Task %0d :", t);

            for (i = 0; i < N; i = i + 1) begin

                $display("  C row %0d = [%0d %0d %0d %0d]  ref = [%0d %0d %0d %0d]",
                    i,
                    cgot[t][i*N+0], cgot[t][i*N+1], cgot[t][i*N+2], cgot[t][i*N+3],
                    cref[t][i*N+0], cref[t][i*N+1], cref[t][i*N+2], cref[t][i*N+3]);

            end

            for (i = 0; i < BLOCK; i = i + 1) begin

                if (cgot[t][i] !== cref[t][i]) begin
                    $display("  Task%0d C[%0d] FAIL : got %0d, expected %0d",
                        t, i, cgot[t][i], cref[t][i]);
                    fail_count = fail_count + 1;
                end

            end

            if (fail_count == 0)
                $display("  Task %0d PASS (all %0d elements match)", t, BLOCK);
            else
                $display("  Task %0d FAIL : %0d mismatches", t, fail_count);

            total_fail = total_fail + fail_count;

        end

        //--------------------------------------------------
        // Latency comparison
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("LATENCY (4 consecutive 4x4 matrix multiplies)");
        $display("  Serial (Day19)      : ~%0d cycles", NUM_TASKS*78);
        $display("  Double buffered     : %0d cycles", total_cycles);
        $display("  Throughput speedup  : ~%0d%%",
            (NUM_TASKS*78 * 100) / total_cycles);

        $display("");
        if (total_fail == 0) begin

            $display("###############################");
            $display("#  DAY20 DOUBLE BUFFER PASS   #");
            $display("###############################");

        end
        else begin

            $display("###############################");
            $display("#  DAY20 DOUBLE BUFFER FAIL   #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule


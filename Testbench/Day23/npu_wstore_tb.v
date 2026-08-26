`timescale 1ns/1ps

//==========================================================
// Day 23 : npu_wstore_top - 2-wide Store Testbench
//==========================================================
// Loads NUM_TASKS (4) matrix pairs packed into 32-bit words,
// runs the pipelined NPU with a 2-wide store (64-bit result
// words), and verifies all results against a reference model.
// Tasks (same as Day20/21/22): identity, [1..16]x[16..1],
// scaled, negatives.
//==========================================================

module npu_wstore_tb;

    localparam DATA_WIDTH     = 8;
    localparam WORD_WIDTH     = 32;
    localparam ACC_WIDTH      = 32;
    localparam ADDR_WIDTH     = 4;
    localparam OUT_ADDR_WIDTH = 5;
    localparam N              = 4;
    localparam NUM_TASKS      = 4;
    localparam BLOCK          = N*N;

    reg clk;
    reg reset;
    reg start;

    reg weight_write_enable;
    reg [ADDR_WIDTH-1:0] weight_write_address;
    reg signed [WORD_WIDTH-1:0] weight_write_data;

    reg activation_write_enable;
    reg [ADDR_WIDTH-1:0] activation_write_address;
    reg signed [WORD_WIDTH-1:0] activation_write_data;

    reg result_read_enable;
    reg [OUT_ADDR_WIDTH-1:0] result_read_address;
    wire signed [2*ACC_WIDTH-1:0] result_read_data;

    wire done;

    reg signed [DATA_WIDTH-1:0] ma [0:NUM_TASKS-1][0:BLOCK-1];
    reg signed [DATA_WIDTH-1:0] mb [0:NUM_TASKS-1][0:BLOCK-1];

    reg signed [ACC_WIDTH-1:0] cref [0:NUM_TASKS-1][0:BLOCK-1];
    reg signed [ACC_WIDTH-1:0] cgot [0:NUM_TASKS-1][0:BLOCK-1];

    integer i, j, k, t, w;
    integer fail_count;
    integer total_fail;

    reg [31:0] cycle;
    reg [31:0] start_cycle;
    reg [31:0] done_cycle;
    reg [31:0] total_cycles;
    reg measuring;
    reg [31:0] measure_total, compute_cycles, load_cycles, store_cycles, stall_cycles;
    reg [31:0] mac_count, output_transactions, memory_transactions;

    //--------------------------------------------------
    // DUT
    //--------------------------------------------------

    npu_wstore_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .WORD_WIDTH(WORD_WIDTH),
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

    // Passive performance instrumentation. These counters observe the DUT
    // hierarchy and never drive functional signals.
    always @(posedge clk) begin
        if (reset) begin
            measuring <= 1'b0;
            measure_total <= 0; compute_cycles <= 0; load_cycles <= 0;
            store_cycles <= 0; stall_cycles <= 0; mac_count <= 0;
            output_transactions <= 0; memory_transactions <= 0;
        end else begin
            if (measuring) begin
                measure_total <= measure_total + 1'b1;
                if (dut.state == 4'd5) compute_cycles <= compute_cycles + 1'b1;
                if (dut.state == 4'd2 || dut.state == 4'd3 || dut.state == 4'd8)
                    load_cycles <= load_cycles + 1'b1;
                if (dut.storing) store_cycles <= store_cycles + 1'b1;
                if (dut.state != 4'd5 && dut.state != 4'd2 &&
                    dut.state != 4'd3 && dut.state != 4'd8 && !dut.storing)
                    stall_cycles <= stall_cycles + 1'b1;
                if (dut.weight_read_enable || dut.activation_read_enable)
                    memory_transactions <= memory_transactions + 1'b1;
            end
            if (done) measuring <= 1'b0;
        end
    end
    //--------------------------------------------------
    // Write one 32-bit word (4 packed elements)
    //--------------------------------------------------

    task automatic write_word_act (
        input [ADDR_WIDTH-1:0] addr,
        input signed [DATA_WIDTH-1:0] e0,
        input signed [DATA_WIDTH-1:0] e1,
        input signed [DATA_WIDTH-1:0] e2,
        input signed [DATA_WIDTH-1:0] e3
    );
        begin
            @(negedge clk);
            memory_transactions = memory_transactions + 1'b1;
            activation_write_enable  = 1'b1;
            activation_write_address = addr;
            activation_write_data    = {e3, e2, e1, e0};
            @(negedge clk);
            memory_transactions = memory_transactions + 1'b1;
            activation_write_enable  = 1'b0;
        end
    endtask

    task automatic write_word_wt (
        input [ADDR_WIDTH-1:0] addr,
        input signed [DATA_WIDTH-1:0] e0,
        input signed [DATA_WIDTH-1:0] e1,
        input signed [DATA_WIDTH-1:0] e2,
        input signed [DATA_WIDTH-1:0] e3
    );
        begin
            @(negedge clk);
            weight_write_enable  = 1'b1;
            weight_write_address = addr;
            weight_write_data    = {e3, e2, e1, e0};
            @(negedge clk);
            weight_write_enable  = 1'b0;
        end
    endtask

    //--------------------------------------------------
    // Load all tasks (packed into words)
    //--------------------------------------------------

    task automatic load_all;
        begin
            for (t = 0; t < NUM_TASKS; t = t + 1) begin
                for (w = 0; w < BLOCK/4; w = w + 1) begin
                    write_word_act(t*(BLOCK/4) + w,
                        ma[t][4*w+0], ma[t][4*w+1], ma[t][4*w+2], ma[t][4*w+3]);
                    write_word_wt(t*(BLOCK/4) + w,
                        mb[t][4*w+0], mb[t][4*w+1], mb[t][4*w+2], mb[t][4*w+3]);
                end
            end
        end
    endtask

    //--------------------------------------------------
    // Reference model
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
                for (w = 0; w < BLOCK/2; w = w + 1) begin
                    @(negedge clk);
                    result_read_enable  = 1'b1;
                    result_read_address = t*(BLOCK/2) + w;
                    @(negedge clk);
                    result_read_enable  = 1'b0;
                    cgot[t][2*w]   = result_read_data[31:0];
                    cgot[t][2*w+1] = result_read_data[63:32];
                end
        end
    endtask

    //--------------------------------------------------
    // Main test sequence
    //--------------------------------------------------

    initial begin

        $dumpfile("Simulation/Day23/npu_wstore.vcd");
        $dumpvars(0, npu_wstore_tb);

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
        measuring = 1'b0;
        output_transactions = 0;
        mac_count = NUM_TASKS * BLOCK * N;
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
        $display("DAY23 WIDE STORE TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Build the 4 tasks (same as Day20)
        //--------------------------------------------------

        for (i = 0; i < N; i = i + 1)
            for (j = 0; j < N; j = j + 1)
                ma[0][i*N + j] = (i == j) ? 8'sd1 : 8'sd0;
        for (i = 0; i < BLOCK; i = i + 1)
            mb[0][i] = i + 1;

        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[1][i] = i + 1;
            mb[1][i] = 16 - i;
        end

        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[2][i] = 2*(i + 1);
            mb[2][i] = 3*(i + 1);
        end

        for (i = 0; i < BLOCK; i = i + 1) begin
            ma[3][i] = -8'sd1*(i + 1);
            mb[3][i] = i + 1;
        end

        load_all();

        ref_matmul();
        mac_count = NUM_TASKS * BLOCK * N;

        //--------------------------------------------------
        // Start the pipelined NPU
        //--------------------------------------------------

        @(negedge clk);

        start = 1'b1;

        @(negedge clk);

        start = 1'b0;

        @(posedge clk);       // start sampled
        start_cycle = cycle;
        measuring = 1'b1;

        @(posedge done);      // all tasks done
        done_cycle = cycle;

        total_cycles = done_cycle - start_cycle;
        output_transactions = NUM_TASKS * (BLOCK/2);

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
        $display("  Day19 serial           : ~312 cycles");
        $display("  Day20 double buffer    :  243 cycles");
        $display("  Day21 wide fetch       :  147 cycles");
        $display("  Day22 pipelined store  :  100 cycles");
        $display("  Day23 wide store       : %0d cycles", total_cycles);
        $display("  Instrumentation total  : %0d", measure_total);
        $display("  Compute cycles         : %0d", compute_cycles);
        $display("  Load/copy cycles       : %0d", load_cycles);
        $display("  Store cycles           : %0d", store_cycles);
        $display("  Stall/overhead cycles  : %0d", stall_cycles);
        $display("  MAC operations         : %0d", mac_count);
        $display("  Memory transactions    : %0d", memory_transactions);
        $display("  Output transactions    : %0d", output_transactions);

        $display("");
        if (total_fail == 0) begin

            $display("###############################");
            $display("#   DAY23 WIDE STORE PASS     #");
            $display("###############################");

        end
        else begin

            $display("###############################");
            $display("#   DAY23 WIDE STORE FAIL     #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule

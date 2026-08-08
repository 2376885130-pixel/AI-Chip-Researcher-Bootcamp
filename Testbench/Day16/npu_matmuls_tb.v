`timescale 1ns/1ps

//==========================================================
// Day 16 : Matrix Multiplication Workload on the NPU
//==========================================================
//
// Goal:
//   Compute C = A x B using the Day14 NPU (no RTL change).
//
//   A = [1 2]        B = [5 6]
//       [3 4]            [7 8]
//
//   Expected:
//   C = [19 22]
//       [43 50]
//
// Key idea (verified by the learner):
//   Matrix multiply = a set of dot products.
//   One NPU task  == one dot product == one output element.
//
//   Mapping rule:
//     activation buffer  <- a row  of A
//     weight buffer      <- a column of B
//     result stored at   <- output buffer address
//
//   4 tasks:
//     Task 1: C[0][0] = A row0 . B col0 = 1*5 + 2*7 = 19
//     Task 2: C[0][1] = A row0 . B col1 = 1*6 + 2*8 = 22
//     Task 3: C[1][0] = A row1 . B col0 = 3*5 + 4*7 = 43
//     Task 4: C[1][1] = A row1 . B col1 = 3*6 + 4*8 = 50
//==========================================================

module npu_matmuls_tb;

    //--------------------------------------------------
    // Parameters must match the DUT configuration
    //--------------------------------------------------

    localparam DATA_WIDTH        = 8;
    localparam ACC_WIDTH         = 32;
    localparam ADDR_WIDTH        = 4;
    localparam VECTOR_LEN        = 4;
    localparam OUTPUT_ADDR_WIDTH = 2;

    //--------------------------------------------------
    // Clock and reset
    //--------------------------------------------------

    reg clk;
    reg reset;

    //--------------------------------------------------
    // CPU command interface
    //--------------------------------------------------

    reg start;

    reg [OUTPUT_ADDR_WIDTH-1:0]
    result_write_address;

    //--------------------------------------------------
    // Weight-buffer CPU write interface
    //--------------------------------------------------

    reg weight_write_enable;

    reg [ADDR_WIDTH-1:0]
    weight_write_address;

    reg signed [DATA_WIDTH-1:0]
    weight_write_data;

    //--------------------------------------------------
    // Activation-buffer CPU write interface
    //--------------------------------------------------

    reg activation_write_enable;

    reg [ADDR_WIDTH-1:0]
    activation_write_address;

    reg signed [DATA_WIDTH-1:0]
    activation_write_data;

    //--------------------------------------------------
    // Result read interface
    //--------------------------------------------------

    reg result_read_enable;

    reg [OUTPUT_ADDR_WIDTH-1:0]
    result_read_address;

    wire signed [ACC_WIDTH-1:0]
    result_read_data;

    //--------------------------------------------------
    // Completion
    //--------------------------------------------------

    wire done;

    //--------------------------------------------------
    // Matrix C element storage
    //
    // c00 = C[0][0]  c01 = C[0][1]
    // c10 = C[1][0]  c11 = C[1][1]
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0] c00;
    reg signed [ACC_WIDTH-1:0] c01;
    reg signed [ACC_WIDTH-1:0] c10;
    reg signed [ACC_WIDTH-1:0] c11;

    //--------------------------------------------------
    // DUT : reuse the Day14 NPU unchanged
    //--------------------------------------------------

    npu_top #(

        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .VECTOR_LEN(VECTOR_LEN),
        .OUTPUT_ADDR_WIDTH(OUTPUT_ADDR_WIDTH)

    ) dut (

        .clk(clk),
        .reset(reset),

        .start(start),

        .result_write_address(
            result_write_address
        ),

        .weight_write_enable(
            weight_write_enable
        ),

        .weight_write_address(
            weight_write_address
        ),

        .weight_write_data(
            weight_write_data
        ),

        .activation_write_enable(
            activation_write_enable
        ),

        .activation_write_address(
            activation_write_address
        ),

        .activation_write_data(
            activation_write_data
        ),

        .result_read_enable(
            result_read_enable
        ),

        .result_read_address(
            result_read_address
        ),

        .result_read_data(
            result_read_data
        ),

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
    // Write one weight-buffer entry
    //--------------------------------------------------

    task automatic write_weight (

        input [ADDR_WIDTH-1:0] address,

        input signed [DATA_WIDTH-1:0] data

    );

        begin

            @(negedge clk);

            weight_write_enable  = 1'b1;
            weight_write_address = address;
            weight_write_data    = data;

            @(negedge clk);

            weight_write_enable = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Write one activation-buffer entry
    //--------------------------------------------------

    task automatic write_activation (

        input [ADDR_WIDTH-1:0] address,

        input signed [DATA_WIDTH-1:0] data

    );

        begin

            @(negedge clk);

            activation_write_enable  = 1'b1;
            activation_write_address = address;
            activation_write_data    = data;

            @(negedge clk);

            activation_write_enable = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Load one complete four-element task
    //
    //   weight[0:3]     <- a column of B
    //   activation[0:3] <- a row of A
    //--------------------------------------------------

    task automatic load_task (

        input signed [DATA_WIDTH-1:0] weight0,
        input signed [DATA_WIDTH-1:0] weight1,
        input signed [DATA_WIDTH-1:0] weight2,
        input signed [DATA_WIDTH-1:0] weight3,

        input signed [DATA_WIDTH-1:0] activation0,
        input signed [DATA_WIDTH-1:0] activation1,
        input signed [DATA_WIDTH-1:0] activation2,
        input signed [DATA_WIDTH-1:0] activation3

    );

        begin

            write_weight(4'd0, weight0);
            write_weight(4'd1, weight1);
            write_weight(4'd2, weight2);
            write_weight(4'd3, weight3);

            write_activation(4'd0, activation0);
            write_activation(4'd1, activation1);
            write_activation(4'd2, activation2);
            write_activation(4'd3, activation3);

        end

    endtask

    //--------------------------------------------------
    // Start one NPU task
    //--------------------------------------------------

    task automatic start_npu_task (

        input [OUTPUT_ADDR_WIDTH-1:0]
        destination_address

    );

        begin

            @(negedge clk);

            result_write_address =
                destination_address;

            start = 1'b1;

            @(negedge clk);

            start = 1'b0;

        end

    endtask

    //--------------------------------------------------
    // Wait for one complete done pulse
    //--------------------------------------------------

    task automatic wait_for_done;

        begin

            @(posedge done);

            @(negedge clk);
            repeat (2) @(posedge clk);
            @(negedge clk);

        end

    endtask

    //--------------------------------------------------
    // Read one output-buffer entry
    //--------------------------------------------------

    task automatic read_result (

        input [OUTPUT_ADDR_WIDTH-1:0] address,

        output signed [ACC_WIDTH-1:0] data

    );

        begin

            @(negedge clk);

            result_read_enable  = 1'b1;
            result_read_address = address;

            @(negedge clk);

            result_read_enable = 1'b0;

            data = result_read_data;

        end

    endtask

    //--------------------------------------------------
    // Timeout protection
    //--------------------------------------------------

    initial begin

        #8000;

        $display("");
        $display("==================================");
        $display(" ERROR: NPU SIMULATION TIMEOUT");
        $display("==================================");

        $finish;

    end

    //--------------------------------------------------
    // Main test sequence
    //--------------------------------------------------

    initial begin

        //--------------------------------------------------
        // Waveform dump
        //--------------------------------------------------

        $dumpfile(
            "Simulation/Day16/matmuls.vcd"
        );

        $dumpvars(0, npu_matmuls_tb);

        //--------------------------------------------------
        // Initial values
        //--------------------------------------------------

        reset = 1'b1;
        start = 1'b0;

        result_write_address = 0;

        weight_write_enable  = 1'b0;
        weight_write_address = 0;
        weight_write_data    = 0;

        activation_write_enable  = 1'b0;
        activation_write_address = 0;
        activation_write_data    = 0;

        result_read_enable  = 1'b0;
        result_read_address = 0;

        c00 = 0;
        c01 = 0;
        c10 = 0;
        c11 = 0;

        //--------------------------------------------------
        // Reset only once
        //--------------------------------------------------

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY16 MATRIX MULTIPLY TEST START");
        $display("--------------------------------");
        $display("");
        $display("A = [1 2]     B = [5 6]");
        $display("    [3 4]         [7 8]");
        $display("");

        //--------------------------------------------------
        // Task 1 : C[0][0]
        // activation = A row 0 = [1, 2]
        // weight     = B col 0 = [5, 7]
        // expected  = 1*5 + 2*7 = 19
        // store to output buffer address 0
        //--------------------------------------------------

        $display("Computing C[0][0] ...");

        load_task(
            8'sd5, 8'sd7, 8'sd0, 8'sd0,
            8'sd1, 8'sd2, 8'sd0, 8'sd0
        );

        start_npu_task(2'd0);

        wait_for_done();

        $display(
            "  C[0][0] compute result = %0d",
            dut.compute_result
        );

        //--------------------------------------------------
        // Task 2 : C[0][1]
        // activation = A row 0 = [1, 2]
        // weight     = B col 1 = [6, 8]
        // expected  = 1*6 + 2*8 = 22
        // store to output buffer address 1
        //--------------------------------------------------

        $display("Computing C[0][1] ...");

        load_task(
            8'sd6, 8'sd8, 8'sd0, 8'sd0,
            8'sd1, 8'sd2, 8'sd0, 8'sd0
        );

        start_npu_task(2'd1);

        wait_for_done();

        $display(
            "  C[0][1] compute result = %0d",
            dut.compute_result
        );

        //--------------------------------------------------
        // Task 3 : C[1][0]
        // activation = A row 1 = [3, 4]
        // weight     = B col 0 = [5, 7]
        // expected  = 3*5 + 4*7 = 43
        // store to output buffer address 2
        //--------------------------------------------------

        $display("Computing C[1][0] ...");

        load_task(
            8'sd5, 8'sd7, 8'sd0, 8'sd0,
            8'sd3, 8'sd4, 8'sd0, 8'sd0
        );

        start_npu_task(2'd2);

        wait_for_done();

        $display(
            "  C[1][0] compute result = %0d",
            dut.compute_result
        );

        //--------------------------------------------------
        // Task 4 : C[1][1]
        // activation = A row 1 = [3, 4]
        // weight     = B col 1 = [6, 8]
        // expected  = 3*6 + 4*8 = 50
        // store to output buffer address 3
        //--------------------------------------------------

        $display("Computing C[1][1] ...");

        load_task(
            8'sd6, 8'sd8, 8'sd0, 8'sd0,
            8'sd3, 8'sd4, 8'sd0, 8'sd0
        );

        start_npu_task(2'd3);

        wait_for_done();

        $display(
            "  C[1][1] compute result = %0d",
            dut.compute_result
        );
        //--------------------------------------------------
        // Read all four results from the output buffer
        //--------------------------------------------------

        read_result(2'd0, c00);
        read_result(2'd1, c01);
        read_result(2'd2, c10);
        read_result(2'd3, c11);

        //--------------------------------------------------
        // Display matrix C
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("MATRIX C = A x B");
        $display("");
        $display("  C = [%0d %0d]", c00, c01);
        $display("      [%0d %0d]", c10, c11);
        $display("--------------------------------");

        //--------------------------------------------------
        // Element-wise verification
        //--------------------------------------------------

        if (c00 === 32'sd19)
            $display("  C[0][0] = %0d  PASS (expected 19)", c00);
        else
            $display("  C[0][0] = %0d  FAIL (expected 19)", c00);

        if (c01 === 32'sd22)
            $display("  C[0][1] = %0d  PASS (expected 22)", c01);
        else
            $display("  C[0][1] = %0d  FAIL (expected 22)", c01);

        if (c10 === 32'sd43)
            $display("  C[1][0] = %0d  PASS (expected 43)", c10);
        else
            $display("  C[1][0] = %0d  FAIL (expected 43)", c10);

        if (c11 === 32'sd50)
            $display("  C[1][1] = %0d  PASS (expected 50)", c11);
        else
            $display("  C[1][1] = %0d  FAIL (expected 50)", c11);

        //--------------------------------------------------
        // Overall result
        //--------------------------------------------------

        if (
            c00 === 32'sd19 &&
            c01 === 32'sd22 &&
            c10 === 32'sd43 &&
            c11 === 32'sd50
        ) begin

            $display("");
            $display("###############################");
            $display("# DAY16 MATRIX MULTIPLY PASS  #");
            $display("###############################");

        end
        else begin

            $display("");
            $display("###############################");
            $display("# DAY16 MATRIX MULTIPLY FAIL  #");
            $display("###############################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule


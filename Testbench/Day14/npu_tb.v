`timescale 1ns/1ps

module npu_tb;

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
    // Weight write interface
    //--------------------------------------------------

    reg weight_write_enable;

    reg [ADDR_WIDTH-1:0]
    weight_write_address;

    reg signed [DATA_WIDTH-1:0]
    weight_write_data;

    //--------------------------------------------------
    // Activation write interface
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
    // Testbench result storage
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0]
    task1_result;

    reg signed [ACC_WIDTH-1:0]
    task2_result;

    //--------------------------------------------------
    // DUT
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
    // Clock generation: 10 ns period
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
    // Start one task
    //--------------------------------------------------

    task automatic start_npu_task (

        input [OUTPUT_ADDR_WIDTH-1:0]
        destination_address

    );

        begin

            /*
             * Set the destination before asserting start.
             */
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

            /*
             * Wait for the rising edge of the current task's
             * completion pulse.
             */
            @(posedge done);

            /*
             * Wait until the DONE state finishes and the
             * controller returns to IDLE.
             */
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

            /*
             * Present the read request before a rising edge.
             */
            @(negedge clk);

            result_read_enable  = 1'b1;
            result_read_address = address;

            /*
             * The synchronous Output Buffer samples the
             * request at the next rising edge.
             */
            @(negedge clk);

            result_read_enable = 1'b0;

            /*
             * read_data has now been updated by the previous
             * rising edge and is stable.
             */
            data = result_read_data;

        end

    endtask

    //--------------------------------------------------
    // Timeout protection
    //--------------------------------------------------

    initial begin

        #8000;

        $display("");
        $display("================================");
        $display(" ERROR: NPU SIMULATION TIMEOUT");
        $display("================================");

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
            "Simulation/Day14/npu.vcd"
        );

        $dumpvars(0, npu_tb);

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

        task1_result = 0;
        task2_result = 0;

        //--------------------------------------------------
        // Reset only once
        //--------------------------------------------------

        repeat (3) @(posedge clk);

        @(negedge clk);

        reset = 1'b0;

        $display("--------------------------------");
        $display("DAY14 MULTI-TASK TEST START");
        $display("--------------------------------");

        //--------------------------------------------------
        // Task 1
        //
        // [1, 3, 0, 0] dot [5, 7, 0, 0]
        // = 1*5 + 3*7
        // = 26
        //
        // Store result at Output Buffer[0]
        //--------------------------------------------------

        $display("");
        $display("Loading Task 1...");

        load_task(

            8'sd5,
            8'sd7,
            8'sd0,
            8'sd0,

            8'sd1,
            8'sd3,
            8'sd0,
            8'sd0

        );

        $display(
            "Task 1 weights     = %0d, %0d, %0d, %0d",
            dut.weight_mem.memory[0],
            dut.weight_mem.memory[1],
            dut.weight_mem.memory[2],
            dut.weight_mem.memory[3]
        );

        $display(
            "Task 1 activations = %0d, %0d, %0d, %0d",
            dut.activation_mem.memory[0],
            dut.activation_mem.memory[1],
            dut.activation_mem.memory[2],
            dut.activation_mem.memory[3]
        );

        start_npu_task(2'd0);

        wait_for_done();

        $display(
            "Task 1 compute result = %0d",
            dut.compute_result
        );

        //--------------------------------------------------
        // Task 2 — no reset between tasks
        //
        // [2, 4, 0, 0] dot [6, 8, 0, 0]
        // = 2*6 + 4*8
        // = 44
        //
        // Store result at Output Buffer[1]
        //--------------------------------------------------

        $display("");
        $display("Loading Task 2 without reset...");

        load_task(

            8'sd6,
            8'sd8,
            8'sd0,
            8'sd0,

            8'sd2,
            8'sd4,
            8'sd0,
            8'sd0

        );

        $display(
            "Task 2 weights     = %0d, %0d, %0d, %0d",
            dut.weight_mem.memory[0],
            dut.weight_mem.memory[1],
            dut.weight_mem.memory[2],
            dut.weight_mem.memory[3]
        );

        $display(
            "Task 2 activations = %0d, %0d, %0d, %0d",
            dut.activation_mem.memory[0],
            dut.activation_mem.memory[1],
            dut.activation_mem.memory[2],
            dut.activation_mem.memory[3]
        );

        start_npu_task(2'd1);

        wait_for_done();

        $display(
            "Task 2 compute result = %0d",
            dut.compute_result
        );

        //--------------------------------------------------
        // Read both stored results
        //--------------------------------------------------

        read_result(
            2'd0,
            task1_result
        );

        read_result(
            2'd1,
            task2_result
        );

        //--------------------------------------------------
        // Display final results
        //--------------------------------------------------

        $display("");
        $display("--------------------------------");
        $display("MULTI-TASK RESULTS");

        $display(
            "Output Buffer[0] = %0d, expected 26",
            task1_result
        );

        $display(
            "Output Buffer[1] = %0d, expected 44",
            task2_result
        );

        //--------------------------------------------------
        // Task 1 verification
        //--------------------------------------------------

        if (task1_result === 32'sd26) begin

            $display("");
            $display("==============================");
            $display(" TASK 1 TEST PASS");
            $display("==============================");

        end
        else begin

            $display("");
            $display("==============================");
            $display(" TASK 1 TEST FAIL");
            $display("==============================");

        end

        //--------------------------------------------------
        // Task 2 verification
        //--------------------------------------------------

        if (task2_result === 32'sd44) begin

            $display("");
            $display("==============================");
            $display(" TASK 2 TEST PASS");
            $display("==============================");

        end
        else begin

            $display("");
            $display("==============================");
            $display(" TASK 2 TEST FAIL");
            $display("==============================");

        end

        //--------------------------------------------------
        // Confirm that Task 1 was not overwritten
        //--------------------------------------------------

        if (
            dut.result_mem.memory[0] === 32'sd26 &&
            dut.result_mem.memory[1] === 32'sd44
        ) begin

            $display("");
            $display("==============================");
            $display(" OUTPUT ADDRESS TEST PASS");
            $display("==============================");

        end
        else begin

            $display("");
            $display("==============================");
            $display(" OUTPUT ADDRESS TEST FAIL");
            $display("==============================");

        end

        //--------------------------------------------------
        // Overall result
        //--------------------------------------------------

        if (
            task1_result === 32'sd26 &&
            task2_result === 32'sd44 &&
            dut.result_mem.memory[0] === 32'sd26 &&
            dut.result_mem.memory[1] === 32'sd44
        ) begin

            $display("");
            $display("################################");
            $display("#  DAY14 MULTI-TASK TEST PASS  #");
            $display("################################");

        end
        else begin

            $display("");
            $display("################################");
            $display("#  DAY14 MULTI-TASK TEST FAIL  #");
            $display("################################");

        end

        $display("--------------------------------");

        #20;

        $finish;

    end

endmodule

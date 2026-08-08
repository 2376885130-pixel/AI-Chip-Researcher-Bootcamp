`timescale 1ns/1ps

//==========================================================
// Day 19 : npu_systolic_top
//==========================================================
//
// Day14 NPU with the serial dot_product_engine REPLACED by
// the parameterized 4x4 systolic array.
//
// Flow:
//   CPU writes A into activation_buffer, B into weight_buffer
//   start -> fetch16 reads 16+16 values
//   -> systolic_matmul computes C = A x B (11 cycles)
//   -> results stored into output_buffer (16 entries)
//   -> done
//
// Controller FSM:
//   IDLE -> START_FETCH -> WAIT_FETCH -> START_COMPUTE
//        -> WAIT_COMPUTE -> STORE -> DONE -> IDLE
//==========================================================

module npu_systolic_top #(

    parameter DATA_WIDTH     = 8,
    parameter ACC_WIDTH      = 32,
    parameter ADDR_WIDTH     = 4,
    parameter OUT_ADDR_WIDTH = 4,
    parameter MAT_N          = 4

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // CPU command
    //--------------------------------------------------

    input wire start,

    //--------------------------------------------------
    // Weight-buffer (B) CPU write interface
    //--------------------------------------------------

    input wire weight_write_enable,

    input wire [ADDR_WIDTH-1:0]
    weight_write_address,

    input wire signed [DATA_WIDTH-1:0]
    weight_write_data,

    //--------------------------------------------------
    // Activation-buffer (A) CPU write interface
    //--------------------------------------------------

    input wire activation_write_enable,

    input wire [ADDR_WIDTH-1:0]
    activation_write_address,

    input wire signed [DATA_WIDTH-1:0]
    activation_write_data,

    //--------------------------------------------------
    // Output-buffer CPU read interface
    //--------------------------------------------------

    input wire result_read_enable,

    input wire [OUT_ADDR_WIDTH-1:0]
    result_read_address,

    output wire signed [ACC_WIDTH-1:0]
    result_read_data,

    //--------------------------------------------------
    // Completion
    //--------------------------------------------------

    output reg done

);

    //--------------------------------------------------
    // Internal control signals (driven by the controller)
    //--------------------------------------------------

    reg start_fetch;
    reg start_compute;
    reg store_result;

    wire data_ready;
    wire compute_done;

    //--------------------------------------------------
    // Buffer / fetch / compute wires
    //--------------------------------------------------

    wire weight_read_enable;
    wire activation_read_enable;

    wire [ADDR_WIDTH-1:0]
    weight_read_address;

    wire [ADDR_WIDTH-1:0]
    activation_read_address;

    wire signed [DATA_WIDTH-1:0]
    weight_buffer_data;

    wire signed [DATA_WIDTH-1:0]
    activation_buffer_data;

    wire signed [DATA_WIDTH-1:0]
    a [0:MAT_N*MAT_N-1];

    wire signed [DATA_WIDTH-1:0]
    b [0:MAT_N*MAT_N-1];

    wire signed [ACC_WIDTH-1:0]
    c [0:MAT_N*MAT_N-1];

    //--------------------------------------------------
    // Result-store address counter
    //--------------------------------------------------

    reg [OUT_ADDR_WIDTH-1:0] store_addr;

    always @(posedge clk) begin

        if (reset)
            store_addr <= {OUT_ADDR_WIDTH{1'b0}};

        else if (store_result) begin

            if (store_addr == MAT_N*MAT_N-1)
                store_addr <= {OUT_ADDR_WIDTH{1'b0}};
            else
                store_addr <= store_addr + 1'b1;

        end

    end
    //--------------------------------------------------
    // Weight buffer (stores B)
    //--------------------------------------------------

    weight_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) weight_mem (
        .clk(clk),
        .reset(reset),
        .write_enable(weight_write_enable),
        .write_address(weight_write_address),
        .write_data(weight_write_data),
        .read_enable(weight_read_enable),
        .read_address(weight_read_address),
        .data_out(weight_buffer_data)
    );

    //--------------------------------------------------
    // Activation buffer (stores A)
    //--------------------------------------------------

    activation_buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) activation_mem (
        .clk(clk),
        .reset(reset),
        .write_enable(activation_write_enable),
        .write_address(activation_write_address),
        .write_data(activation_write_data),
        .read_enable(activation_read_enable),
        .read_address(activation_read_address),
        .data_out(activation_buffer_data)
    );

    //--------------------------------------------------
    // Data fetch (16 weights + 16 activations)
    //--------------------------------------------------

    fetch16 #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM(MAT_N*MAT_N)
    ) fetch_inst (
        .clk(clk),
        .reset(reset),
        .start_fetch(start_fetch),
        .data_ready(data_ready),
        .weight_read_enable(weight_read_enable),
        .weight_address(weight_read_address),
        .weight_data_in(weight_buffer_data),
        .activation_read_enable(activation_read_enable),
        .activation_address(activation_read_address),
        .activation_data_in(activation_buffer_data),
        .weight_out(b),
        .activation_out(a)
    );

    //--------------------------------------------------
    // Systolic compute array (replaces dot_product_engine)
    //--------------------------------------------------

    systolic_matmul #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .N(MAT_N)
    ) compute_inst (
        .clk(clk),
        .reset(reset),
        .start(start_compute),
        .a(a),
        .b(b),
        .c(c),
        .done(compute_done)
    );

    //--------------------------------------------------
    // Output buffer (16 entries)
    //--------------------------------------------------

    output_buffer #(
        .DATA_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(OUT_ADDR_WIDTH)
    ) result_mem (
        .clk(clk),
        .reset(reset),
        .write_enable(store_result),
        .write_address(store_addr),
        .write_data(c[store_addr]),
        .read_enable(result_read_enable),
        .read_address(result_read_address),
        .read_data(result_read_data)
    );

    //--------------------------------------------------
    // Main controller FSM
    //--------------------------------------------------

    localparam S_IDLE          = 3'd0;
    localparam S_START_FETCH   = 3'd1;
    localparam S_WAIT_FETCH    = 3'd2;
    localparam S_START_COMPUTE = 3'd3;
    localparam S_WAIT_COMPUTE  = 3'd4;
    localparam S_STORE         = 3'd5;
    localparam S_DONE          = 3'd6;

    reg [2:0] state;
    reg [2:0] next_state;

    //--------------------------------------------------
    // State register
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;

    end

    //--------------------------------------------------
    // Next-state logic
    //--------------------------------------------------

    always @(*) begin

        next_state = state;

        case (state)

            S_IDLE: begin
                if (start)
                    next_state = S_START_FETCH;
            end

            S_START_FETCH: begin
                next_state = S_WAIT_FETCH;
            end

            S_WAIT_FETCH: begin
                if (data_ready)
                    next_state = S_START_COMPUTE;
            end

            S_START_COMPUTE: begin
                next_state = S_WAIT_COMPUTE;
            end

            S_WAIT_COMPUTE: begin
                if (compute_done)
                    next_state = S_STORE;
            end

            S_STORE: begin
                // all 16 results written
                if (store_addr == MAT_N*MAT_N-1)
                    next_state = S_DONE;
            end

            S_DONE: begin
                next_state = S_IDLE;
            end

            default: begin
                next_state = S_IDLE;
            end

        endcase

    end

    //--------------------------------------------------
    // Output decoding
    //--------------------------------------------------

    always @(*) begin

        start_fetch   = 1'b0;
        start_compute = 1'b0;
        store_result  = 1'b0;
        done          = 1'b0;

        case (state)

            S_START_FETCH: begin
                start_fetch = 1'b1;
            end

            S_START_COMPUTE: begin
                start_compute = 1'b1;
            end

            S_STORE: begin
                store_result = 1'b1;
            end

            S_DONE: begin
                done = 1'b1;
            end

            default: begin
                start_fetch   = 1'b0;
                start_compute = 1'b0;
                store_result  = 1'b0;
                done          = 1'b0;
            end

        endcase

    end

endmodule


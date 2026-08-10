`timescale 1ns/1ps

//==========================================================
// Day 23 : npu_wstore_top (2-wide result store)
//==========================================================
//
// Day22 pipelined-store NPU with the result write widened to
// 2 results per cycle: two 32-bit results are packed into one
// 64-bit output-buffer word.
//
//   Day22 serial store : 16 writes x 1 cycle = 16 cycles
//   Day23 wide store   :  8 writes x 1 cycle =  8 cycles
//
// Store (8) is now shorter than compute (~12), so the store
// queue is no longer the throughput limiter.
//==========================================================

module npu_wstore_top #(

    parameter DATA_WIDTH     = 8,
    parameter WORD_WIDTH     = 32,
    parameter ACC_WIDTH      = 32,
    parameter ADDR_WIDTH     = 4,
    parameter OUT_ADDR_WIDTH = 5,
    parameter MAT_N          = 4,
    parameter NUM_TASKS      = 4

)(

    input wire clk,
    input wire reset,

    input wire start,

    input wire weight_write_enable,
    input wire [ADDR_WIDTH-1:0]
    weight_write_address,
    input wire signed [WORD_WIDTH-1:0]
    weight_write_data,

    input wire activation_write_enable,
    input wire [ADDR_WIDTH-1:0]
    activation_write_address,
    input wire signed [WORD_WIDTH-1:0]
    activation_write_data,

    input wire result_read_enable,
    input wire [OUT_ADDR_WIDTH-1:0]
    result_read_address,
    output wire signed [2*ACC_WIDTH-1:0]
    result_read_data,

    output reg done

);

    localparam BLOCK     = MAT_N*MAT_N;          // 16 elements per result block
    localparam WORDS     = MAT_N*MAT_N/4;        // 4 words per task block
    localparam OUT_WORDS = MAT_N*MAT_N/2;        // 8 packed 2-result words per task

    //--------------------------------------------------
    // Fetch signals
    //--------------------------------------------------

    wire weight_read_enable;
    wire activation_read_enable;

    wire [ADDR_WIDTH-1:0]
    weight_read_address;

    wire [ADDR_WIDTH-1:0]
    activation_read_address;

    wire signed [WORD_WIDTH-1:0]
    weight_buffer_data;

    wire signed [WORD_WIDTH-1:0]
    activation_buffer_data;

    wire fetch_done;

    wire signed [DATA_WIDTH-1:0]
    fetch_a [0:BLOCK-1];

    wire signed [DATA_WIDTH-1:0]
    fetch_b [0:BLOCK-1];

    //--------------------------------------------------
    // Controller outputs
    //--------------------------------------------------

    reg start_fetch;
    reg start_compute;

    reg [ADDR_WIDTH-1:0] fetch_base;

    //--------------------------------------------------
    // Ping-pong input banks (a/b, as Day21)
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0]
    a_bank [0:1][0:BLOCK-1];

    reg signed [DATA_WIDTH-1:0]
    b_bank [0:1][0:BLOCK-1];

    //--------------------------------------------------
    // Systolic wires
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0]
    a [0:BLOCK-1];

    wire signed [DATA_WIDTH-1:0]
    b [0:BLOCK-1];

    wire signed [ACC_WIDTH-1:0]
    c [0:BLOCK-1];

    wire compute_done;

    //--------------------------------------------------
    // Output ping-pong banks + store sub-FSM
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0]
    out_bank [0:1][0:BLOCK-1];

    reg [2:0] store_task;      // task whose results are being stored
    reg [3:0] store_cnt;
    reg [1:0] store_state;
    reg       storing;         // combinational: result_mem write enable

    //--------------------------------------------------
    // Main controller state
    //--------------------------------------------------

    reg [2:0] task_fetch;
    reg [2:0] task_comp;
    reg       fetch_done_flag;

    reg [3:0] state;
    //--------------------------------------------------
    // Weight buffer (all B matrices, 16 words of 32-bit)
    //--------------------------------------------------

    weight_buffer #(
        .DATA_WIDTH(WORD_WIDTH),
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
    // Activation buffer (all A matrices, 16 words of 32-bit)
    //--------------------------------------------------

    activation_buffer #(
        .DATA_WIDTH(WORD_WIDTH),
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
    // 4-wide fetch (12 cycles)
    //--------------------------------------------------

    fetch16w #(
        .DATA_WIDTH(DATA_WIDTH),
        .WORD_WIDTH(WORD_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_WORDS(WORDS)
    ) fetch_inst (
        .clk(clk),
        .reset(reset),
        .start_fetch(start_fetch),
        .base_addr(fetch_base),
        .data_ready(fetch_done),
        .weight_read_enable(weight_read_enable),
        .weight_address(weight_read_address),
        .weight_data_in(weight_buffer_data),
        .activation_read_enable(activation_read_enable),
        .activation_address(activation_read_address),
        .activation_data_in(activation_buffer_data),
        .weight_out(fetch_b),
        .activation_out(fetch_a)
    );

    //--------------------------------------------------
    // Systolic compute array
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
    // Output buffer (64 result entries)
    //--------------------------------------------------

    wire [OUT_ADDR_WIDTH-1:0] store_waddr;

    assign store_waddr = store_task*OUT_WORDS + store_cnt;

    // Packed 2-result write: {result[2w+1], result[2w]}
    reg signed [ACC_WIDTH-1:0] wres_lo;
    reg signed [ACC_WIDTH-1:0] wres_hi;

    always @(*) begin
        wres_lo = out_bank[store_task[0]][store_cnt*2];
        wres_hi = out_bank[store_task[0]][store_cnt*2+1];
    end

    output_buffer #(
        .DATA_WIDTH(2*ACC_WIDTH),
        .ADDR_WIDTH(OUT_ADDR_WIDTH)
    ) result_mem (
        .clk(clk),
        .reset(reset),
        .write_enable(storing),
        .write_address(store_waddr),
        .write_data({wres_hi, wres_lo}),
        .read_enable(result_read_enable),
        .read_address(result_read_address),
        .read_data(result_read_data)
    );

    //--------------------------------------------------
    // Input bank mux : systolic reads bank[task_comp % 2]
    //--------------------------------------------------

    genvar gi;
    generate
        for (gi = 0; gi < BLOCK; gi = gi + 1) begin : BANK_MUX
            assign a[gi] = task_comp[0] ? a_bank[1][gi] : a_bank[0][gi];
            assign b[gi] = task_comp[0] ? b_bank[1][gi] : b_bank[0][gi];
        end
    endgenerate

    //--------------------------------------------------
    // Main FSM state encoding
    //--------------------------------------------------

    localparam S_IDLE        = 4'd0;
    localparam S_FETCH_START = 4'd1;
    localparam S_FETCH_WAIT  = 4'd2;
    localparam S_COPY        = 4'd3;
    localparam S_COMP_START  = 4'd4;
    localparam S_WAIT_C      = 4'd5;
    localparam S_LATCH       = 4'd6;
    localparam S_WAIT_NEXT_F = 4'd7;
    localparam S_COPY2       = 4'd8;
    localparam S_WAIT_LAST   = 4'd9;
    localparam S_DONE        = 4'd10;

    integer bk;

    //--------------------------------------------------
    // Result latch : capture systolic output into a bank in 1 cycle
    // Also queues a store request (store_req).
    //--------------------------------------------------

    reg store_req;

    always @(posedge clk) begin

        if (reset) begin

            for (bk = 0; bk < BLOCK; bk = bk + 1) begin
                out_bank[0][bk] <= {ACC_WIDTH{1'b0}};
                out_bank[1][bk] <= {ACC_WIDTH{1'b0}};
            end

            store_task <= {3{1'b0}};
            store_req   <= 1'b0;

        end
        else if (state == S_LATCH) begin

            for (bk = 0; bk < BLOCK; bk = bk + 1)
                out_bank[task_comp[0]][bk] <= c[bk];

            store_task <= task_comp;
            store_req   <= 1'b1;

        end

    end

    //--------------------------------------------------
    // Store sub-FSM : runs CONCURRENTLY with the main FSM
    //--------------------------------------------------

    localparam ST_IDLE = 1'd0;
    localparam ST_RUN  = 1'd1;

    always @(posedge clk) begin

        if (reset) begin

            store_state <= ST_IDLE;
            store_cnt   <= 4'd0;

        end
        else begin

            case (store_state)

                ST_IDLE: begin
                    if (store_req) begin
                        store_req   <= 1'b0;
                        store_cnt   <= 4'd0;
                        store_state <= ST_RUN;
                    end
                end

                ST_RUN: begin
                    if (store_cnt == OUT_WORDS-1)
                        store_state <= ST_IDLE;
                    else
                        store_cnt <= store_cnt + 1'b1;
                end

                default: store_state <= ST_IDLE;

            endcase

        end

    end

    always @(*) begin
        storing = (store_state == ST_RUN);
    end

    wire store_busy = (store_state == ST_RUN);

    //--------------------------------------------------
    // Input bank copy (fetch -> a_bank/b_bank)
    //--------------------------------------------------

    wire copying   = (state == S_COPY) || (state == S_COPY2);
    wire copy_bank = task_fetch[0];

    always @(posedge clk) begin

        if (copying) begin

            for (bk = 0; bk < BLOCK; bk = bk + 1) begin
                a_bank[copy_bank][bk] <= fetch_a[bk];
                b_bank[copy_bank][bk] <= fetch_b[bk];
            end

        end

    end

    //--------------------------------------------------
    // Main FSM : compute pipeline (store is decoupled)
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            state           <= S_IDLE;
            task_fetch      <= {3{1'b0}};
            task_comp       <= {3{1'b0}};
            fetch_done_flag <= 1'b0;
            start_fetch     <= 1'b0;
            start_compute   <= 1'b0;
            fetch_base      <= {ADDR_WIDTH{1'b0}};
            done            <= 1'b0;

        end
        else begin

            done <= 1'b0;

            if (fetch_done)
                fetch_done_flag <= 1'b1;

            if (copying)
                fetch_done_flag <= 1'b0;

            case (state)

                S_IDLE: begin
                    if (start) begin
                        task_fetch <= {3{1'b0}};
                        task_comp  <= {3{1'b0}};
                        state      <= S_FETCH_START;
                    end
                end

                S_FETCH_START: begin
                    start_fetch <= 1'b1;
                    fetch_base  <= task_fetch*WORDS;
                    state       <= S_FETCH_WAIT;
                end

                S_FETCH_WAIT: begin
                    start_fetch <= 1'b0;
                    if (fetch_done)
                        state <= S_COPY;
                end

                S_COPY: begin
                    state <= S_COMP_START;
                end

                S_COMP_START: begin
                    start_compute <= 1'b1;
                    if (task_fetch + 1 < NUM_TASKS) begin
                        task_fetch  <= task_fetch + 1'b1;
                        start_fetch <= 1'b1;
                        fetch_base  <= (task_fetch + 1)*WORDS;
                    end
                    state <= S_WAIT_C;
                end

                S_WAIT_C: begin
                    start_compute <= 1'b0;
                    start_fetch   <= 1'b0;
                    if (compute_done)
                        state <= S_LATCH;
                end

                //--------------------------------------
                // Latch results (1 cycle), queue store,
                // then advance to the next compute.
                //--------------------------------------

                S_LATCH: begin
                    if (task_comp + 1 >= NUM_TASKS) begin
                        state <= S_WAIT_LAST;
                    end
                    else begin
                        task_comp <= task_comp + 1'b1;
                        if (fetch_done_flag)
                            state <= S_COMP_START;
                        else
                            state <= S_WAIT_NEXT_F;
                    end
                end

                S_WAIT_NEXT_F: begin
                    if (fetch_done_flag)
                        state <= S_COPY2;
                end

                S_COPY2: begin
                    state <= S_COMP_START;
                end

                // Wait for the final store to drain
                S_WAIT_LAST: begin
                    if (!store_busy && !store_req)
                        state <= S_DONE;
                end

                S_DONE: begin
                    done  <= 1'b1;
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end

            endcase

        end

    end

endmodule


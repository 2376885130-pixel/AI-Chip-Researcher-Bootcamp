`timescale 1ns/1ps

//==========================================================
// Day 21 : npu_wide_top (wide 4-element fetch + double buffer)
//==========================================================
//
// Day20 npu_pipelined_top with the fetch widened to 4 elements
// per cycle (32-bit SRAM words). Same ping-pong pipeline
// controller, same systolic compute, same store.
//
// Memory layout (4 packed elements per 32-bit word):
//   task t : A words at activation_buf[t*4 .. t*4+3]
//            B words at weight_buf[t*4 .. t*4+3]
//            C elements at output_buf[t*16 .. t*16+15]
//
// Fetch: 4 words x 3 cycles = 12 cycles (was 48).
// Steady-state interval: max(12, compute+store=27) = 27.
//==========================================================

module npu_wide_top #(

    parameter DATA_WIDTH     = 8,
    parameter WORD_WIDTH     = 32,
    parameter ACC_WIDTH      = 32,
    parameter ADDR_WIDTH     = 4,
    parameter OUT_ADDR_WIDTH = 6,
    parameter MAT_N          = 4,
    parameter NUM_TASKS      = 4

)(

    input wire clk,
    input wire reset,

    input wire start,

    //--------------------------------------------------
    // Weight-buffer (B) CPU write interface (32-bit words)
    //--------------------------------------------------

    input wire weight_write_enable,

    input wire [ADDR_WIDTH-1:0]
    weight_write_address,

    input wire signed [WORD_WIDTH-1:0]
    weight_write_data,

    //--------------------------------------------------
    // Activation-buffer (A) CPU write interface (32-bit words)
    //--------------------------------------------------

    input wire activation_write_enable,

    input wire [ADDR_WIDTH-1:0]
    activation_write_address,

    input wire signed [WORD_WIDTH-1:0]
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
    // Completion (all tasks done)
    //--------------------------------------------------

    output reg done

);

    localparam BLOCK = MAT_N*MAT_N;          // 16 elements per result block
    localparam WORDS = MAT_N*MAT_N/4;        // 4 words per task block

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
    // Ping-pong banks
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0]
    a_bank [0:1][0:BLOCK-1];

    reg signed [DATA_WIDTH-1:0]
    b_bank [0:1][0:BLOCK-1];

    //--------------------------------------------------
    // Systolic inputs (muxed from the active bank)
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0]
    a [0:BLOCK-1];

    wire signed [DATA_WIDTH-1:0]
    b [0:BLOCK-1];

    wire signed [ACC_WIDTH-1:0]
    c [0:BLOCK-1];

    wire compute_done;

    //--------------------------------------------------
    // Controller state
    //--------------------------------------------------

    reg [2:0] task_fetch;
    reg [2:0] task_comp;
    reg       fetch_done_flag;

    reg [3:0] store_cnt;
    reg       storing;

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
    // 4-wide fetch (4 words x 3 cycles = 12 cycles)
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
    // Systolic compute array (reads the active bank)
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
    // Output buffer (64 result entries, one block per task)
    //--------------------------------------------------

    reg [OUT_ADDR_WIDTH-1:0] store_waddr;

    always @(*) begin
        store_waddr = task_comp*BLOCK + store_cnt;
    end

    output_buffer #(
        .DATA_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(OUT_ADDR_WIDTH)
    ) result_mem (
        .clk(clk),
        .reset(reset),
        .write_enable(storing),
        .write_address(store_waddr),
        .write_data(c[store_cnt]),
        .read_enable(result_read_enable),
        .read_address(result_read_address),
        .read_data(result_read_data)
    );

    //--------------------------------------------------
    // Bank mux : systolic reads bank[task_comp % 2]
    //--------------------------------------------------

    genvar gi;
    generate
        for (gi = 0; gi < BLOCK; gi = gi + 1) begin : BANK_MUX
            assign a[gi] = task_comp[0] ? a_bank[1][gi] : a_bank[0][gi];
            assign b[gi] = task_comp[0] ? b_bank[1][gi] : b_bank[0][gi];
        end
    endgenerate

    //--------------------------------------------------
    // Pipelined controller (same structure as Day20)
    //--------------------------------------------------

    localparam S_IDLE        = 4'd0;
    localparam S_FETCH_START = 4'd1;
    localparam S_FETCH_WAIT  = 4'd2;
    localparam S_COPY        = 4'd3;
    localparam S_COMP_START  = 4'd4;
    localparam S_WAIT_C      = 4'd5;
    localparam S_STORE_START = 4'd6;
    localparam S_STORE       = 4'd7;
    localparam S_STORE_END   = 4'd8;
    localparam S_WAIT_NEXT_F = 4'd9;
    localparam S_COPY2       = 4'd10;
    localparam S_DONE        = 4'd11;

    wire copying   = (state == S_COPY) || (state == S_COPY2);
    wire copy_bank = task_fetch[0];

    integer bk;

    //--------------------------------------------------
    // Bank copy: move the finished fetch into its bank
    //--------------------------------------------------

    always @(posedge clk) begin

        if (copying) begin

            for (bk = 0; bk < BLOCK; bk = bk + 1) begin
                a_bank[copy_bank][bk] <= fetch_a[bk];
                b_bank[copy_bank][bk] <= fetch_b[bk];
            end

        end

    end

    //--------------------------------------------------
    // storing flag (combinational)
    //--------------------------------------------------

    always @(*) begin
        storing = (state == S_STORE);
    end

    //--------------------------------------------------
    // Main FSM
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            state           <= S_IDLE;
            task_fetch      <= {3{1'b0}};
            task_comp       <= {3{1'b0}};
            fetch_done_flag <= 1'b0;
            store_cnt       <= 4'd0;
            start_fetch     <= 1'b0;
            start_compute   <= 1'b0;
            fetch_base      <= {ADDR_WIDTH{1'b0}};
            done            <= 1'b0;

        end
        else begin

            done <= 1'b0;

            //------------------------------------------------
            // Latch fetch completion for later use
            //------------------------------------------------

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
                    fetch_base  <= task_fetch*WORDS;   // 4 words per task
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
                        state <= S_STORE_START;
                end

                S_STORE_START: begin
                    store_cnt <= 4'd0;
                    state     <= S_STORE;
                end

                S_STORE: begin
                    if (store_cnt == BLOCK-1)
                        state <= S_STORE_END;
                    else
                        store_cnt <= store_cnt + 1'b1;
                end

                S_STORE_END: begin
                    if (task_comp + 1 >= NUM_TASKS)
                        state <= S_DONE;
                    else begin
                        task_comp <= task_comp + 1'b1;
                        state     <= S_WAIT_NEXT_F;
                    end
                end

                S_WAIT_NEXT_F: begin
                    if (fetch_done_flag)
                        state <= S_COPY2;
                end

                S_COPY2: begin
                    state <= S_COMP_START;
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


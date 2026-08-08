`timescale 1ns/1ps

//==========================================================
// Day 18 : Systolic 2x2 Matrix Multiply
//==========================================================
//
// Four pe_unit (reused from Day14) arranged as a 2x2
// systolic array.
//
// Dataflow:
//   activations flow  left  -> right  (one row of A per row)
//   weights     flow  top   -> down   (one column of B per col)
//   each PE accumulates  activation_in * weight_in  in place
//
// Skew schedule (the key insight of Day18):
//   A[i][k] enters row i at cycle  k + i
//   B[k][j] enters col j at cycle  k + j
//
//   Because activation needs j hops to reach PE(i,j) and
//   weight needs i hops, both arrive with index
//   k = t - 1 - i - j  -> they match, so PE(i,j) computes
//   C[i][j] = sum_k A[i][k] * B[k][j].
//
// Latency: 5 cycles
//   S_CLR clear + S_FEED0/1/2 (pipeline fill + compute)
//   + S_DRAIN (last PE finishes)
//==========================================================

module systolic_matmul_2x2 #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(

    input wire clk,
    input wire reset,
    input wire start,

    //--------------------------------------------------
    // A matrix (row-major), 2x2
    //--------------------------------------------------

    input  wire signed [DATA_WIDTH-1:0] a00, a01,
    input  wire signed [DATA_WIDTH-1:0] a10, a11,

    //--------------------------------------------------
    // B matrix (row-major), 2x2
    //--------------------------------------------------

    input  wire signed [DATA_WIDTH-1:0] b00, b01,
    input  wire signed [DATA_WIDTH-1:0] b10, b11,

    //--------------------------------------------------
    // C matrix = A x B, 2x2 (combinational from accumulators)
    //--------------------------------------------------

    output wire signed [ACC_WIDTH-1:0] c00, c01,
    output wire signed [ACC_WIDTH-1:0] c10, c11,

    output reg done

);

    //--------------------------------------------------
    // Controller state encoding
    //--------------------------------------------------

    localparam S_IDLE  = 3'd0;  // wait for start
    localparam S_CLR   = 3'd1;  // clear all PE accumulators
    localparam S_FEED0 = 3'd2;  // feed k=0 terms  (skew)
    localparam S_FEED1 = 3'd3;  // feed k=1 terms
    localparam S_FEED2 = 3'd4;  // feed the last skewed elements
    localparam S_DRAIN = 3'd5;  // drain the array, assert done

    reg [2:0] state;

    //--------------------------------------------------
    // Boundary feed signals (combinational, per state)
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0] act_b0;   // row 0 left boundary
    reg signed [DATA_WIDTH-1:0] act_b1;   // row 1 left boundary
    reg signed [DATA_WIDTH-1:0] w_b0;     // col 0 top boundary
    reg signed [DATA_WIDTH-1:0] w_b1;     // col 1 top boundary

    //--------------------------------------------------
    // PE-to-PE forwarding wires
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0] a_00_to_01;  // PE00 -> PE01 activation
    wire signed [DATA_WIDTH-1:0] a_10_to_11;  // PE10 -> PE11 activation
    wire signed [DATA_WIDTH-1:0] w_00_to_10;  // PE00 -> PE10 weight
    wire signed [DATA_WIDTH-1:0] w_01_to_11;  // PE01 -> PE11 weight

    // unused array exit wires (kept for completeness)
    wire signed [DATA_WIDTH-1:0] a_exit0, a_exit1;
    wire signed [DATA_WIDTH-1:0] w_exit0, w_exit1;

    //--------------------------------------------------
    // Control signals for the PEs
    //--------------------------------------------------

    wire compute_en = (state != S_IDLE) && (state != S_CLR);
    wire clear_acc  = (state == S_CLR);

    //--------------------------------------------------
    // Skew-scheduled boundary values
    //
    // S_FEED0: A[0][0], B[0][0]              (k=0, no skew)
    // S_FEED1: A[0][1], A[1][0], B[1][0], B[0][1]
    // S_FEED2: A[1][1], B[1][1]              (last skewed elements)
    //--------------------------------------------------

    always @(*) begin

        act_b0 = {DATA_WIDTH{1'b0}};
        act_b1 = {DATA_WIDTH{1'b0}};
        w_b0   = {DATA_WIDTH{1'b0}};
        w_b1   = {DATA_WIDTH{1'b0}};

        case (state)

            S_FEED0: begin
                act_b0 = a00;
                w_b0   = b00;
            end

            S_FEED1: begin
                act_b0 = a01;
                act_b1 = a10;
                w_b0   = b10;
                w_b1   = b01;
            end

            S_FEED2: begin
                act_b1 = a11;
                w_b1   = b11;
            end

            default: ;
        endcase

    end

    //--------------------------------------------------
    // 2x2 PE array (reusing the Day14 pe_unit IP)
    //--------------------------------------------------

    pe_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) pe_00 (
        .clk(clk),
        .reset(reset),
        .compute_enable(compute_en),
        .clear_acc(clear_acc),
        .activation_in(act_b0),
        .weight_in(w_b0),
        .activation_out(a_00_to_01),
        .weight_out(w_00_to_10),
        .psum_out(c00)
    );

    pe_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) pe_01 (
        .clk(clk),
        .reset(reset),
        .compute_enable(compute_en),
        .clear_acc(clear_acc),
        .activation_in(a_00_to_01),
        .weight_in(w_b1),
        .activation_out(a_exit0),
        .weight_out(w_01_to_11),
        .psum_out(c01)
    );

    pe_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) pe_10 (
        .clk(clk),
        .reset(reset),
        .compute_enable(compute_en),
        .clear_acc(clear_acc),
        .activation_in(act_b1),
        .weight_in(w_00_to_10),
        .activation_out(a_10_to_11),
        .weight_out(w_exit0),
        .psum_out(c10)
    );

    pe_unit #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) pe_11 (
        .clk(clk),
        .reset(reset),
        .compute_enable(compute_en),
        .clear_acc(clear_acc),
        .activation_in(a_10_to_11),
        .weight_in(w_01_to_11),
        .activation_out(a_exit1),
        .weight_out(w_exit1),
        .psum_out(c11)
    );

    //--------------------------------------------------
    // Controller
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            state <= S_IDLE;
            done  <= 1'b0;

        end
        else begin

            done <= 1'b0;

            case (state)

                S_IDLE: begin
                    if (start)
                        state <= S_CLR;
                end

                S_CLR: begin
                    state <= S_FEED0;
                end

                S_FEED0: begin
                    state <= S_FEED1;
                end

                S_FEED1: begin
                    state <= S_FEED2;
                end

                S_FEED2: begin
                    state <= S_DRAIN;
                end

                S_DRAIN: begin
                    done <= 1'b1;
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end

            endcase

        end

    end

endmodule

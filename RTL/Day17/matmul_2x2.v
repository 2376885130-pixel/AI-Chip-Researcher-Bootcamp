`timescale 1ns/1ps

//==========================================================
// Day 17 : Parallel 2x2 Matrix Multiply
//==========================================================
//
// Four MAC units compute all four output elements of
// C = A x B simultaneously (spatial parallelism).
//
//   C[i][j] = A[i][0]*B[0][j] + A[i][1]*B[1][j]
//
// Pipeline:
//   MAC1 : each accumulator adds the k=0 product
//   MAC2 : each accumulator adds the k=1 product -> result
//
// Latency from start sampling to done:
//   2 clock cycles (MAC1 + MAC2), plus 1 cycle to clear.
//
// Compared with Day16 serial NPU (~88 cycles for the whole
// 2x2 matrix), this parallel design finishes in ~3 cycles.
// The cost is 4x more hardware (4 multipliers + 4 adders).
//==========================================================

module matmul_2x2 #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(

    input  wire clk,
    input  wire reset,
    input  wire start,

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
    // C matrix = A x B, 2x2
    //--------------------------------------------------

    output reg  signed [ACC_WIDTH-1:0] c00, c01,
    output reg  signed [ACC_WIDTH-1:0] c10, c11,

    output reg  done

);

    //--------------------------------------------------
    // FSM state encoding
    //--------------------------------------------------

    localparam S_IDLE = 2'd0;  // wait for start
    localparam S_MAC1 = 2'd1;  // first  product (k=0)
    localparam S_MAC2 = 2'd2;  // second product (k=1) -> result

    reg [1:0] state;

    //--------------------------------------------------
    // 8-bit x 8-bit signed products (16-bit wide)
    //
    // p0_* : k=0 term  = A[i][0] * B[0][j]
    // p1_* : k=1 term  = A[i][1] * B[1][j]
    //--------------------------------------------------

    wire signed [(2*DATA_WIDTH)-1:0] p0_c00 = a00 * b00;
    wire signed [(2*DATA_WIDTH)-1:0] p0_c01 = a00 * b01;
    wire signed [(2*DATA_WIDTH)-1:0] p0_c10 = a10 * b00;
    wire signed [(2*DATA_WIDTH)-1:0] p0_c11 = a10 * b01;

    wire signed [(2*DATA_WIDTH)-1:0] p1_c00 = a01 * b10;
    wire signed [(2*DATA_WIDTH)-1:0] p1_c01 = a01 * b11;
    wire signed [(2*DATA_WIDTH)-1:0] p1_c10 = a11 * b10;
    wire signed [(2*DATA_WIDTH)-1:0] p1_c11 = a11 * b11;

    //--------------------------------------------------
    // Four independent accumulators (one per output)
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0] acc00, acc01, acc10, acc11;

    //--------------------------------------------------
    // Sequential control + datapath
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            state <= S_IDLE;

            acc00 <= {ACC_WIDTH{1'b0}};
            acc01 <= {ACC_WIDTH{1'b0}};
            acc10 <= {ACC_WIDTH{1'b0}};
            acc11 <= {ACC_WIDTH{1'b0}};

            c00   <= {ACC_WIDTH{1'b0}};
            c01   <= {ACC_WIDTH{1'b0}};
            c10   <= {ACC_WIDTH{1'b0}};
            c11   <= {ACC_WIDTH{1'b0}};

            done  <= 1'b0;

        end
        else begin

            // one-clock completion pulse
            done <= 1'b0;

            case (state)

                //----------------------------------------
                // Wait for start, then clear all 4 MACs
                //----------------------------------------

                S_IDLE: begin

                    if (start) begin

                        acc00 <= {ACC_WIDTH{1'b0}};
                        acc01 <= {ACC_WIDTH{1'b0}};
                        acc10 <= {ACC_WIDTH{1'b0}};
                        acc11 <= {ACC_WIDTH{1'b0}};

                        state <= S_MAC1;

                    end

                end

                //----------------------------------------
                // MAC1 : add the k=0 products
                //----------------------------------------

                S_MAC1: begin

                    acc00 <= acc00 + p0_c00;
                    acc01 <= acc01 + p0_c01;
                    acc10 <= acc10 + p0_c10;
                    acc11 <= acc11 + p0_c11;

                    state <= S_MAC2;

                end

                //----------------------------------------
                // MAC2 : add the k=1 products, capture result
                //
                // Non-blocking: acc on the right side is the
                // MAC1 value, so acc + p1 = final dot product.
                //----------------------------------------

                S_MAC2: begin

                    acc00 <= acc00 + p1_c00;
                    c00   <= acc00 + p1_c00;

                    acc01 <= acc01 + p1_c01;
                    c01   <= acc01 + p1_c01;

                    acc10 <= acc10 + p1_c10;
                    c10   <= acc10 + p1_c10;

                    acc11 <= acc11 + p1_c11;
                    c11   <= acc11 + p1_c11;

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

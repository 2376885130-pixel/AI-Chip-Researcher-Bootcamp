`timescale 1ns/1ps

//==========================================================
// Day 19 : Parameterized NxN Systolic Matrix Multiply
//==========================================================
//
// Generalization of Day18 (2x2) to any N using generate loops.
//
// C = A x B, all NxN matrices, row-major inputs.
//
// Dataflow (same as Day18):
//   A rows flow left -> right, B columns flow top -> down
//   each PE accumulates activation * weight in place
//
// Skew schedule:
//   A[i][k] presented at cnt = 1 + i + k
//   B[k][j] presented at cnt = 1 + j + k
//   -> A[i][k] and B[k][j] reach PE(i,j) in the same cycle
//
// Latency: 3N-1 run cycles (1 clear + 2N-1 feed + N-1 drain)
//   e.g. N=2 -> 5 cycles, N=4 -> 11 cycles
//==========================================================

module systolic_matmul #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter N          = 4

)(

    input  wire clk,
    input  wire reset,
    input  wire start,

    // A matrix, row-major: a[i*N + k]
    input  wire signed [DATA_WIDTH-1:0] a [0:N*N-1],

    // B matrix, row-major: b[k*N + j]
    input  wire signed [DATA_WIDTH-1:0] b [0:N*N-1],

    // C matrix = A x B, row-major: c[i*N + j]
    output wire signed [ACC_WIDTH-1:0]  c [0:N*N-1],

    output reg done

);

    //--------------------------------------------------
    // Run-state counter
    // cnt = 0        : clear accumulators
    // cnt = 1..2N-1  : feed skewed boundary values
    // cnt = 2N..3N-2 : drain, done at cnt = 3N-2
    //--------------------------------------------------

    localparam NST = 3*N - 1;   // number of run states

    reg [$clog2(NST)-1:0] cnt;

    wire compute_en = (cnt != 0);
    wire clear_acc  = (cnt == 0) && (start);
    // Results must persist after done (cnt==0, idle) so the
    // NPU can read them. Accumulators are cleared only when a
    // NEW task asserts start.

    //--------------------------------------------------
    // Boundary feed registers (one per row / column)
    //--------------------------------------------------

    reg signed [DATA_WIDTH-1:0] act_b [0:N-1];   // left boundary per row
    reg signed [DATA_WIDTH-1:0] w_b   [0:N-1];   // top boundary per column

    //--------------------------------------------------
    // Propagation network
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0] act_w [0:N-1][0:N];  // N rows, N+1 cols
    wire signed [DATA_WIDTH-1:0] w_w   [0:N][0:N-1];  // N+1 rows, N cols

    //--------------------------------------------------
    // Boundary values from skew schedule
    //
    // A[i][k] at cnt = 1+i+k  ->  k = cnt-1-i
    // B[k][j] at cnt = 1+j+k  ->  k = cnt-1-j
    //--------------------------------------------------

    integer p;
    integer kk;

    always @(*) begin

        for (p = 0; p < N; p = p + 1) begin
            act_b[p] = {DATA_WIDTH{1'b0}};
            w_b[p]   = {DATA_WIDTH{1'b0}};
        end

        for (p = 0; p < N; p = p + 1) begin

            kk = cnt - 1 - p;

            if (kk >= 0 && kk < N) begin
                act_b[p] = a[p*N + kk];
                w_b[p]   = b[kk*N + p];
            end

        end

    end

    //--------------------------------------------------
    // Boundary connections into the array
    //--------------------------------------------------

    genvar gi;
    generate
        for (gi = 0; gi < N; gi = gi + 1) begin : ACT_BOUNDARY
            assign act_w[gi][0] = act_b[gi];
        end
        for (gi = 0; gi < N; gi = gi + 1) begin : W_BOUNDARY
            assign w_w[0][gi] = w_b[gi];
        end
    endgenerate

    //--------------------------------------------------
    // N x N PE array (reusing Day14 pe_unit)
    //--------------------------------------------------

    genvar gr;
    genvar gc;

    generate

        for (gr = 0; gr < N; gr = gr + 1) begin : ROW_GEN

            for (gc = 0; gc < N; gc = gc + 1) begin : COL_GEN

                pe_unit #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) pe_inst (
                    .clk(clk),
                    .reset(reset),
                    .compute_enable(compute_en),
                    .clear_acc(clear_acc),
                    .activation_in(act_w[gr][gc]),
                    .weight_in(w_w[gr][gc]),
                    .activation_out(act_w[gr][gc+1]),
                    .weight_out(w_w[gr+1][gc]),
                    .psum_out(c[gr*N + gc])
                );

            end

        end

    endgenerate
    //--------------------------------------------------
    // Run-state counter controller
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            cnt  <= {($clog2(NST)){1'b0}};
            done <= 1'b0;

        end
        else begin

            done <= 1'b0;

            if (cnt == 0) begin

                // idle; start on request
                if (start)
                    cnt <= 1;

            end
            else begin

                if (cnt == NST-1) begin

                    // last drain cycle: final PE just finished
                    done <= 1'b1;
                    cnt  <= {($clog2(NST)){1'b0}};

                end
                else begin

                    cnt <= cnt + 1'b1;

                end

            end

        end

    end

endmodule


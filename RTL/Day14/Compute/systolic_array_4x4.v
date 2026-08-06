module systolic_array_4x4 #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(

    input wire clk,
    input wire reset,

    input wire start_compute,

    output reg compute_done,

    input wire signed [DATA_WIDTH-1:0]
    activation_in [0:3],

    input wire signed [DATA_WIDTH-1:0]
    weight_in [0:3],

    output wire signed [ACC_WIDTH-1:0]
    result [0:3][0:3]

);

    //--------------------------------------------------
    // Propagation network
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0]
    activation_wire [0:3][0:4];

    wire signed [DATA_WIDTH-1:0]
    weight_wire [0:4][0:3];

    //--------------------------------------------------
    // Internal compute control
    //--------------------------------------------------

    reg busy;
    reg clear_acc;

    reg [2:0] compute_counter;

    //--------------------------------------------------
    // Boundary connections
    //--------------------------------------------------

    genvar i;

    generate

        for (i = 0; i < 4; i = i + 1) begin:
            ACTIVATION_BOUNDARY

            assign activation_wire[i][0] =
                activation_in[i];

        end

    endgenerate

    genvar j;

    generate

        for (j = 0; j < 4; j = j + 1) begin:
            WEIGHT_BOUNDARY

            assign weight_wire[0][j] =
                weight_in[j];

        end

    endgenerate

    //--------------------------------------------------
    // PE array
    //--------------------------------------------------

    genvar row;
    genvar col;

    generate

        for (row = 0; row < 4; row = row + 1) begin:
            ROW

            for (col = 0; col < 4; col = col + 1) begin:
                COL

                pe_unit #(

                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)

                ) pe_inst (

                    .clk(clk),
                    .reset(reset),

                    .compute_enable(busy),
                    .clear_acc(clear_acc),

                    .activation_in(
                        activation_wire[row][col]
                    ),

                    .weight_in(
                        weight_wire[row][col]
                    ),

                    .activation_out(
                        activation_wire[row][col+1]
                    ),

                    .weight_out(
                        weight_wire[row+1][col]
                    ),

                    .psum_out(
                        result[row][col]
                    )

                );

            end

        end

    endgenerate

    //--------------------------------------------------
    // Compute handshake controller
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            busy            <= 1'b0;
            clear_acc       <= 1'b0;
            compute_counter <= 3'd0;
            compute_done    <= 1'b0;

        end
        else begin

            compute_done <= 1'b0;
            clear_acc    <= 1'b0;

            if (start_compute && !busy) begin

                /*
                 * Clear accumulators first.
                 * busy becomes active after this edge, so MAC
                 * operations begin on the following clock.
                 */
                clear_acc       <= 1'b1;
                busy            <= 1'b1;
                compute_counter <= 3'd0;

            end
            else if (busy) begin

                if (compute_counter == 3) begin

                    busy            <= 1'b0;
                    compute_done    <= 1'b1;
                    compute_counter <= 3'd0;

                end
                else begin

                    compute_counter <=
                        compute_counter + 1'b1;

                end

            end

        end

    end

endmodule

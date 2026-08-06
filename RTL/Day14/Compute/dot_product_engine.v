module dot_product_engine #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32,
    parameter VECTOR_LEN = 4

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // Controller handshake
    //--------------------------------------------------

    input wire start_compute,

    output reg compute_done,

    //--------------------------------------------------
    // Input vectors
    //--------------------------------------------------

    input wire signed [DATA_WIDTH-1:0]
    activation_vector [0:VECTOR_LEN-1],

    input wire signed [DATA_WIDTH-1:0]
    weight_vector [0:VECTOR_LEN-1],

    //--------------------------------------------------
    // Dot-product result
    //--------------------------------------------------

    output reg signed [ACC_WIDTH-1:0]
    result

);

    //--------------------------------------------------
    // Internal control
    //--------------------------------------------------

    reg busy;

    reg [$clog2(VECTOR_LEN)-1:0]
    element_index;

    //--------------------------------------------------
    // Accumulator
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0]
    accumulator;

    //--------------------------------------------------
    // Current multiplication
    //--------------------------------------------------

    wire signed [(2*DATA_WIDTH)-1:0]
    current_product;

    assign current_product =
        activation_vector[element_index]
        *
        weight_vector[element_index];

    //--------------------------------------------------
    // Compute process
    //
    // start_compute:
    //     clear accumulator and begin a new task
    //
    // busy cycle 0:
    //     activation[0] * weight[0]
    //
    // busy cycle 1:
    //     activation[1] * weight[1]
    //
    // busy cycle 2:
    //     activation[2] * weight[2]
    //
    // busy cycle 3:
    //     activation[3] * weight[3]
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            busy          <= 1'b0;
            element_index <= 0;

            accumulator <=
                {ACC_WIDTH{1'b0}};

            result <=
                {ACC_WIDTH{1'b0}};

            compute_done <= 1'b0;

        end
        else begin

            // One-clock completion pulse
            compute_done <= 1'b0;

            //--------------------------------------------------
            // Start a new dot-product operation
            //--------------------------------------------------

            if (start_compute && !busy) begin

                busy          <= 1'b1;
                element_index <= 0;

                accumulator <=
                    {ACC_WIDTH{1'b0}};

                result <=
                    {ACC_WIDTH{1'b0}};

            end

            //--------------------------------------------------
            // Process one vector element per clock
            //--------------------------------------------------

            else if (busy) begin

                if (element_index == VECTOR_LEN-1) begin

                    /*
                     * Non-blocking assignments use the old
                     * accumulator value on the right-hand side.
                     *
                     * Therefore the final product must be added
                     * explicitly when result is generated.
                     */
                    accumulator <=
                        accumulator + current_product;

                    result <=
                        accumulator + current_product;

                    busy <= 1'b0;

                    element_index <= 0;

                    compute_done <= 1'b1;

                end
                else begin

                    accumulator <=
                        accumulator + current_product;

                    element_index <=
                        element_index + 1'b1;

                end

            end

        end

    end

endmodule

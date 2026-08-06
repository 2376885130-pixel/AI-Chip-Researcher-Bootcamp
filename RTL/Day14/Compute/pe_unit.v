module pe_unit #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(

    input wire clk,
    input wire reset,

    input wire compute_enable,
    input wire clear_acc,

    input wire signed [DATA_WIDTH-1:0]
    activation_in,

    input wire signed [DATA_WIDTH-1:0]
    weight_in,

    output reg signed [DATA_WIDTH-1:0]
    activation_out,

    output reg signed [DATA_WIDTH-1:0]
    weight_out,

    output wire signed [ACC_WIDTH-1:0]
    psum_out

);

    //--------------------------------------------------
    // Internal accumulator
    //--------------------------------------------------

    reg signed [ACC_WIDTH-1:0]
    accumulator;

    wire signed [(2*DATA_WIDTH)-1:0]
    product;

    assign product = activation_in * weight_in;

    /*
     * Directly expose the accumulator.
     *
     * The previous registered psum_out lagged one clock
     * behind accumulator and made result observation harder.
     */
    assign psum_out = accumulator;

    //--------------------------------------------------
    // PE sequential behavior
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            activation_out <= {DATA_WIDTH{1'b0}};
            weight_out     <= {DATA_WIDTH{1'b0}};
            accumulator    <= {ACC_WIDTH{1'b0}};

        end
        else begin

            if (clear_acc)
                accumulator <= {ACC_WIDTH{1'b0}};

            else if (compute_enable)
                accumulator <= accumulator + product;

            if (compute_enable) begin
                activation_out <= activation_in;
                weight_out     <= weight_in;
            end

        end

    end

endmodule

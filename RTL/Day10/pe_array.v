module pe_array #(
    parameter NUM_PE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 32
)
(
    input clk,
    input reset,

    input signed [NUM_PE*DATA_WIDTH-1:0] activation,
    input signed [NUM_PE*DATA_WIDTH-1:0] weight,

    output signed [NUM_PE*ACC_WIDTH-1:0] result
);


wire signed [NUM_PE*ACC_WIDTH-1:0] result_internal;


assign result = result_internal;


genvar i;


generate

    for(i = 0; i < NUM_PE; i = i + 1)
    begin : PE_ARRAY_GEN


        processing_element pe_inst
        (
            .clk(clk),

            .reset(reset),

            .activation(
                activation[i*DATA_WIDTH +: DATA_WIDTH]
            ),

            .weight(
                weight[i*DATA_WIDTH +: DATA_WIDTH]
            ),

            .partial_sum(
                result_internal[i*ACC_WIDTH +: ACC_WIDTH]
            )

        );


    end

endgenerate


endmodule

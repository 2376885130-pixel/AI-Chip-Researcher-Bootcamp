module pe_unit #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)(
    input clk,
    input rst,
    input enable,

    // Load weight control
    input load_weight,
    input [DATA_WIDTH-1:0] weight_in,

    // Activation data flow
    input [DATA_WIDTH-1:0] activation_in,
    output reg [DATA_WIDTH-1:0] activation_out,

    // Partial sum flow
    input [ACC_WIDTH-1:0] partial_sum_in,
    output reg [ACC_WIDTH-1:0] partial_sum_out
);


    // Weight storage
    reg [DATA_WIDTH-1:0] weight_reg;


    // Multiplication result
    wire [2*DATA_WIDTH-1:0] mult_result;


    assign mult_result = activation_in * weight_reg;



    always @(posedge clk) begin

        if(rst) begin

            weight_reg      <= 0;
            partial_sum_out <= 0;
            activation_out  <= 0;

        end


        else begin


            // Load weight phase
            if(load_weight) begin

                weight_reg <= weight_in;

            end



            // Computation phase
            if(enable) begin

                partial_sum_out <= 
                    partial_sum_in + mult_result;


                activation_out <= activation_in;

            end

        end

    end


endmodule

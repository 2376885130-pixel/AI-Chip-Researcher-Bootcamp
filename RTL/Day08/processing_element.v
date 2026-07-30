module processing_element #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32
)
(
    input clk,
    input reset,

    input signed [DATA_WIDTH-1:0] activation,
    input signed [DATA_WIDTH-1:0] weight,

    output reg signed [ACC_WIDTH-1:0] partial_sum
);


wire signed [2*DATA_WIDTH-1:0] product;


assign product = activation * weight;


always @(posedge clk)
begin

    if(reset)

        partial_sum <= 0;

    else

        partial_sum <= partial_sum + product;

end


endmodule

module multiplier_param #(
    parameter DATA_WIDTH = 8
)(
    input wire [DATA_WIDTH-1:0] A,
    input wire [DATA_WIDTH-1:0] B,

    output wire [2*DATA_WIDTH-1:0] PRODUCT
);


    assign PRODUCT = A * B;


endmodule

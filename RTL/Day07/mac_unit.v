module mac_unit #(
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire reset,

    input wire [DATA_WIDTH-1:0] A,
    input wire [DATA_WIDTH-1:0] B,

    output reg [2*DATA_WIDTH-1:0] ACC
);


always @(posedge clk)
begin

    if(reset)

        ACC <= 0;

    else

        ACC <= ACC + (A * B);

end


endmodule

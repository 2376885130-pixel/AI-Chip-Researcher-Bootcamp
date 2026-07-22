module counter_param
#(
    parameter WIDTH = 8
)
(
    input clk,
    input reset,
    input enable,
    output reg [WIDTH-1:0] count
);


always @(posedge clk)
begin

    if(reset)
        count <= 0;

    else if(enable)
        count <= count + 1;
    else
        count <= count;
end


endmodule

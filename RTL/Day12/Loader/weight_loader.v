module weight_loader #(

parameter DATA_WIDTH=8

)(


input wire clk,

input wire reset,


input wire load,


output reg signed [DATA_WIDTH-1:0] weight_out [0:3]

);



always @(posedge clk)

begin


if(reset)

begin

weight_out[0]<=0;

weight_out[1]<=0;

weight_out[2]<=0;

weight_out[3]<=0;

end



else if(load)

begin


weight_out[0]<=5;

weight_out[1]<=7;

weight_out[2]<=0;

weight_out[3]<=0;


end



end



endmodule

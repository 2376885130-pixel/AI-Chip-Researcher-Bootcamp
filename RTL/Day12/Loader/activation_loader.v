module activation_loader #(

parameter DATA_WIDTH=8

)(


input wire clk,

input wire reset,


input wire load,


output reg signed [DATA_WIDTH-1:0] activation_out [0:3]

);



always @(posedge clk)

begin


    if(reset)

    begin

        activation_out[0] <= 0;

        activation_out[1] <= 0;

        activation_out[2] <= 0;

        activation_out[3] <= 0;


    end



    else if(load)

    begin


        activation_out[0] <= 1;

        activation_out[1] <= 3;

        activation_out[2] <= 0;

        activation_out[3] <= 0;


    end


end



endmodule

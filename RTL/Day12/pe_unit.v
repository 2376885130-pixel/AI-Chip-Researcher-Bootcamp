module pe_unit #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(

    input wire clk,

    input wire reset,


    // control

    input wire enable,

    input wire clear_acc,


    // data

    input wire signed [DATA_WIDTH-1:0] activation_in,

    input wire signed [DATA_WIDTH-1:0] weight_in,



    // forwarding

    output reg signed [DATA_WIDTH-1:0] activation_out,

    output reg signed [DATA_WIDTH-1:0] weight_out,



    // accumulated result

    output reg signed [ACC_WIDTH-1:0] psum_out


);



    wire signed [(2*DATA_WIDTH)-1:0] product;


    assign product = activation_in * weight_in;



    reg signed [ACC_WIDTH-1:0] accumulator;



    always @(posedge clk) begin


        if(reset) begin


            activation_out <= 0;

            weight_out <= 0;

            accumulator <= 0;

            psum_out <= 0;


        end



        else begin



            // data forwarding

            activation_out <= activation_in;

            weight_out <= weight_in;



            // clear tile accumulation

            if(clear_acc) begin


                accumulator <= 0;


            end



            // MAC

            else if(enable) begin


                accumulator <=
                accumulator + product;


            end



            // output

            psum_out <= accumulator;


        end


    end



endmodule

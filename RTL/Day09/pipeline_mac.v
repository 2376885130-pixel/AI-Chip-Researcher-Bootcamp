module pipeline_mac #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)
(

    input clk,
    input rst,


    input [DATA_WIDTH-1:0] activation,
    input [DATA_WIDTH-1:0] weight,

    input [ACC_WIDTH-1:0] partial_sum,


    output [ACC_WIDTH-1:0] result

);



    // Stage 1 registers

    reg [(2*DATA_WIDTH)-1:0] product_reg;

    reg [ACC_WIDTH-1:0] partial_sum_reg;



    // Stage 2 register

    reg [ACC_WIDTH-1:0] result_reg;



    always @(posedge clk)

    begin

        if(rst)

        begin

            product_reg <= 0;

            partial_sum_reg <= 0;

            result_reg <= 0;

        end


        else

        begin


            // Stage 1

            product_reg <= activation * weight;

            partial_sum_reg <= partial_sum;



            // Stage 2

            result_reg <= product_reg + partial_sum_reg;


        end


    end



    assign result = result_reg;



endmodule

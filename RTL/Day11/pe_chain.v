module pe_chain #(
    parameter NUM_PE = 4,
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 32
)(
    input clk,
    input rst,
    input enable,

    // weight loading control
    input load_weight,

    // activation input
    input [DATA_WIDTH-1:0] activation_in,

    // weight array
    input [NUM_PE*DATA_WIDTH-1:0] weight_in,

    // final output
    output [ACC_WIDTH-1:0] result
);


    /*
        activation connection between PE

        PE0 -> PE1 -> PE2 -> PE3
    */

    wire [DATA_WIDTH-1:0] activation_wire [0:NUM_PE];


    /*
        partial sum connection

        PS0 -> PS1 -> PS2 -> PS3
    */

    wire [ACC_WIDTH-1:0] partial_sum_wire [0:NUM_PE];


    assign activation_wire[0] = activation_in;


    // First PE starts from zero
    assign partial_sum_wire[0] = {ACC_WIDTH{1'b0}};



    genvar i;

    generate

        for(i=0;i<NUM_PE;i=i+1)
        begin : PE_ARRAY


            pe_unit #(
                .DATA_WIDTH(DATA_WIDTH),
                .ACC_WIDTH(ACC_WIDTH)
            )
            pe_inst
            (

                .clk(clk),
                .rst(rst),
                .enable(enable),


                // weight control
                .load_weight(load_weight),


                /*
                    extract each PE weight

                    PE0:
                    weight_in[7:0]

                    PE1:
                    weight_in[15:8]

                */

                .weight_in(
                    weight_in[
                        i*DATA_WIDTH +:
                        DATA_WIDTH
                    ]
                ),


                // activation flow

                .activation_in(
                    activation_wire[i]
                ),

                .activation_out(
                    activation_wire[i+1]
                ),


                // partial sum flow

                .partial_sum_in(
                    partial_sum_wire[i]
                ),

                .partial_sum_out(
                    partial_sum_wire[i+1]
                )

            );


        end

    endgenerate



    assign result = partial_sum_wire[NUM_PE];


endmodule

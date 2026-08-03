module systolic_array_4x4 #(

    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH  = 32

)(


    input wire clk,

    input wire reset,


    input wire enable,

    input wire clear_acc,


    input wire signed [DATA_WIDTH-1:0]
    activation_in [0:3],


    input wire signed [DATA_WIDTH-1:0]
    weight_in [0:3],



    output wire signed [ACC_WIDTH-1:0]
    result [0:3][0:3]

);




    // Activation horizontal path

    wire signed [DATA_WIDTH-1:0]
    activation_wire [0:3][0:4];



    // Weight vertical path

    wire signed [DATA_WIDTH-1:0]
    weight_wire [0:4][0:3];






    // -----------------------------
    // Input connection
    // -----------------------------


    genvar i;


    generate

        for(i=0;i<4;i=i+1)

        begin: INPUT


            assign activation_wire[i][0]
            =
            activation_in[i];


        end

    endgenerate





    genvar c;


    generate

        for(c=0;c<4;c=c+1)

        begin: WEIGHT_INPUT


            assign weight_wire[0][c]
            =
            weight_in[c];


        end

    endgenerate






    // -----------------------------
    // PE Array
    // -----------------------------


    genvar row;
    genvar col;



    generate


        for(row=0;row<4;row=row+1)

        begin: ROW


            for(col=0;col<4;col=col+1)

            begin: COL



                pe_unit #(

                    .DATA_WIDTH(DATA_WIDTH),

                    .ACC_WIDTH(ACC_WIDTH)

                )

                pe_inst

                (

                    .clk(clk),

                    .reset(reset),


                    .enable(enable),

                    .clear_acc(clear_acc),



                    .activation_in(
                        activation_wire[row][col]
                    ),



                    .weight_in(
                        weight_wire[row][col]
                    ),




                    .activation_out(
                        activation_wire[row][col+1]
                    ),



                    .weight_out(
                        weight_wire[row+1][col]
                    ),



                    .psum_out(
                        result[row][col]
                    )


                );


            end


        end


    endgenerate




endmodule

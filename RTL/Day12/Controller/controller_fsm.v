module controller_fsm(

    input wire clk,

    input wire reset,


    input wire start,


    output reg load_weight,

    output reg compute,

    output reg output_valid,

    output reg clear_acc


);



parameter IDLE = 3'd0;

parameter LOAD_WEIGHT = 3'd1;

parameter COMPUTE = 3'd2;

parameter OUTPUT = 3'd3;

parameter CLEAR = 3'd4;



reg [2:0] state;


always @(posedge clk)

begin


    if(reset)

        state <= IDLE;



    else begin


        case(state)


        IDLE:

        begin

            if(start)

                state <= LOAD_WEIGHT;

        end



        LOAD_WEIGHT:

            state <= COMPUTE;



        COMPUTE:

            state <= OUTPUT;



        OUTPUT:

            state <= CLEAR;



        CLEAR:

            state <= IDLE;



        default:

            state <= IDLE;


        endcase



    end


end






always @(*)

begin


    load_weight = 0;

    compute = 0;

    output_valid = 0;

    clear_acc = 0;



    case(state)


    LOAD_WEIGHT:

        load_weight = 1;



    COMPUTE:

        compute = 1;



    OUTPUT:

        output_valid = 1;



    CLEAR:

        clear_acc = 1;



    endcase


end



endmodule

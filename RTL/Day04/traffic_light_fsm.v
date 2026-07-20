module traffic_light_fsm(

    input  wire clk,
    input  wire rst_n,

    output reg red,
    output reg yellow,
    output reg green

);


    //--------------------------------
    // State Encoding
    //--------------------------------

    localparam RED    = 2'b00;
    localparam GREEN  = 2'b01;
    localparam YELLOW = 2'b10;


    //--------------------------------
    // State Register
    //--------------------------------

    reg [1:0] current_state;
    reg [1:0] next_state;


    //--------------------------------
    // State Update
    //--------------------------------

    always @(posedge clk) begin

        if(!rst_n)

            current_state <= RED;

        else

            current_state <= next_state;

    end



    //--------------------------------
    // Next State Logic
    //--------------------------------

    always @(*) begin

        case(current_state)

            RED:
                next_state = GREEN;


            GREEN:
                next_state = YELLOW;


            YELLOW:
                next_state = RED;


            default:
                next_state = RED;


        endcase

    end



    //--------------------------------
    // Output Logic
    //--------------------------------

    always @(*) begin


        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;


        case(current_state)


            RED:
                red = 1'b1;


            GREEN:
                green = 1'b1;


            YELLOW:
                yellow = 1'b1;


            default:
            begin

                red    = 1'b0;
                yellow = 1'b0;
                green  = 1'b0;

            end


        endcase


    end


endmodule

module data_fetch_controller #(

    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // Main-controller interface
    //--------------------------------------------------

    input wire start_fetch,

    output reg data_ready,

    //--------------------------------------------------
    // Weight-buffer interface
    //--------------------------------------------------

    output reg weight_read_enable,

    output reg [ADDR_WIDTH-1:0]
    weight_address,

    input wire signed [DATA_WIDTH-1:0]
    weight_data_in,

    //--------------------------------------------------
    // Activation-buffer interface
    //--------------------------------------------------

    output reg activation_read_enable,

    output reg [ADDR_WIDTH-1:0]
    activation_address,

    input wire signed [DATA_WIDTH-1:0]
    activation_data_in,

    //--------------------------------------------------
    // Outputs to compute engine
    //--------------------------------------------------

    output reg signed [DATA_WIDTH-1:0]
    weight_out [0:3],

    output reg signed [DATA_WIDTH-1:0]
    activation_out [0:3]

);

    //--------------------------------------------------
    // Fetch-state encoding
    //--------------------------------------------------

    localparam FETCH_IDLE      = 2'd0;
    localparam FETCH_ISSUE     = 2'd1;
    localparam FETCH_WAIT_READ = 2'd2;
    localparam FETCH_CAPTURE   = 2'd3;

    reg [1:0] fetch_state;

    /*
     * Important:
     * The index has the same width as the SRAM address.
     *
     * The previous 3-bit declaration followed by
     * fetch_index[3:0] generated an unknown MSB and
     * addresses such as x000, x001, x010 and x011.
     */
    reg [ADDR_WIDTH-1:0] fetch_index;

    integer i;

    //--------------------------------------------------
    // Fetch FSM
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            fetch_state <= FETCH_IDLE;
            fetch_index <= {ADDR_WIDTH{1'b0}};

            data_ready <= 1'b0;

            weight_read_enable     <= 1'b0;
            activation_read_enable <= 1'b0;

            weight_address     <= {ADDR_WIDTH{1'b0}};
            activation_address <= {ADDR_WIDTH{1'b0}};

            for (i = 0; i < 4; i = i + 1) begin
                weight_out[i]     <= {DATA_WIDTH{1'b0}};
                activation_out[i] <= {DATA_WIDTH{1'b0}};
            end

        end
        else begin

            // data_ready is a one-clock pulse
            data_ready <= 1'b0;

            case (fetch_state)

                //--------------------------------------------------
                // Wait for a fetch command
                //--------------------------------------------------

                FETCH_IDLE: begin

                    weight_read_enable     <= 1'b0;
                    activation_read_enable <= 1'b0;

                    if (start_fetch) begin

                        fetch_index <= {ADDR_WIDTH{1'b0}};
                        fetch_state <= FETCH_ISSUE;

                    end

                end

                //--------------------------------------------------
                // Present address and read-enable
                //--------------------------------------------------

                FETCH_ISSUE: begin

                    weight_address     <= fetch_index;
                    activation_address <= fetch_index;

                    weight_read_enable     <= 1'b1;
                    activation_read_enable <= 1'b1;

                    fetch_state <= FETCH_WAIT_READ;

                end

                //--------------------------------------------------
                // Synchronous SRAM performs its registered read
                //--------------------------------------------------

                FETCH_WAIT_READ: begin

                    weight_read_enable     <= 1'b0;
                    activation_read_enable <= 1'b0;

                    fetch_state <= FETCH_CAPTURE;

                end

                //--------------------------------------------------
                // Capture stable SRAM output
                //--------------------------------------------------

                FETCH_CAPTURE: begin

                    weight_out[fetch_index] <=
                        weight_data_in;

                    activation_out[fetch_index] <=
                        activation_data_in;

                    if (fetch_index == {{(ADDR_WIDTH-2){1'b0}}, 2'b11}) begin

                        data_ready <= 1'b1;

                        fetch_index <= {ADDR_WIDTH{1'b0}};
                        fetch_state <= FETCH_IDLE;

                    end
                    else begin

                        fetch_index <= fetch_index + 1'b1;
                        fetch_state <= FETCH_ISSUE;

                    end

                end

                default: begin

                    fetch_state <= FETCH_IDLE;
                    fetch_index <= {ADDR_WIDTH{1'b0}};

                    data_ready <= 1'b0;

                    weight_read_enable     <= 1'b0;
                    activation_read_enable <= 1'b0;

                end

            endcase

        end

    end

endmodule

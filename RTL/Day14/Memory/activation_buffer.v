module activation_buffer #(

    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // External write interface
    //--------------------------------------------------

    input wire write_enable,

    input wire [ADDR_WIDTH-1:0]
    write_address,

    input wire signed [DATA_WIDTH-1:0]
    write_data,

    //--------------------------------------------------
    // Compute-side read interface
    //--------------------------------------------------

    input wire read_enable,

    input wire [ADDR_WIDTH-1:0]
    read_address,

    output reg signed [DATA_WIDTH-1:0]
    data_out

);

    localparam DEPTH = (1 << ADDR_WIDTH);

    reg signed [DATA_WIDTH-1:0]
    memory [0:DEPTH-1];

    integer i;

    //--------------------------------------------------
    // Synchronous SRAM model
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            data_out <= {DATA_WIDTH{1'b0}};

            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= {DATA_WIDTH{1'b0}};

        end
        else begin

            if (write_enable)
                memory[write_address] <= write_data;

            if (read_enable)
                data_out <= memory[read_address];

        end

    end

endmodule

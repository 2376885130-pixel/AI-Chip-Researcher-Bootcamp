module output_buffer #(

    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 2

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // Compute-side write interface
    //--------------------------------------------------

    input wire write_enable,

    input wire [ADDR_WIDTH-1:0]
    write_address,

    input wire signed [DATA_WIDTH-1:0]
    write_data,

    //--------------------------------------------------
    // CPU-side read interface
    //--------------------------------------------------

    input wire read_enable,

    input wire [ADDR_WIDTH-1:0]
    read_address,

    output reg signed [DATA_WIDTH-1:0]
    read_data

);

    localparam DEPTH = (1 << ADDR_WIDTH);

    reg signed [DATA_WIDTH-1:0]
    memory [0:DEPTH-1];

    integer i;

    //--------------------------------------------------
    // Synchronous output buffer
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            read_data <= {DATA_WIDTH{1'b0}};

            for (i = 0; i < DEPTH; i = i + 1)
                memory[i] <= {DATA_WIDTH{1'b0}};

        end
        else begin

            //--------------------------------------------------
            // Store compute result
            //--------------------------------------------------

            if (write_enable)
                memory[write_address] <= write_data;

            //--------------------------------------------------
            // CPU reads stored result
            //--------------------------------------------------

            if (read_enable)
                read_data <= memory[read_address];

        end

    end

endmodule

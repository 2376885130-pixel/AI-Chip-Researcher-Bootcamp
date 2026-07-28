module register_bank
#(
    parameter DATA_WIDTH = 16,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)
(
    input clk,
    input reset,

    input write_enable,

    input [ADDR_WIDTH-1:0] write_addr,

    input [DATA_WIDTH-1:0] write_data,

    input [ADDR_WIDTH-1:0] read_addr,

    output [DATA_WIDTH-1:0] read_data
);


reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];



always @(posedge clk)
begin

    if (reset)
    begin

    end

    else if (write_enable)
    begin
        mem[write_addr] <= write_data;
    end

end



assign read_data = mem[read_addr];


endmodule

`timescale 1ns/1ps

//==========================================================
// Day 21 : fetch16w - 4-wide fetch
//==========================================================
//
// Reads the 16 elements of one matrix as 4 words of 32 bits
// (4 packed 8-bit elements per word), then unpacks them.
//
//   serial fetch (Day20) : 16 reads x 3 cycles = 48 cycles
//   wide fetch  (Day21)  :  4 reads x 3 cycles = 12 cycles
//
// Word layout (defined by the testbench packing):
//   word = {e[4w+3], e[4w+2], e[4w+1], e[4w+0]}
//   unpack: e[4w+0]=word[7:0], e[4w+1]=word[15:8],
//           e[4w+2]=word[23:16], e[4w+3]=word[31:24]
//==========================================================

module fetch16w #(

    parameter DATA_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter ADDR_WIDTH = 4,
    parameter NUM_WORDS  = 4

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // Main-controller interface
    //--------------------------------------------------

    input wire start_fetch,

    input wire [ADDR_WIDTH-1:0] base_addr,

    output reg data_ready,

    //--------------------------------------------------
    // Weight-buffer (wide) interface
    //--------------------------------------------------

    output reg weight_read_enable,

    output reg [ADDR_WIDTH-1:0]
    weight_address,

    input wire signed [WORD_WIDTH-1:0]
    weight_data_in,

    //--------------------------------------------------
    // Activation-buffer (wide) interface
    //--------------------------------------------------

    output reg activation_read_enable,

    output reg [ADDR_WIDTH-1:0]
    activation_address,

    input wire signed [WORD_WIDTH-1:0]
    activation_data_in,

    //--------------------------------------------------
    // Outputs: 16 unpacked elements per matrix
    //--------------------------------------------------

    output reg signed [DATA_WIDTH-1:0]
    weight_out [0:15],

    output reg signed [DATA_WIDTH-1:0]
    activation_out [0:15]

);

    localparam F_IDLE      = 2'd0;
    localparam F_ISSUE     = 2'd1;
    localparam F_WAIT_READ = 2'd2;
    localparam F_CAPTURE   = 2'd3;

    reg [1:0] fstate;

    reg [ADDR_WIDTH-1:0] wcnt;   // word counter 0..NUM_WORDS-1

    integer ii;

    always @(posedge clk) begin

        if (reset) begin

            fstate <= F_IDLE;
            wcnt   <= {ADDR_WIDTH{1'b0}};

            data_ready <= 1'b0;

            weight_read_enable     <= 1'b0;
            activation_read_enable <= 1'b0;

            weight_address     <= {ADDR_WIDTH{1'b0}};
            activation_address <= {ADDR_WIDTH{1'b0}};

            for (ii = 0; ii < 16; ii = ii + 1) begin
                weight_out[ii]     <= {DATA_WIDTH{1'b0}};
                activation_out[ii] <= {DATA_WIDTH{1'b0}};
            end

        end
        else begin

            data_ready <= 1'b0;

            case (fstate)

                F_IDLE: begin

                    weight_read_enable     <= 1'b0;
                    activation_read_enable <= 1'b0;

                    if (start_fetch) begin

                        wcnt    <= {ADDR_WIDTH{1'b0}};
                        fstate  <= F_ISSUE;

                    end

                end

                F_ISSUE: begin

                    weight_address     <= base_addr + wcnt;
                    activation_address <= base_addr + wcnt;

                    weight_read_enable     <= 1'b1;
                    activation_read_enable <= 1'b1;

                    fstate <= F_WAIT_READ;

                end

                F_WAIT_READ: begin

                    weight_read_enable     <= 1'b0;
                    activation_read_enable <= 1'b0;

                    fstate <= F_CAPTURE;

                end

                F_CAPTURE: begin

                    // Unpack 4 elements from each 32-bit word
                    weight_out[wcnt*4 + 0] <= weight_data_in[7:0];
                    weight_out[wcnt*4 + 1] <= weight_data_in[15:8];
                    weight_out[wcnt*4 + 2] <= weight_data_in[23:16];
                    weight_out[wcnt*4 + 3] <= weight_data_in[31:24];

                    activation_out[wcnt*4 + 0] <= activation_data_in[7:0];
                    activation_out[wcnt*4 + 1] <= activation_data_in[15:8];
                    activation_out[wcnt*4 + 2] <= activation_data_in[23:16];
                    activation_out[wcnt*4 + 3] <= activation_data_in[31:24];

                    if (wcnt == NUM_WORDS-1) begin

                        data_ready <= 1'b1;

                        wcnt   <= {ADDR_WIDTH{1'b0}};
                        fstate <= F_IDLE;

                    end
                    else begin

                        wcnt   <= wcnt + 1'b1;
                        fstate <= F_ISSUE;

                    end

                end

                default: begin

                    fstate <= F_IDLE;

                end

            endcase

        end

    end

endmodule

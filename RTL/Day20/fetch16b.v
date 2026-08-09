`timescale 1ns/1ps

//==========================================================
// Day 20 : fetch16b - serial fetch with base address
//==========================================================
//
// Same serial SRAM read as Day19 fetch16, but the fetch
// start address is selected by base_addr (one task per
// 16-entry block). Used for double buffering: each task
// occupies a 16-entry window of the buffer.
//==========================================================

module fetch16b #(

    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 6,    // wide enough for all tasks
    parameter NUM        = 16

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
    // Outputs to the double-buffer banks
    //--------------------------------------------------

    output reg signed [DATA_WIDTH-1:0]
    weight_out [0:NUM-1],

    output reg signed [DATA_WIDTH-1:0]
    activation_out [0:NUM-1]

);

    localparam F_IDLE      = 2'd0;
    localparam F_ISSUE     = 2'd1;
    localparam F_WAIT_READ = 2'd2;
    localparam F_CAPTURE   = 2'd3;

    reg [1:0] fstate;

    reg [ADDR_WIDTH-1:0] idx;

    integer ii;

    always @(posedge clk) begin

        if (reset) begin

            fstate <= F_IDLE;
            idx    <= {ADDR_WIDTH{1'b0}};

            data_ready <= 1'b0;

            weight_read_enable     <= 1'b0;
            activation_read_enable <= 1'b0;

            weight_address     <= {ADDR_WIDTH{1'b0}};
            activation_address <= {ADDR_WIDTH{1'b0}};

            for (ii = 0; ii < NUM; ii = ii + 1) begin
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

                        idx     <= {ADDR_WIDTH{1'b0}};
                        fstate  <= F_ISSUE;

                    end

                end

                F_ISSUE: begin

                    weight_address     <= base_addr + idx;
                    activation_address <= base_addr + idx;

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

                    weight_out[idx]     <= weight_data_in;
                    activation_out[idx] <= activation_data_in;

                    if (idx == NUM-1) begin

                        data_ready <= 1'b1;

                        idx    <= {ADDR_WIDTH{1'b0}};
                        fstate <= F_IDLE;

                    end
                    else begin

                        idx    <= idx + 1'b1;
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

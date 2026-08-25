`timescale 1ns/1ps

// Parameterized, protocol-neutral AI Accelerator MVP.
// Memory map: region=0 activation, region=1 weight; addr=task*E+element.
module ai_accelerator_system #(
    parameter DATA_WIDTH=8,
    parameter ACC_WIDTH=32,
    parameter MATRIX_SIZE=4,
    parameter PE_NUM=16,
    parameter NUM_TASKS=4,
    parameter ADDR_WIDTH=8,
    parameter TIMEOUT_CYCLES=4095
) (
    input wire clk, input wire reset,
    input wire start, output wire start_ready,
    output wire busy, output reg done, output reg error,
    input wire mem_valid, output wire mem_ready, input wire mem_write,
    input wire mem_region, input wire [ADDR_WIDTH-1:0] mem_addr,
    input wire signed [DATA_WIDTH-1:0] mem_wdata,
    output reg result_valid, input wire result_ready,
    output reg signed [ACC_WIDTH-1:0] result_data,
    output reg [ADDR_WIDTH-1:0] result_addr
);
    localparam ELEMENTS = MATRIX_SIZE*MATRIX_SIZE;
    localparam MEMORY_DEPTH = NUM_TASKS*ELEMENTS;
    localparam TASK_W = (NUM_TASKS <= 1) ? 1 : $clog2(NUM_TASKS);
    localparam COUNT_W = (ELEMENTS <= 1) ? 1 : $clog2(ELEMENTS);
    localparam TIME_W = (TIMEOUT_CYCLES <= 1) ? 1 : $clog2(TIMEOUT_CYCLES+1);

    reg signed [DATA_WIDTH-1:0] activation_mem [0:NUM_TASKS*ELEMENTS-1];
    reg signed [DATA_WIDTH-1:0] weight_mem [0:NUM_TASKS*ELEMENTS-1];
    reg signed [ACC_WIDTH-1:0] output_mem [0:NUM_TASKS*ELEMENTS-1];
    wire signed [DATA_WIDTH-1:0] a [0:ELEMENTS-1];
    wire signed [DATA_WIDTH-1:0] b [0:ELEMENTS-1];
    wire signed [ACC_WIDTH-1:0] c [0:ELEMENTS-1];
    reg compute_start;
    wire compute_done;
    reg [TASK_W-1:0] task_id;
    reg [COUNT_W-1:0] result_count;
    reg [TIME_W-1:0] timeout_count;
    reg [2:0] state;
    integer i;

    localparam S_IDLE=3'd0, S_COMPUTE=3'd1, S_STORE=3'd2,
               S_STREAM=3'd3, S_ERROR=3'd4;
    wire mem_addr_valid = (mem_addr < MEMORY_DEPTH);

    assign busy = (state != S_IDLE);
    assign start_ready = (state == S_IDLE) && !error;
    assign mem_ready = (state == S_IDLE) && !error;

    genvar g;
    generate for (g=0; g<ELEMENTS; g=g+1) begin : INPUT_MAP
        assign a[g] = activation_mem[task_id*ELEMENTS+g];
        assign b[g] = weight_mem[task_id*ELEMENTS+g];
    end endgenerate

    ai_systolic_engine #(.DATA_WIDTH(DATA_WIDTH),.ACC_WIDTH(ACC_WIDTH),.MATRIX_SIZE(MATRIX_SIZE)) compute (
        .clk(clk), .reset(reset), .start(compute_start), .activation(a), .weight(b), .result(c), .done(compute_done)
    );

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE; task_id <= 0; result_count <= 0; timeout_count <= 0;
            compute_start <= 0; done <= 0; error <= 0; result_valid <= 0;
            result_data <= 0; result_addr <= 0;
            for (i=0; i<NUM_TASKS*ELEMENTS; i=i+1) begin
                activation_mem[i] <= 0; weight_mem[i] <= 0; output_mem[i] <= 0;
            end
        end else begin
            done <= 0; compute_start <= 0;
            if (state == S_IDLE && mem_valid && mem_ready) begin
                if (!mem_write || !mem_addr_valid) begin
                    error <= 1'b1;
                    state <= S_ERROR;
                end else if (mem_region) weight_mem[mem_addr] <= mem_wdata;
                else activation_mem[mem_addr] <= mem_wdata;
            end
            case (state)
                S_IDLE: begin
                    result_valid <= 0;
                    if (start && start_ready) begin
                        task_id <= 0; timeout_count <= 0; state <= S_COMPUTE;
                        compute_start <= 1;
                    end
                end
                S_COMPUTE: begin
                    if (timeout_count == TIMEOUT_CYCLES-1) begin error <= 1; state <= S_ERROR; end
                    else timeout_count <= timeout_count + 1'b1;
                    if (compute_done) begin
                        result_count <= 0; state <= S_STORE;
                    end
                end
                S_STORE: begin
                    output_mem[task_id*ELEMENTS+result_count] <= c[result_count];
                    if (result_count == ELEMENTS-1) begin
                        result_count <= 0; timeout_count <= 0;
                        if (task_id == NUM_TASKS-1) begin result_addr <= 0; state <= S_STREAM; end
                        else begin task_id <= task_id + 1'b1; compute_start <= 1; state <= S_COMPUTE; end
                    end else result_count <= result_count + 1'b1;
                end
                S_STREAM: begin
                    if (!result_valid) begin
                        result_valid <= 1;
                        result_data <= output_mem[result_addr];
                    end else if (result_ready) begin
                        if (result_addr == NUM_TASKS*ELEMENTS-1) begin
                            result_valid <= 0; done <= 1; state <= S_IDLE;
                        end else begin
                            result_addr <= result_addr + 1'b1;
                            result_data <= output_mem[result_addr + 1'b1];
                        end
                    end
                end
                S_ERROR: begin
                    result_valid <= 0;
                    if (!start) state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end
endmodule

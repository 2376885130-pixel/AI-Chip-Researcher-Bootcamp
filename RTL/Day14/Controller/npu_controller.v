module npu_controller (

    input  wire clk,
    input  wire reset,

    // CPU command
    input  wire start,

    // Feedback from submodules
    input  wire data_ready,
    input  wire compute_done,

    // Commands to submodules
    output reg  start_fetch,
    output reg  start_compute,
    output reg  store_result,

    // Completion to CPU
    output reg  done

);

    //--------------------------------------------------
    // State encoding
    //--------------------------------------------------

    localparam STATE_IDLE          = 3'd0;
    localparam STATE_START_FETCH   = 3'd1;
    localparam STATE_WAIT_FETCH    = 3'd2;
    localparam STATE_START_COMPUTE = 3'd3;
    localparam STATE_WAIT_COMPUTE  = 3'd4;
    localparam STATE_STORE_RESULT  = 3'd5;
    localparam STATE_DONE          = 3'd6;

    reg [2:0] state;
    reg [2:0] next_state;

    //--------------------------------------------------
    // State register
    //--------------------------------------------------

    always @(posedge clk) begin

        if (reset)
            state <= STATE_IDLE;
        else
            state <= next_state;

    end

    //--------------------------------------------------
    // Next-state logic
    //--------------------------------------------------

    always @(*) begin

        next_state = state;

        case (state)

            STATE_IDLE: begin
                if (start)
                    next_state = STATE_START_FETCH;
            end

            STATE_START_FETCH: begin
                next_state = STATE_WAIT_FETCH;
            end

            STATE_WAIT_FETCH: begin
                if (data_ready)
                    next_state = STATE_START_COMPUTE;
            end

            STATE_START_COMPUTE: begin
                next_state = STATE_WAIT_COMPUTE;
            end

            STATE_WAIT_COMPUTE: begin
                if (compute_done)
                    next_state = STATE_STORE_RESULT;
            end

            STATE_STORE_RESULT: begin
                next_state = STATE_DONE;
            end

            STATE_DONE: begin
                next_state = STATE_IDLE;
            end

            default: begin
                next_state = STATE_IDLE;
            end

        endcase

    end

    //--------------------------------------------------
    // Output decoding
    //--------------------------------------------------

    always @(*) begin

        start_fetch   = 1'b0;
        start_compute = 1'b0;
        store_result  = 1'b0;
        done          = 1'b0;

        case (state)

            STATE_START_FETCH: begin
                start_fetch = 1'b1;
            end

            STATE_START_COMPUTE: begin
                start_compute = 1'b1;
            end

            STATE_STORE_RESULT: begin
                store_result = 1'b1;
            end

            STATE_DONE: begin
                done = 1'b1;
            end

            default: begin
                start_fetch   = 1'b0;
                start_compute = 1'b0;
                store_result  = 1'b0;
                done          = 1'b0;
            end

        endcase

    end

endmodule

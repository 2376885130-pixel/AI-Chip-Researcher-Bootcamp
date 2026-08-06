module npu_top #(

    parameter DATA_WIDTH        = 8,
    parameter ACC_WIDTH         = 32,
    parameter ADDR_WIDTH        = 4,
    parameter VECTOR_LEN        = 4,
    parameter OUTPUT_ADDR_WIDTH = 2

)(

    input wire clk,
    input wire reset,

    //--------------------------------------------------
    // CPU command interface
    //--------------------------------------------------

    input wire start,

    /*
     * Destination address for the current task result.
     * This address is latched when start is asserted.
     */
    input wire [OUTPUT_ADDR_WIDTH-1:0]
    result_write_address,

    //--------------------------------------------------
    // Weight-buffer CPU write interface
    //--------------------------------------------------

    input wire weight_write_enable,

    input wire [ADDR_WIDTH-1:0]
    weight_write_address,

    input wire signed [DATA_WIDTH-1:0]
    weight_write_data,

    //--------------------------------------------------
    // Activation-buffer CPU write interface
    //--------------------------------------------------

    input wire activation_write_enable,

    input wire [ADDR_WIDTH-1:0]
    activation_write_address,

    input wire signed [DATA_WIDTH-1:0]
    activation_write_data,

    //--------------------------------------------------
    // Output-buffer CPU read interface
    //--------------------------------------------------

    input wire result_read_enable,

    input wire [OUTPUT_ADDR_WIDTH-1:0]
    result_read_address,

    output wire signed [ACC_WIDTH-1:0]
    result_read_data,

    //--------------------------------------------------
    // NPU completion
    //--------------------------------------------------

    output wire done

);

    //--------------------------------------------------
    // Main-controller signals
    //--------------------------------------------------

    wire start_fetch;
    wire start_compute;
    wire store_result;

    wire data_ready;
    wire compute_done;

    //--------------------------------------------------
    // Result destination register
    //--------------------------------------------------

    reg [OUTPUT_ADDR_WIDTH-1:0]
    active_result_write_address;

    /*
     * Capture the output destination at the beginning
     * of each task.
     *
     * The CPU may change result_write_address after start,
     * but the running task will continue using the captured
     * destination.
     */
    always @(posedge clk) begin

        if (reset) begin

            active_result_write_address <=
                {OUTPUT_ADDR_WIDTH{1'b0}};

        end
        else if (start) begin

            active_result_write_address <=
                result_write_address;

        end

    end

    //--------------------------------------------------
    // Weight-buffer read interface
    //--------------------------------------------------

    wire weight_read_enable;

    wire [ADDR_WIDTH-1:0]
    weight_read_address;

    wire signed [DATA_WIDTH-1:0]
    weight_buffer_data;

    //--------------------------------------------------
    // Activation-buffer read interface
    //--------------------------------------------------

    wire activation_read_enable;

    wire [ADDR_WIDTH-1:0]
    activation_read_address;

    wire signed [DATA_WIDTH-1:0]
    activation_buffer_data;

    //--------------------------------------------------
    // Fetched vectors
    //--------------------------------------------------

    wire signed [DATA_WIDTH-1:0]
    weight_array [0:VECTOR_LEN-1];

    wire signed [DATA_WIDTH-1:0]
    activation_array [0:VECTOR_LEN-1];

    //--------------------------------------------------
    // Compute result
    //--------------------------------------------------

    wire signed [ACC_WIDTH-1:0]
    compute_result;

    //--------------------------------------------------
    // Main NPU controller
    //--------------------------------------------------

    npu_controller controller_inst (

        .clk(clk),
        .reset(reset),

        .start(start),

        .data_ready(data_ready),
        .compute_done(compute_done),

        .start_fetch(start_fetch),
        .start_compute(start_compute),

        .store_result(store_result),
        .done(done)

    );

    //--------------------------------------------------
    // Weight buffer
    //--------------------------------------------------

    weight_buffer #(

        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) weight_mem (

        .clk(clk),
        .reset(reset),

        .write_enable(
            weight_write_enable
        ),

        .write_address(
            weight_write_address
        ),

        .write_data(
            weight_write_data
        ),

        .read_enable(
            weight_read_enable
        ),

        .read_address(
            weight_read_address
        ),

        .data_out(
            weight_buffer_data
        )

    );

    //--------------------------------------------------
    // Activation buffer
    //--------------------------------------------------

    activation_buffer #(

        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) activation_mem (

        .clk(clk),
        .reset(reset),

        .write_enable(
            activation_write_enable
        ),

        .write_address(
            activation_write_address
        ),

        .write_data(
            activation_write_data
        ),

        .read_enable(
            activation_read_enable
        ),

        .read_address(
            activation_read_address
        ),

        .data_out(
            activation_buffer_data
        )

    );

    //--------------------------------------------------
    // Data-fetch controller
    //--------------------------------------------------

    data_fetch_controller #(

        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)

    ) fetch_inst (

        .clk(clk),
        .reset(reset),

        .start_fetch(
            start_fetch
        ),

        .data_ready(
            data_ready
        ),

        .weight_read_enable(
            weight_read_enable
        ),

        .weight_address(
            weight_read_address
        ),

        .weight_data_in(
            weight_buffer_data
        ),

        .activation_read_enable(
            activation_read_enable
        ),

        .activation_address(
            activation_read_address
        ),

        .activation_data_in(
            activation_buffer_data
        ),

        .weight_out(
            weight_array
        ),

        .activation_out(
            activation_array
        )

    );

    //--------------------------------------------------
    // Dot-product compute engine
    //--------------------------------------------------

    dot_product_engine #(

        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .VECTOR_LEN(VECTOR_LEN)

    ) compute_inst (

        .clk(clk),
        .reset(reset),

        .start_compute(
            start_compute
        ),

        .compute_done(
            compute_done
        ),

        .activation_vector(
            activation_array
        ),

        .weight_vector(
            weight_array
        ),

        .result(
            compute_result
        )

    );

    //--------------------------------------------------
    // Output buffer
    //--------------------------------------------------

    output_buffer #(

        .DATA_WIDTH(ACC_WIDTH),
        .ADDR_WIDTH(OUTPUT_ADDR_WIDTH)

    ) result_mem (

        .clk(clk),
        .reset(reset),

        /*
         * Controller asserts store_result after the compute
         * engine produces compute_done.
         */
        .write_enable(
            store_result
        ),

        /*
         * Use the task-specific destination captured when
         * the CPU asserted start.
         */
        .write_address(
            active_result_write_address
        ),

        .write_data(
            compute_result
        ),

        .read_enable(
            result_read_enable
        ),

        .read_address(
            result_read_address
        ),

        .read_data(
            result_read_data
        )

    );

endmodule

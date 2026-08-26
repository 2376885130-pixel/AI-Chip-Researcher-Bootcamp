`timescale 1ns/1ps
module verification_closure_tb;
    localparam N = 2;
    localparam E = 4;
    localparam T = 2;
    reg clk = 0, reset = 1, start = 0, mem_valid = 0, mem_write = 0, mem_region = 0;
    reg [7:0] mem_addr = 0;
    reg signed [7:0] mem_wdata = 0;
    reg result_ready = 1;
    wire start_ready, busy, done, error, mem_ready, result_valid;
    wire signed [31:0] result_data;
    wire [7:0] result_addr;
    reg signed [7:0] a [0:T-1][0:E-1];
    reg signed [7:0] b [0:T-1][0:E-1];
    reg signed [31:0] golden [0:T-1][0:E-1];
    reg signed [31:0] held_data;
    reg [7:0] held_addr;
    integer i, j, k, t, cycles, failures, results_seen, lfsr;

    always #5 clk = ~clk;
    ai_accelerator_system #(.MATRIX_SIZE(N), .PE_NUM(E), .NUM_TASKS(T),
        .ADDR_WIDTH(8), .TIMEOUT_CYCLES(200)) dut (.*);

    task write_mem;
        input integer region, addr, value;
        begin
            @(negedge clk); mem_valid = 1; mem_write = 1; mem_region = region;
            mem_addr = addr; mem_wdata = value;
            @(negedge clk); mem_valid = 0; mem_write = 0;
        end
    endtask

    task load_inputs;
        begin
            for (t = 0; t < T; t = t + 1)
                for (i = 0; i < E; i = i + 1) begin
                    write_mem(0, t*E+i, a[t][i]);
                    write_mem(1, t*E+i, b[t][i]);
                end
        end
    endtask

    task reset_and_load;
        begin
            reset = 1; start = 0; mem_valid = 0; result_ready = 1;
            repeat (3) @(posedge clk);
            @(negedge clk); reset = 0;
            load_inputs();
        end
    endtask

    task check_idle_after_reset;
        begin
            @(posedge clk); #1;
            if (busy || done || result_valid || error) begin
                $display("RESET STATE FAIL busy=%b done=%b valid=%b error=%b", busy, done, result_valid, error);
                failures = failures + 1;
            end
        end
    endtask

    task run_and_check;
        input integer reset_mode;
        begin
            results_seen = 0; cycles = 0; lfsr = 32'h1;
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            while (!done && cycles < 1000) begin
                @(posedge clk); #1; cycles = cycles + 1;
                lfsr = {lfsr[30:0], lfsr[31]^lfsr[21]^lfsr[1]^lfsr[0]};
                result_ready = (lfsr[0] | (results_seen == 0 && cycles > 2));

                if (reset_mode == 1 && cycles == 3) begin
                    @(negedge clk); reset = 1; result_ready = 1;
                    repeat (2) @(posedge clk);
                    @(negedge clk); reset = 0;
                    check_idle_after_reset();
                    load_inputs();
                    @(negedge clk); start = 1; @(negedge clk); start = 0;
                    reset_mode = 0;
                end
                if (reset_mode == 2 && dut.state == dut.S_COMPUTE) begin
                    @(negedge clk); reset = 1; repeat (2) @(posedge clk);
                    @(negedge clk); reset = 0; check_idle_after_reset();
                    load_inputs(); @(negedge clk); start = 1; @(negedge clk); start = 0;
                    reset_mode = 0;
                end
                if (reset_mode == 3 && dut.state == dut.S_STORE) begin
                    @(negedge clk); reset = 1; repeat (2) @(posedge clk);
                    @(negedge clk); reset = 0; check_idle_after_reset();
                    load_inputs(); @(negedge clk); start = 1; @(negedge clk); start = 0;
                    reset_mode = 0;
                end
                if (reset_mode == 4 && result_valid) begin
                    @(negedge clk); reset = 1; repeat (2) @(posedge clk);
                    @(negedge clk); reset = 0; check_idle_after_reset();
                    load_inputs(); @(negedge clk); start = 1; @(negedge clk); start = 0;
                    reset_mode = 0;
                end

                if (result_valid && !result_ready) begin
                    held_data = result_data; held_addr = result_addr;
                    @(posedge clk); #1;
                    if (!result_valid || result_data !== held_data || result_addr !== held_addr) begin
                        $display("BACKPRESSURE FAIL addr=%0d", held_addr);
                        failures = failures + 1;
                    end
                end
                if (result_valid && result_ready) begin
                    if (result_data !== golden[result_addr/E][result_addr%E]) begin
                        $display("RESULT FAIL task=%0d index=%0d expected=%0d actual=%0d",
                            result_addr/E, result_addr%E, golden[result_addr/E][result_addr%E], result_data);
                        failures = failures + 1;
                    end
                    results_seen = results_seen + 1;
                end
            end
            if (cycles >= 1000 || error || results_seen != T*E) begin
                $display("CLOSURE RUN FAIL mode=%0d cycles=%0d results=%0d error=%b", reset_mode, cycles, results_seen, error);
                failures = failures + 1;
            end
        end
    endtask

    initial begin
        failures = 0;
        a[0][0]=1; a[0][1]=0; a[0][2]=0; a[0][3]=1;
        b[0][0]=1; b[0][1]=2; b[0][2]=3; b[0][3]=4;
        a[1][0]=-3; a[1][1]=2; a[1][2]=-3; a[1][3]=2;
        b[1][0]=-4; b[1][1]=0; b[1][2]=0; b[1][3]=5;
        for (t=0; t<T; t=t+1) for (i=0; i<N; i=i+1) for (j=0; j<N; j=j+1) begin
            golden[t][i*N+j] = 0;
            for (k=0; k<N; k=k+1) golden[t][i*N+j] = golden[t][i*N+j] + a[t][i*N+k]*b[t][k*N+j];
        end

        reset_and_load();
        run_and_check(0); // randomized ready, including first and consecutive stalls
        reset_and_load(); run_and_check(1); // LOAD reset
        reset_and_load(); run_and_check(2); // COMPUTE reset
        reset_and_load(); run_and_check(3); // STORE reset
        reset_and_load(); run_and_check(4); // STREAM reset
        if (failures == 0) $display("VERIFICATION CLOSURE PASS");
        else $fatal(1, "VERIFICATION CLOSURE FAILURES=%0d", failures);
        #10 $finish;
    end
endmodule

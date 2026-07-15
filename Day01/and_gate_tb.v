`timescale 1ns/1ps

module and_gate_tb;

    reg a;
    reg b;
    wire y;

    integer error_count;

    and_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    task check;
        input expected;
        begin
            #1;

            if (y === expected) begin
                $display(
                    "PASS: a=%b b=%b y=%b expected=%b",
                    a, b, y, expected
                );
            end
            else begin
                $display(
                    "FAIL: a=%b b=%b y=%b expected=%b",
                    a, b, y, expected
                );
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("and_gate.vcd");
        $dumpvars(0, and_gate_tb);

        error_count = 0;

        a = 0; b = 0;
        check(0);

        a = 0; b = 1;
        check(0);

        a = 1; b = 0;
        check(0);

        a = 1; b = 1;
        check(1);

        if (error_count == 0)
            $display("TEST PASSED: all cases are correct.");
        else
            $display("TEST FAILED: %0d case(s) are incorrect.", error_count);

        $finish;
    end

endmodule

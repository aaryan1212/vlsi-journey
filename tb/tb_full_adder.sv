// tb_full_adder.sv — exhaustive self-checking testbench
//
// A full adder has three inputs, so there are exactly eight possible
// cases. When the input space is that small, do not sample it — sweep it.
// Exhaustive proof beats random sampling every time you can afford it.

`timescale 1ns/1ps

module tb_full_adder;

    logic a, b, cin, sum, cout;

    int errors = 0;
    int checks = 0;

    full_adder dut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    task automatic check(input logic exp_sum, input logic exp_cout);
        checks++;
        if (sum !== exp_sum || cout !== exp_cout) begin
            errors++;
            $display("  FAIL  a=%b b=%b cin=%b -> sum=%b cout=%b  expected sum=%b cout=%b",
                     a, b, cin, sum, cout, exp_sum, exp_cout);
        end
    endtask

    initial begin
        $dumpfile("build/tb_full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        $display("");
        $display("=== tb_full_adder ===");

        // All 2^3 input combinations. The expected value is computed
        // independently of the DUT — that independence is the whole point.
        for (int i = 0; i < 8; i++) begin
            {a, b, cin} = i[2:0];
            #1;
            check((a ^ b ^ cin), ((a & b) | (b & cin) | (a & cin)));
        end

        $display("--- %0d checks, %0d failures", checks, errors);
        if (errors == 0) begin
            $display("PASS  tb_full_adder");
            $finish;
        end else begin
            $display("FAIL  tb_full_adder");
            $fatal(1, "tb_full_adder failed");
        end
    end

endmodule

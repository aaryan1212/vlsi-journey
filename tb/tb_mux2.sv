// tb_mux2.sv — self-checking testbench for mux2
//
// THIS FILE IS THE TEMPLATE. Copy its shape for every block you write
// this year. The rules it follows:
//
//   * It CHECKS. It does not print values for a human to eyeball.
//     If you have to squint at a waveform to know whether it passed,
//     it is not a testbench, it is a demo.
//   * It COUNTS errors and reports a verdict at the end.
//   * It EXITS NON-ZERO on failure, so a script can run fifty of these
//     and tell you which broke without you reading any of them.
//   * It DUMPS a VCD, so when something does break you can go look.

`timescale 1ns/1ps

module tb_mux2;

    localparam int WIDTH = 8;

    logic [WIDTH-1:0] d0, d1, y;
    logic             sel;

    int errors = 0;
    int checks = 0;

    mux2 #(.WIDTH(WIDTH)) dut (
        .d0  (d0),
        .d1  (d1),
        .sel (sel),
        .y   (y)
    );

    // One place that knows how to compare, report and count.
    task automatic check(input logic [WIDTH-1:0] expected, input string what);
        checks++;
        if (y !== expected) begin
            errors++;
            $display("  FAIL  %-28s got=%0h expected=%0h  (t=%0t)", what, y, expected, $time);
        end
    endtask

    initial begin
        $dumpfile("build/tb_mux2.vcd");
        $dumpvars(0, tb_mux2);

        $display("");
        $display("=== tb_mux2 ===");

        // Directed cases first: the ones you can reason about by hand.
        d0 = 8'hAA; d1 = 8'h55; sel = 1'b0; #1 check(8'hAA, "sel=0 selects d0");
        d0 = 8'hAA; d1 = 8'h55; sel = 1'b1; #1 check(8'h55, "sel=1 selects d1");
        d0 = 8'h00; d1 = 8'hFF; sel = 1'b0; #1 check(8'h00, "all-zeros through d0");
        d0 = 8'h00; d1 = 8'hFF; sel = 1'b1; #1 check(8'hFF, "all-ones through d1");

        // Then random cases: the ones you would never think to write.
        // This is constrained-random testing in its most primitive form,
        // and it is where real bugs get found.
        for (int i = 0; i < 200; i++) begin
            d0  = $urandom_range(0, (1<<WIDTH)-1);
            d1  = $urandom_range(0, (1<<WIDTH)-1);
            sel = $urandom_range(0, 1);
            #1 check(sel ? d1 : d0, $sformatf("random iteration %0d", i));
        end

        // The verdict. One line, machine-readable, no ambiguity.
        $display("--- %0d checks, %0d failures", checks, errors);
        if (errors == 0) begin
            $display("PASS  tb_mux2");
            $finish;
        end else begin
            $display("FAIL  tb_mux2");
            $fatal(1, "tb_mux2 failed");
        end
    end

endmodule

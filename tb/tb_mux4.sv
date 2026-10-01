// tb_mux4.sv — self-checking testbench for mux2
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

module tb_mux4;

    localparam int WIDTH = 8;

    logic [WIDTH-1:0] d0, d1,d2,d3, y;
    logic  [1:0]           sel;

    int errors = 0;
    int checks = 0;

    mux4 #(.WIDTH(WIDTH)) dut (
        .d0  (d0),
        .d1  (d1),
        .d2  (d2),
        .d3  (d3),
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
        $dumpfile("build/tb_mux4.vcd");
        $dumpvars(0, tb_mux4);

        $display("");
        $display("=== tb_mux4 ===");

        // Directed cases first: the ones you can reason about by hand.
        d0 = 8'hA0; d1 = 8'hA1; d2 = 8'hA2; d3 = 8'hA3;
        sel = 2'b00; #1 check(8'hA0, "sel=00 selects d0");
        d0 = 8'hA0; d1 = 8'hA1; d2 = 8'hA2; d3 = 8'hA3;
        sel = 2'b01; #1 check(8'hA1, "sel=01 select d1");
        d0 = 8'hA0; d1 = 8'hA1; d2 = 8'hA2; d3 = 8'hA3;
        sel = 2'b10; #1 check(8'hA2, "sel=10 selct d2");
        d0 = 8'hA0; d1 = 8'hA1; d2 = 8'hA2; d3 = 8'hA3;
        sel = 2'b11; #1 check(8'hA3, "sel=11 selct d3");


        

        // Then random cases: the ones you would never think to write.
        // This is constrained-random testing in its most primitive form,
        // and it is where real bugs get found.
        for (int i = 0; i < 200; i++) begin
            d0  = $urandom_range(0, (1<<WIDTH)-1);
            d1  = $urandom_range(0, (1<<WIDTH)-1);
            d2  = $urandom_range(0, (1<<WIDTH)-1);
            d3  = $urandom_range(0, (1<<WIDTH)-1);
            sel = $urandom_range(0, 3);
            #1 check(sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0),$sformatf("random iteration %0d", i));
            end

        // The verdict. One line, machine-readable, no ambiguity.
        $display("--- %0d checks, %0d failures", checks, errors);
        if (errors == 0) begin
            $display("PASS  tb_mux4");
            $finish;
        end else begin
            $display("FAIL  tb_mux4");
            $fatal(1, "tb_mux4 failed");
        end
    end

endmodule

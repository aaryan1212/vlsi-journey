`timescale 1ns/1ps

// mux2.sv — parameterised 2:1 multiplexer
//
// The smallest design worth writing properly. Note three habits that will
// follow you all year:
//   1. `logic` everywhere, not `reg`/`wire`. SystemVerilog, like the job ads ask for.
//   2. `always_comb`, not `always @(*)`. It makes the tools catch your mistakes.
//   3. A parameter instead of a hard-coded width. Reusable beats clever.

module mux2 #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH-1:0] d0,
    input  logic [WIDTH-1:0] d1,
    input  logic             sel,
    output logic [WIDTH-1:0] y
);

    always_comb begin
        y = sel ? d1 : d0;
    end

endmodule

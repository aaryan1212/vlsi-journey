`timescale 1ns/1ps

// full_adder.sv — 1-bit full adder
//
// Build this from the truth table, not from memory. Then check that your
// gate-level intuition and the arithmetic agree — that is what the
// testbench is for.

module full_adder (
    input  logic a,
    input  logic b,
    input  logic cin,
    output logic sum,
    output logic cout
);

    always_comb begin
        {cout, sum} = a + b + cin;
    end

endmodule

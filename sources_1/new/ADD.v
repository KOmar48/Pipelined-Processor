`timescale 1ns / 1ps
/*
    Adder module:
        - 2 inputs / 1 output (32bits)
        - Purely combinational
*/
module ADD (input [31:0] A0, A1,
            output [31:0] AOut);
            
// Combinational Logic:
assign AOut = A0 + A1;

endmodule

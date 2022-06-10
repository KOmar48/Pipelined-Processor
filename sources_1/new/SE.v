`timescale 1ns / 1ps
/*
    Sign Extended module:
    Purely Combinational
    1 input 16 bits >>> 1 output 32 bits
*/
module SE (input [15:0] SIn,
           output [31:0] SOut);

// Combinational Logic:
assign SOut = $signed(SIn);

endmodule

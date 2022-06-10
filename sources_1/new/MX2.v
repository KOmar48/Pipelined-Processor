`timescale 1ns / 1ps
/*
    MUX Module:
        - 2 input / Select / 1 Output
        - Paramterized
        - Purely Combinational
*/
module MX2 #(parameter BL = 32)
           (input MS,
            input [BL-1:0] M0, M1,
            output [BL-1:0] MOut);

// Combinational Logic:
assign MOut = MS ? M1 : M0;

endmodule

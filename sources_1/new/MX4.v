`timescale 1ns / 1ps
/*
    MUX Module: 4 to 1
    Used for the ALUIn1
*/
module MX4 #(parameter BL = 32)
           (input [1:0] MS,
            input [BL-1:0] M0, M1, M2, M3,
            output [BL-1:0] MOut);
            
// 4x1 Assignment:
assign MOut = MS[1] ? (MS[0] ? M3:M2):(MS[0] ? M1:M0);

endmodule

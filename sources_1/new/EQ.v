`timescale 1ns / 1ps
/*
    Equal Module Checker 
*/
module EQ (input [31:0] EQIn1, EQIn2,
           output reg EQOut);
           
always @ *
    if ((EQIn1 - EQIn2) == 0)
        EQOut = 1'b1;
    else 
        EQOut = 1'b0;
        
endmodule

`timescale 1ns / 1ps
/*
    ALU Unit with 2 out registers 
    Purely Combinational Logic Bruh
*/
module ALU (input [3:0] ALUsel,
            input [4:0] Shamt,
            input [31:0] ALUIn1, ALUIn2,
            output reg [31:0] ALUOutE);
            
//Internal wire/reg definitions:
wire [31:0] ALUOp0, ALUOp1, ALUOp2, ALUOp3, ALUOp4, ALUOp5, 
            ALUOp6, ALUOp7, ALUOp8, ALUOp9, ALUOpA; 

//Operation Assignments:
assign ALUOp0 = ALUIn1 + ALUIn2;    //Addition
assign ALUOp1 = ALUIn1 - ALUIn2;    //Subtraction
assign ALUOp2 = ALUIn2 << Shamt;    //Logical Left Shift
assign ALUOp3 = ALUIn2 >>> Shamt;   //Logical Right Shift
assign ALUOp4 = ALUIn2 << ALUIn1;   //Logical Variable Left Shift
assign ALUOp5 = ALUIn2 >>> ALUIn1;  //Logical Variable Right Shift
assign ALUOp6 = ALUIn2 >> ALUIn1;   //Arithmetic Variable Right Shift
assign ALUOp7 = ALUIn1 & ALUIn2;    //Bitwise AND
assign ALUOp8 = ALUIn1 | ALUIn2;    //Bitwise OR
assign ALUOp9 = ALUIn1 ^ ALUIn2;    //Bitwise XOR
assign ALUOpA = ALUIn1 ~^ ALUIn2;   //Bitwise XNOR

//Register Output
always @ *
    case (ALUsel)
    4'b0000: ALUOutE = ALUOp0;     //Addition
    4'b0001: ALUOutE = ALUOp1;     //Subtraction
    4'b0010: ALUOutE = ALUOp2;     //Logical Left Shift
    4'b0011: ALUOutE = ALUOp3;     //Logical Right Shift
    4'b0100: ALUOutE = ALUOp4;     //Logical Variable Left Shift
    4'b0101: ALUOutE = ALUOp5;     //Logical Variable Right Shift
    4'b0110: ALUOutE = ALUOp6;     //Arithmetic Variable Right Shift
    4'b0111: ALUOutE = ALUOp7;     //Bitwise AND
    4'b1000: ALUOutE = ALUOp8;     //Bitwise OR
    4'b1001: ALUOutE = ALUOp9;     //Bitwise XOR
    4'b1010: ALUOutE = ALUOpA;     //Bitwise XNOR
    default: ALUOutE = ALUOp0;     //Default: ADD
    endcase
        
endmodule
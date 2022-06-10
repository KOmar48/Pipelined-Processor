`timescale 1ns / 1ps
/*
    Control Unit Module:
     - 2 inputs OP/FUN
     - 1 Output everything ok 
*/
module CU (input [5:0] OP, FUN,
           output [10:0] DEC);

// Define Operation Codes
parameter 
    lw = 6'b100011,
    sw = 6'b101011,
    beq = 6'b000100,
    r = 6'b000000,
    i = 6'b001000,
    j = 6'b000010;

// Internal Connections
reg [6:0] CD;
reg [1:0] ALUOp;
reg [3:0] ALUsel;
/*
    RFWE = DEC[10];
    MtoRFSel = DEC[9];
    DMWE = DEC[8];
    Branch = DEC[7];
    ALUInSel = DEC[6];
    RFDSel = DEC[5];
    Jump = DEC[4];
    ALUsel = DEC[3:0];
*/

// Assign Control Unit Decode
assign DEC = {CD,ALUsel};

// Combinational Logic: Decoder
always @ * 
case (OP)
    lw: begin
        CD = 7'b1100100;
        ALUOp = 2'b00;
    end
    sw: begin
        CD = 7'b0X101X0;
        ALUOp = 2'b00;
    end
    beq: begin
        CD = 7'b0X010X0;
        ALUOp = 2'b01;
    end
    r: begin
        if (FUN == 6'b000000) begin
            CD = 7'b0000000;
            ALUOp = 2'b00;
        end 
        else begin 
            CD = 7'b1000010;
            ALUOp = 2'b1X;
        end
    end
    i: begin
        CD = 7'b1000100;
        ALUOp = 2'b00;
    end
    j: begin
        CD = 7'b0X00XX1;
        ALUOp = 2'bXX;
    end
    default: begin
        CD = 7'b0000000;
        ALUOp = 2'b00;
    end
endcase

//ALU Decoder
always @ *
    if (ALUOp == 2'b00)
        ALUsel = 4'b0000;
    else if (ALUOp == 2'b01)
        ALUsel = 4'b0001;
    else 
        case (FUN)
            6'b100000:  ALUsel = 4'b0000;   //Addition
            6'b100010:  ALUsel = 4'b0001;   //Subtraction
            6'b000000:  ALUsel = 4'b0010;   //Logical Left Shift
            6'b000010:  ALUsel = 4'b0011;   //Logical Right Shift
            6'b000100:  ALUsel = 4'b0100;   //Logical Variable Left Shift   
            6'b000110:  ALUsel = 4'b0101;   //Logical Variable Right Shift
            6'b000111:  ALUsel = 4'b0110;   //Arithmetic Variable Right Shift
            6'b100100:  ALUsel = 4'b0111;   //Bitwise AND
            6'b100101:  ALUsel = 4'b1000;   //Bitwise OR
            6'b100110:  ALUsel = 4'b1001;   //Bitwise XOR
            6'b100111:  ALUsel = 4'b1010;   //Bitwise XNOR -- Replaces NOR function
            default:  ALUsel = 4'b0000;     //Default: ADD
        endcase

endmodule

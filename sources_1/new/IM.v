`timescale 1ns / 1ps
/*
    Instruction Memory:
        - 1 input / 1 output (32bits)
        - Purely Combinational
*/
module IM (input [31:0] IMA,
           output [31:0] IMRD);
           
// Internal Memory Declaration
reg [31:0] IMEM [0:31];

// Initialize Instruction Memory
initial begin 
    $readmemh("D:/Vivado/Projects/Assignment4/IMEM.mem", IMEM);
/*
    IMEM[0] = 32'h20100000;
    IMEM[1] = 32'h20110005;
    IMEM[2] = 32'h20120001;
    IMEM[3] = 32'h00005820;
    IMEM[4] = 32'h12110006;
    IMEM[5] = 32'h8e080000;
    IMEM[6] = 32'h02284004;
    IMEM[7] = 32'hae08001f;
    IMEM[8] = 32'h02508020;
    IMEM[9] = 32'h01685820;
    IMEM[10] = 32'h08000004;
    IMEM[11] = 32'h00000000;
*/
end

// Combinational Logic 
assign IMRD = IMEM[IMA];
 
endmodule

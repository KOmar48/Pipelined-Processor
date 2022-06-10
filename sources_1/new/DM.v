`timescale 1ns / 1ps
/*
    Data Memory Module:
    Includes a single register
*/
module DM (input DMWE,
           input [31:0] DMA, DMWD,
           output [31:0] DMRD);
           
//Internal wire/reg definitions:
reg [31:0] DMEM [0:63];

//Initializations:
initial begin
    $readmemh("D:/Vivado/Projects/Assignment4/DMEM.txt", DMEM);
/*
    DMEM[0] = 32'h00000011;
    DMEM[1] = 32'h0000001F;
    DMEM[2] = 32'hFFFFFFFB;
    DMEM[3] = 32'hFFFFFFFE;
    DMEM[4] = 32'h000000FA;
*/
end

//Data Read Assignment:
assign DMRD = DMEM[DMA];

//Write + Register Out:
always @ *
    if (DMWE)
        DMEM[DMA] = DMWD;
 
endmodule

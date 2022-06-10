`timescale 1ns / 1ps
/*
    Register File Module:
    - 4 inputs (2 Read Data/2 Write Data)
    - 2 outputs (2 Read Data)
    - Combinational/Sequential
    - Combinational 
*/
module RF (input RFWE,
           input [4:0] RFRA1, RFRA2, RFWA,
           input [31:0] RFWD,
           output reg [31:0] RFRD1D, RFRD2D);

// Internal Register File Memory:
reg [31:0] RFMEM [0:31];

// Initialize Register Memory:
integer i;
initial 
    for (i = 0; i < 32; i = i+1)
        RFMEM[i] = 0;

// Read Register - Combinational Logic
always @ * begin
    if (RFWE)
        RFMEM[RFWA] = RFWD;
    RFRD1D = RFMEM[RFRA1];
    RFRD2D = RFMEM[RFRA2];
end
 
// What's the point of the CLK here idk :>

endmodule

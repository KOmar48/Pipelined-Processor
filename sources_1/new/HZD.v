`timescale 1ns / 1ps
/*
    Hazard Unit: (stage I)
    Capable to Forward data from the MEM & WB stage...
    ...to the EX stage 
    This avoids RAW hazards
    EFFECTIVE for: R-type instructions 
    
    Hazard Unit: (stage II)
    Capable to Stall data in the Fetch/Decode stage...
    This helps prevent LW latency
    EFFECTIVE for: LW instructions
*/
module HZD (input RFWEE, RFWEM, RFWEW, MtoRFSelE, MtoRFSelM, BranchD,
            input [4:0] rsD, rtD,
            input [4:0] rsE, rtE, 
            input [4:0] rtdE, rtdM, rtdW,
            output Flush,
            output Stall,
            output reg ForwardAD, ForwardBD,
            output reg [1:0] ForwardAE, ForwardBE);

// Internal Connection     
reg LWStall, BRStall;            

// Assignments:
assign Stall = LWStall || BRStall;
assign Flush = Stall;
            
// Combinational Logic:
always @ * begin
        if ((rsE != 0) && (rsE == rtdM) && RFWEM)
            ForwardAE = 2'b10;
        else if ((rsE != 0) && (rsE == rtdW) && RFWEW)
            ForwardAE = 2'b01;
        else 
            ForwardAE = 2'b00;
        //
        if ((rtE != 0) && (rtE == rtdM) && RFWEM)
            ForwardBE = 2'b10;
        else if ((rtE != 0) && (rtE == rtdW) && RFWEW)
            ForwardBE = 2'b01;
        else 
            ForwardBE = 2'b00;
        //
        if ((rsD != 0) && (rsD == rtdM) && RFWEM)
            ForwardAD = 1'b1;
        else 
            ForwardAD = 1'b0;
        if ((rtD != 0) && (rtD == rtdM) && RFWEM)
            ForwardBD = 1'b1;
        else 
            ForwardBD = 1'b0;
        //
        if (MtoRFSelE && ((rtE == rsD) || (rtE == rtD)))
            LWStall = 1'b1;
        else 
            LWStall = 1'b0;
        //
        if ((((rsD == rtdE)||(rtD == rtdE)) && BranchD && RFWEE ) || (((rsD == rtdM)||(rtD == rtdM)) && BranchD && MtoRFSelM))
            BRStall = 1'b1;
        else 
            BRStall = 1'b0;
end

        
endmodule

`timescale 1ns / 1ps
/*
    New register method 
*/
module PPP;

reg CLK, RST;
reg [31:0] p1;
//
wire [31:0] PCIn1, PCIn2, PCOut;
wire [31:0] PCp1F, PCp1D;
wire [31:0] InstrF, InstrD, InstrE;
wire [10:0] DecD, DecE, DecM, DecW;
wire [31:0] RFRD1D, RFRD2D, RFRD1E, RFRD2E;
wire [31:0] SImmD, SImmE;
wire [31:0] PCBranchD;
wire [31:0] EQIn1D, EQIn2D;
wire EqualD, PCselD;
wire [31:0] ALUIn1E, ALUIn2E;
wire [31:0] ALUOutE, ALUOutM, ALUOutW;
wire [31:0] DMdinE, DMdinM;
wire [4:0] rtdE, rtdM, rtdW;
wire [31:0] DMOutM, DMOutW;
wire [31:0] ResultW;
//
wire Flush, Stall, ForwardAD, ForwardBD;
wire [1:0] ForwardAE, ForwardBE;
//
wire [31:0] RFMEM [0:31] = RF.RFMEM;
wire [31:0] DMEM [0:63] = DM.DMEM;
/*
RG R0 (.CLK(CLK), .RST(RST), .EN(), .CLR(), .IN(), .OUT());
MX2 M (.MS(), .M0(), .M1(), .MOut());
MX4 M (.MS(), .M0(), .M1(), .M2(), .M3(), .MOut());
*/

// PostWriteBack-PreFetch: WB-IF
MX2 M0 (.MS(PCselD), .M0(PCp1F), .M1(PCBranchD), .MOut(PCIn1));
MX2 M1 (.MS(DecD[4]), .M0(PCIn1), .M1({PCp1D[31:26],InstrD[25:0]}), .MOut(PCIn2));
//
RG PC (.CLK(CLK), .RST(RST), .EN(Stall), .CLR(!p1), .IN(PCIn2), .OUT(PCOut));

// PostFetch-PreDecode: IF-ID
IM IM (.IMA(PCOut), .IMRD(InstrF));
ADD AD0 (.A0(PCOut), .A1(p1), .AOut(PCp1F));
//
RG DR0 (.CLK(CLK), .RST(RST), .EN(Stall), .CLR(PCselD || DecD[4]), .IN(InstrF), .OUT(InstrD));
RG DR1 (.CLK(CLK), .RST(RST), .EN(Stall), .CLR(PCselD || DecD[4]), .IN(PCp1F), .OUT(PCp1D));

// PostDecode-PreExecute: ID-EX
CU CU (.OP(InstrD[31:26]), .FUN(InstrD[5:0]), .DEC(DecD));
RF RF (.RFWE(DecW[10]), .RFRA1(InstrD[25:21]), .RFRA2(InstrD[20:16]), .RFWA(rtdW), .RFWD(ResultW), .RFRD1D(RFRD1D), .RFRD2D(RFRD2D));
SE SE (.SIn(InstrD[15:0]), .SOut(SImmD));
ADD AD1 (.A0(SImmD), .A1(PCp1D), .AOut(PCBranchD));
EQ EQ (.EQIn1(EQIn1D), .EQIn2(EQIn2D), .EQOut(EqualD));
AND AN (.AN0(DecD[7]), .AN1(EqualD), .ANO(PCselD));
MX2 M2 (.MS(ForwardAD), .M0(RFRD1D), .M1(ALUOutM), .MOut(EQIn1D));
MX2 M3 (.MS(ForwardBD), .M0(RFRD2D), .M1(ALUOutM), .MOut(EQIn2D));
//
RG ER0 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(Flush), .IN(DecD), .OUT(DecE));
defparam ER0.BL = 11;
RG ER1 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(Flush), .IN(RFRD1D), .OUT(RFRD1E));
RG ER2 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(Flush), .IN(RFRD2D), .OUT(RFRD2E));
RG ER3 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(Flush), .IN(InstrD), .OUT(InstrE));
RG ER4 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(Flush), .IN(SImmD), .OUT(SImmE));

// PostExecute-PreMemory: EX-DM
ALU ALU (.ALUsel(DecE[3:0]), .Shamt(InstrE[10:6]), .ALUIn1(ALUIn1E), .ALUIn2(ALUIn2E), .ALUOutE(ALUOutE));
MX2 M4 (.MS(DecE[6]), .M0(DMdinE), .M1(SImmE), .MOut(ALUIn2E));
MX4 M5 (.MS(ForwardAE), .M0(RFRD1E), .M1(ResultW), .M2(ALUOutM), .M3(), .MOut(ALUIn1E));
MX4 M6 (.MS(ForwardBE), .M0(RFRD2E), .M1(ResultW), .M2(ALUOutM), .M3(), .MOut(DMdinE));
MX2 M7 (.MS(DecE[5]), .M0(InstrE[20:16]), .M1(InstrE[15:11]), .MOut(rtdE));
defparam M7.BL = 5;
//
RG MR0 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(DecE), .OUT(DecM));
defparam MR0.BL = 11;
RG MR1 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(ALUOutE), .OUT(ALUOutM));
RG MR2 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(DMdinE), .OUT(DMdinM));
RG MR3 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(rtdE), .OUT(rtdM));
defparam MR3.BL = 5;

// PostMemory-PreWriteback: DM-WB
DM DM (.DMWE(DecM[8]), .DMA(ALUOutM), .DMWD(DMdinM), .DMRD(DMOutM));
//
RG WR0 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(DecM), .OUT(DecW));
defparam WR0.BL = 11;
RG WR1 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(ALUOutM), .OUT(ALUOutW));
RG WR2 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(DMOutM), .OUT(DMOutW));
RG WR3 (.CLK(CLK), .RST(RST), .EN(!p1), .CLR(!p1), .IN(rtdM), .OUT(rtdW));
defparam WR3.BL = 5;
//
MX2 M8 (.MS(DecW[9]), .M0(ALUOutW), .M1(DMOutW), .MOut(ResultW));

// Hazard Unit:
HZD HZD (.RFWEE(DecE[10]), .RFWEM(DecM[10]), .RFWEW(DecW[10]), .MtoRFSelE(DecE[9]), .MtoRFSelM(DecM[9]), .BranchD(DecD[7]),
         .rsD(InstrD[25:21]), .rtD(InstrD[20:16]), .rsE(InstrE[25:21]), .rtE(InstrE[20:16]), .rtdE(rtdE), .rtdM(rtdM), .rtdW(rtdW),
         .Flush(Flush), .Stall(Stall), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE));

initial begin
    CLK = 1;
    RST = 1;
    p1 = 1;
end

always #1 CLK = ~CLK;

initial begin
    #2
    RST = 0;
    #110
    $finish;
end     

endmodule

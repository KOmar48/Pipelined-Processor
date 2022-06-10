`timescale 1ns / 1ps
/*
    Register Module:
    - Simple Input > Output register
    - Clock/Reset
    - Enable(stall)/Flush(clear)
    - Parameterized
    - Used mostly in conjunction with MUX/ADDER    
*/
module RG #(parameter BL = 32)
          (input CLK, RST, EN, CLR,
           input [BL-1:0] IN,
           output reg [BL-1:0] OUT);

// Internal Connection:  
reg [BL-1:0] INA;         
           
always @ * 
    if (RST || CLR)
        INA = 0;
    else if (!EN)
        INA = IN;
    else 
        INA = OUT;
/*
    if (RST)
        INA = 0;
    else begin
        if (!EN)
            INA = IN;
        else 
            INA = INA;
        if (CLR)
            INA = 0;
    end
*/
    
always @ (posedge CLK)
    OUT <= INA;

endmodule

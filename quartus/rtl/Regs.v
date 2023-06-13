`timescale 1ns / 1ps
`include "defines.v"

module Regs(
    input wire clk,
    input wire rst,

    // from ex
    input wire wFlagIn,                      
    input wire[`REGS_ADDR_BUS] wAddrIn,  
    input wire[`CPU_BUS] wDataIn,     
    
    // from id
    input wire[`REGS_ADDR_BUS] rAddr1In, 
    input wire[`REGS_ADDR_BUS] rAddr2In,    
    // to id
    output reg[`CPU_BUS] rData1Out,   
    output reg[`CPU_BUS] rData2Out    
);

    reg[`CPU_BUS] regs[0:`REGS_NUM - 1];
    integer i;

    always @ (posedge clk) begin
        if (rst == `REST_EN) begin
            for (i = 0; i < 31; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end
        else begin
            if ((wFlagIn == `REGS_WEN) && (wAddrIn != `ZeroRegADDR)) begin
                regs[wAddrIn] <= wDataIn;
            end
        end
    end

    always @ (*) begin
        if (rAddr1In == `ZeroRegADDR)
            rData1Out = `ZeroReg;
        else if (rAddr1In == wAddrIn && wFlagIn == `REGS_WEN)
            rData1Out = wDataIn;
        else
            rData1Out = regs[rAddr1In];
    end

     always @ (*) begin
        if (rAddr2In == `ZeroRegADDR)
            rData2Out = `ZeroReg;
        else if (rAddr2In == wAddrIn && wFlagIn == `REGS_WEN)
            rData2Out = wDataIn;
        else
            rData2Out = regs[rAddr2In];
    end
    
endmodule
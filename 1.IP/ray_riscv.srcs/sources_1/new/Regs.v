`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 17:31:37
// Design Name: 
// Module Name: Regs
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Regs(
    input wire clk,
    input wire rst,

    // from ex
    input wire wFlagIn,                      // Ð´¼Ä´æÆ÷±êÖ¾
    input wire[`REGS_ADDR_BUS] wAddrIn,      // Ð´¼Ä´æÆ÷µØÖ·
    input wire[`CPU_BUS] wDataIn,          // Ð´¼Ä´æÆ÷Êý¾Ý
    
    // from id
    input wire[`REGS_ADDR_BUS] rAddr1In,     // ¶Á¼Ä´æÆ÷1µØÖ·
    input wire[`REGS_ADDR_BUS] rAddr2In,     // ¶Á¼Ä´æÆ÷2µØÖ·

    // to id
    output reg[`CPU_BUS] rData1Out,         // ¶Á¼Ä´æÆ÷1Êý¾Ý
    output reg[`CPU_BUS] rData2Out         // ¶Á¼Ä´æÆ÷2Êý¾Ý
);

    reg[`CPU_BUS] regs[0:`REGS_NUM - 1];
    integer i;

    // Ð´¼Ä´æÆ÷
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

    // ¶Á¼Ä´æÆ÷1
    always @ (*) begin
        if (rAddr1In == `ZeroRegADDR)
            rData1Out = `ZeroReg;
        else if (rAddr1In == wAddrIn && wFlagIn == `REGS_WEN)
            rData1Out = wDataIn;
        else
            rData1Out = regs[rAddr1In];
    end

    // ¶Á¼Ä´æÆ÷2
     always @ (*) begin
        if (rAddr2In == `ZeroRegADDR)
            rData2Out = `ZeroReg;
        else if (rAddr2In == wAddrIn && wFlagIn == `REGS_WEN)
            rData2Out = wDataIn;
        else
            rData2Out = regs[rAddr2In];
    end
    
endmodule
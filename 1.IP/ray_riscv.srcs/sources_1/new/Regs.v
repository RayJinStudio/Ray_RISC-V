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
    input wire wFlagIn,                      // д�Ĵ�����־
    input wire[`REGS_ADDR_BUS] wAddrIn,      // д�Ĵ�����ַ
    input wire[`CPU_BUS] wDataIn,          // д�Ĵ�������
    
    // from id
    input wire[`REGS_ADDR_BUS] rAddr1In,     // ���Ĵ���1��ַ
    input wire[`REGS_ADDR_BUS] rAddr2In,     // ���Ĵ���2��ַ

    // to id
    output reg[`CPU_BUS] rData1Out,         // ���Ĵ���1����
    output reg[`CPU_BUS] rData2Out         // ���Ĵ���2����
);

    reg[`CPU_BUS] regs[0:`REGS_NUM - 1];
    integer i;

    // д�Ĵ���
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

    // ���Ĵ���1
    always @ (*) begin
        if (rAddr1In == `ZeroRegADDR)
            rData1Out = `ZeroReg;
        else if (rAddr1In == wAddrIn && wFlagIn == `REGS_WEN)
            rData1Out = wDataIn;
        else
            rData1Out = regs[rAddr1In];
    end

    // ���Ĵ���2
     always @ (*) begin
        if (rAddr2In == `ZeroRegADDR)
            rData2Out = `ZeroReg;
        else if (rAddr2In == wAddrIn && wFlagIn == `REGS_WEN)
            rData2Out = wDataIn;
        else
            rData2Out = regs[rAddr2In];
    end
    
endmodule
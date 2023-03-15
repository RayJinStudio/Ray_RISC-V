`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 17:11:09
// Design Name: 
// Module Name: PcReg
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


module PcReg(
    input wire clk,
    input wire rst,
    
    input wire jumpFlagIn,                 // 跳转标志
    input wire[`CPU_BUS] jumpAddrIn,   // 跳转地址
    input wire[`HOLD_FLAG_BUS] holdFlagIn, // 流水线暂停标志
    
    output reg[`CPU_BUS] pcOut
);

    always @ (posedge clk) begin
        if(rst == `REST_EN) pcOut <= `CPU_W'b0;
        else if (jumpFlagIn) pcOut <= jumpAddrIn;
        else pcOut <= pcOut + 4'd4;
    end
        
endmodule

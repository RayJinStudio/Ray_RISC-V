`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/20 10:16:57
// Design Name: 
// Module Name: ctrl
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


module Ctrl(
    // from ex
    input wire jumpFlagIn,
    input wire[`CPU_BUS] jumpAddrIn,
    input wire holdFlagIn,

    output reg[`HOLD_FLAG_BUS] holdFlagOut,
    output reg jumpFlagOut,
    output reg[`CPU_BUS] jumpAddrOut
);


    always @ (*) begin
        jumpAddrOut = jumpAddrIn;
        jumpFlagOut = jumpFlagIn;
        if (jumpFlagIn == `EN || holdFlagIn == `EN) begin
            // 暂停整条流水线
            holdFlagOut = `HOLD_EN;
        end 
        else begin
            holdFlagOut = `HOLD_NONE;
        end
    end
endmodule

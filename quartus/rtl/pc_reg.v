`timescale 1ns / 1ps
`include "defines.v"

module PcReg(
    input wire clk,
    input wire rst,
    
    input wire jumpFlagIn, 
    input wire[`CPU_BUS] jumpAddrIn,
    input wire[`HOLD_FLAG_BUS] holdFlagIn, 
    
    output reg[`CPU_BUS] pcOut
);

    always @ (posedge clk) begin
        if(rst == `REST_EN) pcOut <= `CPU_W'b0;
        else if (jumpFlagIn) pcOut <= jumpAddrIn;
        else pcOut <= pcOut + 4'd4;
    end
        
endmodule
`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 18:03:08
// Design Name: 
// Module Name: DiffSet
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


module DiffSet#(
    parameter DW = 32
)(
    input wire clk,
    input wire rst,
    input wire holdFlagIn,
    input wire[DW - 1:0] setData,
    input wire[DW - 1:0] dataIn,
    output reg[DW - 1:0] dataOut
);

    always @ (posedge clk) begin
        if (rst == `REST_EN || holdFlagIn)
            dataOut <= setData;
        else
            dataOut <= dataIn;
    end
    
endmodule

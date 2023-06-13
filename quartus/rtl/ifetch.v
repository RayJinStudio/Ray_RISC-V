`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 17:57:23
// Design Name: 
// Module Name: ifetch
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


module Ifetch(
    input wire [`CPU_BUS] instAddrIn, //from pc_reg
    input wire [`CPU_BUS] instIn, //from rom
    
    output wire [`CPU_BUS] instAddr2RomOut,//to rom
    output wire [`CPU_BUS] instAddrOut, //to if_id
    output wire [`CPU_BUS] instOut //to if_id
);

    assign instAddr2RomOut = instAddrIn;
    assign instAddrOut = instAddrIn;
    assign instOut = instIn;

endmodule
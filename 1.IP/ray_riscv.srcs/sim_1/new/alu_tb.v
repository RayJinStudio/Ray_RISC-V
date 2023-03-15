`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 15:28:04
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();

reg[`CPU_BUS] aluParam1;
reg[`CPU_BUS] aluParam2;
reg[`ALU_OP_W - 1:0] aluOpt;

wire[`CPU_BUS] aluRes;

Alu alu1(
    .aluParam1(aluParam1),
    .aluParam2(aluParam2),
    .aluOpt(aluOpt),
    .aluRes(aluRes)
);

initial begin
    aluParam1 = 32'd10;
    aluParam2 = 32'd10;
    aluOpt = `ALU_ADD;
    #500;
    aluParam1 = 32'd10;
    aluParam2 = 32'd120;
    aluOpt = `ALU_ADD;
    #500;
    aluParam1 = 32'd10;
    aluParam2 = 32'd120;
    aluOpt = `ALU_SUB;
    #500;
end
endmodule

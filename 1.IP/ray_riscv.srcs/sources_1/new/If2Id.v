`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 10:40:13
// Design Name: 
// Module Name: If2Id
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


module If2Id(
    input wire clk,
    input wire rst,

    input wire[`CPU_BUS] instIn,            // 指令内容
    input wire[`CPU_BUS] instAddrIn,   // 指令地址

    input wire[`HOLD_FLAG_BUS] holdFlagIn, // 流水线暂停标志

    // input wire[`INT_BUS] int_flag_i,        // 外设中断输入信号
    // output wire[`INT_BUS] int_flag_o,

    output wire[`CPU_BUS] instOut,           // 指令内容
    output wire[`CPU_BUS] instAddrOut   // 指令地址

    );

    wire hold_en = (holdFlagIn >= `HOLD_EN);

    wire[`CPU_BUS] inst;
    DiffSet #(32) diff1(clk, rst, hold_en, `INST_NOP, instIn, inst);
    assign instOut = inst;

    wire[`CPU_BUS] inst_addr;
    DiffSet #(32) inst_addr_ff(clk, rst, hold_en, 32'b0, instAddrIn, inst_addr);
    assign instAddrOut = inst_addr;

//    wire[`CPU_BUS] int_flag;
//    gen_pipe_dff #(8) int_ff(clk, rst, hold_en, `INT_NONE, int_flag_i, int_flag);
//    assign int_flag_o = int_flag;
endmodule

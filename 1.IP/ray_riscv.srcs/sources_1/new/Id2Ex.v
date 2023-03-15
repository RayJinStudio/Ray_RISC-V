`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 12:21:40
// Design Name: 
// Module Name: Id2Ex
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


module Id2Ex(
    input wire clk,
    input wire rst,

    input wire[`CPU_BUS] instIn,            // 指令内容
    input wire[`CPU_BUS] instAddrIn,   // 指令地址
    input wire wFlagIn,                    // 写通用寄存器标志
    input wire[`REGS_ADDR_BUS] wAddrIn,    // 写通用寄存器地址
    
    input wire[`CPU_BUS] op1In,
    input wire[`CPU_BUS] op2In,
    
    input wire[`HOLD_FLAG_BUS] holdFlagIn, // 流水线暂停标志
    
    output wire[`CPU_BUS] op1Out,
    output wire[`CPU_BUS] op2Out,
    output wire[`CPU_BUS] instOut,            // 指令内容
    output wire[`CPU_BUS] instAddrOut,   // 指令地址
    output wire wFlagOut,                    // 写通用寄存器标志
    output wire[`REGS_ADDR_BUS] wAddrOut    // 写通用寄存器地址
    // output wire csr_we_o,                    // 写CSR寄存器标志
    // output wire[`MemAddrBus] csr_waddr_o,    // 写CSR寄存器地址
    // output wire[`RegBus] csr_rdata_o         // CSR寄存器读数据

    );

    wire hold_en = (holdFlagIn >= `HOLD_EN);

    wire[`CPU_BUS] inst;
    DiffSet #(32) inst_ff(clk, rst, hold_en, `INST_NOP, instIn, inst);
    assign instOut = inst;

    wire[`CPU_BUS] inst_addr;
    DiffSet #(32) inst_addr_ff(clk, rst, hold_en, `ZeroWord, instAddrIn, inst_addr);
    assign instAddrOut = inst_addr;

    wire reg_we;
    DiffSet #(1) reg_we_ff(clk, rst, hold_en, `REGS_WDEN, wFlagIn, reg_we);
    assign wFlagOut = reg_we;

    wire[`REGS_ADDR_BUS] reg_waddr;
    DiffSet #(5) reg_waddr_ff(clk, rst, hold_en, `ZeroRegADDR, wAddrIn, reg_waddr);
    assign wAddrOut = reg_waddr;

//    wire[`CPU_BUS] reg1_rdata;
//    DiffSet #(32) reg1_rdata_ff(clk, rst, hold_en, `ZeroWord, regData1In, reg1_rdata);
//    assign regData1Out = reg1_rdata;

//    wire[`CPU_BUS] reg2_rdata;
//    DiffSet #(32) reg2_rdata_ff(clk, rst, hold_en, `ZeroWord, regData2In, reg2_rdata);
//    assign regDataOut = reg2_rdata;

    // wire csr_we;
    // gen_pipe_dff #(1) csr_we_ff(clk, rst, hold_en, `WriteDisable, csr_we_i, csr_we);
    // assign csr_we_o = csr_we;

    // wire[`MemAddrBus] csr_waddr;
    // gen_pipe_dff #(32) csr_waddr_ff(clk, rst, hold_en, `ZeroWord, csr_waddr_i, csr_waddr);
    // assign csr_waddr_o = csr_waddr;

    // wire[`RegBus] csr_rdata;
    // gen_pipe_dff #(32) csr_rdata_ff(clk, rst, hold_en, `ZeroWord, csr_rdata_i, csr_rdata);
    // assign csr_rdata_o = csr_rdata;

    wire[`CPU_BUS] op1;
    DiffSet #(32) op1_ff(clk, rst, hold_en, `ZeroWord, op1In, op1);
    assign op1Out = op1;

    wire[`CPU_BUS] op2;
    DiffSet #(32) op2_ff(clk, rst, hold_en, `ZeroWord, op2In, op2);
    assign op2Out = op2;

    // wire[`MemAddrBus] op1_jump;
    // gen_pipe_dff #(32) op1_jump_ff(clk, rst, hold_en, `ZeroWord, op1_jump_i, op1_jump);
    // assign op1_jump_o = op1_jump;

    // wire[`MemAddrBus] op2_jump;
    // gen_pipe_dff #(32) op2_jump_ff(clk, rst, hold_en, `ZeroWord, op2_jump_i, op2_jump);
    // assign op2_jump_o = op2_jump;
endmodule

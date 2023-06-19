`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 10:50:22
// Design Name: 
// Module Name: Id
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


module Id(
    input wire rst,

    // from if_id
    input wire[`CPU_BUS] instIn,             // 指令内容
    input wire[`CPU_BUS] instAddrIn,        // 指令地址

    // from regs
    input wire[`CPU_BUS] regData1In,        // 通用寄存器1输入数据
    input wire[`CPU_BUS] regData2In,        // 通用寄存器2输入数据

    // from csr reg
    // input wire[`RegBus] csr_rdata_i,         // CSR寄存器输入数据

    // from ex
    // input wire ex_jump_flag_i,               // 跳转标志

    // to regs
    output reg[`REGS_ADDR_BUS] regAddr1Out,    // 读通用寄存器1地址
    output reg[`REGS_ADDR_BUS] regAddr2Out,    // 读通用寄存器2地址

    // to csr reg
    // output reg[`MemAddrBus] csr_raddr_o,     // 读CSR寄存器地址

    // to IdEx
    output reg[`CPU_BUS] op1Out,
    output reg[`CPU_BUS] op2Out,
    //    output reg[`MemAddrBus] op1_jump_o,
    //    output reg[`MemAddrBus] op2_jump_o,
    output reg[`CPU_BUS] instOut,             // 指令内容
    output reg[`CPU_BUS] instAddrOut,    // 指令地址
    //    output reg[`RegBus] reg1_rdata_o,        // 通用寄存器1数据
    //    output reg[`RegBus] reg2_rdata_o,        // 通用寄存器2数据
    output reg wFlagOut,                     // 写通用寄存器标志
    output reg[`REGS_ADDR_BUS] wAddrOut     // 写通用寄存器地址
    // output reg csr_we_o,                     // 写CSR寄存器标志
    // output reg[`RegBus] csr_rdata_o,         // CSR寄存器数据
    // output reg[`MemAddrBus] csr_waddr_o      // 写CSR寄存器地址
);

    wire[6:0] opcode = instIn[6:0];
    wire[2:0] funct3 = instIn[14:12];
    wire[6:0] funct7 = instIn[31:25];
    wire[4:0] rd = instIn[11:7];
    wire[4:0] rs1 = instIn[19:15];
    wire[4:0] rs2 = instIn[24:20];


    always @ (*) begin
        instOut = instIn;
        instAddrOut = instAddrIn;

        case (opcode)
            `INST_TYPE_B: begin
                wFlagOut = `REGS_WDEN;
                wAddrOut = `ZeroRegADDR;
                case (funct3)
                    `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU: begin
                        regAddr1Out = rs1;
                        regAddr2Out = rs2;
                        op1Out = regData1In;
                        op2Out = regData2In;
                    end
                    default: begin
                        regAddr1Out = `ZeroRegADDR;
                        regAddr2Out = `ZeroRegADDR;
                        op1Out = `ZeroRegADDR;
                        op2Out = `ZeroRegADDR;
                    end
               endcase
            end
            `INST_TYPE_I: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = rs1;
                regAddr2Out = `ZeroRegADDR;
                op1Out = regData1In;
                op2Out = {{20{instIn[31]}}, instIn[31:20]};
            end
            `INST_TYPE_R_M: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    wFlagOut = `REGS_WEN;
                    wAddrOut = rd;
                    regAddr1Out = rs1;
                    regAddr2Out = rs2;
                    op1Out = regData1In;
                    op2Out = regData2In;
                end
                else begin
                    wFlagOut = `REGS_WDEN;
                    wAddrOut = `ZeroRegADDR;
                    regAddr1Out = `ZeroRegADDR;
                    regAddr2Out = `ZeroRegADDR;
                end
            end
            `INST_JAL: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = `ZeroRegADDR;
                regAddr2Out = `ZeroRegADDR;
                op1Out = instAddrIn;
                op2Out = {{12{instIn[31]}}, instIn[19:12], instIn[20], instIn[30:21], 1'b0};
            end
            `INST_JALR: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = rs1;
                regAddr2Out = `ZeroRegADDR;
                op1Out = regData1In;
                op2Out = {{20{instIn[31]}}, instIn[31:20]};
            end
            `INST_LUI: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = `ZeroRegADDR;
                regAddr2Out = `ZeroRegADDR;
                op1Out = {instIn[31:12], 12'b0};
                op2Out = `ZeroReg;
            end
            `INST_AUIPC: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = `ZeroRegADDR;
                regAddr2Out = `ZeroRegADDR;
                op1Out = {instIn[31:12], 12'b0};
                op2Out = instAddrIn;
            end
            `INST_LOAD: begin
                wFlagOut = `REGS_WEN;
                wAddrOut = rd;
                regAddr1Out = rs1;
                regAddr2Out = `ZeroRegADDR;
                op1Out = regData1In;
                op2Out = {{20{instIn[31]}}, instIn[31:20]};
            end
            `INST_STORE: begin
                regAddr1Out = rs1;
                regAddr2Out = rs2;
                wFlagOut = `REGS_WDEN;
                wAddrOut = `ZeroReg;
                op1Out = regData1In + {{20{instIn[31]}}, instIn[31:25], instIn[11:7]};
                op2Out = regData2In;
            end
            default: begin
                wFlagOut = `REGS_WDEN;
                wAddrOut = `ZeroRegADDR;
                regAddr1Out = `ZeroRegADDR;
                regAddr2Out = `ZeroRegADDR;
            end
        endcase
    end

endmodule

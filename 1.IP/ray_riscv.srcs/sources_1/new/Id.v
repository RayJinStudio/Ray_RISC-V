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
    input wire[`CPU_BUS] instIn,             // ָ������
    input wire[`CPU_BUS] instAddrIn,        // ָ���ַ

    // from regs
    input wire[`CPU_BUS] regData1In,        // ͨ�üĴ���1��������
    input wire[`CPU_BUS] regData2In,        // ͨ�üĴ���2��������

    // from csr reg
    // input wire[`RegBus] csr_rdata_i,         // CSR�Ĵ�����������

    // from ex
    // input wire ex_jump_flag_i,               // ��ת��־

    // to regs
    output reg[`REGS_ADDR_BUS] regAddr1Out,    // ��ͨ�üĴ���1��ַ
    output reg[`REGS_ADDR_BUS] regAddr2Out,    // ��ͨ�üĴ���2��ַ

    // to csr reg
    // output reg[`MemAddrBus] csr_raddr_o,     // ��CSR�Ĵ�����ַ

    // to IdEx
    output reg[`CPU_BUS] op1Out,
    output reg[`CPU_BUS] op2Out,
    //    output reg[`MemAddrBus] op1_jump_o,
    //    output reg[`MemAddrBus] op2_jump_o,
    output reg[`CPU_BUS] instOut,             // ָ������
    output reg[`CPU_BUS] instAddrOut,    // ָ���ַ
    //    output reg[`RegBus] reg1_rdata_o,        // ͨ�üĴ���1����
    //    output reg[`RegBus] reg2_rdata_o,        // ͨ�üĴ���2����
    output reg wFlagOut,                     // дͨ�üĴ�����־
    output reg[`REGS_ADDR_BUS] wAddrOut     // дͨ�üĴ�����ַ
    // output reg csr_we_o,                     // дCSR�Ĵ�����־
    // output reg[`RegBus] csr_rdata_o,         // CSR�Ĵ�������
    // output reg[`MemAddrBus] csr_waddr_o      // дCSR�Ĵ�����ַ
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

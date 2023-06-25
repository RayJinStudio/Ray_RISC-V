`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/18 17:53:37
// Design Name: 
// Module Name: ex
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


module Ex(
    input wire rst,

    // from id
    input wire[`CPU_BUS] instIn,            // 指令内容
    input wire[`CPU_BUS] instAddrIn,   // 指令地址
    input wire wFlagIn,                    // 是否写通用寄存器
    input wire[`REGS_ADDR_BUS] wAddrIn,    // 写通用寄存器地址
    
    input wire[`CPU_BUS] op1In,
    input wire[`CPU_BUS] op2In,
    
    // to regs
    output wire[`CPU_BUS] wDataOut,       // 写寄存器数据
    output wire wFlagOut,                   // 是否要写通用寄存器
    output wire[`REGS_ADDR_BUS] wAddrOut,   // 写通用寄存器地
    
    //bus
    input wire[`CPU_BUS] busDataIn,
    output reg[`CPU_BUS] busDataOut,
    output reg[`CPU_BUS] busAddrOut,
    output reg busWEOut,
    
    output wire jumpFlagOut,
    output wire[`CPU_BUS] jumpAddrOut,
    output wire holdFlagOut
);

    wire[31:0] op1_add_op2_res;
    wire[31:0] sr_res;
    wire[31:0] sr_mask;
    wire op1_eq_op2;
    wire op1_less_op2_signed;
    wire op1_less_op2_unsigned;
    reg[31:0] jump_imm;
    reg[31:0] jump_addr_res;
    
    wire[6:0] opcode;
    wire[2:0] funct3;
    wire[6:0] funct7;
    wire[4:0] rd;
    wire[4:0] uimm;
    reg[`CPU_BUS] reg_wdata;
    reg reg_we;
    reg[`REGS_ADDR_BUS] reg_waddr;
    reg hold_flag;
    reg jump_flag;
    reg[`CPU_BUS] jump_addr;

    assign opcode = instIn[6:0];
    assign funct3 = instIn[14:12];
    assign funct7 = instIn[31:25];
    assign rd = instIn[11:7];
    assign uimm = instIn[19:15];


    assign op1_add_op2_res = op1In + op2In;
    assign op1_eq_op2 = op1In == op2In;
    assign op1_less_op2_unsigned = op1In < op2In;
    assign op1_less_op2_signed = $signed(op1In) < $signed(op2In);
    
    assign sr_res = op1In >> op2In[4:0];
    assign sr_mask = 32'hffffffff >> op2In[4:0];
    
    //assign     assign jump_addr_res = jump_imm + instAddrIn;
    
    assign wDataOut = reg_wdata;
    assign wFlagOut = reg_we;
    assign wAddrOut = reg_waddr;
    assign holdFlagOut = hold_flag;
    assign jumpFlagOut = jump_flag;
    assign jumpAddrOut = jump_addr;
    // 执行
    always @ (*) begin
    
        reg_we = wFlagIn;
        reg_waddr = wAddrIn;
        hold_flag = `DEN;
        jump_flag = `DEN;
        busWEOut = `DEN;
        jump_addr = 32'b0;
        
        case (opcode)
            `INST_TYPE_B: begin
                jump_imm = {{20{instIn[31]}}, instIn[7], instIn[30:25], instIn[11:8], 1'b0};
                jump_addr_res = jump_imm + instAddrIn;
                case (funct3)
                    `INST_BEQ: begin
                        jump_flag = (op1_eq_op2);
                        jump_addr = {32{(op1_eq_op2)}} & jump_addr_res;
                    end
                    `INST_BNE: begin
                        jump_flag = (~op1_eq_op2);
                        jump_addr = {32{(~op1_eq_op2)}} & jump_addr_res;
                    end
                    `INST_BLT: begin
                        jump_flag = (op1_less_op2_signed);
                        jump_addr = {32{(op1_less_op2_signed)}} & jump_addr_res;
                    end
                    `INST_BGE: begin
                        jump_flag = (~op1_less_op2_signed);
                        jump_addr = {32{(~op1_less_op2_signed)}} & jump_addr_res;
                    end
                    `INST_BLTU: begin
                        jump_flag = (op1_less_op2_unsigned);
                        jump_addr = {32{(op1_less_op2_unsigned)}} & jump_addr_res;
                    end
                    `INST_BGEU: begin
                        jump_flag = (~op1_less_op2_unsigned);
                        jump_addr = {32{(~op1_less_op2_unsigned)}} & jump_addr_res;
                    end                   
                    default: begin
                        jump_flag = `DEN;
                        jump_addr = 32'b0;
                    end
               endcase
            end
            `INST_TYPE_I: begin
                case (funct3)
                    `INST_ADDI: reg_wdata = op1_add_op2_res;
                    `INST_SLLI: reg_wdata = op1In << op2In[4:0];
                    `INST_SLTI: reg_wdata = {31'b0, op1_less_op2_signed};
                    `INST_SLTIU: reg_wdata = {31'b0, op1_less_op2_unsigned};
                    `INST_XORI: reg_wdata = op1In ^ op2In;
                    `INST_SRI: begin
                        if(funct7[5]==1'b0) reg_wdata = sr_res;
                        else reg_wdata = (sr_res & sr_mask) | ({32{op1In[31]}} & (~sr_mask));
                    end
                    `INST_ORI: reg_wdata = op1In | op2In;
                    `INST_ANDI: reg_wdata = op1In & op2In;
                    default: reg_wdata = `ZeroWord;
                endcase
            end
            `INST_TYPE_R_M: begin
                if ((funct7 == 7'b0000000) || (funct7 == 7'b0100000)) begin
                    case (funct3)
                        `INST_ADD_SUB: begin
                            if (funct7[5] == 1'b0) reg_wdata = op1_add_op2_res;
                            else reg_wdata = op1In - op2In;
                        end
                        `INST_SLL: reg_wdata = op1In << op2In[4:0];
                        `INST_SLT: reg_wdata = {31'b0, op1_less_op2_signed};
                        `INST_SLTU: reg_wdata = {31'b0, op1_less_op2_unsigned};
                        `INST_XOR: reg_wdata = op1In ^ op2In;
                        `INST_SR: begin
                            if(funct7[5] == 1'b0) reg_wdata = sr_res;
                            else reg_wdata = (sr_res & sr_mask) | ({32{op1In[31]}} & (~sr_mask));
                        end
                        `INST_OR: reg_wdata = op1In | op2In;
                        `INST_AND: reg_wdata = op1In & op2In;
                        default: reg_wdata = `ZeroWord;
                    endcase
                end 
                else reg_wdata = `ZeroWord;
            end
            `INST_JAL, `INST_JALR: begin
                jump_flag = `EN;
                jump_addr = op1_add_op2_res;
                reg_wdata = instAddrIn + 32'd4;
            end
            `INST_LUI, `INST_AUIPC: reg_wdata = op1_add_op2_res;
            `INST_LOAD: begin
                busAddrOut = op1_add_op2_res;
                reg_wdata = busDataIn;
            end
            `INST_STORE: begin
                busAddrOut = op1In;
                busDataOut = op2In;
                busWEOut = `EN;
            end
            default: reg_wdata = `ZeroWord;
        endcase
    end
endmodule

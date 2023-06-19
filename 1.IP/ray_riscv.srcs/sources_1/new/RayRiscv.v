`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 13:35:18
// Design Name: 
// Module Name: RayRiscv
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


module RayRiscv(
    input wire clk,
    input wire rst,
    input wire[`CPU_BUS] dataIn,
    input wire[`CPU_BUS] busDataIn,
    output wire[`CPU_BUS] busDataOut,
    output wire[`CPU_BUS] dataAddrOut,
    output wire[`CPU_BUS] busAddrOut,
    output wire busWEOut
);

//PcReg to Ifetch
wire[`CPU_BUS] pc2IfPc;

//If to If2Id
wire[`CPU_BUS] if2IfIdInst;
wire[`CPU_BUS] if2IfIdInstAddr;

//If2Id to Id
wire[`CPU_BUS] ifId2IdInst;
wire[`CPU_BUS] ifId2IdInstAddr;

//Id to Regs
wire[`REGS_ADDR_BUS] id2RegsAddr1;
wire[`REGS_ADDR_BUS] id2RegsAddr2;

//Regs to Id
wire[`CPU_BUS] regs2IdData1;
wire[`CPU_BUS] regs2IdData2;

//Id to Id2Ex
wire[`CPU_BUS] id2IdExOp1;
wire[`CPU_BUS] id2IdExOp2;
wire id2IdExWFlag;
wire[`CPU_BUS] id2IdExInst;
wire[`CPU_BUS] id2IdExInstAddr;
wire[`REGS_ADDR_BUS] id2IdExWAddr;

//Id2Ex to Ex
wire[`CPU_BUS] idEx2ExOp1;
wire[`CPU_BUS] idEx2ExOp2;
wire[`CPU_BUS] idEx2ExInst;
wire[`CPU_BUS] idEx2ExInstAddr;
wire idEx2ExWFlag;
wire[`REGS_ADDR_BUS] idEx2ExWAddr;

//Ex to Regs
wire[`REGS_ADDR_BUS] ex2RegsWAddr;
wire ex2RegsWFlag;
wire[`CPU_BUS] ex2RegsWData;

//Ex to Ctrl
wire ex2CtrlJmpFlag;
wire[`CPU_BUS] ex2CtrlJmpAddr;
wire ex2CtrlHoldFlag;

//from Ctrl
wire[`HOLD_FLAG_BUS] ctrlHoldFlag;

//Ctrl to PcReg
wire ctrl2PcJmpFlag;
wire[`CPU_BUS] ctrl2PcJmpAddr;

//Ctrl
Ctrl ctrl(
    // from ex
    .jumpFlagIn(ex2CtrlJmpFlag),
    .jumpAddrIn(ex2CtrlJmpAddr),
    .holdFlagIn(ex2CtrlHoldFlag),

    .holdFlagOut(ctrlHoldFlag),
    .jumpFlagOut(ctrl2PcJmpFlag),
    .jumpAddrOut(ctrl2PcJmpAddr)
);

//PcReg
PcReg pcreg(
    .clk(clk),
    .rst(rst),
    
    .jumpFlagIn(ctrl2PcJmpFlag),                 // 跳转标志
    .jumpAddrIn(ctrl2PcJmpAddr),   // 跳转地址
    .holdFlagIn(ctrlHoldFlag),
    
    .pcOut(pc2IfPc)
);

//Ifech
Ifetch ifetch(
    .instAddrIn(pc2IfPc), //from pc_reg
    .instIn(dataIn), //from rom
    
    .instAddr2RomOut(dataAddrOut),//to rom
    .instAddrOut(if2IfIdInstAddr), //to if_id
    .instOut(if2IfIdInst) //to if_id
);

//If2Id
If2Id if2id(
    .clk(clk),
    .rst(rst),

    .instIn(if2IfIdInst),            // 指令内容
    .instAddrIn(if2IfIdInstAddr),   // 指令地址
    
    .holdFlagIn(ctrlHoldFlag),

    .instOut(ifId2IdInst),           // 指令内容
    .instAddrOut(ifId2IdInstAddr)   // 指令地址
);

//Id
Id id1(
    .rst(rst),
    // from if_id
    .instIn(ifId2IdInst),             // 指令内容
    .instAddrIn(ifId2IdInstAddr),        // 指令地址
    // from regs
    .regData1In(regs2IdData1),        // 通用寄存器1输入数据
    .regData2In(regs2IdData2),        // 通用寄存器2输入数据
    // to regs
    .regAddr1Out(id2RegsAddr1),    // 读通用寄存器1地址
    .regAddr2Out(id2RegsAddr2),    // 读通用寄存器2地址
    // to Id2Ex
    .op1Out(id2IdExOp1),
    .op2Out(id2IdExOp2),
    .instOut(id2IdExInst),             // 指令内容
    .instAddrOut(id2IdExInstAddr),    // 指令地址
    .wFlagOut(id2IdExWFlag),                     // 写通用寄存器标志
    .wAddrOut(id2IdExWAddr)     // 写通用寄存器地址
);

Id2Ex id2ex(
    .clk(clk),
    .rst(rst),
    .instIn(id2IdExInst),            // 指令内容
    .instAddrIn(id2IdExInstAddr),   // 指令地址
    .wFlagIn(id2IdExWFlag),                    // 写通用寄存器标志
    .wAddrIn(id2IdExWAddr),    // 写通用寄存器地址
    .op1In(id2IdExOp1),
    .op2In(id2IdExOp2),
    
    .holdFlagIn(ctrlHoldFlag),
    
    .op1Out(idEx2ExOp1),
    .op2Out(idEx2ExOp2),
    .instOut(idEx2ExInst),            // 指令内容
    .instAddrOut(idEx2ExInstAddr),   // 指令地址
    .wFlagOut(idEx2ExWFlag),                    // 写通用寄存器标志
    .wAddrOut(idEx2ExWAddr)    // 写通用寄存器地址
);

//Ex
Ex ex(
    .rst(rst),

    // from id
    .instIn(idEx2ExInst),            // 指令内容
    .instAddrIn(idEx2ExInstAddr),   // 指令地址
    .wFlagIn(idEx2ExWFlag),                    // 是否写通用寄存器
    .wAddrIn(idEx2ExWAddr),    // 写通用寄存器地址
    
    .op1In(idEx2ExOp1),
    .op2In(idEx2ExOp2),
    
    // to regs
    .wDataOut(ex2RegsWData),       // 写寄存器数据
    .wFlagOut(ex2RegsWFlag),                   // 是否要写通用寄存器
    .wAddrOut(ex2RegsWAddr),   // 写通用寄存器地
    
    //Bus
    .busDataIn(busDataIn),
    .busDataOut(busDataOut),
    .busAddrOut(busAddrOut),
    .busWEOut(busWEOut),
    
    .jumpFlagOut(ex2CtrlJmpFlag),
    .jumpAddrOut(ex2CtrlJmpAddr),
    .holdFlagOut(ex2CtrlHoldFlag)
);

//regs
Regs regs(
    .clk(clk),
    .rst(rst),
    // from ex
    .wFlagIn(ex2RegsWFlag),                      // 写寄存器标志
    .wAddrIn(ex2RegsWAddr),      // 写寄存器地址
    .wDataIn(ex2RegsWData),          // 写寄存器数据
    // from id
    .rAddr1In(id2RegsAddr1),     // 读寄存器1地址
    .rAddr2In(id2RegsAddr2),     // 读寄存器2地址
    // to id
    .rData1Out(regs2IdData1),         // 读寄存器1数据
    .rData2Out(regs2IdData2)         // 读寄存器2数据
);

endmodule

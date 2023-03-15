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
    output wire[`CPU_BUS] dataAddrOut
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
    
    .jumpFlagIn(ctrl2PcJmpFlag),                 // ��ת��־
    .jumpAddrIn(ctrl2PcJmpAddr),   // ��ת��ַ
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

    .instIn(if2IfIdInst),            // ָ������
    .instAddrIn(if2IfIdInstAddr),   // ָ���ַ
    
    .holdFlagIn(ctrlHoldFlag),

    .instOut(ifId2IdInst),           // ָ������
    .instAddrOut(ifId2IdInstAddr)   // ָ���ַ
);

//Id
Id id1(
    .rst(rst),
    // from if_id
    .instIn(ifId2IdInst),             // ָ������
    .instAddrIn(ifId2IdInstAddr),        // ָ���ַ
    // from regs
    .regData1In(regs2IdData1),        // ͨ�üĴ���1��������
    .regData2In(regs2IdData2),        // ͨ�üĴ���2��������
    // to regs
    .regAddr1Out(id2RegsAddr1),    // ��ͨ�üĴ���1��ַ
    .regAddr2Out(id2RegsAddr2),    // ��ͨ�üĴ���2��ַ
    // to Id2Ex
    .op1Out(id2IdExOp1),
    .op2Out(id2IdExOp2),
    .instOut(id2IdExInst),             // ָ������
    .instAddrOut(id2IdExInstAddr),    // ָ���ַ
    .wFlagOut(id2IdExWFlag),                     // дͨ�üĴ�����־
    .wAddrOut(id2IdExWAddr)     // дͨ�üĴ�����ַ
);

Id2Ex id2ex(
    .clk(clk),
    .rst(rst),
    .instIn(id2IdExInst),            // ָ������
    .instAddrIn(id2IdExInstAddr),   // ָ���ַ
    .wFlagIn(id2IdExWFlag),                    // дͨ�üĴ�����־
    .wAddrIn(id2IdExWAddr),    // дͨ�üĴ�����ַ
    .op1In(id2IdExOp1),
    .op2In(id2IdExOp2),
    
    .holdFlagIn(ctrlHoldFlag),
    
    .op1Out(idEx2ExOp1),
    .op2Out(idEx2ExOp2),
    .instOut(idEx2ExInst),            // ָ������
    .instAddrOut(idEx2ExInstAddr),   // ָ���ַ
    .wFlagOut(idEx2ExWFlag),                    // дͨ�üĴ�����־
    .wAddrOut(idEx2ExWAddr)    // дͨ�üĴ�����ַ
);

//Ex
Ex ex(
    .rst(rst),

    // from id
    .instIn(idEx2ExInst),            // ָ������
    .instAddrIn(idEx2ExInstAddr),   // ָ���ַ
    .wFlagIn(idEx2ExWFlag),                    // �Ƿ�дͨ�üĴ���
    .wAddrIn(idEx2ExWAddr),    // дͨ�üĴ�����ַ
    
    .op1In(idEx2ExOp1),
    .op2In(idEx2ExOp2),
    
    // to regs
    .wDataOut(ex2RegsWData),       // д�Ĵ�������
    .wFlagOut(ex2RegsWFlag),                   // �Ƿ�Ҫдͨ�üĴ���
    .wAddrOut(ex2RegsWAddr),   // дͨ�üĴ�����
    
    .jumpFlagOut(ex2CtrlJmpFlag),
    .jumpAddrOut(ex2CtrlJmpAddr),
    .holdFlagOut(ex2CtrlHoldFlag)
);

//regs
Regs regs(
    .clk(clk),
    .rst(rst),
    // from ex
    .wFlagIn(ex2RegsWFlag),                      // д�Ĵ�����־
    .wAddrIn(ex2RegsWAddr),      // д�Ĵ�����ַ
    .wDataIn(ex2RegsWData),          // д�Ĵ�������
    // from id
    .rAddr1In(id2RegsAddr1),     // ���Ĵ���1��ַ
    .rAddr2In(id2RegsAddr2),     // ���Ĵ���2��ַ
    // to id
    .rData1Out(regs2IdData1),         // ���Ĵ���1����
    .rData2Out(regs2IdData2)         // ���Ĵ���2����
);

endmodule

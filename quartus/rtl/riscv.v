`timescale 1ns / 1ps
`include "defines.v"

module riscv(
    input clk,
	 input rst,
	 input a,
	 output b
);
	assign b = a;
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
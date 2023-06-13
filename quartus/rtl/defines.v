`define CPU_W 32
`define ALU_OP_W 4

`define EN 1'b1
`define DEN 1'b0

`define REST_EN 1'b0
`define REST_DEN 1'b1
`define REGS_NUM 32
`define REGS_ADDR_W 5
`define REGS_WEN 1'b1
`define REGS_WDEN 1'b0

`define CPU_BUS `CPU_W - 1:0
`define REGS_ADDR_BUS `REGS_ADDR_W - 1:0

`define HOLD_FLAG_BUS   1:0
`define HOLD_NONE 2'b00
`define HOLD_PC   2'b01
`define HOLD_EN   2'b10

`define ZeroReg 32'b0
`define ZeroRegADDR 5'b0
`define ZeroWord 32'b0

//ALUOpt
`define ALU_AND  `ALU_OP_W'b0000
`define ALU_OR   `ALU_OP_W'b0001
`define ALU_XOR  `ALU_OP_W'b0010
`define ALU_ADD  `ALU_OP_W'b0011
`define ALU_SUB  `ALU_OP_W'b0100
`define ALU_SLL  `ALU_OP_W'b0101 // shift left logical
`define ALU_SRL  `ALU_OP_W'b0110 // shift right logical
`define ALU_SRA  `ALU_OP_W'b0111 // shift right arith 
`define ALU_SLT  `ALU_OP_W'b1000 // set less than  
`define ALU_SLTU `ALU_OP_W'b1001 // set less than (unsigned) 
`define ALU_BLT  `ALU_OP_W'b1010 // branch less than
`define ALU_BLTU `ALU_OP_W'b1011 // branch less than (unsigned)
`define ALU_JAL  `ALU_OP_W'b1100  
`define ALU_JALR `ALU_OP_W'b1101  

// B type inst
`define INST_TYPE_B 7'b1100011
`define INST_BEQ    3'b000
`define INST_BNE    3'b001
`define INST_BLT    3'b100
`define INST_BGE    3'b101
`define INST_BLTU   3'b110
`define INST_BGEU   3'b111

//I
`define INST_TYPE_I 7'b0010011
`define INST_ADDI   3'b000
`define INST_SLLI   3'b001
`define INST_SLTI   3'b010
`define INST_SLTIU  3'b011
`define INST_XORI   3'b100
`define INST_SRI    3'b101
`define INST_ORI    3'b110
`define INST_ANDI   3'b111

//R
`define INST_TYPE_R_M 7'b0110011
`define INST_ADD_SUB 3'b000
`define INST_SLL    3'b001
`define INST_SLT    3'b010
`define INST_SLTU   3'b011
`define INST_XOR    3'b100
`define INST_SR     3'b101
`define INST_OR     3'b110
`define INST_AND    3'b111

//J
`define INST_JAL    7'b1101111
`define INST_JALR   7'b1100111

//U
`define INST_LUI    7'b0110111
`define INST_AUIPC  7'b0010111

`define INST_NOP    32'h00000013
`define INST_MRET   32'h30200073
`define INST_RET    32'h00008067
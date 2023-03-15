`define CPU_W 32
`define ALU_OP_W 4


`define REST_EN 1'b0
`define REST_DEN 1'b1
`define REGS_NUM 32
`define REGS_ADDR_W 5
`define REGS_WEN 1'b1
`define REGS_WDEN 1'b0

`define CPU_BUS `CPU_W - 1:0
`define REGS_ADDR_BUS `REGS_ADDR_W - 1:0

`define ZeroReg 32'b0
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

//I
`define INST_TYPE_I 7'b0010011
`define INST_ADDI 3'b000

//R
`define INST_TYPE_R_M 7'b0110011
`define INST_ADD_SUB 3'b000

//J
`define INST_NOP 32'h00000013
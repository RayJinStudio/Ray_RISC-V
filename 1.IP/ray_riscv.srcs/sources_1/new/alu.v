`include "defines.v"

module Alu(
    input wire[`CPU_W - 1:0] aluParam1,
    input wire[`CPU_W - 1:0] aluParam2,
    input wire[`ALU_OP_W - 1:0] aluOpt,
    
    output reg[`CPU_W - 1:0] aluRes
);

    always @ (*) begin
        case (aluOpt)
            `ALU_ADD: aluRes = aluParam1 + aluParam2;
            default: aluRes = `CPU_W'b0;
        endcase
    end
endmodule

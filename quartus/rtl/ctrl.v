`timescale 1ns / 1ps

module Ctrl(
    // from ex
    input wire jumpFlagIn,
    input wire[`CPU_BUS] jumpAddrIn,
    input wire holdFlagIn,

    output reg[`HOLD_FLAG_BUS] holdFlagOut,
    output reg jumpFlagOut,
    output reg[`CPU_BUS] jumpAddrOut
);


    always @ (*) begin
        jumpAddrOut = jumpAddrIn;
        jumpFlagOut = jumpFlagIn;
        if (jumpFlagIn == `EN || holdFlagIn == `EN) begin
            holdFlagOut = `HOLD_EN;
        end 
        else begin
            holdFlagOut = `HOLD_NONE;
        end
    end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 13:44:58
// Design Name: 
// Module Name: Rom
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


module Rom(
    input wire[`CPU_BUS] AddrIn,
    output reg[`CPU_BUS] DataOut
);

    reg[`CPU_BUS] rom_mem[0:4095];
    
    always@ (*) begin
        DataOut = rom_mem[AddrIn >> 2];
    end
    
endmodule

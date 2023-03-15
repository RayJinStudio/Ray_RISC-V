`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 18:08:21
// Design Name: 
// Module Name: RaySOC
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


module RaySOC(
    input wire clk,
    input wire rst
);

//CPU to ROM
wire[`CPU_BUS] cpu2RomAddr;

//ROM to CPU
wire[`CPU_BUS] cpu2RomData;

RayRiscv cpu(
    .clk(clk),
    .rst(rst),
    .dataIn(cpu2RomData),
    .dataAddrOut(cpu2RomAddr)
);

Rom rom(
    .AddrIn(cpu2RomAddr),
    .DataOut(cpu2RomData)
);

endmodule

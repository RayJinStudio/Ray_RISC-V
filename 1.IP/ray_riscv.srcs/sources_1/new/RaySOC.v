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
    input wire rst,
    output wire[31:0] io
);

//CPU to ROM
wire[`CPU_BUS] cpu2RomAddr;
wire[`CPU_BUS] cpu2RomData;

//CPU to Bus
wire[`CPU_BUS] cpu2BusAddr;
wire[`CPU_BUS] cpu2BusData;
wire cpu2BusWE;
wire[`CPU_BUS] bus2CPUData;

RayRiscv cpu(
    .clk(clk),
    .rst(rst),
    .dataIn(cpu2RomData),
    .busDataIn(bus2CPUData),
    .busAddrOut(cpu2BusAddr),
    .busDataOut(cpu2BusData),
    .dataAddrOut(cpu2RomAddr),
    .busWEOut(cpu2BusWE)
);

Rom rom(
    .AddrIn(cpu2RomAddr),
    .DataOut(cpu2RomData)
);

//Ram ram(.clk(clk),
//        .rst(rst),
//        .weIn(cpu2BusWE),
//        .addrIn(cpu2BusAddr),    // addr
//        .dataIn(cpu2BusData),
//        .dataOut(bus2CPUData)
//);

reg [31:0] ioReg;
assign io = ioReg;
//GPIO
always @(*) begin
    if(cpu2BusWE)
        ioReg = cpu2BusData;
end

endmodule

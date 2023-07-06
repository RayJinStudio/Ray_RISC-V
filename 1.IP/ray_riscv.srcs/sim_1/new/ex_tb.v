`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/19 13:45:31
// Design Name: 
// Module Name: ex_tb
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


module ex_tb();

reg[`CPU_BUS] instIn;        // ָ������
wire[`CPU_BUS] instAddrIn;   // ָ���ַ

reg clk;
reg rst;
reg f = 1'b1;

wire x3;
assign x3 = ex_tb.risc.cpu.regs.regs[3];
wire x26;
assign x26 = ex_tb.risc.cpu.regs.regs[26];
wire x27;
assign x27 = ex_tb.risc.cpu.regs.regs[27];


RaySOC risc(
   .clk(clk),            // ָ������
   .rst(rst)   // ָ���ַ        
);

always #10 clk=~clk;

initial begin
    clk <= 1'b1;
    rst <= 1'b0;
    #40
    rst <= 1'b1;
    #200;
    $readmemh("D:/Ray/projects/ray_riscv/2.test/rv32ui-p-lw.txt",ex_tb.risc.rom.rom_mem);
end

integer r;
initial  begin
   wait(x26);
   #40;
   if(x27 == 32'b1) begin
       $display("success");
   end
   else begin
       $display("fail at %d", x3);
       for(r = 0; r<=31; r= r+1) begin
           $display("x%2d = %d",r, ex_tb.risc.cpu.regs.regs[r]);
       end
   end
   $stop;
end
endmodule


`include "defines.v"

// ram module
module Ram(

    input wire clk,
    input wire rst,

    input wire weIn,                   // write enable
    input wire[`MemAddrBus] addrIn,    // addr
    input wire[`MemBus] dataIn,

    output reg[`MemBus] dataOut       // read data

    );

    reg[`MemBus] _ram[0:`MemNum - 1];


    always @ (posedge clk) begin
        if (weIn == `EN) begin
            _ram[addrIn[31:2]] <= dataIn;
        end
    end

    always @ (*) begin
        if (rst == `REST_EN) begin
            dataOut = `ZeroWord;
        end else begin
            dataOut = _ram[addrIn[31:2]];
        end
    end

endmodule
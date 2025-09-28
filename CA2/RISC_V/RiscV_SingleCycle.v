module RISC_V(input clk,reset);

    wire RegWrite, ALUSrc, MemWrite, Zero;
    wire [1:0] ResultSrc, PCSrc;
    wire [2:0] ALUControl, ImmSrc;
    wire [6:0] opc, funct7;
    wire [2:0] funct3;

	Controller CU(opc,funct3,funct7,Zero,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,ALUControl,PCSrc);

	Datapath DP(clk,reset,MemWrite,ALUSrc,RegWrite,ResultSrc,PCSrc,ALUControl,ImmSrc,opc,funct7,funct3,Zero);


endmodule

module Datapath(
	input clk,reset,MemWrite,ALUSrc,RegWrite,
	input [1:0] ResultSrc,PCSrc,
	input [2:0] ALUControl,ImmSrc,
	output [6:0] opc,funct7,
    output [2:0]funct3,
    output Zero
);

wire [31:0] Instr,RD1,RD2;
wire [4:0] A1, A2, A3;             
wire [31:0] PC, PCNext;          
wire [31:0] PCPlus4, PCTarget;    
wire [31:0] Immidiate;             
wire [31:0] ImmExt;            
wire [31:0] SrcA, SrcB;            
wire [31:0] WriteData;           
wire [31:0] ALUResult;           
wire [31:0] ReadData;              
wire [31:0] Result;    

assign opc=Instr[6:0];
assign A1 = Instr[19:15];
assign A2 = Instr[24:20];
assign A3 = Instr[11:7];
assign funct3=Instr[14:12];
assign funct7=Instr[31:25];
assign Immidiate = Instr[31:7];
assign SrcA = RD1;
assign WriteData = RD2;


           
mux4to1 PC_next(PCPlus4,PCTarget,ALUResult,1'b0,PCSrc,PCNext);

register PC_reg(clk,1'b1,reset,PCNext,PC);

Instruction_Memory Instruction_Mem(clk,PC,Instr);

Adder PCPlus4_adder(PC,32'd4,PCPlus4);

Register_File Reg_File(clk,RegWrite,A1,A2,A3,Result,RD1,RD2);

Imm_Extend immExt(Immidiate,ImmSrc,ImmExt);

mux2to1 SrcB_mux(RD2,ImmExt,ALUSrc,SrcB);

ALU alu(SrcA,SrcB,ALUControl,ALUResult,Zero);

Adder PCJump(PC,ImmExt,PCTarget);

Data_Memory Data_Mem(clk,MemWrite,ALUResult,WriteData,ReadData);

mux4to1 Result_mux(ALUResult,ReadData,PCPlus4,ImmExt,ResultSrc,Result);


endmodule

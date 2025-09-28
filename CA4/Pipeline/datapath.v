module Datapath(
	input clk,reset,MemWriteD,ALUSrcD,RegWriteD,luiD,
	input [1:0] ResultSrcD,PCSrcE,
	input [2:0] ALUControlD,ImmSrcD,
	output [6:0] opc,opcE,funct7,
    output [2:0]funct3,funct3E,
    output ZeroE
);

wire [31:0] InstrF,InstrD;
wire [4:0] Rs1D, Rs2D, RdD;             
wire [31:0] PCF_next,PCF,PCPlus4F,PCPlus4D,PCPlus4E,PCPlus4M,PCPlus4W;          
wire [31:0] PCTargetE;    
wire [31:7] Immidiate;                                            
wire [31:0] ALUResultE;                      
wire [31:0] PCD, PCE;
wire [31:0] RD1D, RD2D;
wire [31:0] ImmExtD;
wire [31:0] ImmExtE;
wire [31:0] ImmExtM;
wire [31:0] ImmExtW;
wire [31:0] ResultW;
wire [31:0] ALUResultW, ReadDataW;
wire [31:0] WriteDataE;
wire [31:0] SrcAE, SrcBE0, SrcBE;
wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;
wire MemWriteE, MemWriteM;
wire ALUSrcE;
wire [2:0] ALUControlE;
wire [31:0] RD1E, RD2E;
wire [4:0] Rs1E, Rs2E, RdE, RdM, RdW;
wire [31:0] ALUResultM,ReadDataM;
wire [31:0] WriteDataM;
wire luiE,luiM;

wire StallF,StallD,FlushD,FlushE;
wire [1:0] ForwardAE,ForwardBE;

assign opc=InstrD[6:0];
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD = InstrD[11:7];
assign funct3=InstrD[14:12];
assign funct7=InstrD[31:25];
assign Immidiate = InstrD[31:7];


Hazard_unit hu( reset,RegWriteM,RegWriteW,luiM,PCSrcE,ResultSrcE,
 Rs1D,Rs2D,RdE,Rs1E,Rs2E,RdM,RdW, StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE);



mux4to1 PC_next(PCPlus4F,PCTargetE,ALUResultE,32'b0,PCSrcE,PCF_next);

register #(32) PC_reg(clk,~StallF,reset,0,PCF_next,PCF);

Instruction_Memory Instruction_Mem(clk,PCF,InstrF);

Adder PCPlus4_adder(PCF,32'd4,PCPlus4F);

register #(32) D_reg_Instr(clk,~StallD,reset,FlushD,InstrF,InstrD);
register #(32) D_reg_PC(clk,~StallD,reset,FlushD, PCF,PCD );
register #(32) D_reg_PCPlus4(clk,~StallD,reset,FlushD,PCPlus4F,PCPlus4D);




Register_File Reg_File(clk,RegWriteW,Rs1D,Rs2D,RdW,ResultW,RD1D,RD2D);

Imm_Extend immExt(Immidiate,ImmSrcD,ImmExtD);
//////////////////////

register #(1) E_reg_RegWrite(clk,1'b1,reset,FlushE,RegWriteD,RegWriteE);
register #(2) E_reg_ResultSrc(clk,1'b1,reset,FlushE,ResultSrcD,ResultSrcE);
register #(1) E_reg_MemWrite(clk,1'b1,reset,FlushE,MemWriteD,MemWriteE);
register #(2) E_reg_ALUSrc(clk,1'b1,reset,FlushE,ALUSrcD,ALUSrcE);
register #(3) E_reg_ALUControl(clk,1'b1,reset,FlushE,ALUControlD,ALUControlE);
register #(2) E_reg_lui(clk,1'b1,reset,FlushE,luiD,luiE);

register #(32) E_reg_ImmExt(clk,1'b1,reset,0,ImmExtD,ImmExtE);

register #(32) E_reg_RD1(clk,1'b1,reset,FlushE,RD1D,RD1E);
register #(32) E_reg_RD2(clk,1'b1,reset,FlushE, RD2D,RD2E );
register #(32) E_reg_PC(clk,1'b1,reset,FlushE,PCD,PCE);
register #(5) E_reg_Rs1(clk,1'b1,reset,FlushE, Rs1D,Rs1E );
register #(5) E_reg_Rs2(clk,1'b1,reset,FlushE,Rs2D,Rs2E);
register #(5) E_reg_Rd(clk,1'b1,reset,FlushE, RdD,RdE );
register #(32) E_reg_PCPlus4(clk,1'b1,reset,FlushE, PCPlus4D,PCPlus4E);

register #(7) E_reg_opc(clk,1'b1,reset,FlushE,opc,opcE);
register #(3) E_reg_f3(clk,1'b1,reset,FlushE, funct3,funct3E);

///////////////////////


mux4to1 forwardA_mux(RD1E,ResultW,ALUResultM,ImmExtM,ForwardAE,SrcAE);
mux4to1 forwardB_mux(RD2E,ResultW,ALUResultM,ImmExtM,ForwardBE,SrcBE0);

assign WriteDataE = SrcBE0;

mux2to1 SrcB_mux(SrcBE0,ImmExtE,ALUSrcE,SrcBE);





ALU alu(SrcAE,SrcBE,ALUControlE,ALUResultE,ZeroE);

Adder PCJump(PCE,ImmExtE,PCTargetE);



register #(1) M_reg_RegWrite(clk,1'b1,reset,0,RegWriteE,RegWriteM);
register #(2) M_reg_ResultSrc(clk,1'b1,reset,0,ResultSrcE,ResultSrcM);
register #(1) M_reg_MemWrite(clk,1'b1,reset,0,MemWriteE,MemWriteM);

register #(32) M_reg_ALUResult(clk,1'b1,reset,0,ALUResultE,ALUResultM);
register #(32) M_reg_WriteData(clk,1'b1,reset,0, WriteDataE,WriteDataM);
register #(5) M_reg_Rd(clk,1'b1,reset,0,RdE,RdM);
register #(32) M_reg_ImmExt(clk,1'b1,reset,0,ImmExtE,ImmExtM); // in ezafe shod 
register #(32) M_reg_PCPlus4(clk,1'b1,reset,0,PCPlus4E,PCPlus4M);
register #(1) M_reg_lui(clk,1'b1,reset,0,luiE, luiM);




Data_Memory Data_Mem(clk,MemWriteM,ALUResultM,WriteDataM,ReadDataM);



register #(1) W_reg_RegWrite(clk,1'b1,reset,0,RegWriteM,RegWriteW);
register #(2) W_reg_ResultSrc(clk,1'b1,reset,0,ResultSrcM,ResultSrcW);

register #(32) W_reg_ALUResult(clk,1'b1,reset,0,ALUResultM,ALUResultW);
register #(32) W_reg_ReadData(clk,1'b1,reset,0,ReadDataM,ReadDataW);
register #(5) W_reg_Rd(clk,1'b1,reset,0,RdM,RdW);
register #(32) W_reg_ImmExt(clk,1'b1,reset,0,ImmExtM,ImmExtW); // in ezaf shod
register #(32) W_reg_PCPlus4(clk,1'b1,reset,0,PCPlus4M,PCPlus4W);



mux4to1 Result_mux(ALUResultW,ReadDataW,PCPlus4W,ImmExtW,ResultSrcW,ResultW);


endmodule




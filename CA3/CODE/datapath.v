module Datapath(
	input clk,reset, push , pop,IR_write , en2 , en3,write_en , pc_write,old_pc_write, adr_src,
	input [1:0] s1,s2,bus5_src,bus8_src,ALU_control,
    output [2:0] opc,
	output Zero

);

wire [7:0] bus8,SrcA, SrcB, ALUResult , D_in , D_out, ReadData , IR_regout , A_regout, B_regout,ALU_reg_out;
wire [4:0] bus5, PC,old_PC, Addr;




assign opc= IR_regout[7:5];
assign Zero = ~(|D_out);

assign D_in=bus8;

register #(5) PC_reg(clk, pc_write , reset, bus5, PC);
register #(5) old_PC_reg(clk, old_pc_write , reset, PC, old_PC);
register IR_reg(clk, IR_write , reset, bus8 , IR_regout);
register A_reg(clk, en3 , reset, bus8, A_regout);
register B_reg(clk, en2 , reset, bus8, B_regout);
register ALU_reg(clk,1,reset,ALUResult, ALU_reg_out);




mux2to1 Addr_src_mux(PC, bus5 ,adr_src, Addr);


mux4to1 bus5_src_mux(IR_regout[4:0], ALU_reg_out[4:0],ALUResult[4:0],0, bus5_src, bus5);
mux4to1 bus8_src_mux(ReadData ,D_out , ALUResult , 0 ,bus8_src , bus8);  
mux4to1 SrcB_mux(B_regout ,8'b00000001 ,{3'b0,bus5} , 0, s2,SrcB);     
mux4to1 SrcA_mux(A_regout, {3'b0,PC} ,{3'b0,old_PC}, 0 , s1, SrcA);		


ALU alu(SrcA, SrcB, ALU_control, ALUResult);

Data_Memory Data_Mem(clk, write_en ,Addr , bus8 ,ReadData);

Stack stack(clk,reset,push,pop,bus8,D_out);


endmodule


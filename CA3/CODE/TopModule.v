module TopModule(input clk,reset);


wire push, pop, IR_write, en2, en3, write_en, pc_write, old_pc_write,  adr_src;
wire [1:0] s1, s2,bus5_src, bus8_src, ALU_control;
wire [2:0] opc;
wire Zero;

Datapath dp(clk,reset,push,pop,IR_write,en2,en3,write_en,pc_write,old_pc_write,adr_src,s1,s2,bus5_src,bus8_src,ALU_control,opc,Zero);

Controller cu(clk,reset,opc,Zero,push,pop,IR_write,en2,en3,write_en,pc_write,old_pc_write,adr_src,s1,s2,bus5_src,bus8_src,ALU_control);

endmodule

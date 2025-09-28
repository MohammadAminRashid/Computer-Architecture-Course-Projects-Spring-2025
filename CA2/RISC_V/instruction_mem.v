module Instruction_Memory(input clk,
input [31:0] PC,
output reg [31:0] instr
);

	reg [7:0] inst_memory[0:256];
	wire [31:0] adress ;
	assign adress = {PC[31:2], 2'b00}; 

	initial begin
    	$readmemh("instruction_memory.mem", inst_memory);
	end

	assign instr = {inst_memory[adress + 3], inst_memory[adress + 2], inst_memory[adress + 1], inst_memory[adress]};

endmodule
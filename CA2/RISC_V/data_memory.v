module Data_Memory(input clk, write_en,
	input [31:0] adress,write_data,
	output reg [31:0] data_out
);

	reg [7:0] memory[0:256];
	reg [31:0] word_adress ;
	assign word_adress = {adress[31:2], 2'b00}; 

	initial begin
    	$readmemh("data_memory.mem", memory);
	end

	assign data_out = {memory[word_adress + 3], memory[word_adress + 2], memory[word_adress + 1], memory[word_adress]};

 	always @(posedge clk) begin 
    
    	if(write_en)begin
        	{memory[word_adress + 3], memory[word_adress + 2], memory[word_adress + 1], memory[word_adress]} <= write_data;
    	end
  	end
endmodule
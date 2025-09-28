module Data_Memory(
	input clk, write_en,
	input [4:0] adress,
	input [7:0] write_data,
	output reg [7:0] data_out
);

	reg [7:0] memory[0:31]; 

	initial begin
    	$readmemb("data_memory.mem", memory);
	end

	assign data_out = memory[adress] ;

 	always @(posedge clk) begin 
    
    	if(write_en)begin
        	memory[adress] <= write_data;
    	end
  	end
endmodule
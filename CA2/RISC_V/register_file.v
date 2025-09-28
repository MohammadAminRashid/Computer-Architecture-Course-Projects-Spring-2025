module Register_File(
	input clk,write_en,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	input [31:0] write_data,
	output reg [31:0] RD1,
	output reg [31:0] RD2
);

	reg [31:0] regs [0:31];

	 

	assign RD1 = regs[A1];
	assign RD2 = regs[A2];

 	always @(posedge clk) begin 

    	if(write_en && (|A3))begin
        	regs[A3] <= write_data;
    	end
		regs[0]=32'b0;
	end 
endmodule
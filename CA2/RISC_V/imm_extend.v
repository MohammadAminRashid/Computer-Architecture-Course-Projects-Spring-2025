`define I_Type	3'b000             
`define S_Type	3'b001            
`define B_Type	3'b010   
`define J_Type	3'b011                 
`define U_Type	3'b100    


module Imm_Extend(
	input [31:7] immidiate,
	input [2:0] immsrc,
	output reg [31:0] immext
);

always @(immidiate,immsrc) begin 

    case(immsrc)

    	`I_Type: immext={ {20{immidiate[31]}} , immidiate[31:20] };
    	`S_Type: immext={ {20{immidiate[31]}} , immidiate[31:25] , immidiate[11:7]  };
    	`B_Type: immext={ {19{immidiate[31]}} , immidiate[31], immidiate[7] , immidiate[30:25] , immidiate[11:8] , 1'b0};
    	`J_Type: immext={ {11{immidiate[31]}} , immidiate[31], immidiate[19:12] , immidiate[20] , immidiate[30:21] , 1'b0};
		`U_Type: immext={immidiate[31:12] ,  {12{1'b0}} };
    	default: immext =32'b0;

    endcase

  end

endmodule
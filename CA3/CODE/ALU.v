`define ADD           2'b00            
`define SUB           2'b01            
`define AND           2'b10   
`define NOT           2'b11                 
                  

module ALU(
input [7:0] inp1,inp2,
input [1:0] ALU_control,

output reg [7:0] out
);


 always @(inp1,inp2,ALU_control) begin 

    case(ALU_control)

    `ADD: out=inp1 + inp2;
    `SUB: out=inp1 - inp2;
    `AND: out=inp1 & inp2;
    `NOT : out= ~ inp2 ;
    default:out=8'b0;

    endcase

  end


endmodule







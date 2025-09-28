`define ADD           3'b000             
`define SUB           3'b001            
`define AND           3'b010   
`define OR            3'b011                 
`define SLT           3'b101                     

module ALU(
input [31:0] inp1,inp2,
input [2:0] ALU_control,

output reg [31:0] out,
output zero
);

assign zero= ~(|out);
 always @(inp1,inp2,ALU_control) begin 

    case(ALU_control)

    `ADD: out=inp1 + inp2;
    `SUB: out=inp1 - inp2;
    `AND: out=inp1 & inp2;
    `OR: out=inp1 | inp2;
    `SLT: out= (inp1 < inp2) ? 32'd1 : 32'b0 ;
    default:out=32'b0;

    endcase

  end


endmodule







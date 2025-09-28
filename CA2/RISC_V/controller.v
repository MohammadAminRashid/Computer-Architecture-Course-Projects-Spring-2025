`define R_TYPE   7'b0110011             
`define I_TYPE   7'b0010011            
`define LW       7'b0000011   
`define JALR     7'b1100111                 
`define S_TYPE   7'b0100011                     
`define B_TYPE   7'b1100011
`define U_TYPE   7'b0110111 
`define J_TYPE   7'b1101111


module Controller(
    input [6:0] opcode,
    input [2:0] f3,
    input [6:0] f7,
    input zero,
    output reg RegWrite,
    output reg [2:0] ImmSrc,
    output reg ALUSrc,
    output reg MemWrite,
    output reg [1:0] ResultSrc,
    output reg [2:0] ALUControl,
    output reg [1:0] PCSrc
);


wire [1:0] B;
assign B[0]=zero ^ f3[0];
assign B[1]=0;
reg [1:0] ALUOpc;





always @(opcode,B) begin


    case (opcode)

    	`R_TYPE: begin
       	 	RegWrite   <= 1;
            ALUSrc     <= 0;
            MemWrite   <= 0;
            ResultSrc  <= 2'b00;
            ALUOpc     <= 2'b10;
            PCSrc      <= 2'b00;
            ImmSrc     <= 3'b000;
        end

        `I_TYPE: begin
     
			RegWrite   <= 1;
            ALUSrc     <= 1;
            MemWrite   <= 0;
            ResultSrc  <= 2'b00;
            ALUOpc     <= 2'b10;
            PCSrc      <= 2'b00;
            ImmSrc     <= 3'b000;
        end

        `LW: begin

        	RegWrite   <= 1;
        	ALUSrc     <= 1;
            MemWrite   <= 0;
            ResultSrc  <= 2'b01;
            ALUOpc     <= 2'b00;
            PCSrc      <= 2'b00;
            ImmSrc     <= 3'b000;
        end
		
		`JALR: begin

        	RegWrite   <= 1;
            ALUSrc     <= 1;
            MemWrite   <= 1;
            ResultSrc  <= 2'b10;
            ALUOpc     <= 2'b00;
            PCSrc      <= 2'b10;
            ImmSrc     <= 3'b000;
        end

        `S_TYPE: begin

         	RegWrite   <= 0;
            ALUSrc     <= 1;
            MemWrite   <= 1;
            ResultSrc  <= 2'b00;
            ALUOpc     <= 2'b00;
            PCSrc      <= 2'b00;
            ImmSrc     <= 3'b001;
        end

        `B_TYPE: begin
  
            RegWrite   <= 0;
            ALUSrc     <= 0;
            MemWrite   <= 0;
            ResultSrc  <= 2'b00;
            ALUOpc     <= 2'b01;
            PCSrc      <= B;
            ImmSrc     <= 3'b010;
        end

        `J_TYPE: begin

         	RegWrite   <= 1;
            ALUSrc     <= 0;
            MemWrite   <= 0;
            ResultSrc  <= 2'b10;
            ALUOpc     <= 2'b00;
            PCSrc      <= 2'b01;
            ImmSrc     <= 3'b011;
        end

        `U_TYPE: begin

        	RegWrite   <= 1;
            ALUSrc     <= 0;
            MemWrite   <= 0;
            ResultSrc  <= 2'b11;
            ALUOpc     <= 2'b00;
            PCSrc      <= 2'b00;
            ImmSrc     <= 3'b100;
        end

        default: begin

        	RegWrite   <= 0;
            ALUSrc     <= 0;
            MemWrite   <= 0;
            ResultSrc  <= 2'b00;
            ALUOpc     <= 2'b00;
           	PCSrc      <= 2'b00;
            ImmSrc     <= 3'b000;
        end

    endcase

end


always @(ALUOpc , f3 , f7) begin

    case (ALUOpc)

        2'b00: begin
        	ALUControl <= 3'b000;
        end

        2'b01: begin
        	ALUControl <= 3'b001;
        end

        2'b10: begin

                case(f3)

                   3'b000:begin

                       if(f7==7'b0100000)begin

                           ALUControl <= 3'b001;
                        
                           end

                       else begin

                           ALUControl <= 3'b000;

                       end

                   end

                   3'b111:begin
                        ALUControl <= 3'b010;
                   end
        
                   3'b110:begin
                        ALUControl <= 3'b011;          
                   end

                   3'b010:begin
                   		ALUControl <= 3'b101;           
                   end

				endcase
		end

        default: begin
            ALUControl <= 3'b000;
        end

    endcase

end


endmodule
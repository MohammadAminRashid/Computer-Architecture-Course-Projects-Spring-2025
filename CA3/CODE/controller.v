`define IF                  4'b0000             
`define ID                  4'b0001             
`define PUSH                4'b0010   
`define FIRST_POP           4'b0011                
`define POP                 4'b0100                     
`define JUMP                4'b0101
`define SAVE_B              4'b0110 
`define SECOND_POP          4'b0111 
`define SAVE_A              4'b1000
`define CALCULATION         4'b1001           

module Controller(

    input clk,reset,
    input [2:0] opc,
	input Zero,

    output reg  push , pop,IR_write , en2 , en3,write_en , pc_write,old_pc_write,adr_src,
    output reg [1:0] s1,s2, bus5_src,bus8_src,ALU_control
);

 reg [3:0] pstate;
 reg [3:0] nstate;

 always @(posedge clk or posedge reset) begin
    if (reset)
    pstate <= `IF;
    else 
    pstate <= nstate;
 end

always @(pstate or opc or Zero) begin
  case (pstate)
    `IF:    

     	nstate = `ID;

    `ID:    
   
     	begin
        	if (opc == 3'b100)
            	nstate = `PUSH;
        	else if (opc == 3'b111 && !Zero)
                nstate = `IF;
            else if ((opc == 3'b111 && Zero) || opc == 3'b110)
                nstate = `JUMP;
            else
                nstate = `FIRST_POP;
        end

    `PUSH:      

     	nstate = `IF;

    `FIRST_POP: 

     	begin
        	if (opc == 3'b101)
            	nstate = `POP;
            else
            	nstate = `SAVE_B;
        end

    `SECOND_POP:   

     	nstate = `SAVE_A;

    `SAVE_A:
   
     	nstate = `CALCULATION;

    `SAVE_B:

     	begin
        	if(opc == 3'b011)
            	nstate = `CALCULATION;
            else
                nstate = `SECOND_POP;
        end 
    
    `POP:    
    
        nstate = `IF;

    `JUMP:  
   
         nstate = `IF;

    `CALCULATION:

        nstate = `IF;

     default:    
        nstate = `IF;

  endcase
end


always @(pstate) begin
  {push, pop, IR_write, en2, en3, write_en, pc_write,old_pc_write,  adr_src} = 9'b0;
  s2 = 2'b00;
  s1 = 2'b00;
  bus8_src = 2'b00;
  bus5_src=2'b00;
  ALU_control = 2'b00;

  case (pstate)
    `IF: begin
			bus8_src = 2'b00;
			adr_src = 0;
 			IR_write = 1;
			s1 = 2'b01;
			s2 = 2'b01;
			pc_write = 1;
			ALU_control = 2'b00;
			bus5_src = 2'b10;
			old_pc_write = 1;
    end

    `ID: begin
			s1 = 2'b10;
			s2 = 2'b10;
			bus5_src = 2'b00;
			ALU_control = 2'b00;
    end

    `PUSH: begin
			bus5_src = 2'b00;
			adr_src = 1;
    		bus8_src = 2'b00;
			push = 1;
    end

    `FIRST_POP: begin
 			pop = 1;

    end

    `SECOND_POP: begin
			pop = 1;
    end

    `SAVE_A: begin
			bus8_src = 2'b01;		
			en3 = 1;
    end

    `SAVE_B: begin
			bus8_src = 2'b01;		
			en2 = 1;
    end

    `POP: begin
			bus8_src = 2'b01; 	
			bus5_src = 2'b00;
			adr_src = 1;
			write_en = 1;
    end

    `JUMP: begin
			bus5_src = 2'b01;
			pc_write = 1;			
    end

    `CALCULATION: begin
			ALU_control = opc[1:0];
			s1 = 2'b00;
			s2 = 2'b00;
			push = 1;
			bus8_src = 2'b10;
    end

  endcase

end
 
endmodule

module mux2to1 #(parameter N = 8) (
    input [N-1:0] A, B,   
    input select,            
    output [N-1:0] Y     
);
    assign Y = select ? B : A; 
endmodule


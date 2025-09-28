module Adder #(parameter N = 32) (
    input [N-1:0] A, B,       
    output [N-1:0] result 
);

    assign  result = A + B;

endmodule

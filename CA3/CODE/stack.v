module Stack #(parameter WIDTH = 8,parameter DEPTH = 256 ,parameter N = 8)(
    input clk, reset , push , pop ,
    input [WIDTH - 1:0] stack_in ,
    output reg [WIDTH - 1:0] stack_out
);

 reg [WIDTH - 1:0] stack [0:DEPTH - 1];
 reg [N-1:0] size;


 always @(posedge clk or posedge reset) begin
    if(reset)begin
        size <= 0;
    end
    
    else if (push) begin
        stack[size]<= stack_in;
        size<= size+1;
    end
    else if (pop)begin
        stack_out=stack[size-1];
        stack[size-1]=8'bz ;
        size= size-1;
    end
    else begin
    

    stack_out=stack[size-1];

    end

 end
endmodule


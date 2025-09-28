module MazeMemory #(parameter N=16 , B=4) (
    input clk, D_in, Read, Write,
    input [B-1:0] X, Y,
    output reg D_out
);
    
    reg [0:N-1] memory[0:N-1];

  

    initial begin
        $readmemh("maze.txt", memory);
    end

  always @(posedge clk, posedge Read) begin //posedge read
       if(Write)
              memory[X][Y]<=D_in;    //X is ROW and Y is COLUMN
       
       else if(Read) 
            D_out<=memory[X][Y];
  end
endmodule


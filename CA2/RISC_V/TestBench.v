`timescale 1ns/1ns

module RISC_V_TB();
    reg clk, reset;


    RISC_V risc_v(clk,reset);


    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #3 reset = 1'b1;
        #7 reset = 1'b0;
        #2000 $stop;
    end
    
endmodule

`timescale 1ns/1ns

module MULTI_CYCLE_TB();
    reg clk, reset;


    TopModule MULTI_CYCLE_UUT(clk,reset);


    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        #1 reset = 1'b1;
        #2 reset = 1'b0;
        #2000 $stop;
    end
    
endmodule

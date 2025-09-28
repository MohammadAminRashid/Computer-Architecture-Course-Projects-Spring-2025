module register #(parameter N=4)(
    input clk,load , reset,
	input [N-1:0] init_value,
    input [N-1:0] par_load,
    output reg [N-1:0] W
);

    always @(posedge clk) begin 
        if (reset) 
            W <= init_value;
        else if (load) 
            W <= par_load;
    end
endmodule

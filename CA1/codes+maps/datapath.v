module DataPath(
    input clk, en_counter,reverse,reset_reg,reset_counter,reset_stack , reset_queue , read_start , D_out, load_row , load_col , load_counter,
    input stack_push, stack_pop, enqueue,Write,
    output can_move,co,is_goal,empty_stack,read_path_finished,
    output [3:0] X,Y,
	output [1:0] move
);

wire [3:0] p[1:2];
wire [3:0] W_row, W_col, out_mux1, result;
wire [1:0] W, stack_out;
wire select, add_sub;



assign is_goal = (&W_col) & (~|W_row);
assign select = W[0] ^ W[1];
assign add_sub= W[0] ^ reverse;


register row (clk, load_row, reset_reg, 4'b1111, p[1], W_row);
register col(clk, load_col, reset_reg, 4'b0000, p[2], W_col);
counter count(clk, reset_counter, load_counter, en_counter, stack_out ,co,W);

mux2to1 mux1(W_row, W_col, select, out_mux1);
mux2to1 mux2(result, W_row, select, p[1]);
mux2to1 mux3(W_col , result, select, p[2]);
mux2to1 mux4(p[1],W_row,Write,X);
mux2to1 mux5(p[2],W_col,Write,Y);

Adder_Subtractor AS(out_mux1, 4'b0001 , add_sub ,result);

CanMove cm(D_out, add_sub , select , W_col , W_row , can_move);

Stack stack(clk, reset_stack, stack_push, stack_pop, W,stack_out, empty_stack );

Queue queue(clk, reset_queue, enqueue , read_start , stack_out , read_path_finished  , move);

endmodule



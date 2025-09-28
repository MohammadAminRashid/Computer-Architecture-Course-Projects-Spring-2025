module CanMove( 
    input D_out, add_sub, select,
    input [3:0] col_reg, row_reg , 
    output cm 
);

assign cm=~(D_out |
   (select & add_sub & (&col_reg))|
   (select & (~add_sub) & (~|col_reg))|
   ((~select) & add_sub & (&row_reg)) |
   ((~select) & (~add_sub) & (~|row_reg)));

endmodule

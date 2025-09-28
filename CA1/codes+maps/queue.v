module Queue #(parameter WIDTH = 2, parameter DEPTH = 256)(
    input clk, rst, enqueue, read_start,
    input [WIDTH-1:0] direction_in,
    output reg read_finished,
    output reg [WIDTH-1:0] d_out
);
    
    reg [WIDTH-1:0] q [0:DEPTH-1];
    reg [DEPTH-1:0] length;
    reg signed [DEPTH:0] ptr;
    reg reading;
    integer file; 



    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ptr <= 0;
            length <= 0;
            read_finished <= 0;
            reading <= 0;
        end 
        else if (enqueue) begin
            q[length] <= direction_in;
            length <= length + 1;
     
        end 
        else if (read_start && !reading) begin
            ptr <= length - 1;
            read_finished <= 0;
			if (!read_finished) begin
                reading <= 1;
				file = $fopen("output.txt", "w");
            end
	
			
			
        end 
        else if (reading) begin
            if (ptr >= 0) begin
                d_out <= q[ptr];


                case (q[ptr])
                    2'b00: $fdisplay(file, "00 up");
                    2'b01: $fdisplay(file, "01 right");
                    2'b10: $fdisplay(file, "10 left");
                    2'b11: $fdisplay(file, "11 down");
                endcase

                ptr <= ptr - 1;
            end 
            else begin
                ptr <= length - 1;
                reading <= 0;
                read_finished <= 1;
                d_out = 2'bzz;
                $fclose(file); 
            end
        end
    end
endmodule

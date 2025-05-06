module max (
	clk,
	rst,
	initialize,
	in_data,
	result
);
	parameter D_W = 32;
	input wire clk;
	input wire rst;
	input wire initialize;
	input wire signed [D_W - 1:0] in_data;
	output reg signed [D_W - 1:0] result;
	always @(posedge clk)
		if (rst)
			result <= 0;
		else if (initialize)
			result <= in_data;
		else if (in_data >= result)
			result <= in_data;
		else
			result <= result;
endmodule

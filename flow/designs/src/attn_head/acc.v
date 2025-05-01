module acc (
	clk,
	rst,
	initialize,
	in_data,
	result
);
	parameter D_W = 32;
	parameter D_W_ACC = 32;
	input wire clk;
	input wire rst;
	input wire initialize;
	input wire signed [D_W - 1:0] in_data;
	output reg signed [D_W_ACC - 1:0] result;
	always @(posedge clk)
		if (rst)
			result <= 0;
		else if (initialize)
			result <= in_data;
		else
			result <= result + in_data;
endmodule

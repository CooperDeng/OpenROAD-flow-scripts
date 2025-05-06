module pe (
	clk,
	rst,
	init,
	in_a,
	in_b,
	in_data,
	in_valid,
	out_a,
	out_b,
	out_data,
	out_valid
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	input wire clk;
	input wire rst;
	input wire init;
	input wire signed [D_W - 1:0] in_a;
	input wire signed [D_W - 1:0] in_b;
	input wire signed [D_W_ACC - 1:0] in_data;
	input wire in_valid;
	output reg signed [D_W - 1:0] out_a;
	output reg signed [D_W - 1:0] out_b;
	output reg signed [D_W_ACC - 1:0] out_data;
	output reg out_valid;
	reg signed [D_W_ACC - 1:0] in_data_reg;
	reg signed [D_W_ACC - 1:0] acc_data_reg;
	reg signed [D_W_ACC - 1:0] in_data_reg_1;
	reg out_valid_reg;
	always @(posedge clk)
		if (rst) begin
			out_data <= 0;
			out_valid <= 0;
			in_data_reg <= 0;
			acc_data_reg <= 0;
			out_a <= 0;
			out_b <= 0;
			in_data_reg_1 <= 0;
			out_valid_reg <= 0;
		end
		else begin
			out_a <= in_a;
			out_b <= in_b;
			out_valid_reg <= in_valid;
			in_data_reg_1 <= in_data;
			out_data <= in_data_reg_1;
			out_valid <= out_valid_reg;
			if (init) begin
				out_data <= acc_data_reg;
				acc_data_reg <= in_a * in_b;
				out_valid <= 1;
			end
			else
				acc_data_reg <= acc_data_reg + (in_a * in_b);
		end
endmodule

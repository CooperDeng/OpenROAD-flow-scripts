module exp (
	clk,
	rst,
	in_valid,
	qin,
	qb,
	qc,
	qln2,
	qln2_inv,
	out_valid,
	qout
);
	parameter integer D_W = 32;
	parameter integer FP_BITS = 30;
	input wire clk;
	input wire rst;
	input wire in_valid;
	input wire signed [D_W - 1:0] qin;
	input wire signed [D_W - 1:0] qb;
	input wire signed [D_W - 1:0] qc;
	input wire signed [D_W - 1:0] qln2;
	input wire signed [D_W - 1:0] qln2_inv;
	output wire out_valid;
	output wire signed [D_W - 1:0] qout;
	reg signed [63:0] qp_reg;
	reg signed [63:0] qp_reg_1;
	reg signed [63:0] qp_reg_2;
	reg signed [63:0] ql_reg;
	reg signed [63:0] ql_reg_temp_1;
	reg signed [63:0] ql_reg_temp_2;
	reg signed [63:0] ql_reg_temp_3;
	reg signed [63:0] z_reg;
	reg signed [63:0] z_reg_1;
	reg signed [63:0] z_reg_2;
	reg signed [63:0] z_reg_3;
	reg signed [63:0] z_reg_4;
	reg signed [63:0] z_reg_5;
	reg signed [63:0] z_reg_6;
	reg signed [D_W - 1:0] qin_reg_1;
	reg signed [D_W - 1:0] qin_reg_2;
	reg signed [D_W - 1:0] qln2_reg_1;
	reg signed [D_W - 1:0] qb_reg_1;
	reg signed [D_W - 1:0] qb_reg_2;
	reg signed [D_W - 1:0] qb_reg_3;
	reg signed [D_W - 1:0] qc_reg_1;
	reg signed [D_W - 1:0] qc_reg_2;
	reg signed [D_W - 1:0] qc_reg_3;
	reg signed [D_W - 1:0] qc_reg_4;
	reg signed [D_W - 1:0] qc_reg_5;
	reg signed [63:0] z_reg_actual;
	reg signed [D_W - 1:0] qln2_reg_actual;
	reg signed [D_W - 1:0] qb_reg_actual;
	reg signed [D_W - 1:0] qc_reg_actual;
	reg signed [D_W - 1:0] qin_reg_actual;
	reg out_valid_reg_actual;
	reg out_valid_reg_1;
	reg out_valid_reg_2;
	reg out_valid_reg_3;
	reg out_valid_reg_4;
	reg out_valid_reg_5;
	reg out_valid_reg_6;
	reg out_valid_reg_7;
	reg signed [63:0] mid_reg;
	reg signed [D_W - 1:0] qout_reg;
	reg out_valid_reg;
	assign qout = qout_reg;
	assign out_valid = out_valid_reg;
	always @(posedge clk)
		if (rst) begin
			z_reg <= 0;
			qp_reg <= 0;
			qp_reg_1 <= 0;
			qp_reg_2 <= 0;
			ql_reg <= 0;
			ql_reg_temp_1 <= 0;
			ql_reg_temp_2 <= 0;
			ql_reg_temp_3 <= 0;
			qout_reg <= 0;
			out_valid_reg <= 0;
			z_reg_1 <= 0;
			z_reg_2 <= 0;
			z_reg_3 <= 0;
			z_reg_4 <= 0;
			qin_reg_1 <= 0;
			qin_reg_2 <= 0;
			qln2_reg_1 <= 0;
			qb_reg_1 <= 0;
			qb_reg_2 <= 0;
			qb_reg_3 <= 0;
			qc_reg_1 <= 0;
			qc_reg_2 <= 0;
			qc_reg_3 <= 0;
			qc_reg_4 <= 0;
			qc_reg_5 <= 0;
			out_valid_reg_1 <= 0;
			out_valid_reg_2 <= 0;
			out_valid_reg_3 <= 0;
			out_valid_reg_4 <= 0;
			out_valid_reg_5 <= 0;
			out_valid_reg_6 <= 0;
			out_valid_reg_7 <= 0;
			out_valid_reg_actual <= 0;
			z_reg_actual <= 0;
			qln2_reg_actual <= 0;
			qb_reg_actual <= 0;
			qc_reg_actual <= 0;
			qin_reg_actual <= 0;
			mid_reg <= 0;
		end
		else begin
			if (in_valid) begin
				z_reg <= qln2_inv * qin;
				z_reg_1 <= z_reg;
				qln2_reg_1 <= qln2;
				qb_reg_1 <= qb;
				qc_reg_1 <= qc;
				qin_reg_1 <= qin;
				out_valid_reg_1 <= 1;
			end
			else
				out_valid_reg_1 <= 0;
			z_reg_actual <= z_reg >> FP_BITS;
			qln2_reg_actual <= qln2_reg_1;
			qb_reg_actual <= qb_reg_1;
			qc_reg_actual <= qc_reg_1;
			qin_reg_actual <= qin_reg_1;
			out_valid_reg_actual <= out_valid_reg_1;
			mid_reg <= qln2_reg_actual * z_reg_actual;
			z_reg_2 <= z_reg_actual;
			qb_reg_2 <= qb_reg_actual;
			qc_reg_2 <= qc_reg_actual;
			qin_reg_2 <= qin_reg_actual;
			out_valid_reg_2 <= out_valid_reg_actual;
			qp_reg <= qin_reg_2 - mid_reg;
			z_reg_3 <= z_reg_2;
			qb_reg_3 <= qb_reg_2;
			qc_reg_3 <= qc_reg_2;
			out_valid_reg_3 <= out_valid_reg_2;
			ql_reg_temp_1 <= qb_reg_3 + qp_reg;
			out_valid_reg_4 <= out_valid_reg_3;
			qp_reg_2 <= qp_reg;
			qc_reg_4 <= qc_reg_3;
			z_reg_4 <= z_reg_3;
			ql_reg_temp_2 <= ql_reg_temp_1 * qp_reg_2;
			out_valid_reg_5 <= out_valid_reg_4;
			qc_reg_5 <= qc_reg_4;
			z_reg_5 <= z_reg_4;
			ql_reg <= ql_reg_temp_2 + qc_reg_5;
			out_valid_reg_6 <= out_valid_reg_5;
			z_reg_6 <= z_reg_5;
			qout_reg <= ql_reg >> z_reg_6;
			out_valid_reg <= out_valid_reg_6;
		end
endmodule

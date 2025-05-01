module systolic (
	clk,
	rst,
	init,
	A,
	B,
	D,
	valid_D
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer N1 = 8;
	parameter integer N2 = 4;
	input wire clk;
	input wire rst;
	input wire [(N1 * N2) - 1:0] init;
	input wire signed [(N1 * D_W) - 1:0] A;
	input wire signed [(N2 * D_W) - 1:0] B;
	output wire signed [(N1 * D_W_ACC) - 1:0] D;
	output wire [N1 - 1:0] valid_D;
	wire signed [D_W - 1:0] array_a_out [N1 - 1:0][N2 - 1:0];
	wire signed [D_W - 1:0] array_b_out [N1 - 1:0][N2 - 1:0];
	wire signed [D_W_ACC - 1:0] array_out_data [N1 - 1:0][N2 - 1:0];
	wire signed [D_W_ACC - 1:0] array_in_data [N1 - 1:0][N2 - 1:0];
	wire array_in_valid [N1 - 1:0][N2 - 1:0];
	wire array_data_valid [N1 - 1:0][N2 - 1:0];
	reg [(N1 * N2) - 1:0] init_reg;
	reg signed [(N1 * D_W) - 1:0] A_reg;
	reg signed [(N2 * D_W) - 1:0] B_reg;
	always @(posedge clk) begin
		init_reg <= init;
		A_reg <= A;
		B_reg <= B;
	end
	genvar _gv_i_2;
	genvar _gv_j_2;
	generate
		for (_gv_i_2 = 0; _gv_i_2 < N1; _gv_i_2 = _gv_i_2 + 1) begin : row
			localparam i = _gv_i_2;
			assign valid_D[i] = array_data_valid[i][N2 - 1];
			assign D[i * D_W_ACC+:D_W_ACC] = array_out_data[i][N2 - 1];
			for (_gv_j_2 = 0; _gv_j_2 < N2; _gv_j_2 = _gv_j_2 + 1) begin : col
				localparam j = _gv_j_2;
				pe #(
					.D_W(D_W),
					.D_W_ACC(D_W_ACC)
				) pe_inst(
					.clk(clk),
					.rst(rst),
					.init(init_reg[(i * N2) + j]),
					.in_a((j == 0 ? A_reg[i * D_W+:D_W] : array_a_out[i][j - 1])),
					.in_b((i == 0 ? B_reg[j * D_W+:D_W] : array_b_out[i - 1][j])),
					.in_data(array_in_data[i][j]),
					.in_valid(array_in_valid[i][j]),
					.out_a(array_a_out[i][j]),
					.out_b(array_b_out[i][j]),
					.out_data(array_out_data[i][j]),
					.out_valid(array_data_valid[i][j])
				);
			end
		end
		for (_gv_i_2 = 0; _gv_i_2 < N1; _gv_i_2 = _gv_i_2 + 1) begin : row_2
			localparam i = _gv_i_2;
			for (_gv_j_2 = 0; _gv_j_2 < N2; _gv_j_2 = _gv_j_2 + 1) begin : col_2
				localparam j = _gv_j_2;
				if (j == 0) begin : joe
					assign array_in_data[i][j] = 0;
					assign array_in_valid[i][j] = 0;
				end
				else begin : bruh
					assign array_in_data[i][j] = array_out_data[i][j - 1];
					assign array_in_valid[i][j] = array_data_valid[i][j - 1];
				end
			end
		end
	endgenerate
endmodule

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

	wire signed [D_W - 1:0] array_a_out [0:N1*N2-1];
	wire signed [D_W - 1:0] array_b_out [0:N1*N2-1];
	wire signed [D_W_ACC - 1:0] array_out_data [0:N1*N2-1];
	wire signed [D_W_ACC - 1:0] array_in_data [0:N1*N2-1];
	wire array_in_valid [0:N1*N2-1];
	wire array_data_valid [0:N1*N2-1];

	reg [(N1 * N2) - 1:0] init_reg;
	reg signed [(N1 * D_W) - 1:0] A_reg;
	reg signed [(N2 * D_W) - 1:0] B_reg;

	// Zero constant coz of yosys cringeness
	wire signed [D_W_ACC-1:0] zero = 'sd0;

	always @(posedge clk) begin
		init_reg <= init;
		A_reg <= A;
		B_reg <= B;
	end

	genvar i, j;
	generate
		for (i = 0; i < N1; i = i + 1) begin : row
			assign valid_D[i] = array_data_valid[i*N2 + (N2 - 1)];
			assign D[i * D_W_ACC+:D_W_ACC] = array_out_data[i*N2 + (N2 - 1)];

			for (j = 0; j < N2; j = j + 1) begin : col
				localparam int flat_idx = i * N2 + j;

				// hard-coded muxes to avoid signed mismatch
				wire signed [D_W-1:0] in_a_mux = (j == 0) ? A_reg[i * D_W+:D_W] : array_a_out[flat_idx - 1];
				wire signed [D_W-1:0] in_b_mux = (i == 0) ? B_reg[j * D_W+:D_W] : array_b_out[(i - 1) * N2 + j];

				pe #(
					.D_W(D_W),
					.D_W_ACC(D_W_ACC)
				) pe_inst (
					.clk(clk),
					.rst(rst),
					.init(init_reg[flat_idx]),
					.in_a(in_a_mux),
					.in_b(in_b_mux),
					.in_data(array_in_data[flat_idx]),
					.in_valid(array_in_valid[flat_idx]),
					.out_a(array_a_out[flat_idx]),
					.out_b(array_b_out[flat_idx]),
					.out_data(array_out_data[flat_idx]),
					.out_valid(array_data_valid[flat_idx])
				);
			end
		end

		for (i = 0; i < N1; i = i + 1) begin : row_2
			for (j = 0; j < N2; j = j + 1) begin : col_2
				localparam int flat_idx = i * N2 + j;
				if (j == 0) begin
					assign array_in_data[flat_idx] = zero;
					assign array_in_valid[flat_idx] = 1'b0;
				end else begin
					assign array_in_data[flat_idx] = array_out_data[flat_idx - 1];
					assign array_in_valid[flat_idx] = array_data_valid[flat_idx - 1];
				end
			end
		end
	endgenerate
endmodule
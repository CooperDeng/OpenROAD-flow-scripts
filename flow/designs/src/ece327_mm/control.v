module control (
	clk,
	rst,
	M2,
	M1dN1,
	M3dN2,
	M1xM3dN1xN2,
	rd_addr_A,
	rd_addr_B,
	init
);
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer ADDR_W_A = 12;
	parameter integer ADDR_W_B = 12;
	input wire clk;
	input wire rst;
	input wire [MATRIXSIZE_W - 1:0] M2;
	input wire [MATRIXSIZE_W - 1:0] M1dN1;
	input wire [MATRIXSIZE_W - 1:0] M3dN2;
	input wire [MATRIXSIZE_W - 1:0] M1xM3dN1xN2;
	output wire [ADDR_W_A - 1:0] rd_addr_A;
	output wire [ADDR_W_B - 1:0] rd_addr_B;
	output wire [(N1 * N2) - 1:0] init;
	wire [MATRIXSIZE_W - 1:0] pixel_cntr_A;
	wire [MATRIXSIZE_W - 1:0] slice_cntr_A;
	wire [MATRIXSIZE_W - 1:0] pixel_cntr_B;
	wire [MATRIXSIZE_W - 1:0] slice_cntr_B;
	assign rd_addr_A = (slice_cntr_A * M2) + pixel_cntr_A;
	assign rd_addr_B = (pixel_cntr_B * M2) + slice_cntr_B;
	reg [MATRIXSIZE_W - 1:0] e_patch_cntr = 1;
	reg enable_row_count_A = 0;
	always @(posedge clk)
		if (rst) begin
			e_patch_cntr <= 1;
			enable_row_count_A <= 0;
		end
		else if (enable_row_count_A == 1'b1)
			enable_row_count_A <= 0;
		else if ((pixel_cntr_A == (M2 - 2)) && (e_patch_cntr == M3dN2)) begin
			e_patch_cntr <= 1;
			enable_row_count_A <= ~enable_row_count_A;
		end
		else if (pixel_cntr_A == (M2 - 2))
			e_patch_cntr <= e_patch_cntr + 1;
	reg [(N1 + N2) - 1:0] shift = 0;
	reg [MATRIXSIZE_W - 1:0] i_patch_cntr = 0;
	integer r;
	always @(posedge clk)
		if (rst) begin
			shift <= 0;
			i_patch_cntr <= 0;
		end
		else begin
			if ((pixel_cntr_A == (M2 - 1)) && (i_patch_cntr < M1xM3dN1xN2)) begin
				i_patch_cntr <= i_patch_cntr + 1;
				shift[0] <= 1'b1;
			end
			else
				shift[0] <= 0;
			for (r = 1; r < (N1 + N2); r = r + 1)
				shift[r] <= shift[r - 1];
		end
	genvar _gv_i_1;
	genvar _gv_j_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < N1; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			for (_gv_j_1 = 0; _gv_j_1 < N2; _gv_j_1 = _gv_j_1 + 1) begin : genblk1
				localparam j = _gv_j_1;
				assign init[(i * N2) + j] = shift[(i + j) + 1];
			end
		end
	endgenerate
	counter #(.MATRIXSIZE_W(MATRIXSIZE_W)) counter_A(
		.clk(clk),
		.rst(rst),
		.enable_pixel_count(1'b1),
		.enable_slice_count(enable_row_count_A),
		.WIDTH(M2),
		.HEIGHT(M1dN1),
		.pixel_cntr(pixel_cntr_A),
		.slice_cntr(slice_cntr_A)
	);
	counter #(.MATRIXSIZE_W(MATRIXSIZE_W)) counter_B(
		.clk(clk),
		.rst(rst),
		.enable_pixel_count(1'b1),
		.enable_slice_count(1'b1),
		.WIDTH(M2),
		.HEIGHT(M3dN2),
		.pixel_cntr(slice_cntr_B),
		.slice_cntr(pixel_cntr_B)
	);
endmodule

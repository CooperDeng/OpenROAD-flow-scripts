module mem_write (
	clk,
	rst,
	M1xM3dN1,
	in_valid,
	in_data,
	wr_addr_bram,
	wr_data_bram,
	wr_en_bram
);
	parameter integer D_W = 32;
	parameter integer N = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer ADDR_W = 12;
	input wire clk;
	input wire rst;
	input wire [MATRIXSIZE_W - 1:0] M1xM3dN1;
	input wire [N - 1:0] in_valid;
	input wire signed [(N * D_W) - 1:0] in_data;
	output reg [(N * ADDR_W) - 1:0] wr_addr_bram;
	output wire signed [(N * D_W) - 1:0] wr_data_bram;
	output wire [N - 1:0] wr_en_bram;
	assign wr_data_bram = in_data;
	assign wr_en_bram = (rst == 1 ? 0 : in_valid);
	genvar _gv_x_2;
	generate
		for (_gv_x_2 = 0; _gv_x_2 < N; _gv_x_2 = _gv_x_2 + 1) begin : genblk1
			localparam x = _gv_x_2;
			always @(posedge clk)
				if (rst)
					wr_addr_bram[x * ADDR_W+:ADDR_W] <= 0;
				else if (in_valid[x] == 1'b1)
					wr_addr_bram[x * ADDR_W+:ADDR_W] <= (wr_addr_bram[x * ADDR_W+:ADDR_W] < (M1xM3dN1 - 1) ? wr_addr_bram[x * ADDR_W+:ADDR_W] + 1 : 0);
		end
	endgenerate
endmodule

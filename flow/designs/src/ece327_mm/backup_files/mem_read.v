module mem_read (
	clk,
	rd_en,
	rd_addr,
	rd_addr_bram,
	rd_en_bram
);
	parameter integer D_W = 8;
	parameter integer N = 4;
	parameter integer ADDR_W = 12;
	input wire clk;
	input wire rd_en;
	input wire [ADDR_W - 1:0] rd_addr;
	output wire [(N * ADDR_W) - 1:0] rd_addr_bram;
	output wire [N - 1:0] rd_en_bram;
	assign rd_addr_bram[0+:ADDR_W] = rd_addr;
	assign rd_en_bram[0] = rd_en;
	reg [ADDR_W - 1:0] rd_addr_bram_reg [N - 1:0];
	reg [N - 1:0] rd_en_bram_reg;
	genvar _gv_x_1;
	generate
		for (_gv_x_1 = 1; _gv_x_1 < N; _gv_x_1 = _gv_x_1 + 1) begin : genblk1
			localparam x = _gv_x_1;
			always @(posedge clk) begin
				rd_addr_bram_reg[x] <= rd_addr_bram[(x - 1) * ADDR_W+:ADDR_W];
				rd_en_bram_reg[x] <= rd_en_bram[x - 1];
			end
			assign rd_addr_bram[x * ADDR_W+:ADDR_W] = rd_addr_bram_reg[x];
			assign rd_en_bram[x] = rd_en_bram_reg[x];
		end
	endgenerate
endmodule

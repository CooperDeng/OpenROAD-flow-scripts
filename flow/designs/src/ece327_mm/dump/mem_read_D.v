module mem_read_D (
	clk,
	rst,
	M3,
	M1dN1,
	valid_D,
	rd_addr_D,
	activate_D
);
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer ADDR_W = 12;
	input wire clk;
	input wire rst;
	input wire [MATRIXSIZE_W - 1:0] M3;
	input wire [MATRIXSIZE_W - 1:0] M1dN1;
	input wire valid_D;
	output reg [ADDR_W - 1:0] rd_addr_D;
	output reg [N1 - 1:0] activate_D;
	wire [MATRIXSIZE_W - 1:0] half_M3_wire;
	assign half_M3_wire = N2;
	reg [ADDR_W - 1:0] last_base_value_reg;
	reg [ADDR_W - 1:0] value_offset_reg;
	always @(posedge clk)
		if (rst) begin
			rd_addr_D <= 0;
			activate_D <= 0;
			last_base_value_reg <= 0;
		end
		else if (valid_D) begin
			if (activate_D == 0) begin
				rd_addr_D <= half_M3_wire - 1;
				last_base_value_reg <= half_M3_wire - 1;
				value_offset_reg <= 0;
				activate_D <= 1;
			end
			else if (last_base_value_reg < (M3 * M1dN1)) begin
				if (rd_addr_D == (last_base_value_reg - (half_M3_wire - 1))) begin
					if (N2 == M3) begin
						rd_addr_D <= last_base_value_reg;
						activate_D <= activate_D << 1;
					end
					else if (value_offset_reg == 0) begin
						value_offset_reg <= half_M3_wire;
						rd_addr_D <= last_base_value_reg + half_M3_wire;
						last_base_value_reg <= last_base_value_reg + half_M3_wire;
					end
					else begin
						value_offset_reg <= 0;
						if (activate_D == (1 << (N1 - 1))) begin
							last_base_value_reg <= last_base_value_reg + half_M3_wire;
							rd_addr_D <= last_base_value_reg + half_M3_wire;
							activate_D <= 1;
						end
						else begin
							last_base_value_reg <= last_base_value_reg - half_M3_wire;
							rd_addr_D <= last_base_value_reg - half_M3_wire;
							activate_D <= activate_D << 1;
						end
					end
				end
				else
					rd_addr_D <= rd_addr_D - 1;
			end
			else
				activate_D <= 0;
		end
endmodule

module mem_write_B (
	clk,
	rst,
	M2,
	M3dN2,
	valid_B,
	wr_addr_B,
	activate_B
);
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer ADDR_W = 12;
	input wire clk;
	input wire rst;
	input wire [MATRIXSIZE_W - 1:0] M2;
	input wire [MATRIXSIZE_W - 1:0] M3dN2;
	input wire valid_B;
	output reg [ADDR_W - 1:0] wr_addr_B;
	output reg [N2 - 1:0] activate_B;
	reg [ADDR_W - 1:0] last_base_value_reg;
	always @(posedge clk)
		if (rst) begin
			wr_addr_B <= 0;
			activate_B <= 0;
			last_base_value_reg <= 0;
		end
		else if (valid_B) begin
			if (activate_B == 0) begin
				activate_B <= 1;
				wr_addr_B <= 0;
				last_base_value_reg <= 0;
			end
			else if (activate_B == (1 << (N2 - 1))) begin
				if ((wr_addr_B + M2) < (M2 * M3dN2)) begin
					wr_addr_B <= wr_addr_B + M2;
					activate_B <= 1;
				end
				else if (wr_addr_B == ((M2 * M3dN2) - 1)) begin
					wr_addr_B <= M2;
					activate_B <= 0;
				end
				else begin
					wr_addr_B <= last_base_value_reg + 1;
					last_base_value_reg <= last_base_value_reg + 1;
					activate_B <= 1;
				end
			end
			else
				activate_B <= activate_B << 1;
		end
endmodule

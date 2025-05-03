module mem_write_A (
	clk,
	rst,
	M2,
	M1dN1,
	valid_A,
	wr_addr_A,
	activate_A
);
	parameter integer N1 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer ADDR_W = 12;
	input wire clk;
	input wire rst;
	input wire [MATRIXSIZE_W - 1:0] M2;
	input wire [MATRIXSIZE_W - 1:0] M1dN1;
	input wire valid_A;
	output reg [ADDR_W - 1:0] wr_addr_A;
	output reg [N1 - 1:0] activate_A;
	reg [ADDR_W - 1:0] last_base_value_reg;
	reg [N1 - 1:0] cycle_finished_reg;
	always @(posedge clk)
		if (rst) begin
			wr_addr_A <= 0;
			activate_A <= 0;
			cycle_finished_reg <= 0;
		end
		else if (valid_A) begin
			if (activate_A == 0) begin
				activate_A <= 1;
				wr_addr_A <= 0;
				last_base_value_reg <= 0;
			end
			else if (wr_addr_A == (last_base_value_reg + (M2 - 1))) begin
				if (activate_A == (1 << (N1 - 1))) begin
					if (wr_addr_A == ((M2 * M1dN1) - 1)) begin
						activate_A <= 0;
						wr_addr_A <= wr_addr_A + 1;
					end
					else begin
						last_base_value_reg <= wr_addr_A + 1;
						activate_A <= 1;
						wr_addr_A <= wr_addr_A + 1;
					end
				end
				else begin
					activate_A <= activate_A << 1;
					wr_addr_A <= last_base_value_reg;
				end
			end
			else
				wr_addr_A <= wr_addr_A + 1;
		end
endmodule

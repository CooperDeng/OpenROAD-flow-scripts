module sreg (
	clk,
	rst,
	shift_en,
	data_in,
	data_out
);
	parameter integer D_W = 32;
	parameter integer DEPTH = 8;
	input wire clk;
	input wire rst;
	input wire shift_en;
	input wire signed [D_W - 1:0] data_in;
	output reg signed [D_W - 1:0] data_out;
	reg [$clog2(DEPTH) - 1:0] rdaddr;
	reg [$clog2(DEPTH) - 1:0] wraddr;
	(* rom_style = "distributed" *) reg [D_W - 1:0] mem [DEPTH - 1:0];
	always @(posedge clk) begin
		data_out <= mem[rdaddr];
		if (shift_en)
			mem[wraddr] <= data_in;
	end
	always @(posedge clk)
		if (rst) begin
			rdaddr <= 1;
			wraddr <= 0;
		end
		else begin
			if (shift_en) begin
				wraddr <= wraddr + 1;
				if (wraddr == (DEPTH - 1))
					wraddr <= 0;
			end
			if (shift_en) begin
				rdaddr <= rdaddr + 1;
				if (rdaddr == (DEPTH - 1))
					rdaddr <= 0;
			end
		end
endmodule

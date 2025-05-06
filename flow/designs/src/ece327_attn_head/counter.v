module counter (
	clk,
	rst,
	enable_pixel_count,
	enable_slice_count,
	WIDTH,
	HEIGHT,
	pixel_cntr,
	slice_cntr
);
	parameter integer MATRIXSIZE_W = 16;
	input wire clk;
	input wire rst;
	input wire enable_pixel_count;
	input wire enable_slice_count;
	input wire [MATRIXSIZE_W - 1:0] WIDTH;
	input wire [MATRIXSIZE_W - 1:0] HEIGHT;
	output reg [MATRIXSIZE_W - 1:0] pixel_cntr;
	output reg [MATRIXSIZE_W - 1:0] slice_cntr;
	always @(posedge clk)
		if (rst)
			pixel_cntr <= 0;
		else if (enable_pixel_count) begin
			if (pixel_cntr == (WIDTH - 1))
				pixel_cntr <= 0;
			else
				pixel_cntr <= pixel_cntr + 1;
		end
	always @(posedge clk)
		if (rst)
			slice_cntr <= 0;
		else if (enable_slice_count && (pixel_cntr == (WIDTH - 1))) begin
			if (slice_cntr == (HEIGHT - 1))
				slice_cntr <= 0;
			else
				slice_cntr <= slice_cntr + 1;
		end
endmodule

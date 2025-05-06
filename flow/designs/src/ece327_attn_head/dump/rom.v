module rom (
	clk,
	rdaddr,
	rddata
);
	parameter integer D_W = 32;
	parameter integer DEPTH = 768;
	parameter INIT = "NONE";
	input wire clk;
	input wire [$clog2(DEPTH) - 1:0] rdaddr;
	output reg signed [D_W - 1:0] rddata;
	(* rom_style = "distributed" *) reg [D_W - 1:0] mem [DEPTH - 1:0];
	initial if (INIT != "NONE")
		$readmemh(INIT, mem);
	always @(posedge clk) rddata <= mem[rdaddr];
endmodule

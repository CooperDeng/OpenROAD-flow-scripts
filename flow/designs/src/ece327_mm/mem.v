module mem (
	rst,
	clkA,
	clkB,
	weA,
	enA,
	enB,
	addrA,
	addrB,
	dinA,
	doutB
);
	parameter WIDTH = 32;
	parameter DEPTH = 512;
	input wire rst;
	input wire clkA;
	input wire clkB;
	input wire weA;
	input wire enA;
	input wire enB;
	input wire [$clog2(DEPTH) - 1:0] addrA;
	input wire [$clog2(DEPTH) - 1:0] addrB;
	input wire [WIDTH - 1:0] dinA;
	output reg [WIDTH - 1:0] doutB;
	(* ram_style = "block" *) reg [WIDTH - 1:0] mem [0:DEPTH - 1];
	integer r;
	initial for (r = 0; r < (DEPTH - 1); r = r + 1)
		mem[r] = {WIDTH {1'b0}};
	always @(posedge clkA)
		if (enA) begin
			if (weA)
				mem[addrA] <= dinA;
		end
	always @(posedge clkB)
		if (rst)
			doutB <= {WIDTH {1'b0}};
		else if (enB)
			doutB <= mem[addrB];
endmodule

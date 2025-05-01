module div (
	clk,
	rst,
	in_valid,
	divisor,
	divident,
	quotient,
	out_valid
);
	parameter integer D_W = 32;
	input wire clk;
	input wire rst;
	input wire in_valid;
	input wire [D_W - 1:0] divisor;
	input wire [D_W - 1:0] divident;
	output wire [D_W - 1:0] quotient;
	output wire out_valid;
	reg [$clog2(D_W) - 1:0] msb;
	reg [D_W - 1:0] A;
	reg [D_W - 1:0] B;
	reg out_valid_reg;
	reg assign_done;
	reg calculation_done;
	wire [D_W - 1:0] remainder;
	reg [D_W - 1:0] remainder_reg;
	reg [D_W - 1:0] remainder_reg_1;
	reg [D_W - 1:0] remainder_reg_1_1;
	reg [D_W - 1:0] remainder_reg_2;
	reg [D_W - 1:0] remainder_reg_2_2;
	reg [D_W - 1:0] quotient_reg;
	reg [D_W - 1:0] quotient_reg_1;
	reg [D_W - 1:0] quotient_reg_1_1;
	reg [D_W - 1:0] quotient_reg_2;
	reg [D_W - 1:0] quotient_reg_2_2;
	reg [D_W - 1:0] divisor_reg;
	reg [$clog2(D_W) - 1:0] divisor_log2_reg;
	reg [D_W - 1:0] remainder_reg_next;
	reg [D_W - 1:0] quotient_reg_next;
	wire [$clog2(D_W) - 1:0] divisor_log2;
	wire [$clog2(D_W) - 1:0] remainder_log2;
	assign quotient = quotient_reg;
	assign out_valid = out_valid_reg;
	assign remainder = remainder_reg;
	lopd floor_divisor(
		.in_data(divisor),
		.out_data(divisor_log2)
	);
	lopd floor_remainder(
		.in_data(remainder),
		.out_data(remainder_log2)
	);
	reg [31:0] state;
	always @(posedge clk) begin : main_stmc
		if (rst) begin
			out_valid_reg <= 0;
			quotient_reg <= 0;
			remainder_reg_next <= 0;
			remainder_reg <= 0;
			remainder_reg_1 <= 0;
			remainder_reg_2 <= 0;
			quotient_reg_1 <= 0;
			quotient_reg_2 <= 0;
			remainder_reg_1_1 <= 0;
			remainder_reg_2_2 <= 0;
			quotient_reg_1_1 <= 0;
			quotient_reg_2_2 <= 0;
			assign_done <= 0;
			calculation_done <= 0;
			state <= 32'd0;
		end
		else
			case (state)
				32'd0: begin
					out_valid_reg <= 0;
					if (in_valid) begin
						out_valid_reg <= 0;
						quotient_reg <= 0;
						remainder_reg <= divident;
						divisor_reg <= divisor;
						divisor_log2_reg <= divisor_log2;
						remainder_reg_1 <= 0;
						remainder_reg_2 <= 0;
						quotient_reg_1 <= 0;
						quotient_reg_2 <= 0;
						state <= 32'd2;
					end
					else
						state <= 32'd0;
				end
				32'd2: begin
					A <= divisor_reg << (remainder_log2 - divisor_log2);
					B <= divisor_reg << ((remainder_log2 - divisor_log2) - 1);
					quotient_reg_1 <= 1 << ((remainder_log2 - divisor_log2) - 1);
					quotient_reg_2 <= 1 << (remainder_log2 - divisor_log2);
					state <= 32'd1;
				end
				32'd1:
					if (remainder_reg >= divisor_reg) begin
						state <= 32'd2;
						if (remainder < A) begin
							remainder_reg <= remainder_reg - B;
							quotient_reg <= quotient_reg + quotient_reg_1;
						end
						else begin
							remainder_reg <= remainder_reg - A;
							quotient_reg <= quotient_reg + quotient_reg_2;
						end
						assign_done <= 1;
					end
					else begin
						out_valid_reg <= 1;
						state <= 32'd0;
					end
			endcase
	end
endmodule

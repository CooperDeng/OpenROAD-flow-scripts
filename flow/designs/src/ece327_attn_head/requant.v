module requant (
	clk,
	rst,
	A_data_in,
	A_keep_in,
	A_last_in,
	A_valid_in,
	bias_data_in,
	bias_valid_in,
	bias_keep_in,
	M_data_in,
	M_valid_in,
	M_keep_in,
	E_data_in,
	E_valid_in,
	E_keep_in,
	back_ready_in,
	back_ready_out,
	quant_data,
	quant_valid,
	quant_last,
	quant_keep
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	input wire clk;
	input wire rst;
	input wire signed [D_W_ACC - 1:0] A_data_in;
	input wire [3:0] A_keep_in;
	input wire A_last_in;
	input wire A_valid_in;
	input wire signed [D_W_ACC - 1:0] bias_data_in;
	input wire bias_valid_in;
	input wire [3:0] bias_keep_in;
	input wire signed [D_W_ACC - 1:0] M_data_in;
	input wire M_valid_in;
	input wire [3:0] M_keep_in;
	input wire signed [D_W - 1:0] E_data_in;
	input wire E_valid_in;
	input wire [3:0] E_keep_in;
	input wire back_ready_in;
	output wire back_ready_out;
	(* keep = "true" *) output reg signed [D_W - 1:0] quant_data;
	(* keep = "true" *) output reg quant_valid;
	output reg quant_last;
	output reg [3:0] quant_keep;
	localparam SHAMT_SZ = $clog2(2 * D_W_ACC);
	localparam MAX_SHAMT = 1 << SHAMT_SZ;
	reg signed [D_W_ACC - 1:0] bias_data;
	reg bias_valid;
	reg bias_last;
	reg [D_W_ACC - 1:0] A_data_in_reg;
	reg [3:0] A_keep_in_reg;
	reg A_last_in_reg;
	reg A_valid_in_reg;
	reg [D_W_ACC - 1:0] A_data_in_reg_r;
	reg [3:0] A_keep_in_reg_r;
	reg A_last_in_reg_r;
	reg A_valid_in_reg_r;
	always @(posedge clk)
		if (rst) begin
			A_data_in_reg <= 0;
			A_keep_in_reg <= 0;
			A_last_in_reg <= 0;
			A_valid_in_reg <= 0;
			A_data_in_reg_r <= 0;
			A_keep_in_reg_r <= 0;
			A_last_in_reg_r <= 0;
			A_valid_in_reg_r <= 0;
		end
		else begin
			A_data_in_reg_r <= A_data_in;
			A_keep_in_reg_r <= A_keep_in;
			A_last_in_reg_r <= A_last_in;
			A_valid_in_reg_r <= A_valid_in;
			A_data_in_reg <= A_data_in_reg_r;
			A_keep_in_reg <= A_keep_in_reg_r;
			A_last_in_reg <= A_last_in_reg_r;
			A_valid_in_reg <= A_valid_in_reg_r;
		end
	always @(posedge clk)
		if (rst) begin
			bias_data <= 0;
			bias_valid <= 0;
			bias_last <= 0;
		end
		else if ((back_ready_in && bias_valid_in) && A_valid_in_reg) begin
			bias_data <= A_data_in_reg + bias_data_in;
			bias_valid <= 1'b1;
			if (A_last_in_reg)
				bias_last <= 1'b1;
		end
		else begin
			bias_valid <= 1'b0;
			bias_last <= 1'b0;
		end
	reg signed [(2 * D_W_ACC) - 1:0] numerator;
	reg signed [(2 * D_W_ACC) - 1:0] shift_int;
	reg [(2 * D_W_ACC) - 1:0] shift_frac;
	reg valid_r0;
	reg A_last_in_reg_r0;
	reg A_last_in_reg_r1;
	always @(posedge clk)
		if (rst) begin
			numerator <= 0;
			shift_int <= 0;
			shift_frac <= 0;
			quant_last <= 0;
			quant_valid <= 1'b0;
		end
		else begin
			valid_r0 <= 1'b0;
			quant_valid <= 1'b0;
			numerator <= 0;
			shift_int <= 0;
			shift_frac <= 0;
			A_last_in_reg_r0 <= 0;
			A_last_in_reg_r1 <= 0;
			if ((back_ready_in && bias_valid) && M_valid_in) begin
				numerator <= bias_data * M_data_in;
				valid_r0 <= 1'b1;
			end
			if ((back_ready_in && valid_r0) && E_valid_in) begin
				shift_int <= numerator >>> E_data_in;
				shift_frac <= numerator << (MAX_SHAMT - E_data_in);
				quant_valid <= 1'b1;
			end
			A_last_in_reg_r0 <= A_last_in_reg;
			A_last_in_reg_r1 <= A_last_in_reg_r0;
			quant_last <= A_last_in_reg_r1;
		end
	always @(shift_int or shift_frac)
		case ({shift_frac[(2 * D_W_ACC) - 1], |shift_frac[(2 * D_W_ACC) - 2:0]})
			2'b11: quant_data <= shift_int + 1'b1;
			2'b10: quant_data <= (shift_int[0] ? shift_int + 1'b1 : shift_int);
			default: quant_data <= shift_int;
		endcase
	wire [4:1] sv2v_tmp_D2E86;
	assign sv2v_tmp_D2E86 = 4'b1111;
	always @(*) quant_keep = sv2v_tmp_D2E86;
	assign back_ready_out = back_ready_in;
endmodule

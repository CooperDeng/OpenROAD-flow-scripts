module softmax (
	clk,
	rst,
	in_valid,
	qin,
	qb,
	qc,
	qln2,
	qln2_inv,
	Sreq,
	out_valid,
	qout
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer N = 32;
	parameter integer FP_BITS = 30;
	parameter integer MAX_BITS = 30;
	parameter integer OUT_BITS = 6;
	input wire clk;
	input wire rst;
	input wire in_valid;
	input wire signed [D_W_ACC - 1:0] qin;
	input wire signed [D_W_ACC - 1:0] qb;
	input wire signed [D_W_ACC - 1:0] qc;
	input wire signed [D_W_ACC - 1:0] qln2;
	input wire signed [D_W_ACC - 1:0] qln2_inv;
	input wire [D_W_ACC - 1:0] Sreq;
	output wire out_valid;
	output wire signed [D_W - 1:0] qout;
	reg signed [D_W_ACC - 1:0] qin_reg;
	reg signed [D_W - 1:0] qout_reg;
	reg out_valid_reg;
	assign out_valid = out_valid_reg;
	assign qout = qout_reg;
	reg signed [D_W_ACC - 1:0] final_data_out_sreg3_reg;
	reg signed [D_W_ACC - 1:0] final_data_out_sreg3_reg_1;
	reg out_valid_reg_1;
	reg out_valid_reg_2;
	reg out_valid_reg_3;
	reg out_valid_reg_4;
	reg out_valid_reg_5;
	reg out_valid_reg_6;
	reg out_valid_reg_7;
	reg out_valid_reg_8;
	reg out_valid_reg_9;
	reg out_valid_reg_10;
	reg out_valid_reg_11;
	reg out_valid_reg_12;
	reg qsum_complete_reg;
	reg signed [(D_W_ACC * 2) - 1:0] mul_out_reg;
	reg signed [(D_W_ACC * 2) - 1:0] mul_out_reg_1;
	reg signed [(D_W_ACC * 2) - 1:0] last_mul_out_reg;
	reg signed [(D_W_ACC * 2) - 1:0] last_mul_out_reg_1;
	wire signed [FP_BITS - 1:0] fractional_part_wire;
	assign fractional_part_wire = mul_out_reg_1;
	reg [D_W - 1:0] counter1_reg;
	reg [D_W - 1:0] subcounter_reg;
	reg [D_W - 1:0] counter2_reg;
	reg [D_W - 1:0] counter3_reg;
	reg [D_W - 1:0] counter4_reg;
	reg [D_W - 1:0] counter5_reg;
	reg signed [D_W_ACC - 1:0] qmax_reg;
	reg signed [D_W_ACC - 1:0] after_shift_reg;
	wire after_shift_even_check_bit_wire;
	wire [D_W_ACC - 1:0] after_shift_wire;
	assign after_shift_even_check_bit_wire = after_shift_reg[0];
	assign after_shift_wire = mul_out_reg >> FP_BITS;
	wire initialize_max_wire;
	reg initialize_max_reg;
	reg signed [D_W_ACC - 1:0] result_max_reg;
	assign initialize_max_wire = initialize_max_reg;
	wire [D_W_ACC:1] sv2v_tmp_my_max_result;
	always @(*) result_max_reg = sv2v_tmp_my_max_result;
	max #(.D_W(D_W_ACC)) my_max(
		.clk(clk),
		.rst(rst),
		.initialize(initialize_max_wire),
		.in_data(qin),
		.result(sv2v_tmp_my_max_result)
	);
	wire in_valid_exp_wire;
	wire signed [D_W_ACC - 1:0] qin_exp_wire;
	wire signed [D_W_ACC - 1:0] qb_exp_wire;
	wire signed [D_W_ACC - 1:0] qc_exp_wire;
	wire signed [D_W_ACC - 1:0] qln2_exp_wire;
	wire signed [D_W_ACC - 1:0] qln2_inv_exp_wire;
	wire out_valid_exp_wire;
	wire signed [D_W_ACC - 1:0] qout_exp_wire;
	reg in_valid_exp_reg;
	reg signed [D_W_ACC - 1:0] qhat_reg;
	reg signed [D_W_ACC - 1:0] qexp_reg;
	reg signed [D_W_ACC - 1:0] qout_exp_reg;
	assign in_valid_exp_wire = in_valid_exp_reg;
	assign qin_exp_wire = qhat_reg;
	assign qb_exp_wire = qb;
	assign qc_exp_wire = qc;
	assign qln2_exp_wire = qln2;
	assign qln2_inv_exp_wire = qln2_inv;
	exp #(
		.D_W(D_W_ACC),
		.FP_BITS(FP_BITS)
	) my_exp(
		.clk(clk),
		.rst(rst),
		.in_valid(in_valid_exp_wire),
		.qin(qin_exp_wire),
		.qb(qb_exp_wire),
		.qc(qc_exp_wire),
		.qln2(qln2_exp_wire),
		.qln2_inv(qln2_inv_exp_wire),
		.out_valid(out_valid_exp_wire),
		.qout(qout_exp_wire)
	);
	wire initialize_acc_wire;
	wire signed [D_W_ACC - 1:0] in_data_acc_wire;
	reg initialize_acc_reg;
	reg signed [D_W_ACC - 1:0] qreq_reg;
	reg signed [D_W_ACC - 1:0] qsum_reg;
	reg signed [D_W_ACC - 1:0] qsum_valid_reg;
	assign initialize_acc_wire = initialize_acc_reg;
	assign in_data_acc_wire = qreq_reg;
	wire [D_W_ACC:1] sv2v_tmp_my_acc_result;
	always @(*) qsum_reg = sv2v_tmp_my_acc_result;
	acc #(
		.D_W(D_W_ACC),
		.D_W_ACC(D_W_ACC)
	) my_acc(
		.clk(clk),
		.rst(rst),
		.initialize(initialize_acc_wire),
		.in_data(in_data_acc_wire),
		.result(sv2v_tmp_my_acc_result)
	);
	wire in_valid_div_wire;
	wire [D_W_ACC - 1:0] divisor_div_wire;
	wire [D_W_ACC - 1:0] divident_div_wire;
	wire [D_W_ACC - 1:0] quotient_div_wire;
	wire out_valid_div_wire;
	reg in_valid_div_reg;
	reg [D_W_ACC - 1:0] divisor_div_reg;
	reg [D_W_ACC - 1:0] divident_div_reg;
	reg [D_W_ACC - 1:0] factor_reg;
	reg [D_W_ACC - 1:0] quotient_valid_div_reg;
	reg [D_W_ACC - 1:0] quotient_valid_div_reg_1;
	reg [D_W_ACC - 1:0] quotient_valid_div_reg_2;
	assign in_valid_div_wire = in_valid_div_reg;
	assign divisor_div_wire = qsum_valid_reg;
	assign divident_div_wire = 2 << (MAX_BITS - 1);
	div #(.D_W(D_W_ACC)) my_div(
		.clk(clk),
		.rst(rst),
		.in_valid(in_valid_div_wire),
		.divisor(divisor_div_wire),
		.divident(divident_div_wire),
		.quotient(quotient_div_wire),
		.out_valid(out_valid_div_wire)
	);
	wire shift_en_sreg1_wire;
	wire signed [D_W_ACC - 1:0] data_in_sreg1_wire;
	reg shift_en_sreg1_reg;
	reg signed [D_W_ACC - 1:0] data_out_sreg1_reg;
	assign shift_en_sreg1_wire = in_valid || out_valid_reg_1;
	wire [D_W_ACC:1] sv2v_tmp_my_sreg1_data_out;
	always @(*) data_out_sreg1_reg = sv2v_tmp_my_sreg1_data_out;
	sreg #(
		.D_W(D_W_ACC),
		.DEPTH(N)
	) my_sreg1(
		.clk(clk),
		.rst(rst),
		.shift_en(shift_en_sreg1_wire),
		.data_in(qin),
		.data_out(sv2v_tmp_my_sreg1_data_out)
	);
	wire shift_en_sreg2_wire;
	wire signed [D_W_ACC - 1:0] data_in_sreg2_wire;
	reg shift_en_sreg2_reg;
	reg signed [D_W_ACC - 1:0] data_in_sreg2_reg;
	reg signed [D_W_ACC - 1:0] data_out_sreg2_reg;
	assign shift_en_sreg2_wire = out_valid_reg_7 || out_valid_reg_8;
	assign data_in_sreg2_wire = data_in_sreg2_reg;
	wire [D_W_ACC:1] sv2v_tmp_my_sreg2_data_out;
	always @(*) data_out_sreg2_reg = sv2v_tmp_my_sreg2_data_out;
	sreg #(
		.D_W(D_W_ACC),
		.DEPTH(N)
	) my_sreg2(
		.clk(clk),
		.rst(rst),
		.shift_en(shift_en_sreg2_wire),
		.data_in(in_data_acc_wire),
		.data_out(sv2v_tmp_my_sreg2_data_out)
	);
	wire shift_en_sreg3_wire;
	wire signed [D_W_ACC - 1:0] data_in_sreg3_wire;
	reg shift_en_sreg3_reg;
	reg signed [D_W_ACC - 1:0] data_in_sreg3_reg;
	reg signed [D_W_ACC - 1:0] data_out_sreg3_reg;
	assign shift_en_sreg3_wire = shift_en_sreg3_reg;
	assign data_in_sreg3_wire = data_in_sreg3_reg;
	wire [D_W_ACC:1] sv2v_tmp_my_sreg3_data_out;
	always @(*) data_out_sreg3_reg = sv2v_tmp_my_sreg3_data_out;
	sreg #(
		.D_W(D_W_ACC),
		.DEPTH(N)
	) my_sreg3(
		.clk(clk),
		.rst(rst),
		.shift_en(shift_en_sreg3_wire),
		.data_in(data_in_sreg3_wire),
		.data_out(sv2v_tmp_my_sreg3_data_out)
	);
	always @(posedge clk)
		if (rst) begin
			after_shift_reg <= 0;
			qmax_reg <= 0;
			qin_reg <= 0;
			initialize_max_reg <= 0;
			in_valid_exp_reg <= 0;
			qhat_reg <= 0;
			qexp_reg <= 0;
			qout_exp_reg <= 0;
			initialize_acc_reg <= 0;
			qreq_reg <= 0;
			in_valid_div_reg <= 0;
			divisor_div_reg <= 0;
			factor_reg <= 0;
			shift_en_sreg1_reg <= 0;
			shift_en_sreg2_reg <= 0;
			data_in_sreg2_reg <= 0;
			shift_en_sreg3_reg <= 0;
			data_in_sreg3_reg <= 0;
			quotient_valid_div_reg <= 0;
			quotient_valid_div_reg_1 <= 0;
			quotient_valid_div_reg_2 <= 0;
			counter1_reg <= 0;
			subcounter_reg <= 0;
			counter2_reg <= 0;
			counter3_reg <= 0;
			counter4_reg <= 0;
			counter5_reg <= 0;
			out_valid_reg <= 0;
			out_valid_reg_1 <= 0;
			out_valid_reg_2 <= 0;
			out_valid_reg_3 <= 0;
			out_valid_reg_4 <= 0;
			out_valid_reg_5 <= 0;
			out_valid_reg_6 <= 0;
			out_valid_reg_7 <= 0;
			out_valid_reg_8 <= 0;
			out_valid_reg_9 <= 0;
			out_valid_reg_10 <= 0;
			out_valid_reg_11 <= 0;
			out_valid_reg_12 <= 0;
			qsum_complete_reg <= 0;
			mul_out_reg <= 0;
			last_mul_out_reg <= 0;
			last_mul_out_reg_1 <= 0;
			final_data_out_sreg3_reg <= 0;
			final_data_out_sreg3_reg_1 <= 0;
			qsum_valid_reg <= 0;
			qout_reg <= 0;
			mul_out_reg_1 <= 0;
		end
		else begin
			if (in_valid) begin
				shift_en_sreg1_reg <= 1;
				if (counter1_reg == (N - 1)) begin
					counter1_reg <= 0;
					initialize_max_reg <= 1;
					out_valid_reg_1 <= 1;
					qmax_reg <= result_max_reg;
				end
				else begin
					counter1_reg <= counter1_reg + 1;
					initialize_max_reg <= 0;
				end
			end
			else
				shift_en_sreg1_reg <= 0;
			if (out_valid_reg_1) begin
				shift_en_sreg1_reg <= 1;
				if (subcounter_reg == (N - 1)) begin
					subcounter_reg <= 0;
					out_valid_reg_1 <= in_valid;
				end
				else
					subcounter_reg <= subcounter_reg + 1;
			end
			in_valid_exp_reg <= out_valid_reg_1;
			qhat_reg <= data_out_sreg1_reg - qmax_reg;
			out_valid_reg_3 <= out_valid_exp_wire;
			mul_out_reg <= qout_exp_wire * Sreq;
			after_shift_reg <= mul_out_reg >> FP_BITS;
			out_valid_reg_4 <= out_valid_reg_3;
			mul_out_reg_1 <= mul_out_reg;
			if (fractional_part_wire[FP_BITS - 1]) begin
				if (|fractional_part_wire[FP_BITS - 2:0])
					qreq_reg <= after_shift_reg + 1;
				else
					qreq_reg <= after_shift_reg + after_shift_even_check_bit_wire;
			end
			else
				qreq_reg <= after_shift_reg;
			out_valid_reg_7 <= out_valid_reg_4;
			if (out_valid_reg_7) begin
				if (counter2_reg == (N - 1)) begin
					counter2_reg <= 0;
					initialize_acc_reg <= 1;
					qsum_complete_reg <= 1;
					out_valid_reg_8 <= out_valid_reg_7;
				end
				else begin
					counter2_reg <= counter2_reg + 1;
					initialize_acc_reg <= 0;
					qsum_complete_reg <= 0;
				end
			end
			else begin
				initialize_acc_reg <= 1;
				qsum_complete_reg <= 0;
			end
			in_valid_div_reg <= qsum_complete_reg;
			data_in_sreg3_reg <= data_out_sreg2_reg;
			if (out_valid_reg_8) begin
				shift_en_sreg3_reg <= 1;
				if (qsum_complete_reg)
					qsum_valid_reg <= qsum_reg;
				else
					qsum_valid_reg <= qsum_valid_reg;
				if (counter3_reg == (N - 1)) begin
					counter3_reg <= 0;
					out_valid_reg_8 <= out_valid_reg_7;
					out_valid_reg_9 <= out_valid_reg_7;
				end
				else
					counter3_reg <= counter3_reg + 1;
			end
			out_valid_reg_9 <= out_valid_reg_8;
			in_valid_div_reg <= qsum_complete_reg;
			if (out_valid_reg_9) begin
				shift_en_sreg3_reg <= 1;
				if (out_valid_div_wire)
					quotient_valid_div_reg <= quotient_div_wire;
				else
					quotient_valid_div_reg <= quotient_valid_div_reg;
				if (counter4_reg == (N - 1)) begin
					quotient_valid_div_reg_1 <= quotient_valid_div_reg;
					out_valid_reg_10 <= out_valid_reg_9;
					counter4_reg <= 0;
				end
				else
					counter4_reg <= counter4_reg + 1;
			end
			if (out_valid_reg_10) begin
				if (counter5_reg == (N - 1)) begin
					counter5_reg <= 0;
					out_valid_reg_10 <= out_valid_reg_9;
				end
				else
					counter5_reg <= counter5_reg + 1;
			end
			out_valid_reg_11 <= out_valid_reg_10;
			quotient_valid_div_reg_2 <= quotient_valid_div_reg_1;
			final_data_out_sreg3_reg <= data_out_sreg3_reg;
			last_mul_out_reg <= quotient_valid_div_reg_2 * final_data_out_sreg3_reg;
			out_valid_reg_12 <= out_valid_reg_11;
			qout_reg <= last_mul_out_reg >> (MAX_BITS - OUT_BITS);
			out_valid_reg <= out_valid_reg_12;
		end
endmodule

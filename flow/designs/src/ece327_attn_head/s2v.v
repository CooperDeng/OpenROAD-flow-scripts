module s2v (
	clk,
	fclk,
	rst,
	s_axis_s2mm_tdata_bias,
	s_axis_s2mm_tkeep_bias,
	s_axis_s2mm_tlast_bias,
	s_axis_s2mm_tready_bias,
	s_axis_s2mm_tvalid_bias,
	s_axis_s2mm_tdata_M,
	s_axis_s2mm_tkeep_M,
	s_axis_s2mm_tlast_M,
	s_axis_s2mm_tready_M,
	s_axis_s2mm_tvalid_M,
	s_axis_s2mm_tdata_E,
	s_axis_s2mm_tkeep_E,
	s_axis_s2mm_tlast_E,
	s_axis_s2mm_tready_E,
	s_axis_s2mm_tvalid_E,
	bias_data_out,
	M_data_out,
	E_data_out,
	valid_out_bias,
	valid_out_M,
	valid_out_E,
	last_bias,
	last_M,
	last_E,
	back_ready,
	start_read_s2v,
	start_read_mm,
	M1,
	M3
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer MEM_DEPTH = 4096;
	parameter integer MEM_DEPTH_D_A = 4096;
	parameter integer MEM_DEPTH_D_B = 4096;
	input wire clk;
	input wire fclk;
	input wire rst;
	input wire signed [31:0] s_axis_s2mm_tdata_bias;
	input wire [3:0] s_axis_s2mm_tkeep_bias;
	input wire s_axis_s2mm_tlast_bias;
	output reg s_axis_s2mm_tready_bias;
	input wire s_axis_s2mm_tvalid_bias;
	input wire signed [31:0] s_axis_s2mm_tdata_M;
	input wire [3:0] s_axis_s2mm_tkeep_M;
	input wire s_axis_s2mm_tlast_M;
	output reg s_axis_s2mm_tready_M;
	input wire s_axis_s2mm_tvalid_M;
	input wire [31:0] s_axis_s2mm_tdata_E;
	input wire [3:0] s_axis_s2mm_tkeep_E;
	input wire s_axis_s2mm_tlast_E;
	output reg s_axis_s2mm_tready_E;
	input wire s_axis_s2mm_tvalid_E;
	output wire signed [D_W_ACC - 1:0] bias_data_out;
	output wire signed [D_W_ACC - 1:0] M_data_out;
	output wire [D_W - 1:0] E_data_out;
	output reg valid_out_bias;
	output reg valid_out_M;
	output reg valid_out_E;
	output reg last_bias;
	output reg last_M;
	output reg last_E;
	input wire back_ready;
	output wire start_read_s2v;
	input wire start_read_mm;
	input wire [MATRIXSIZE_W - 1:0] M1;
	input wire [MATRIXSIZE_W - 1:0] M3;
	localparam integer ADDR_W = $clog2(MEM_DEPTH);
	reg write_done_bias;
	reg write_done_M;
	reg write_done_E;
	reg write_done;
	reg [1:0] write_done_sync = 0;
	reg done_acc_quant;
	reg [1:0] done_acc_quant_sync = 0;
	reg start_acc_quant;
	reg start_acc_quant_r;
	reg start_acc_quant_r2;
	reg [ADDR_W - 1:0] wr_addr_bias;
	reg [ADDR_W - 1:0] wr_addr_M;
	reg [ADDR_W - 1:0] wr_addr_E;
	wire [ADDR_W - 1:0] rd_addr;
	reg [ADDR_W - 1:0] rd_addr_M;
	reg [ADDR_W - 1:0] rd_addr_E;
	wire [ADDR_W - 1:0] vector_index;
	reg cntr_rst;
	reg pixel_en;
	wire [MATRIXSIZE_W - 1:0] pixel_cntr;
	wire [MATRIXSIZE_W - 1:0] slice_cntr;
	assign rd_addr = pixel_cntr;
	assign vector_index = slice_cntr;
	mem #(
		.WIDTH(D_W_ACC),
		.DEPTH(MEM_DEPTH)
	) read_ram_bias(
		.rst(rst),
		.clkA(clk),
		.clkB(fclk),
		.weA(s_axis_s2mm_tvalid_bias),
		.enA(1'b1),
		.enB(start_acc_quant),
		.addrA(wr_addr_bias),
		.addrB(rd_addr),
		.dinA(s_axis_s2mm_tdata_bias),
		.doutB(bias_data_out)
	);
	mem #(
		.WIDTH(D_W_ACC),
		.DEPTH(MEM_DEPTH)
	) read_ram_M(
		.rst(rst),
		.clkA(clk),
		.clkB(fclk),
		.weA(s_axis_s2mm_tvalid_M),
		.enA(1'b1),
		.enB(start_acc_quant_r),
		.addrA(wr_addr_M),
		.addrB(rd_addr_M),
		.dinA(s_axis_s2mm_tdata_M),
		.doutB(M_data_out)
	);
	mem #(
		.WIDTH(D_W),
		.DEPTH(MEM_DEPTH)
	) read_ram_E(
		.rst(rst),
		.clkA(clk),
		.clkB(fclk),
		.weA(s_axis_s2mm_tvalid_E),
		.enA(1'b1),
		.enB(start_acc_quant_r2),
		.addrA(wr_addr_E),
		.addrB(rd_addr_E),
		.dinA(s_axis_s2mm_tdata_E[D_W - 1:0]),
		.doutB(E_data_out)
	);
	always @(posedge clk)
		if (rst) begin
			s_axis_s2mm_tready_bias <= 1;
			s_axis_s2mm_tready_M <= 1;
			s_axis_s2mm_tready_E <= 1;
			write_done_bias <= 0;
			write_done_M <= 0;
			write_done_E <= 0;
			write_done <= 0;
			wr_addr_bias <= 0;
			wr_addr_M <= 0;
			wr_addr_E <= 0;
		end
		else begin
			case ({s_axis_s2mm_tvalid_bias, s_axis_s2mm_tlast_bias})
				2'b10: wr_addr_bias <= wr_addr_bias + 1;
				2'b11: begin
					wr_addr_bias <= 0;
					write_done_bias <= 1;
					s_axis_s2mm_tready_bias <= 0;
				end
				default: begin
					wr_addr_bias <= wr_addr_bias;
					write_done_bias <= write_done_bias;
					s_axis_s2mm_tready_bias <= s_axis_s2mm_tready_bias;
				end
			endcase
			case ({s_axis_s2mm_tvalid_M, s_axis_s2mm_tlast_M})
				2'b10: wr_addr_M <= wr_addr_M + 1;
				2'b11: begin
					wr_addr_M <= 0;
					write_done_M <= 1;
					s_axis_s2mm_tready_M <= 0;
				end
				default: begin
					wr_addr_M <= wr_addr_M;
					write_done_M <= write_done_M;
					s_axis_s2mm_tready_M <= s_axis_s2mm_tready_M;
				end
			endcase
			case ({s_axis_s2mm_tvalid_E, s_axis_s2mm_tlast_E})
				2'b10: wr_addr_E <= wr_addr_E + 1;
				2'b11: begin
					wr_addr_E <= 0;
					write_done_E <= 1;
					s_axis_s2mm_tready_E <= 0;
				end
				default: begin
					wr_addr_E <= wr_addr_E;
					write_done_E <= write_done_E;
					s_axis_s2mm_tready_E <= s_axis_s2mm_tready_E;
				end
			endcase
			if (write_done) begin
				write_done <= 0;
				write_done_bias <= 0;
				write_done_M <= 0;
				write_done_E <= 0;
			end
			if (done_acc_quant_sync[1]) begin
				s_axis_s2mm_tready_bias <= 1;
				s_axis_s2mm_tready_M <= 1;
				s_axis_s2mm_tready_E <= 1;
			end
			else if ((write_done_bias && write_done_M) && write_done_E)
				write_done <= 1;
		end
	always @(posedge fclk) write_done_sync <= {write_done_sync[0], write_done};
	always @(posedge clk) done_acc_quant_sync <= {done_acc_quant_sync[0], done_acc_quant};
	reg [1:0] done_acc_quant_pulse;
	always @(posedge fclk)
		if (rst) begin
			start_acc_quant <= 0;
			start_acc_quant_r <= 0;
			start_acc_quant_r2 <= 0;
			done_acc_quant <= 0;
			rd_addr_M <= 0;
			rd_addr_E <= 0;
			done_acc_quant_pulse <= 0;
		end
		else begin
			start_acc_quant_r <= start_acc_quant;
			start_acc_quant_r2 <= start_acc_quant_r;
			done_acc_quant_pulse[0] <= (rd_addr == (M3 - 1)) && (vector_index == (M1 - 1));
			done_acc_quant_pulse[1] <= done_acc_quant_pulse[0];
			done_acc_quant <= |done_acc_quant_pulse;
			if (write_done_sync[1])
				start_acc_quant <= 1;
			else if ((rd_addr == (M3 - 1)) && (vector_index == (M1 - 1)))
				start_acc_quant <= 0;
			casez ({start_read_mm, start_acc_quant, back_ready, (rd_addr == (M3 - 1)) && (vector_index == (M1 - 1))})
				4'b1110: {cntr_rst, pixel_en, last_bias} <= 3'b010;
				4'bz111: {cntr_rst, pixel_en, last_bias} <= 3'b101;
				4'bz0z0: {cntr_rst, pixel_en, last_bias} <= 3'b100;
				default: {cntr_rst, pixel_en, last_bias} <= 3'b000;
			endcase
			rd_addr_M <= rd_addr;
			rd_addr_E <= rd_addr_M;
			valid_out_bias <= pixel_en;
			valid_out_M <= valid_out_bias;
			valid_out_E <= valid_out_M;
			last_M <= last_bias;
			last_E <= last_M;
		end
	assign start_read_s2v = start_acc_quant;
	counter #(.MATRIXSIZE_W(MATRIXSIZE_W)) counter_inst(
		.clk(fclk),
		.rst(rst || cntr_rst),
		.enable_pixel_count(pixel_en),
		.enable_slice_count(1'b1),
		.WIDTH(M3),
		.HEIGHT(M1),
		.pixel_cntr(pixel_cntr),
		.slice_cntr(slice_cntr)
	);
endmodule

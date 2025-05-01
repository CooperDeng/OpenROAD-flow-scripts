module s2mm (
	clk,
	fclk,
	rst,
	s_axis_s2mm_tdata_A,
	s_axis_s2mm_tkeep_A,
	s_axis_s2mm_tlast_A,
	s_axis_s2mm_tready_A,
	s_axis_s2mm_tvalid_A,
	s_axis_s2mm_tdata_B,
	s_axis_s2mm_tkeep_B,
	s_axis_s2mm_tlast_B,
	s_axis_s2mm_tready_B,
	s_axis_s2mm_tvalid_B,
	rd_addr_A,
	rd_addr_B,
	A_bram,
	B_bram,
	M2,
	M1dN1,
	M3dN2,
	done_multiply,
	done_read,
	start_multiply
);
	parameter integer D_W = 8;
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer MEM_DEPTH_A = 4096;
	parameter integer MEM_DEPTH_B = 4096;
	parameter integer ADDR_W_A = 12;
	parameter integer ADDR_W_B = 12;
	parameter TRANSPOSE_B = 0;
	input wire clk;
	input wire fclk;
	input wire rst;
	input wire signed [31:0] s_axis_s2mm_tdata_A;
	input wire [3:0] s_axis_s2mm_tkeep_A;
	input wire s_axis_s2mm_tlast_A;
	output reg s_axis_s2mm_tready_A;
	input wire s_axis_s2mm_tvalid_A;
	input wire signed [31:0] s_axis_s2mm_tdata_B;
	input wire [3:0] s_axis_s2mm_tkeep_B;
	input wire s_axis_s2mm_tlast_B;
	output reg s_axis_s2mm_tready_B;
	input wire s_axis_s2mm_tvalid_B;
	input wire [ADDR_W_A - 1:0] rd_addr_A;
	input wire [ADDR_W_B - 1:0] rd_addr_B;
	output wire signed [(N1 * D_W) - 1:0] A_bram;
	output wire signed [(N2 * D_W) - 1:0] B_bram;
	input wire [MATRIXSIZE_W - 1:0] M2;
	input wire [MATRIXSIZE_W - 1:0] M1dN1;
	input wire [MATRIXSIZE_W - 1:0] M3dN2;
	input wire done_multiply;
	input wire done_read;
	output reg start_multiply;
	reg signed [31:0] s_axis_s2mm_tdata_A_r = 0;
	reg s_axis_s2mm_tlast_A_r = 0;
	reg s_axis_s2mm_tvalid_A_r = 0;
	reg signed [31:0] s_axis_s2mm_tdata_B_r = 0;
	reg s_axis_s2mm_tlast_B_r = 0;
	reg s_axis_s2mm_tvalid_B_r = 0;
	reg [MATRIXSIZE_W - 1:0] M2_r = 0;
	reg [MATRIXSIZE_W - 1:0] M1dN1_r = 0;
	reg [MATRIXSIZE_W - 1:0] M3dN2_r = 0;
	reg done_multiply_r = 0;
	always @(posedge clk)
		if (rst) begin
			s_axis_s2mm_tdata_A_r <= 0;
			s_axis_s2mm_tlast_A_r <= 0;
			s_axis_s2mm_tvalid_A_r <= 0;
			s_axis_s2mm_tdata_B_r <= 0;
			s_axis_s2mm_tlast_B_r <= 0;
			s_axis_s2mm_tvalid_B_r <= 0;
		end
		else begin
			s_axis_s2mm_tdata_A_r <= s_axis_s2mm_tdata_A;
			s_axis_s2mm_tlast_A_r <= s_axis_s2mm_tlast_A;
			s_axis_s2mm_tvalid_A_r <= s_axis_s2mm_tvalid_A;
			s_axis_s2mm_tdata_B_r <= s_axis_s2mm_tdata_B;
			s_axis_s2mm_tlast_B_r <= s_axis_s2mm_tlast_B;
			s_axis_s2mm_tvalid_B_r <= s_axis_s2mm_tvalid_B;
		end
	always @(posedge fclk)
		if (rst)
			done_multiply_r <= 0;
		else
			done_multiply_r <= done_multiply;
	always @(posedge clk)
		if (rst) begin
			M2_r <= 0;
			M1dN1_r <= 0;
			M3dN2_r <= 0;
		end
		else begin
			M2_r <= M2;
			M1dN1_r <= M1dN1;
			M3dN2_r <= M3dN2;
		end
	reg tlast_A_flag;
	reg tlast_B_flag;
	reg write_done_A;
	reg write_done_B;
	reg write_done;
	reg write_done_sync_wait;
	reg [1:0] write_done_sync = 0;
	reg [1:0] start_multiply_sync = 0;
	reg [1:0] done_multiply_sync = 0;
	reg [N1 - 1:0] reg_banked_valid_A;
	reg signed [D_W - 1:0] reg_banked_data_A [N1 - 1:0];
	reg [ADDR_W_A - 1:0] reg_banked_write_addr_A [N1 - 1:0];
	reg [N1 - 1:0] reg_banked_activate_A [N1 - 1:0];
	wire signed [D_W - 1:0] A_bram_data [N1 - 1:0];
	wire [N1 - 1:0] activate_A;
	wire [ADDR_W_A - 1:0] wr_addr_A;
	wire [(N1 * ADDR_W_A) - 1:0] rd_addr_A_bram;
	wire [N1 - 1:0] rd_en_A_bram;
	reg [N1 - 1:0] rd_data_valid_A;
	reg [N2 - 1:0] reg_banked_valid_B;
	reg signed [D_W - 1:0] reg_banked_data_B [N2 - 1:0];
	reg [ADDR_W_B - 1:0] reg_banked_write_addr_B [N2 - 1:0];
	reg [N2 - 1:0] reg_banked_activate_B [N2 - 1:0];
	wire signed [D_W - 1:0] B_bram_data [N2 - 1:0];
	wire [N2 - 1:0] activate_B;
	wire [ADDR_W_B - 1:0] wr_addr_B;
	wire [(N2 * ADDR_W_B) - 1:0] rd_addr_B_bram;
	wire [N2 - 1:0] rd_en_B_bram;
	reg [N2 - 1:0] rd_data_valid_B;
	genvar _gv_x_2;
	generate
		for (_gv_x_2 = 0; _gv_x_2 < N1; _gv_x_2 = _gv_x_2 + 1) begin : ram_A
			localparam x = _gv_x_2;
			assign A_bram[x * D_W+:D_W] = (rd_data_valid_A[x] ? A_bram_data[x] : 0);
			mem #(
				.WIDTH(D_W),
				.DEPTH(MEM_DEPTH_A)
			) read_ram_A(
				.rst(rst),
				.clkA(clk),
				.clkB(fclk),
				.weA(reg_banked_valid_A[x]),
				.enA(reg_banked_activate_A[x][x]),
				.enB(rd_en_A_bram[x]),
				.addrA(reg_banked_write_addr_A[x]),
				.addrB(rd_addr_A_bram[x * ADDR_W_A+:ADDR_W_A]),
				.dinA(reg_banked_data_A[x]),
				.doutB(A_bram_data[x])
			);
			always @(posedge fclk) rd_data_valid_A[x] <= rd_en_A_bram[x];
			always @(posedge clk)
				if (x == 0) begin
					reg_banked_valid_A[x] <= s_axis_s2mm_tvalid_A_r;
					reg_banked_data_A[x] <= s_axis_s2mm_tdata_A_r;
					reg_banked_write_addr_A[x] <= wr_addr_A;
					reg_banked_activate_A[x] <= activate_A;
				end
				else begin
					reg_banked_valid_A[x] <= reg_banked_valid_A[x - 1];
					reg_banked_data_A[x] <= reg_banked_data_A[x - 1];
					reg_banked_write_addr_A[x] <= reg_banked_write_addr_A[x - 1];
					reg_banked_activate_A[x] <= reg_banked_activate_A[x - 1];
				end
		end
		for (_gv_x_2 = 0; _gv_x_2 < N2; _gv_x_2 = _gv_x_2 + 1) begin : ram_B
			localparam x = _gv_x_2;
			assign B_bram[x * D_W+:D_W] = (rd_data_valid_B[x] ? B_bram_data[x] : 0);
			mem #(
				.WIDTH(D_W),
				.DEPTH(MEM_DEPTH_B)
			) read_ram_B(
				.rst(rst),
				.clkA(clk),
				.clkB(fclk),
				.weA(reg_banked_valid_B[x]),
				.enA(reg_banked_activate_B[x][x]),
				.enB(rd_en_B_bram[x]),
				.addrA(reg_banked_write_addr_B[x]),
				.addrB(rd_addr_B_bram[x * ADDR_W_B+:ADDR_W_B]),
				.dinA(reg_banked_data_B[x]),
				.doutB(B_bram_data[x])
			);
			always @(posedge fclk) rd_data_valid_B[x] <= rd_en_B_bram[x];
			always @(posedge clk)
				if (x == 0) begin
					reg_banked_valid_B[x] <= s_axis_s2mm_tvalid_B_r;
					reg_banked_data_B[x] <= s_axis_s2mm_tdata_B_r;
					reg_banked_write_addr_B[x] <= wr_addr_B;
					reg_banked_activate_B[x] <= activate_B;
				end
				else begin
					reg_banked_valid_B[x] <= reg_banked_valid_B[x - 1];
					reg_banked_data_B[x] <= reg_banked_data_B[x - 1];
					reg_banked_write_addr_B[x] <= reg_banked_write_addr_B[x - 1];
					reg_banked_activate_B[x] <= reg_banked_activate_B[x - 1];
				end
		end
	endgenerate
	always @(posedge clk)
		if (rst)
			done_multiply_sync <= 0;
		else
			done_multiply_sync <= {done_multiply_sync[0], done_multiply_r};
	always @(posedge clk)
		if (rst) begin
			s_axis_s2mm_tready_A <= 1;
			s_axis_s2mm_tready_B <= 1;
		end
		else begin
			if (s_axis_s2mm_tlast_A_r && s_axis_s2mm_tvalid_A_r)
				s_axis_s2mm_tready_A <= 0;
			else if (done_multiply_sync[1] && ~tlast_A_flag)
				s_axis_s2mm_tready_A <= 1;
			if (s_axis_s2mm_tlast_B_r && s_axis_s2mm_tvalid_B_r)
				s_axis_s2mm_tready_B <= 0;
			else if (done_multiply_sync[1] && ~tlast_B_flag)
				s_axis_s2mm_tready_B <= 1;
		end
	always @(posedge clk)
		if (rst) begin
			tlast_A_flag <= 0;
			tlast_B_flag <= 0;
			write_done_A <= 0;
			write_done_B <= 0;
			write_done <= 0;
		end
		else begin
			if (s_axis_s2mm_tlast_A_r && s_axis_s2mm_tvalid_A_r)
				tlast_A_flag <= 1;
			else if (~reg_banked_valid_A[N1 - 1] && tlast_A_flag)
				write_done_A <= 1;
			if (s_axis_s2mm_tlast_B_r && s_axis_s2mm_tvalid_B_r)
				tlast_B_flag <= 1;
			else if (~reg_banked_valid_B[N2 - 1] && tlast_B_flag)
				write_done_B <= 1;
			if (start_multiply_sync[1]) begin
				write_done <= 0;
				write_done_A <= 0;
				write_done_B <= 0;
				tlast_A_flag <= 0;
				tlast_B_flag <= 0;
			end
			else if (write_done_A && write_done_B)
				write_done <= 1;
		end
	always @(posedge fclk) write_done_sync <= {write_done_sync[0], write_done};
	reg first_batch;
	always @(posedge fclk)
		if (rst) begin
			start_multiply <= 0;
			first_batch <= 1;
		end
		else if (write_done_sync[1] && (done_read || first_batch)) begin
			start_multiply <= 1;
			first_batch <= 0;
		end
		else if (done_multiply_r)
			start_multiply <= 0;
	always @(posedge clk)
		if (rst)
			start_multiply_sync <= 0;
		else
			start_multiply_sync <= {start_multiply_sync[0], start_multiply};
	mem_write_A #(
		.N1(N1),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.ADDR_W(ADDR_W_A)
	) mem_write_A_inst(
		.clk(clk),
		.rst(rst),
		.M2(M2_r),
		.M1dN1(M1dN1_r),
		.valid_A(s_axis_s2mm_tvalid_A & s_axis_s2mm_tready_A),
		.wr_addr_A(wr_addr_A),
		.activate_A(activate_A)
	);
	generate
		if (TRANSPOSE_B) begin : transpose
			mem_write_A #(
				.N1(N2),
				.MATRIXSIZE_W(MATRIXSIZE_W),
				.ADDR_W(ADDR_W_B)
			) mem_write_B_inst(
				.clk(clk),
				.rst(rst),
				.M2(M2_r),
				.M1dN1(M3dN2_r),
				.valid_A(s_axis_s2mm_tvalid_B & s_axis_s2mm_tready_B),
				.wr_addr_A(wr_addr_B),
				.activate_A(activate_B)
			);
		end
		else begin : simple
			mem_write_B #(
				.N2(N2),
				.MATRIXSIZE_W(MATRIXSIZE_W),
				.ADDR_W(ADDR_W_B)
			) mem_write_B_inst(
				.clk(clk),
				.rst(rst),
				.M2(M2_r),
				.M3dN2(M3dN2_r),
				.valid_B(s_axis_s2mm_tvalid_B & s_axis_s2mm_tready_B),
				.wr_addr_B(wr_addr_B),
				.activate_B(activate_B)
			);
		end
	endgenerate
	mem_read #(
		.D_W(D_W),
		.N(N1),
		.ADDR_W(ADDR_W_A)
	) mem_read_A(
		.clk(fclk),
		.rd_addr(rd_addr_A),
		.rd_en(start_multiply),
		.rd_addr_bram(rd_addr_A_bram),
		.rd_en_bram(rd_en_A_bram)
	);
	mem_read #(
		.D_W(D_W),
		.N(N2),
		.ADDR_W(ADDR_W_B)
	) mem_read_B(
		.clk(fclk),
		.rd_addr(rd_addr_B),
		.rd_en(start_multiply),
		.rd_addr_bram(rd_addr_B_bram),
		.rd_en_bram(rd_en_B_bram)
	);
endmodule

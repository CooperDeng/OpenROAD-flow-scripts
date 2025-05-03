module mm (
	mm_clk,
	mm_fclk,
	mm_rst_n,
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
	m_axis_mm2s_tdata,
	m_axis_mm2s_tvalid,
	m_axis_mm2s_tready,
	m_axis_mm2s_tlast,
	m_axis_mm2s_tkeep,
	start_read_s2v,
	M2,
	M3,
	M1xM3dN1,
	M1dN1,
	M3dN2,
	M1xM3dN1xN2
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer MEM_DEPTH_A = 4096;
	parameter integer MEM_DEPTH_B = 4096;
	parameter integer MEM_DEPTH_D = 4096;
	parameter integer TRANSPOSE_B = 0;
	input wire mm_clk;
	input wire mm_fclk;
	input wire mm_rst_n;
	input wire signed [31:0] s_axis_s2mm_tdata_A;
	input wire [3:0] s_axis_s2mm_tkeep_A;
	input wire s_axis_s2mm_tlast_A;
	output wire s_axis_s2mm_tready_A;
	input wire s_axis_s2mm_tvalid_A;
	input wire signed [31:0] s_axis_s2mm_tdata_B;
	input wire [3:0] s_axis_s2mm_tkeep_B;
	input wire s_axis_s2mm_tlast_B;
	output wire s_axis_s2mm_tready_B;
	input wire s_axis_s2mm_tvalid_B;
	(* keep = "true" *) output wire signed [31:0] m_axis_mm2s_tdata;
	(* keep = "true" *) output wire m_axis_mm2s_tvalid;
	input wire m_axis_mm2s_tready;
	output wire m_axis_mm2s_tlast;
	output wire [3:0] m_axis_mm2s_tkeep;
	input wire start_read_s2v;
	input wire [MATRIXSIZE_W - 1:0] M2;
	input wire [MATRIXSIZE_W - 1:0] M3;
	input wire [MATRIXSIZE_W - 1:0] M1xM3dN1;
	input wire [MATRIXSIZE_W - 1:0] M1dN1;
	input wire [MATRIXSIZE_W - 1:0] M3dN2;
	input wire [MATRIXSIZE_W - 1:0] M1xM3dN1xN2;
	localparam integer ADDR_W_A = $clog2(MEM_DEPTH_A);
	localparam integer ADDR_W_B = $clog2(MEM_DEPTH_B);
	localparam integer ADDR_W_D = $clog2(MEM_DEPTH_D);
	wire clk;
	wire fclk;
	wire rst;
	assign clk = ~mm_clk;
	assign fclk = ~mm_fclk;
	assign rst = ~mm_rst_n;
	wire [(N1 * N2) - 1:0] init;
	wire signed [(N1 * D_W) - 1:0] A_bram;
	wire signed [(N2 * D_W) - 1:0] B_bram;
	wire signed [(N1 * D_W_ACC) - 1:0] data_D;
	wire [N1 - 1:0] valid_D;
	wire [ADDR_W_A - 1:0] rd_addr_A;
	wire [ADDR_W_B - 1:0] rd_addr_B;
	wire done_multiply;
	wire start_multiply;
	wire done_read;
	s2mm #(
		.D_W(D_W),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_A),
		.MEM_DEPTH_B(MEM_DEPTH_B),
		.ADDR_W_A(ADDR_W_A),
		.ADDR_W_B(ADDR_W_B),
		.TRANSPOSE_B(TRANSPOSE_B)
	) s2mm_inst(
		.clk(clk),
		.fclk(fclk),
		.rst(rst),
		.s_axis_s2mm_tdata_A(s_axis_s2mm_tdata_A),
		.s_axis_s2mm_tkeep_A(s_axis_s2mm_tkeep_A),
		.s_axis_s2mm_tlast_A(s_axis_s2mm_tlast_A),
		.s_axis_s2mm_tready_A(s_axis_s2mm_tready_A),
		.s_axis_s2mm_tvalid_A(s_axis_s2mm_tvalid_A),
		.s_axis_s2mm_tdata_B(s_axis_s2mm_tdata_B),
		.s_axis_s2mm_tkeep_B(s_axis_s2mm_tkeep_B),
		.s_axis_s2mm_tlast_B(s_axis_s2mm_tlast_B),
		.s_axis_s2mm_tready_B(s_axis_s2mm_tready_B),
		.s_axis_s2mm_tvalid_B(s_axis_s2mm_tvalid_B),
		.rd_addr_A(rd_addr_A),
		.rd_addr_B(rd_addr_B),
		.A_bram(A_bram),
		.B_bram(B_bram),
		.M2(M2),
		.M1dN1(M1dN1),
		.M3dN2(M3dN2),
		.done_multiply(done_multiply),
		.start_multiply(start_multiply),
		.done_read(done_read)
	);
	mm2s #(
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.ADDR_W_D(ADDR_W_D),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_D(MEM_DEPTH_D)
	) mm2s_inst(
		.clk(clk),
		.fclk(fclk),
		.rst(rst),
		.m_axis_mm2s_tdata(m_axis_mm2s_tdata),
		.m_axis_mm2s_tkeep(m_axis_mm2s_tkeep),
		.m_axis_mm2s_tlast(m_axis_mm2s_tlast),
		.m_axis_mm2s_tready(m_axis_mm2s_tready),
		.m_axis_mm2s_tvalid(m_axis_mm2s_tvalid),
		.data_D(data_D),
		.valid_D(valid_D),
		.M3(M3),
		.M1dN1(M1dN1),
		.M1xM3dN1(M1xM3dN1),
		.done_multiply(done_multiply),
		.done_read_pulse(done_read),
		.start_read_s2v(start_read_s2v)
	);
	control #(
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.ADDR_W_A(ADDR_W_A),
		.ADDR_W_B(ADDR_W_B)
	) control_inst(
		.clk(fclk),
		.rst(~start_multiply),
		.M2(M2),
		.M1dN1(M1dN1),
		.M3dN2(M3dN2),
		.M1xM3dN1xN2(M1xM3dN1xN2),
		.rd_addr_A(rd_addr_A),
		.rd_addr_B(rd_addr_B),
		.init(init)
	);
	systolic #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2)
	) systolic_inst(
		.clk(fclk),
		.rst(~start_multiply),
		.init(init),
		.A(A_bram),
		.B(B_bram),
		.D(data_D),
		.valid_D(valid_D)
	);
endmodule

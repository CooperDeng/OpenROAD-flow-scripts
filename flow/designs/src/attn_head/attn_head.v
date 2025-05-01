(* keep_hierarchy = "yes" *) module attn_head (
	attn_clk,
	attn_fclk,
	attn_rst,
	s_axis_s2mm_tdata_I,
	s_axis_s2mm_tkeep_I,
	s_axis_s2mm_tlast_I,
	s_axis_s2mm_tready_I,
	s_axis_s2mm_tvalid_I,
	s_axis_s2mm_tdata_Q,
	s_axis_s2mm_tkeep_Q,
	s_axis_s2mm_tlast_Q,
	s_axis_s2mm_tready_Q,
	s_axis_s2mm_tvalid_Q,
	s_axis_s2mm_tdata_K,
	s_axis_s2mm_tkeep_K,
	s_axis_s2mm_tlast_K,
	s_axis_s2mm_tready_K,
	s_axis_s2mm_tvalid_K,
	s_axis_s2mm_tdata_V,
	s_axis_s2mm_tkeep_V,
	s_axis_s2mm_tlast_V,
	s_axis_s2mm_tready_V,
	s_axis_s2mm_tvalid_V,
	s_axis_s2mm_tdata_bias_Q,
	s_axis_s2mm_tkeep_bias_Q,
	s_axis_s2mm_tlast_bias_Q,
	s_axis_s2mm_tready_bias_Q,
	s_axis_s2mm_tvalid_bias_Q,
	s_axis_s2mm_tdata_bias_K,
	s_axis_s2mm_tkeep_bias_K,
	s_axis_s2mm_tlast_bias_K,
	s_axis_s2mm_tready_bias_K,
	s_axis_s2mm_tvalid_bias_K,
	s_axis_s2mm_tdata_bias_V,
	s_axis_s2mm_tkeep_bias_V,
	s_axis_s2mm_tlast_bias_V,
	s_axis_s2mm_tready_bias_V,
	s_axis_s2mm_tvalid_bias_V,
	s_axis_s2mm_tdata_M_Q,
	s_axis_s2mm_tkeep_M_Q,
	s_axis_s2mm_tlast_M_Q,
	s_axis_s2mm_tready_M_Q,
	s_axis_s2mm_tvalid_M_Q,
	s_axis_s2mm_tdata_M_K,
	s_axis_s2mm_tkeep_M_K,
	s_axis_s2mm_tlast_M_K,
	s_axis_s2mm_tready_M_K,
	s_axis_s2mm_tvalid_M_K,
	s_axis_s2mm_tdata_M_V,
	s_axis_s2mm_tkeep_M_V,
	s_axis_s2mm_tlast_M_V,
	s_axis_s2mm_tready_M_V,
	s_axis_s2mm_tvalid_M_V,
	s_axis_s2mm_tdata_E_Q,
	s_axis_s2mm_tkeep_E_Q,
	s_axis_s2mm_tlast_E_Q,
	s_axis_s2mm_tready_E_Q,
	s_axis_s2mm_tvalid_E_Q,
	s_axis_s2mm_tdata_E_K,
	s_axis_s2mm_tkeep_E_K,
	s_axis_s2mm_tlast_E_K,
	s_axis_s2mm_tready_E_K,
	s_axis_s2mm_tvalid_E_K,
	s_axis_s2mm_tdata_E_V,
	s_axis_s2mm_tkeep_E_V,
	s_axis_s2mm_tlast_E_V,
	s_axis_s2mm_tready_E_V,
	s_axis_s2mm_tvalid_E_V,
	attn_tdata,
	attn_tkeep,
	attn_tlast,
	attn_tready,
	attn_tvalid,
	attn_head_dimensions
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer N1 = 4;
	parameter integer N2 = 4;
	parameter integer L = 12;
	parameter integer SOFTMAX_N = 64;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer MEM_DEPTH_A = 4096;
	parameter integer MEM_DEPTH_B = 4096;
	parameter integer MEM_DEPTH_D = 4096;
	parameter integer MEM_DEPTH_S = 4096;
	parameter integer MEM_DEPTH_D_A = 4096;
	parameter integer MEM_DEPTH_D_B = 4096;
	parameter integer REQ_MEM_DEPTH = 64;
	input wire attn_clk;
	input wire attn_fclk;
	input wire attn_rst;
	input wire signed [31:0] s_axis_s2mm_tdata_I;
	input wire [3:0] s_axis_s2mm_tkeep_I;
	input wire s_axis_s2mm_tlast_I;
	output wire s_axis_s2mm_tready_I;
	input wire s_axis_s2mm_tvalid_I;
	input wire signed [31:0] s_axis_s2mm_tdata_Q;
	input wire [3:0] s_axis_s2mm_tkeep_Q;
	input wire s_axis_s2mm_tlast_Q;
	output wire s_axis_s2mm_tready_Q;
	input wire s_axis_s2mm_tvalid_Q;
	input wire signed [31:0] s_axis_s2mm_tdata_K;
	input wire [3:0] s_axis_s2mm_tkeep_K;
	input wire s_axis_s2mm_tlast_K;
	output wire s_axis_s2mm_tready_K;
	input wire s_axis_s2mm_tvalid_K;
	input wire signed [31:0] s_axis_s2mm_tdata_V;
	input wire [3:0] s_axis_s2mm_tkeep_V;
	input wire s_axis_s2mm_tlast_V;
	output wire s_axis_s2mm_tready_V;
	input wire s_axis_s2mm_tvalid_V;
	input wire signed [31:0] s_axis_s2mm_tdata_bias_Q;
	input wire [3:0] s_axis_s2mm_tkeep_bias_Q;
	input wire s_axis_s2mm_tlast_bias_Q;
	output wire s_axis_s2mm_tready_bias_Q;
	input wire s_axis_s2mm_tvalid_bias_Q;
	input wire signed [31:0] s_axis_s2mm_tdata_bias_K;
	input wire [3:0] s_axis_s2mm_tkeep_bias_K;
	input wire s_axis_s2mm_tlast_bias_K;
	output wire s_axis_s2mm_tready_bias_K;
	input wire s_axis_s2mm_tvalid_bias_K;
	input wire signed [31:0] s_axis_s2mm_tdata_bias_V;
	input wire [3:0] s_axis_s2mm_tkeep_bias_V;
	input wire s_axis_s2mm_tlast_bias_V;
	output wire s_axis_s2mm_tready_bias_V;
	input wire s_axis_s2mm_tvalid_bias_V;
	input wire signed [31:0] s_axis_s2mm_tdata_M_Q;
	input wire [3:0] s_axis_s2mm_tkeep_M_Q;
	input wire s_axis_s2mm_tlast_M_Q;
	output wire s_axis_s2mm_tready_M_Q;
	input wire s_axis_s2mm_tvalid_M_Q;
	input wire signed [31:0] s_axis_s2mm_tdata_M_K;
	input wire [3:0] s_axis_s2mm_tkeep_M_K;
	input wire s_axis_s2mm_tlast_M_K;
	output wire s_axis_s2mm_tready_M_K;
	input wire s_axis_s2mm_tvalid_M_K;
	input wire signed [31:0] s_axis_s2mm_tdata_M_V;
	input wire [3:0] s_axis_s2mm_tkeep_M_V;
	input wire s_axis_s2mm_tlast_M_V;
	output wire s_axis_s2mm_tready_M_V;
	input wire s_axis_s2mm_tvalid_M_V;
	input wire [31:0] s_axis_s2mm_tdata_E_Q;
	input wire [3:0] s_axis_s2mm_tkeep_E_Q;
	input wire s_axis_s2mm_tlast_E_Q;
	output wire s_axis_s2mm_tready_E_Q;
	input wire s_axis_s2mm_tvalid_E_Q;
	input wire [31:0] s_axis_s2mm_tdata_E_K;
	input wire [3:0] s_axis_s2mm_tkeep_E_K;
	input wire s_axis_s2mm_tlast_E_K;
	output wire s_axis_s2mm_tready_E_K;
	input wire s_axis_s2mm_tvalid_E_K;
	input wire [31:0] s_axis_s2mm_tdata_E_V;
	input wire [3:0] s_axis_s2mm_tkeep_E_V;
	input wire s_axis_s2mm_tlast_E_V;
	output wire s_axis_s2mm_tready_E_V;
	input wire s_axis_s2mm_tvalid_E_V;
	output wire signed [31:0] attn_tdata;
	output wire [3:0] attn_tkeep;
	output wire attn_tlast;
	input wire attn_tready;
	output wire attn_tvalid;
	input wire [(((((((((((MATRIXSIZE_W + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) + MATRIXSIZE_W) - 1:0] attn_head_dimensions;
	wire q_ready;
	wire signed [D_W_ACC - 1:0] m_axis_mm2s_tdata_Q;
	wire m_axis_mm2s_tvalid_Q;
	wire m_axis_mm2s_tlast_Q;
	wire [3:0] m_axis_mm2s_tkeep_Q;
	wire signed [D_W_ACC - 1:0] bias_data_out_Q;
	wire signed [D_W_ACC - 1:0] M_data_out_Q;
	wire [D_W - 1:0] E_data_out_Q;
	wire valid_out_bias_Q;
	wire valid_out_M_Q;
	wire valid_out_E_Q;
	wire last_bias_Q;
	wire last_M_Q;
	wire last_E_Q;
	wire start_read_s2v_Q;
	wire quant_ready_Q;
	wire quant_back_Q;
	wire signed [D_W - 1:0] quant_data_Q;
	wire quant_valid_Q;
	wire quant_last_Q;
	wire [3:0] quant_keep_Q;
	wire k_ready;
	wire signed [31:0] m_axis_mm2s_tdata_K;
	wire m_axis_mm2s_tvalid_K;
	wire m_axis_mm2s_tlast_K;
	wire [3:0] m_axis_mm2s_tkeep_K;
	wire signed [D_W_ACC - 1:0] bias_data_out_K;
	wire signed [D_W_ACC - 1:0] M_data_out_K;
	wire [D_W - 1:0] E_data_out_K;
	wire valid_out_bias_K;
	wire valid_out_M_K;
	wire valid_out_E_K;
	wire last_bias_K;
	wire last_M_K;
	wire last_E_K;
	wire start_read_s2v_K;
	wire quant_ready_K;
	wire quant_back_K;
	wire signed [D_W - 1:0] quant_data_K;
	wire quant_valid_K;
	wire quant_last_K;
	wire [3:0] quant_keep_K;
	wire v_ready;
	wire signed [31:0] m_axis_mm2s_tdata_V;
	wire m_axis_mm2s_tvalid_V;
	wire m_axis_mm2s_tlast_V;
	wire [3:0] m_axis_mm2s_tkeep_V;
	wire signed [D_W_ACC - 1:0] bias_data_out_V;
	wire signed [D_W_ACC - 1:0] M_data_out_V;
	wire [D_W - 1:0] E_data_out_V;
	wire valid_out_bias_V;
	wire valid_out_M_V;
	wire valid_out_E_V;
	wire last_bias_V;
	wire last_M_V;
	wire last_E_V;
	wire start_read_s2v_V;
	wire quant_ready_V;
	wire quant_back_V;
	wire signed [D_W - 1:0] quant_data_V;
	wire quant_valid_V;
	wire quant_last_V;
	wire [3:0] quant_keep_V;
	wire signed [D_W_ACC - 1:0] matrix_data_S;
	wire matrix_valid_S;
	wire matrix_ready_P;
	wire matrix_last_S;
	wire [3:0] matrix_keep_S;
	wire matrix_valid_P;
	wire signed [D_W - 1:0] matrix_data_P;
	wire matrix_last_P;
	wire signed [D_W_ACC - 1:0] m_axis_mm2s_tdata_C;
	wire m_axis_mm2s_tvalid_C;
	wire m_axis_mm2s_tready_C;
	wire m_axis_mm2s_tlast_C;
	wire [3:0] m_axis_mm2s_tkeep_C;
	assign s_axis_s2mm_tready_I = (q_ready & k_ready) & v_ready;
	mm #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_A),
		.MEM_DEPTH_B(MEM_DEPTH_B),
		.MEM_DEPTH_D(MEM_DEPTH_D_A),
		.TRANSPOSE_B(0)
	) mm_Q(
		.mm_clk(~attn_clk),
		.mm_fclk(~attn_fclk),
		.mm_rst_n(~attn_rst),
		.s_axis_s2mm_tdata_A(s_axis_s2mm_tdata_I),
		.s_axis_s2mm_tkeep_A(s_axis_s2mm_tkeep_I),
		.s_axis_s2mm_tlast_A(s_axis_s2mm_tlast_I),
		.s_axis_s2mm_tready_A(q_ready),
		.s_axis_s2mm_tvalid_A(s_axis_s2mm_tvalid_I),
		.s_axis_s2mm_tdata_B(s_axis_s2mm_tdata_Q),
		.s_axis_s2mm_tkeep_B(s_axis_s2mm_tkeep_Q),
		.s_axis_s2mm_tlast_B(s_axis_s2mm_tlast_Q),
		.s_axis_s2mm_tready_B(s_axis_s2mm_tready_Q),
		.s_axis_s2mm_tvalid_B(s_axis_s2mm_tvalid_Q),
		.m_axis_mm2s_tdata(m_axis_mm2s_tdata_Q),
		.m_axis_mm2s_tvalid(m_axis_mm2s_tvalid_Q),
		.m_axis_mm2s_tready(quant_ready_Q),
		.m_axis_mm2s_tlast(m_axis_mm2s_tlast_Q),
		.m_axis_mm2s_tkeep(m_axis_mm2s_tkeep_Q),
		.start_read_s2v(start_read_s2v_Q),
		.M2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)]),
		.M1xM3dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))) + 1)]),
		.M1dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) + 1)]),
		.M3dN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) + 1)]),
		.M1xM3dN1xN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) + 1)])
	);
	s2v #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH(REQ_MEM_DEPTH),
		.MEM_DEPTH_D_A(MEM_DEPTH_D_A),
		.MEM_DEPTH_D_B(MEM_DEPTH_D_B)
	) s2v_Q(
		.clk(attn_clk),
		.fclk(attn_clk),
		.rst(attn_rst),
		.s_axis_s2mm_tdata_bias(s_axis_s2mm_tdata_bias_Q),
		.s_axis_s2mm_tkeep_bias(s_axis_s2mm_tkeep_bias_Q),
		.s_axis_s2mm_tlast_bias(s_axis_s2mm_tlast_bias_Q),
		.s_axis_s2mm_tready_bias(s_axis_s2mm_tready_bias_Q),
		.s_axis_s2mm_tvalid_bias(s_axis_s2mm_tvalid_bias_Q),
		.s_axis_s2mm_tdata_M(s_axis_s2mm_tdata_M_Q),
		.s_axis_s2mm_tkeep_M(s_axis_s2mm_tkeep_M_Q),
		.s_axis_s2mm_tlast_M(s_axis_s2mm_tlast_M_Q),
		.s_axis_s2mm_tready_M(s_axis_s2mm_tready_M_Q),
		.s_axis_s2mm_tvalid_M(s_axis_s2mm_tvalid_M_Q),
		.s_axis_s2mm_tdata_E(s_axis_s2mm_tdata_E_Q),
		.s_axis_s2mm_tkeep_E(s_axis_s2mm_tkeep_E_Q),
		.s_axis_s2mm_tlast_E(s_axis_s2mm_tlast_E_Q),
		.s_axis_s2mm_tready_E(s_axis_s2mm_tready_E_Q),
		.s_axis_s2mm_tvalid_E(s_axis_s2mm_tvalid_E_Q),
		.bias_data_out(bias_data_out_Q),
		.M_data_out(M_data_out_Q),
		.E_data_out(E_data_out_Q),
		.valid_out_bias(valid_out_bias_Q),
		.valid_out_M(valid_out_M_Q),
		.valid_out_E(valid_out_E_Q),
		.last_bias(last_bias_Q),
		.last_M(last_M_Q),
		.last_E(last_E_Q),
		.back_ready(quant_ready_Q),
		.start_read_s2v(start_read_s2v_Q),
		.start_read_mm(m_axis_mm2s_tvalid_Q),
		.M1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)])
	);
	requant #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC)
	) requant_Q(
		.clk(attn_clk),
		.rst(attn_rst),
		.A_data_in(m_axis_mm2s_tdata_Q),
		.A_keep_in(m_axis_mm2s_tkeep_Q),
		.A_last_in(m_axis_mm2s_tlast_Q),
		.A_valid_in(m_axis_mm2s_tvalid_Q),
		.bias_data_in(bias_data_out_Q),
		.bias_valid_in(valid_out_bias_Q),
		.bias_keep_in(4'b0000),
		.M_data_in(M_data_out_Q),
		.M_valid_in(valid_out_M_Q),
		.M_keep_in(4'b0000),
		.E_data_in(E_data_out_Q),
		.E_valid_in(valid_out_E_Q),
		.E_keep_in(4'b0000),
		.back_ready_in(quant_back_Q),
		.back_ready_out(quant_ready_Q),
		.quant_data(quant_data_Q),
		.quant_valid(quant_valid_Q),
		.quant_last(quant_last_Q),
		.quant_keep(quant_keep_Q)
	);
	mm #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_A),
		.MEM_DEPTH_B(MEM_DEPTH_B),
		.MEM_DEPTH_D(MEM_DEPTH_D_A),
		.TRANSPOSE_B(0)
	) mm_K(
		.mm_clk(~attn_clk),
		.mm_fclk(~attn_fclk),
		.mm_rst_n(~attn_rst),
		.s_axis_s2mm_tdata_A(s_axis_s2mm_tdata_I),
		.s_axis_s2mm_tkeep_A(s_axis_s2mm_tkeep_I),
		.s_axis_s2mm_tlast_A(s_axis_s2mm_tlast_I),
		.s_axis_s2mm_tready_A(k_ready),
		.s_axis_s2mm_tvalid_A(s_axis_s2mm_tvalid_I),
		.s_axis_s2mm_tdata_B(s_axis_s2mm_tdata_K),
		.s_axis_s2mm_tkeep_B(s_axis_s2mm_tkeep_K),
		.s_axis_s2mm_tlast_B(s_axis_s2mm_tlast_K),
		.s_axis_s2mm_tready_B(s_axis_s2mm_tready_K),
		.s_axis_s2mm_tvalid_B(s_axis_s2mm_tvalid_K),
		.m_axis_mm2s_tdata(m_axis_mm2s_tdata_K),
		.m_axis_mm2s_tvalid(m_axis_mm2s_tvalid_K),
		.m_axis_mm2s_tready(quant_ready_K),
		.m_axis_mm2s_tlast(m_axis_mm2s_tlast_K),
		.m_axis_mm2s_tkeep(m_axis_mm2s_tkeep_K),
		.start_read_s2v(start_read_s2v_K),
		.M2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)]),
		.M1xM3dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))) + 1)]),
		.M1dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) + 1)]),
		.M3dN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) + 1)]),
		.M1xM3dN1xN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) + 1)])
	);
	s2v #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH(REQ_MEM_DEPTH),
		.MEM_DEPTH_D_A(MEM_DEPTH_D_A),
		.MEM_DEPTH_D_B(MEM_DEPTH_D_B)
	) s2v_K(
		.clk(attn_clk),
		.fclk(attn_clk),
		.rst(attn_rst),
		.s_axis_s2mm_tdata_bias(s_axis_s2mm_tdata_bias_K),
		.s_axis_s2mm_tkeep_bias(s_axis_s2mm_tkeep_bias_K),
		.s_axis_s2mm_tlast_bias(s_axis_s2mm_tlast_bias_K),
		.s_axis_s2mm_tready_bias(s_axis_s2mm_tready_bias_K),
		.s_axis_s2mm_tvalid_bias(s_axis_s2mm_tvalid_bias_K),
		.s_axis_s2mm_tdata_M(s_axis_s2mm_tdata_M_K),
		.s_axis_s2mm_tkeep_M(s_axis_s2mm_tkeep_M_K),
		.s_axis_s2mm_tlast_M(s_axis_s2mm_tlast_M_K),
		.s_axis_s2mm_tready_M(s_axis_s2mm_tready_M_K),
		.s_axis_s2mm_tvalid_M(s_axis_s2mm_tvalid_M_K),
		.s_axis_s2mm_tdata_E(s_axis_s2mm_tdata_E_K),
		.s_axis_s2mm_tkeep_E(s_axis_s2mm_tkeep_E_K),
		.s_axis_s2mm_tlast_E(s_axis_s2mm_tlast_E_K),
		.s_axis_s2mm_tready_E(s_axis_s2mm_tready_E_K),
		.s_axis_s2mm_tvalid_E(s_axis_s2mm_tvalid_E_K),
		.bias_data_out(bias_data_out_K),
		.M_data_out(M_data_out_K),
		.E_data_out(E_data_out_K),
		.valid_out_bias(valid_out_bias_K),
		.valid_out_M(valid_out_M_K),
		.valid_out_E(valid_out_E_K),
		.last_bias(last_bias_K),
		.last_M(last_M_K),
		.last_E(last_E_K),
		.back_ready(quant_ready_K),
		.start_read_s2v(start_read_s2v_K),
		.start_read_mm(m_axis_mm2s_tvalid_K),
		.M1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)])
	);
	requant #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC)
	) requant_K(
		.clk(attn_clk),
		.rst(attn_rst),
		.A_data_in(m_axis_mm2s_tdata_K),
		.A_keep_in(m_axis_mm2s_tkeep_K),
		.A_last_in(m_axis_mm2s_tlast_K),
		.A_valid_in(m_axis_mm2s_tvalid_K),
		.bias_data_in(bias_data_out_K),
		.bias_valid_in(valid_out_bias_K),
		.bias_keep_in(4'b0000),
		.M_data_in(M_data_out_K),
		.M_valid_in(valid_out_M_K),
		.M_keep_in(4'b0000),
		.E_data_in(E_data_out_K),
		.E_valid_in(valid_out_E_K),
		.E_keep_in(4'b0000),
		.back_ready_in(quant_back_K),
		.back_ready_out(quant_ready_K),
		.quant_data(quant_data_K),
		.quant_valid(quant_valid_K),
		.quant_last(quant_last_K),
		.quant_keep(quant_keep_K)
	);
	mm #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_A),
		.MEM_DEPTH_B(MEM_DEPTH_B),
		.MEM_DEPTH_D(MEM_DEPTH_D_A),
		.TRANSPOSE_B(0)
	) mm_V(
		.mm_clk(~attn_clk),
		.mm_fclk(~attn_fclk),
		.mm_rst_n(~attn_rst),
		.s_axis_s2mm_tdata_A(s_axis_s2mm_tdata_I),
		.s_axis_s2mm_tkeep_A(s_axis_s2mm_tkeep_I),
		.s_axis_s2mm_tlast_A(s_axis_s2mm_tlast_I),
		.s_axis_s2mm_tready_A(v_ready),
		.s_axis_s2mm_tvalid_A(s_axis_s2mm_tvalid_I),
		.s_axis_s2mm_tdata_B(s_axis_s2mm_tdata_V),
		.s_axis_s2mm_tkeep_B(s_axis_s2mm_tkeep_V),
		.s_axis_s2mm_tlast_B(s_axis_s2mm_tlast_V),
		.s_axis_s2mm_tready_B(s_axis_s2mm_tready_V),
		.s_axis_s2mm_tvalid_B(s_axis_s2mm_tvalid_V),
		.m_axis_mm2s_tdata(m_axis_mm2s_tdata_V),
		.m_axis_mm2s_tvalid(m_axis_mm2s_tvalid_V),
		.m_axis_mm2s_tready(quant_ready_V),
		.m_axis_mm2s_tlast(m_axis_mm2s_tlast_V),
		.m_axis_mm2s_tkeep(m_axis_mm2s_tkeep_V),
		.start_read_s2v(start_read_s2v_V),
		.M2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)]),
		.M1xM3dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))) + 1)]),
		.M1dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) + 1)]),
		.M3dN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) + 1)]),
		.M1xM3dN1xN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) + 1)])
	);
	s2v #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH(REQ_MEM_DEPTH),
		.MEM_DEPTH_D_A(MEM_DEPTH_D_A),
		.MEM_DEPTH_D_B(MEM_DEPTH_D_B)
	) s2v_V(
		.clk(attn_clk),
		.fclk(attn_clk),
		.rst(attn_rst),
		.s_axis_s2mm_tdata_bias(s_axis_s2mm_tdata_bias_V),
		.s_axis_s2mm_tkeep_bias(s_axis_s2mm_tkeep_bias_V),
		.s_axis_s2mm_tlast_bias(s_axis_s2mm_tlast_bias_V),
		.s_axis_s2mm_tready_bias(s_axis_s2mm_tready_bias_V),
		.s_axis_s2mm_tvalid_bias(s_axis_s2mm_tvalid_bias_V),
		.s_axis_s2mm_tdata_M(s_axis_s2mm_tdata_M_V),
		.s_axis_s2mm_tkeep_M(s_axis_s2mm_tkeep_M_V),
		.s_axis_s2mm_tlast_M(s_axis_s2mm_tlast_M_V),
		.s_axis_s2mm_tready_M(s_axis_s2mm_tready_M_V),
		.s_axis_s2mm_tvalid_M(s_axis_s2mm_tvalid_M_V),
		.s_axis_s2mm_tdata_E(s_axis_s2mm_tdata_E_V),
		.s_axis_s2mm_tkeep_E(s_axis_s2mm_tkeep_E_V),
		.s_axis_s2mm_tlast_E(s_axis_s2mm_tlast_E_V),
		.s_axis_s2mm_tready_E(s_axis_s2mm_tready_E_V),
		.s_axis_s2mm_tvalid_E(s_axis_s2mm_tvalid_E_V),
		.bias_data_out(bias_data_out_V),
		.M_data_out(M_data_out_V),
		.E_data_out(E_data_out_V),
		.valid_out_bias(valid_out_bias_V),
		.valid_out_M(valid_out_M_V),
		.valid_out_E(valid_out_E_V),
		.last_bias(last_bias_V),
		.last_M(last_M_V),
		.last_E(last_E_V),
		.back_ready(quant_ready_V),
		.start_read_s2v(start_read_s2v_V),
		.start_read_mm(m_axis_mm2s_tvalid_V),
		.M1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)])
	);
	requant #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC)
	) requant_V(
		.clk(attn_clk),
		.rst(attn_rst),
		.A_data_in(m_axis_mm2s_tdata_V),
		.A_keep_in(m_axis_mm2s_tkeep_V),
		.A_last_in(m_axis_mm2s_tlast_V),
		.A_valid_in(m_axis_mm2s_tvalid_V),
		.bias_data_in(bias_data_out_V),
		.bias_valid_in(valid_out_bias_V),
		.bias_keep_in(4'b0000),
		.M_data_in(M_data_out_V),
		.M_valid_in(valid_out_M_V),
		.M_keep_in(4'b0000),
		.E_data_in(E_data_out_V),
		.E_valid_in(valid_out_E_V),
		.E_keep_in(4'b0000),
		.back_ready_in(quant_back_V),
		.back_ready_out(quant_ready_V),
		.quant_data(quant_data_V),
		.quant_valid(quant_valid_V),
		.quant_last(quant_last_V),
		.quant_keep(quant_keep_V)
	);
	mm #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_D_A),
		.MEM_DEPTH_B(MEM_DEPTH_D_B),
		.MEM_DEPTH_D(MEM_DEPTH_S),
		.TRANSPOSE_B(1)
	) mm_q_k(
		.mm_clk(~attn_clk),
		.mm_fclk(~attn_fclk),
		.mm_rst_n(~attn_rst),
		.s_axis_s2mm_tdata_A(quant_data_Q),
		.s_axis_s2mm_tkeep_A(quant_keep_Q),
		.s_axis_s2mm_tlast_A(quant_last_Q),
		.s_axis_s2mm_tready_A(quant_back_Q),
		.s_axis_s2mm_tvalid_A(quant_valid_Q),
		.s_axis_s2mm_tdata_B(quant_data_K),
		.s_axis_s2mm_tkeep_B(quant_keep_K),
		.s_axis_s2mm_tlast_B(quant_last_K),
		.s_axis_s2mm_tready_B(quant_back_K),
		.s_axis_s2mm_tvalid_B(quant_valid_K),
		.m_axis_mm2s_tdata(matrix_data_S),
		.m_axis_mm2s_tvalid(matrix_valid_S),
		.m_axis_mm2s_tready(matrix_ready_P),
		.m_axis_mm2s_tlast(matrix_last_S),
		.m_axis_mm2s_tkeep(matrix_keep_S),
		.start_read_s2v(1),
		.M2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))))) + 1)]),
		.M1xM3dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + 0)) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))) - (MATRIXSIZE_W + (MATRIXSIZE_W + 0))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + 0)) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))) + 1)]),
		.M1dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) + 1)]),
		.M3dN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W - 1)-:((MATRIXSIZE_W + (MATRIXSIZE_W - 1)) >= (MATRIXSIZE_W + 0) ? ((MATRIXSIZE_W + (MATRIXSIZE_W - 1)) - (MATRIXSIZE_W + 0)) + 1 : ((MATRIXSIZE_W + 0) - (MATRIXSIZE_W + (MATRIXSIZE_W - 1))) + 1)]),
		.M1xM3dN1xN2(attn_head_dimensions[MATRIXSIZE_W - 1-:MATRIXSIZE_W])
	);
	softmax_top #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.L(L),
		.N(SOFTMAX_N)
	) softmax_top_inst(
		.clk(attn_clk),
		.rst(attn_rst),
		.layer(4'b0000),
		.in_valid(matrix_valid_S),
		.qin(matrix_data_S),
		.out_valid(matrix_valid_P),
		.qout(matrix_data_P),
		.done(matrix_last_P)
	);
	mm #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N1(N1),
		.N2(N2),
		.MATRIXSIZE_W(MATRIXSIZE_W),
		.MEM_DEPTH_A(MEM_DEPTH_S),
		.MEM_DEPTH_B(MEM_DEPTH_D_B),
		.MEM_DEPTH_D(MEM_DEPTH_D_A),
		.TRANSPOSE_B(0)
	) mm_p_v(
		.mm_clk(~attn_clk),
		.mm_fclk(~attn_fclk),
		.mm_rst_n(~attn_rst),
		.s_axis_s2mm_tdata_A(matrix_data_P),
		.s_axis_s2mm_tkeep_A(matrix_keep_S),
		.s_axis_s2mm_tlast_A(matrix_last_P),
		.s_axis_s2mm_tready_A(matrix_ready_P),
		.s_axis_s2mm_tvalid_A(matrix_valid_P),
		.s_axis_s2mm_tdata_B(quant_data_V),
		.s_axis_s2mm_tkeep_B(quant_keep_V),
		.s_axis_s2mm_tlast_B(quant_last_V),
		.s_axis_s2mm_tready_B(quant_back_V),
		.s_axis_s2mm_tvalid_B(quant_valid_V),
		.m_axis_mm2s_tdata(m_axis_mm2s_tdata_C),
		.m_axis_mm2s_tvalid(m_axis_mm2s_tvalid_C),
		.m_axis_mm2s_tready(m_axis_mm2s_tready_C),
		.m_axis_mm2s_tlast(m_axis_mm2s_tlast_C),
		.m_axis_mm2s_tkeep(m_axis_mm2s_tkeep_C),
		.start_read_s2v(1),
		.M2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))))) + 1)]),
		.M3(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))))) + 1)]),
		.M1xM3dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))))) + 1)]),
		.M1dN1(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))))) + 1)]),
		.M3dN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))))) + 1)]),
		.M1xM3dN1xN2(attn_head_dimensions[MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))-:((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) >= (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) ? ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1))))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0))))) + 1 : ((MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + 0)))) - (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W + (MATRIXSIZE_W - 1)))))) + 1)])
	);
	requant #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC)
	) requant_final(
		.clk(attn_clk),
		.rst(attn_rst),
		.A_data_in(m_axis_mm2s_tdata_C),
		.A_keep_in(m_axis_mm2s_tkeep_C),
		.A_last_in(m_axis_mm2s_tlast_C),
		.A_valid_in(m_axis_mm2s_tvalid_C),
		.bias_data_in(0),
		.bias_valid_in(1),
		.bias_keep_in(4'b0000),
		.M_data_in(32'd1554288351),
		.M_valid_in(1),
		.M_keep_in(4'b0000),
		.E_data_in(8'd36),
		.E_valid_in(1),
		.E_keep_in(4'b0000),
		.back_ready_in(attn_tready),
		.back_ready_out(m_axis_mm2s_tready_C),
		.quant_data(attn_tdata),
		.quant_valid(attn_tvalid),
		.quant_last(attn_tlast),
		.quant_keep(attn_tkeep)
	);
endmodule

module softmax_top (
	clk,
	rst,
	layer,
	in_valid,
	qin,
	out_valid,
	qout,
	done
);
	parameter integer D_W = 8;
	parameter integer D_W_ACC = 32;
	parameter integer MATRIXSIZE_W = 16;
	parameter integer L = 12;
	parameter integer N = 32;
	input wire clk;
	input wire rst;
	input wire [$clog2(L) - 1:0] layer;
	input wire in_valid;
	input wire signed [D_W_ACC - 1:0] qin;
	(* keep = "true" *) output wire out_valid;
	(* keep = "true" *) output wire signed [D_W - 1:0] qout;
	output wire done;
	localparam [MATRIXSIZE_W - 1:0] _N = N;
	localparam integer FP_BITS = 30;
	localparam integer MAX_BITS = 30;
	localparam integer OUT_BITS = 6;
	localparam QB_MEM = "data/softmax_qb.mem";
	localparam QC_MEM = "data/softmax_qc.mem";
	localparam QLN2_MEM = "data/softmax_qln2.mem";
	localparam QLN2_INV_MEM = "data/softmax_qln2_inv.mem";
	localparam SREQ_MEM = "data/softmax_Sreq.mem";
	reg signed [D_W_ACC - 1:0] qin_r;
	reg in_valid_r;
	wire signed [D_W_ACC - 1:0] qb_rom_rddata;
	wire signed [D_W_ACC - 1:0] qc_rom_rddata;
	wire signed [D_W_ACC - 1:0] qln2_rom_rddata;
	wire signed [D_W_ACC - 1:0] qln2_inv_rom_rddata;
	wire signed [D_W_ACC - 1:0] Sreq_rom_rddata;
	wire [MATRIXSIZE_W - 1:0] col_cntr;
	wire [MATRIXSIZE_W - 1:0] row_cntr;
	assign done = (col_cntr == (N - 1)) & (row_cntr == (N - 1));
	always @(posedge clk)
		if (rst) begin
			qin_r <= 0;
			in_valid_r <= 0;
		end
		else begin
			qin_r <= qin;
			in_valid_r <= in_valid;
		end
	rom #(
		.D_W(D_W_ACC),
		.DEPTH(L),
		.INIT(QB_MEM)
	) qb_rom(
		.clk(clk),
		.rdaddr(layer),
		.rddata(qb_rom_rddata)
	);
	rom #(
		.D_W(D_W_ACC),
		.DEPTH(L),
		.INIT(QC_MEM)
	) qc_rom(
		.clk(clk),
		.rdaddr(layer),
		.rddata(qc_rom_rddata)
	);
	rom #(
		.D_W(D_W_ACC),
		.DEPTH(L),
		.INIT(QLN2_MEM)
	) qln2_rom(
		.clk(clk),
		.rdaddr(layer),
		.rddata(qln2_rom_rddata)
	);
	rom #(
		.D_W(D_W_ACC),
		.DEPTH(L),
		.INIT(QLN2_INV_MEM)
	) qln2_inv_rom(
		.clk(clk),
		.rdaddr(layer),
		.rddata(qln2_inv_rom_rddata)
	);
	rom #(
		.D_W(D_W_ACC),
		.DEPTH(L),
		.INIT(SREQ_MEM)
	) Sreq_rom(
		.clk(clk),
		.rdaddr(layer),
		.rddata(Sreq_rom_rddata)
	);
	counter #(.MATRIXSIZE_W(MATRIXSIZE_W)) counter_softmax(
		.clk(clk),
		.rst(rst),
		.enable_pixel_count(out_valid),
		.enable_slice_count(out_valid),
		.WIDTH(_N),
		.HEIGHT(_N),
		.pixel_cntr(col_cntr),
		.slice_cntr(row_cntr)
	);
	softmax #(
		.D_W(D_W),
		.D_W_ACC(D_W_ACC),
		.N(N),
		.FP_BITS(FP_BITS),
		.MAX_BITS(MAX_BITS),
		.OUT_BITS(OUT_BITS)
	) softmax_unit(
		.clk(clk),
		.rst(rst),
		.in_valid(in_valid_r),
		.qin(qin_r),
		.qb(qb_rom_rddata),
		.qc(qc_rom_rddata),
		.qln2(qln2_rom_rddata),
		.qln2_inv(qln2_inv_rom_rddata),
		.Sreq(Sreq_rom_rddata),
		.out_valid(out_valid),
		.qout(qout)
	);
endmodule

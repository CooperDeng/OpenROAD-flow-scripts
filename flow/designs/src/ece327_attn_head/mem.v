module mem (
    input wire rst,
    input wire clkA,
    input wire clkB,
    input wire weA,
    input wire enA,
    input wire enB,
    input wire [11:0] addrA,  // 4096-depth = 12 bits
    input wire [11:0] addrB,  // also, $clog2(4096) = 12
    input wire [31:0] dinA,
    output reg [31:0] doutB
);
    // Placeholder values
	parameter WIDTH = 32;
	parameter DEPTH = 512;    

    /*
    1. Select 1 among 4 banks (2-bit)
    2. Select 1 among 256 rows (8-bit)
    3. Select 1 among 4 words (2-bit)
    */

    wire [1:0] bank_selA = addrA[11:10];
    wire [1:0] bank_selB = addrB[11:10];
    wire [7:0] row_addrA = addrA[9:2];
    wire [7:0] row_addrB = addrB[9:2];
    wire [1:0] word_selA = addrA[1:0];
    wire [1:0] word_selB = addrB[1:0];

    reg [127:0] din_packed;
    wire [127:0] dout_packed [0:3];
    wire [3:0] csb0;
    wire [3:0] web0;
    wire [3:0] csb1;

    integer i;
    always @(*) begin
        // this creates potential issue:
        // if we write a single word into the full 128-bit row,
        // then all the other previously-written words will be eliminated
        // Solution: Stall one cycle, add RMW (? probably) logic
        din_packed = 128'b0;
        
        // Basically saying:
        // "Starting at bit word_selA * 32, assign the next 32 bits with dinA."
        din_packed[word_selA * 32 +: 32] = dinA;
    end
	
	// the below part was under heavy influence of chatGPT
    // control signals
    // gives pattern like 1110 1101 1011 0111
    // because srams are active low, we need to invert them
    assign csb0 = ~(enA << bank_selA); // active low per bank
    assign web0 = ~(weA << bank_selA); // active low per bank
    assign csb1 = ~(enB << bank_selB); // active low per bank

    // I have no idea what i'm doing
    genvar b;
    generate
        for (b = 0; b < 4; b = b + 1) begin: banks
            sky130_sram_1rw1r_128x256_8 mem_bank (
                .clk0(clkA),
                .csb0(csb0[b]), // selecting the corresponding control signal into each bank
                .web0(web0[b]),
                .addr0(row_addrA),
                .din0(din_packed),
                .dout0(),

                .clk1(clkB),
                .csb1(csb1[b]),
                .addr1(row_addrB),
                .dout1(dout_packed[b])
            );
        end
    endgenerate

    // select correct bank output on read
    always @(posedge clkB) begin
        if (rst)
            doutB <= 32'b0;
        else if (enB)
            doutB <= dout_packed[bank_selB][word_selB * 32 +: 32];
    end
endmodule

module sky130_sram_1rw1r_128x256_8 (
    input  wire         clk0,
    input  wire         csb0,
    input  wire         web0,
    input  wire [7:0]   addr0,
    input  wire [127:0] din0,
    output wire [127:0] dout0,

    input  wire         clk1,
    input  wire         csb1,
    input  wire [7:0]   addr1,
    output wire [127:0] dout1
);

// I should probably specify blackbox in design config....
// But it works? i guess my design config covers everything? i guess?
// second thought - this is not working, i might actually haven't connect macro properly

endmodule
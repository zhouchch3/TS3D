module SRAM_DUAL(
    clk,
    addr_r, addr_w, 
    read_en, write_en,
    data_in, data_out
    );
// parameter OUT_DATA_BIT_WIDTH= 28;
parameter SRAM_DEPTH_BIT = 6;
parameter SRAM_DEPTH = 2 ** SRAM_DEPTH_BIT;
parameter SRAM_WIDTH = 28;
input clk;
input [SRAM_DEPTH_BIT - 1 : 0]addr_r, addr_w;
input read_en, write_en;

input[SRAM_WIDTH  - 1 : 0]data_in;
output [SRAM_WIDTH  - 1 : 0]data_out;

reg [SRAM_WIDTH  - 1 : 0]mem[0 : SRAM_DEPTH - 1];

reg[SRAM_WIDTH  - 1 : 0]data_out;

always @(posedge clk) begin
    if (read_en) begin
        data_out <= mem[addr_r];
    end
end

always @(posedge clk) begin
    if (write_en) begin
        mem[addr_w] <= data_in;            
    end
end

endmodule

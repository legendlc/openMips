`include "defines.v"
`timescale 1ns/1ns

module openMIPS_tb;
reg clk;
reg rst;
wire [`InstBus] wire_inst;
wire [`InstAddrBus] wire_pc;
wire wire_ce;

rom rom_0(
	.ce_i(wire_ce),
	.addr_i(wire_pc),
	.inst_o(wire_inst)
);

open_mips llc(
	.clk(clk),
	.rst(rst),
	.rom_ce_o(wire_ce),
	.rom_addr_o(wire_pc),
	.rom_data_i(wire_inst)
);

initial begin
	clk <= 1'b0;
	rst <= 1'b1;
	#100;
	rst <= 1'b0;
end

always 
	#5 clk <= ~clk;

endmodule


`include "defines.v"

module rom(
	input ce_i,
	input [`InstAddrBus] addr_i,
	output reg [`InstBus] inst_o
);

reg [`InstBus] inst_mem[`InstMemNum:0];

initial $readmemh("inst_rom.data", inst_mem);

always @(*) begin
	if(ce_i == `ChipDisable)
		inst_o <= `ZeroWord;
	else
		inst_o <= inst_mem[addr_i[`InstMemNumLog2-1:2]];
end

endmodule


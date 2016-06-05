`include "defines.v"

module ex_mem(
	input clk,
	input rst,

	input ex_we_i,
	input [`RegAddrBus] ex_reg_addr_i,
	input [`RegBus] ex_data_i,

	output reg mem_we_o,
	output reg [`RegAddrBus] mem_reg_addr_o,
	output reg [`RegBus] mem_data_o
);

always @(posedge clk) begin
	if(rst == `RstEnable) begin
		mem_we_o <= `WriteDisable;
		mem_reg_addr_o <= `NOPRegAddr;
		mem_data_o <= `ZeroWord;
	end
	else begin
		mem_we_o <= ex_we_i;
		mem_reg_addr_o <= ex_reg_addr_i;
		mem_data_o <= ex_data_i;
	end
end

endmodule

`include "defines.v"
module if_id(
	input clk,
	input rst,
	input [`InstAddrBus] if_pc,
	input [`InstBus] if_inst,
	output reg [`InstAddrBus] id_pc,
	output reg [`InstBus] id_inst
);

always @(posedge clk) begin
	if(rst == `RstEnable) begin
		id_inst <= `ZeroWord;
		id_pc <= `ZeroWord;
	end
	else begin
		id_inst <= if_inst;
		id_pc <= if_pc;
	end
end

endmodule

`include "defines.v"

module id_ex(
	input clk,
	input rst,
	input [`RegBus] id_data_a_i,
	input [`RegBus] id_data_b_i,
	input id_we_i,
	input [`RegAddrBus] id_w_reg_addr_i,
	input [`AluSelBus] id_sel_i,
	input [`AluOpBus] id_op_i,
	
	output reg [`RegBus] ex_data_a_o,
	output reg [`RegBus] ex_data_b_o,
	output reg ex_we_o,
	output reg [`RegAddrBus] ex_w_reg_addr_o,
	output reg [`AluSelBus] ex_sel_o,
	output reg [`AluOpBus] ex_op_o
);

always @(posedge clk) begin
	if(rst == `RstEnable) begin
		ex_data_a_o <= `ZeroWord;
		ex_data_b_o <= `ZeroWord;
		ex_we_o <= `WriteDisable;
		ex_w_reg_addr_o <= `NOPRegAddr;
		ex_sel_o <= `EXE_RES_NOP;
		ex_op_o <= `EXE_NOP_OP;
	end
	else begin
		ex_data_a_o <= id_data_a_i;
		ex_data_b_o <= id_data_b_i;
		ex_we_o <= id_we_i;
		ex_w_reg_addr_o <= id_w_reg_addr_i;
		ex_sel_o <= id_sel_i;
		ex_op_o <= id_op_i;
	end
end

endmodule

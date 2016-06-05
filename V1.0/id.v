`include "defines.v"

module id(
	input rst,
	input [`InstAddrBus] pc_i,
	input [`InstBus] inst_i,

	//from ref_file
	input [`RegBus] reg_data_a_i,
	input [`RegBus] reg_data_b_i,

	//to reg_file
	output reg [`RegAddrBus] reg_addr_a_o,
	output reg [`RegAddrBus] reg_addr_b_o,
	output reg re_a,
	output reg re_b,

	//to ALU
	output reg [`RegBus] reg_data_a_o,
	output reg [`RegBus] reg_data_b_o,
	output reg we_o,
	output reg [`RegAddrBus] w_reg_addr_o,
	output reg [`AluSelBus] alu_sel_o,
	output reg [`AluOpBus] alu_op_o
);

wire [5:0] op = inst_i[31:26]; 	//op
wire [4:0] op2 = inst_i[10:6]; 	//sa
wire [5:0] op3 = inst_i[5:0];  	//func
wire [4:0] op4 = inst_i[20:16];	//rt

reg [`RegBus] imm;              //immediate
reg inst_valid;

always @(*) begin
	if(rst == `RstEnable) begin
		re_a <= `ReadDisable;
		re_b <= `ReadDisable;
		reg_addr_a_o <= `NOPRegAddr;
		reg_addr_b_o <= `NOPRegAddr;
		w_reg_addr_o <= `NOPRegAddr;
		alu_op_o <= `EXE_NOP_OP;
		alu_sel_o <= `EXE_RES_NOP;
		we_o <= `WriteDisable;
		inst_valid <= `InstInvalid;
		imm <= `ZeroWord;
	end
	else begin
		re_a <= `ReadDisable;
		re_b <= `ReadDisable;
		reg_addr_a_o <= inst_i[25:21];
		reg_addr_b_o <= inst_i[20:16];
		w_reg_addr_o <= inst_i[15:11];
		alu_op_o <= `EXE_NOP_OP;
		alu_sel_o <= `EXE_RES_NOP;
		we_o <= `WriteDisable;
		inst_valid <= `InstInvalid;
		imm <= `ZeroWord;
		case(op)
			`EXE_ORI: begin
				w_reg_addr_o <= inst_i[20:16];
				we_o <= `WriteEnable;
				imm <= {16'h0, inst_i[15:0]};
				re_a <= `ReadEnable;
				re_b <= `ReadDisable;
				alu_op_o <= `EXE_OR_OP;
				alu_sel_o <= `EXE_RES_LOGIC;
				inst_valid <= `InstValid;
			end
			default: begin
			end
		endcase
	end
end

always @(*) begin
	if(rst == `RstEnable) begin
		reg_data_a_o <= `ZeroWord;
	end
	else begin
		if(re_a == `ReadEnable)
			reg_data_a_o <= reg_data_a_i;
		else if(re_a == `ReadDisable)
			reg_data_a_o <= imm;
		else
			reg_data_a_o <= `ZeroWord;
	end
end

always @(*) begin
	if(rst == `RstEnable) begin
		reg_data_b_o <= `ZeroWord;
	end
	else begin
		if(re_b == `ReadEnable)
			reg_data_b_o <= reg_data_b_i;
		else if(re_b == `ReadDisable)
			reg_data_b_o <= imm;
		else
			reg_data_b_o <= `ZeroWord;
	end
end

endmodule


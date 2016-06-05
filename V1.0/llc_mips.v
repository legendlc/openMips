`include "defines.v"
module open_mips(
	input rst,
	input clk,
	input [`RegBus] rom_data_i,
	output [`RegBus] rom_addr_o,
	output rom_ce_o
);

//pc_reg--rom

//pc_reg--if_id
wire [`InstAddrBus] wire_pc_reg_pc;

//if_id--id
wire [`InstAddrBus] wire_if_id_pc;
wire [`InstBus] wire_if_id_inst;

//id--reg_file
wire [`RegAddrBus] wire_id_reg_addr_a;
wire [`RegAddrBus] wire_id_reg_addr_b;
wire wire_id_re_a;
wire wire_id_re_b;

//reg_file--id
wire [`RegBus] wire_reg_file_reg_data_a;
wire [`RegBus] wire_reg_file_reg_data_b;

//id--id_ex
wire [`RegBus] wire_id_reg_data_a;
wire [`RegBus] wire_id_reg_data_b;
wire [`RegAddrBus] wire_id_w_addr;
wire wire_id_we;
wire [`AluSelBus] wire_id_alu_sel;
wire [`AluOpBus] wire_id_alu_op;

//id_ex--ex
wire [`RegBus] wire_id_ex_data_a;
wire [`RegBus] wire_id_ex_data_b;
wire wire_id_ex_we;
wire [`RegAddrBus] wire_id_ex_w_addr;
wire [`AluSelBus] wire_id_ex_sel;
wire [`AluOpBus] wire_id_ex_op;

//ex--ex_mem
wire wire_ex_we;
wire [`RegAddrBus] wire_ex_w_addr;
wire [`RegBus] wire_ex_data;

//ex_mem--mem
wire wire_ex_mem_we;
wire [`RegAddrBus] wire_ex_mem_w_addr;
wire [`RegBus] wire_ex_mem_data;

//mem--mem_wb
wire wire_mem_we;
wire [`RegAddrBus] wire_mem_w_addr;
wire [`RegBus] wire_mem_data;

//mem_wb--wb
wire wire_mem_wb_we;
wire [`RegAddrBus] wire_mem_wb_w_addr;
wire [`RegBus] wire_mem_wb_data;


//
assign rom_addr_o = wire_pc_reg_pc;

//instantiate pc_reg
pc_reg pc_reg_0(
	.rst(rst),
	.clk(clk),

	.pc(wire_pc_reg_pc),
	.ce(rom_ce_o)
);

//instantiate if_id
if_id if_id_0(
	.rst(rst),
	.clk(clk),
	.if_inst(rom_data_i),
	.if_pc(wire_pc_reg_pc),

	.id_inst(wire_if_id_inst),
	.id_pc(wire_if_id_pc)
);

//instantiate id
id id_0(
	.rst(rst),
	.pc_i(wire_if_id_pc),
	.inst_i(wire_if_id_inst),
	.reg_data_a_i(wire_reg_file_reg_data_a),
	.reg_data_b_i(wire_reg_file_reg_data_b),

	.reg_addr_a_o(wire_id_reg_addr_a),
	.reg_addr_b_o(wire_id_reg_addr_b),
	.re_a(wire_id_re_a),
	.re_b(wire_id_re_b),
	.reg_data_a_o(wire_id_reg_data_a),
	.reg_data_b_o(wire_id_reg_data_b),
	.we_o(wire_id_we),
	.w_reg_addr_o(wire_id_w_addr),
	.alu_sel_o(wire_id_alu_sel),
	.alu_op_o(wire_id_alu_op)
);

//instantiate reg_file
reg_file reg_file_0(
	.clk(clk),
	.rst(rst),
	.w_addr(wire_mem_wb_w_addr),
	.w_data(wire_mem_wb_data),
	.we(wire_mem_wb_we),
	.r_addr_a(wire_id_reg_addr_a),
	.r_addr_b(wire_id_reg_addr_b),
	.re_a(wire_id_re_a),
	.re_b(wire_id_re_b),

	.r_data_a(wire_reg_file_reg_data_a),
	.r_data_b(wire_reg_file_reg_data_b)
);

//instantiate id_ex
id_ex id_ex_0(
	.clk(clk),
	.rst(rst),
	.id_data_a_i(wire_id_reg_data_a),
	.id_data_b_i(wire_id_reg_data_b),
	.id_we_i(wire_id_we),
	.id_w_reg_addr_i(wire_id_w_addr),
	.id_sel_i(wire_id_alu_sel),
	.id_op_i(wire_id_alu_op),

	.ex_data_a_o(wire_id_ex_data_a),
	.ex_data_b_o(wire_id_ex_data_b),
	.ex_we_o(wire_id_ex_we),
	.ex_w_reg_addr_o(wire_id_ex_w_addr),
	.ex_sel_o(wire_id_ex_sel),
	.ex_op_o(wire_id_ex_op)
);

//instantiate ex
ex ex_0(
	.rst(rst),
	.data_a_i(wire_id_ex_data_a),
	.data_b_i(wire_id_ex_data_b),
	.we_i(wire_id_ex_we),
	.w_reg_addr_i(wire_id_ex_w_addr),
	.sel_i(wire_id_ex_sel),
	.op_i(wire_id_ex_op),

	.we_o(wire_ex_we),
	.w_reg_addr_o(wire_ex_w_addr),
	.w_data_o(wire_ex_data)
);

//instantiate ex_mem
ex_mem ex_mem_0(
	.clk(clk),
	.rst(rst),
	.ex_we_i(wire_ex_we),
	.ex_reg_addr_i(wire_ex_w_addr),
	.ex_data_i(wire_ex_data),

	.mem_we_o(wire_ex_mem_we),
	.mem_reg_addr_o(wire_ex_mem_w_addr),
	.mem_data_o(wire_ex_mem_data)
);

//instantiate mem
mem mem_0(
	.rst(rst),
	.w_reg_addr_i(wire_ex_mem_w_addr),
	.we_i(wire_ex_mem_we),
	.w_data_i(wire_ex_mem_data),

	.w_reg_addr_o(wire_mem_w_addr),
	.we_o(wire_mem_we),
	.w_data_o(wire_mem_data)
);

//instantiate mem_wb
mem_wb mem_wb_0(
	.clk(clk),
	.rst(rst),
	.mem_w_reg_addr(wire_mem_w_addr),
	.mem_we(wire_mem_we),
	.mem_w_data(wire_mem_data),

	.wb_w_reg_addr(wire_mem_wb_w_addr),
	.wb_we(wire_mem_wb_we),
	.wb_w_data(wire_mem_wb_data)
);

endmodule

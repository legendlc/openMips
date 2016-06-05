`include "defines.v"

module ex(
	input rst,

	input [`RegBus] data_a_i,
	input [`RegBus] data_b_i,
	input we_i,
	input [`RegAddrBus] w_reg_addr_i,
	input [`AluSelBus] sel_i,
	input [`AluOpBus] op_i,

	output reg we_o,
	output reg [`RegAddrBus] w_reg_addr_o,
	output reg [`RegBus] w_data_o
);

reg [`RegBus] logic_out;

always @(*) begin
	if(rst == `RstEnable) begin
		logic_out <= `ZeroWord;
	end
	else begin
		case(op_i)
			`EXE_OR_OP: begin
				logic_out <= data_a_i | data_b_i;
			end
			default: begin
				logic_out <= `ZeroWord;
			end
		endcase
	end
end

always @(*) begin
	we_o <= we_i;
	w_reg_addr_o <= w_reg_addr_i;
	case(sel_i)
		`EXE_RES_LOGIC: begin
			w_data_o <= logic_out;
		end
		default: begin
			w_data_o <= `ZeroWord;
		end
	endcase
end

endmodule

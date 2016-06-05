`include "defines.v"

module reg_file(
	input clk,
	input rst,
	input [`RegAddrBus] w_addr,
	input [`RegBus] w_data,
	input we,                          //write enable
	input [`RegAddrBus] r_addr_a,
	output reg [`RegBus] r_data_a,
	input re_a,
	input [`RegAddrBus] r_addr_b,
	output reg [`RegBus] r_data_b,
	input re_b
);

reg [`RegBus] regs[`RegNum-1:0]; 

always @(posedge clk) begin
	if(rst == `RstDisable)
	begin
		if(we == `WriteEnable && w_addr != `RegNumLog2'h0) 
		begin
			regs[w_addr] <= w_data;
		end
	end
end


always @(*) begin
	if(rst == `RstEnable) begin
		r_data_a <= `ZeroWord;
	end
	else if(r_addr_a == `RegNumLog2'b0) begin
		r_data_a <= `ZeroWord;
	end
	else if(w_addr == r_addr_a && we == `WriteEnable && re_a == `ReadEnable) begin
		r_data_a <= w_data;
	end
	else begin
		if(re_a == `ReadDisable)
			r_data_a <= `ZeroWord;
		else
			r_data_a <= regs[r_addr_a];
	end
end

always @(*) begin
	if(rst == `RstEnable) begin
		r_data_b <= `ZeroWord;
	end
	else if(r_addr_b == `RegNumLog2'b0) begin
		r_data_b <= `ZeroWord;
	end
	else if(w_addr == r_addr_b && we == `WriteEnable && re_b == `ReadEnable) begin
		r_data_b <= w_data;
	end
	else begin
		if(re_b == `ReadDisable)
			r_data_b <= `ZeroWord;
		else
			r_data_b <= regs[r_addr_b];
	end
end


endmodule

`include "defines.v"

module mem_wb(

	input wire clk,
	input wire rst,
	

	//来自访存阶段的信息	
	input wire[`RegAddrBus] mem_w_reg_addr,
	input wire mem_we,
	input wire[`RegBus]	mem_w_data,

	//送到回写阶段的信息
	output reg[`RegAddrBus] wb_w_reg_addr,
	output reg wb_we,
	output reg[`RegBus] wb_w_data
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_w_reg_addr <= `NOPRegAddr;
			wb_we <= `WriteDisable;
		  	wb_w_reg_addr <= `ZeroWord;	
		end else begin
			wb_w_reg_addr <= mem_w_reg_addr;
			wb_we <= mem_we;
			wb_w_data <= mem_w_data;
		end    //if
	end      //always
			

endmodule

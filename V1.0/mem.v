`include "defines.v"

module mem(
	input wire rst,
	
	input wire[`RegAddrBus] w_reg_addr_i,
	input wire we_i,
	input wire[`RegBus] w_data_i,
	
	output reg[`RegAddrBus] w_reg_addr_o,
	output reg we_o,
	output reg[`RegBus] w_data_o
);
	
	always @ (*) begin
		if(rst == `RstEnable) begin
			w_reg_addr_o <= `NOPRegAddr;
			we_o <= `WriteDisable;
		  	w_data_o <= `ZeroWord;
		end 
		else begin
		  	w_reg_addr_o <= w_reg_addr_i;
			we_o <= we_i;
			w_data_o <= w_data_i;
		end    //if
	end      //always
			
endmodule

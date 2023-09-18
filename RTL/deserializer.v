module DESER (
input 			NRZI_O, shift_en, sample, stuffed, SE0,
input			CLK,RST, RX_active,

output reg		RX_valid, 
output reg		byte_err,
output reg [7:0]	data_o
);

reg [7:0]	hold;
reg [3:0]	bit_cnt;

always @(posedge CLK or negedge RST) begin
if(!RST) begin
	hold 		<= 8'b0;
	data_o 		<= 8'b0;
	bit_cnt 	<= 4'b0;
	RX_valid	<= 1'b0;
	byte_err	<= 1'b0;
end
else if (SE0 && (bit_cnt != 4'b0000)) begin 
	byte_err 	<= 1'b1;
	RX_valid	<= 1'b0;
	//data_o 	<= 8'b0;
end
else if (!RX_active) begin 
	bit_cnt		<= 1'b0;
	byte_err	<= 1'b0;
end
else if (shift_en && sample && !stuffed) begin 
	hold 		<= {NRZI_O,hold[7:1]};
	bit_cnt		<= bit_cnt + 4'b1;
end
else if (bit_cnt == 4'b1000) begin 
	data_o 		<= hold;
	RX_valid	<= 1'b1;
	bit_cnt		<= 4'b0;
	hold 		<= 8'b0;
end
else begin
	//data_o 	<= 8'b0;
	RX_valid	<= 1'b0;
	byte_err	<= 1'b0;
end
end

//flags assignment

endmodule // Serial => Parallel converter

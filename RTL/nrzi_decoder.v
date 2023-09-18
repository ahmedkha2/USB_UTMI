module NRZI_DEC (
input			CLK, RST, sample,
input			J, shift_en,

output 	wire		NRZI_O,
output 			stuffed,
output reg 		stuff_err
);

reg 		last;
reg [3:0]	one_cnt;

always@(posedge CLK or negedge RST) begin
if(!RST) begin
	last 		<= 1'b0;
	one_cnt 	<= 4'b0;
	stuff_err	<= 1'b0;
end
else if(!shift_en && sample) begin//IDLE state
	one_cnt 	<= 3'b0;
	stuff_err	<= 1'b0;
	last 	<= J;
end
else if (shift_en && sample) begin//DATA state
	last 	<= J;
	if(!NRZI_O && stuffed) begin//reset ones counter
		one_cnt 	<= 4'b0;
	end
	else if (NRZI_O && stuffed) begin//stuffing error detection
		stuff_err	<= 1'b1;
	end
	else if (NRZI_O) begin//ones counter
		one_cnt 	<= one_cnt + 1;
	end
	else begin
		one_cnt 	<= 1'b0;
		stuff_err	<= 1'b0;
	end
end
end

assign NRZI_O 		= !(J^last);//decoding output
assign stuffed 		= (one_cnt == 4'b110);//stuffed bit detection

endmodule//NRZI Decoder



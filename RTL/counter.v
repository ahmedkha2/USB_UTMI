module COUNTER (
  input 		CLK, RST, tr,
  output  		sample	
);

reg [1:0]	 edge_cnt;

always@(posedge CLK or negedge RST)
  begin
    if(!RST) begin
	edge_cnt <= 3'b000;
    end
    else if(tr) begin
	edge_cnt <= 3'b000;
    end
    else begin //4 prescale
	if (edge_cnt == 3'b011) begin
	  edge_cnt <= 3'b000;
	end
	else begin
	  edge_cnt <= edge_cnt + 1;
	end
    end	
  end
assign sample = (edge_cnt == 2'b01);
endmodule 
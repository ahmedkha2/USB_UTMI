module SYNC (
input			TX_en, TX_DP, TX_DM,
input wire		DP,DM, //unsynced inputs
input wire		CLK,RST,

output reg		DP_S, DM_S,//synchronized inputs
output			K, J, SE0, tr,//linestate signals
output reg [1:0]	LineState
);

reg			DP_s0, DP_s1;
reg			DM_s0, DM_s1;
reg 			DP_l,DM_l;

always@(posedge CLK or negedge RST) begin
 if(!RST) begin
	{DM_s0, DM_s1} 	<= 1'b0;
	DP_s0 			<= 1'b1;
	DP_s1			<= 1'b1;
	DP_l			<= 1'b1;
	DM_l			<= 1'b0;
 end
 else begin
//sync
	DP_l		<= DP_S;
	DM_l		<= DM_S;
	
	DP_s1		<= DP_s0;
	DP_s0		<= DP;

	DM_s1		<= DM_s0;
	DM_s0		<= DM;
//synchronized signals genereation
 	if (DP_s0 & DP_s1)
        DP_S     <= 1'b1;
   	else if (!DP_s0 & !DP_s1)
        DP_S     <= 1'b0;

    	if (DM_s0 & DM_s1)
        DM_S     <= 1'b1;
    	else if (!DM_s0 & !DM_s1)
        DM_S     <= 1'b0;

 end
end

//linestate signals
assign 	K 		= !DP_S & DM_S;
assign 	J 		= DP_S & !DM_S;
assign 	SE0 		= !DP_S & !DM_S;
//LineState
always@(*) begin
	if (TX_en) begin
		LineState 	= {TX_DM, TX_DP};
	end
	else begin
		LineState 	= {DM_S, DP_S};
	end
end

assign tr		= (DP_l^DP_S)|(DM_S^DM_l);

endmodule //Edge detection and synchronization

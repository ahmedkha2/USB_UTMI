module RX_TOP (
input		CLK,RST,
input		DP, DM, TX_en, TX_DP, TX_DM,

output [7:0]	Data_o,
output		RX_valid, RX_active, RX_error, eop_detection,
output [1:0]	LineState
);

wire 		DP_S,DM_S, K, J, SE0,tr;
wire		sample, S_err, byte_err, S_det, S_en, shift_en;
wire		NRZI_O, stuffed, stuff_err;

SYNC synchronizer  	(.TX_en(TX_en), .TX_DP(TX_DP), .TX_DM(TX_DM), .DP(DP), .DM(DM), .CLK(CLK), .RST(RST),
			.DP_S(DP_S), .DM_S(DM_S), .K(K), .J(J), .SE0(SE0),
			.tr(tr), .LineState(LineState));

DESER deserializer  	(.NRZI_O(NRZI_O), .shift_en(shift_en), .sample(sample), .SE0(SE0),
			.stuffed(stuffed), .CLK(CLK), .RST(RST), .RX_active(RX_active), 
			.RX_valid(RX_valid), .byte_err(byte_err), .data_o(Data_o));

COUNTER counter 	(.CLK(CLK), .RST(RST), .tr(tr), .sample(sample));

S_FSM sync 		(.S_en(S_en), .sample(sample), .J(J), .K(K), .CLK(CLK), .RST(RST), .S_det(S_det), .S_err(S_err));

FSM fsm 		(.CLK(CLK), .RST(RST), .sample(sample), .J(J), .K(K), .SE0(SE0), .stuff_err(stuff_err), .S_err(S_err), .byte_err(byte_err), .S_det(S_det),
			.RX_valid(RX_valid), .S_en(S_en), .shift_en(shift_en), .RX_active(RX_active), .RX_error(RX_error), .eop_detection(eop_detection));

NRZI_DEC decoder 	(.CLK(CLK), .RST(RST), .sample(sample), .J(J), .shift_en(shift_en), .NRZI_O(NRZI_O), .stuffed(stuffed), .stuff_err(stuff_err));

endmodule //top_module

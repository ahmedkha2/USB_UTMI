module FSM (
input		CLK, RST, sample,
input		J, K, SE0,
input		stuff_err, S_err, byte_err,//error signals
input		S_det, RX_valid,

output	reg	S_en, shift_en, 
output  reg	RX_active, RX_error, eop_detection//control signals
);

//states
localparam IDLE			= 3'b000;
localparam RX_SYNC		= 3'b001;
localparam RX_data		= 3'b010;
localparam RX_EOP0		= 3'b100;
localparam RX_EOP1		= 3'b101;
localparam RX_J			= 3'b110;
localparam RX_ERR		= 3'b111;

reg [2:0]	C_S, N_S;

//state transition
always@(posedge CLK or negedge RST) begin
if(!RST) begin
	C_S <= IDLE;
end
else begin
	C_S <= N_S;
end
end 

//next state logic & output logic
always@(*)begin 
case(C_S)
IDLE: begin//000
		S_en 		= 1'b0;
		eop_detection 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		RX_error 	= 1'b0;
	if(K)begin
		N_S 		= RX_SYNC;
		eop_detection 	= 1'b0;
		S_en 		= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		RX_error 	= 1'b0;
	end
	else begin
		N_S 		= IDLE;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		RX_error 	= 1'b0;
	end
end

RX_SYNC: begin//SYNC detection state
	if(S_det)begin
		N_S 		= RX_data;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_active 	= 1'b1;
		shift_en 	= 1'b0;
		RX_error 	= 1'b0;
	end
	else if(S_err)begin
		N_S 		= RX_ERR;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else begin
		N_S 		= RX_SYNC;
		eop_detection 	= 1'b0;
		S_en 		= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		RX_error 	= 1'b0;
	end
end

RX_data: begin//Data decoding, deserialization and unstuffing
		shift_en 	= 1'b1;
	if(SE0 && RX_valid)begin
		N_S 		= RX_EOP0;
		eop_detection 	= 1'b0;
		shift_en 	= 1'b0;
		S_en 		= 1'b0;
		RX_active 	= 1'b1;
		RX_error 	= 1'b0;
	end
	if(SE0 && !RX_valid)begin
		N_S 		= RX_EOP0;
		eop_detection 	= 1'b0;
		shift_en 	= 1'b0;
		S_en 		= 1'b0;
		RX_active 	= 1'b0;
		RX_error 	= 1'b0;
	end
	else if(stuff_err) begin
		N_S = 		RX_ERR;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(byte_err) begin
		N_S = 		RX_ERR;
		eop_detection 	= 1'b1;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else begin
		N_S = RX_data;
		shift_en 	= 1'b1;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_active 	= 1'b1;
		RX_error 	= 1'b0;
	end
end

RX_EOP0: begin//first SE0 deteciton
		RX_active 	= 1'b0;
	if(stuff_err) begin
		N_S = 		RX_ERR;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(byte_err) begin
		N_S = RX_ERR;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(SE0 && sample)begin
		N_S = RX_EOP1;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(!SE0 && sample)begin
		N_S = IDLE;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else begin
		N_S = RX_EOP0;
		eop_detection 	= 1'b0;
		shift_en 	= 1'b0;
		S_en 		= 1'b0;
		RX_active 	= 1'b1;
		RX_error 	= 1'b0;
	end
end

RX_EOP1: begin//second SE0 deteciton
	if(SE0 && sample)begin
		N_S = RX_J;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(!SE0 && sample)begin
		N_S = IDLE;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else begin
		N_S = RX_EOP1;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
end

RX_J: begin//J deteciton
	if(J && sample)begin
		N_S = IDLE;
		eop_detection 	= 1'b1;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else if(!J && sample)begin
		N_S = IDLE;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b1;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
	else begin
		N_S = RX_J;
		eop_detection 	= 1'b0;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
	end
end

RX_ERR: begin//new packet wait
	RX_error 	= 1'b0;
	if(SE0 && sample) begin
		N_S = IDLE;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		eop_detection 	=1'b1;
	end
	else begin
		N_S = RX_ERR;
		S_en 		= 1'b0;
		RX_error 	= 1'b0;
		shift_en 	= 1'b0;
		RX_active 	= 1'b0;
		eop_detection 	=1'b0;
	end
end

default: begin//J deteciton
	N_S = IDLE;
	S_en 		= 1'b0;
	shift_en 	= 1'b0;
	RX_active 	= 1'b0;
	RX_error 	= 1'b0;
	eop_detection 	= 1'b0;
end

endcase
end

endmodule //Control FSM

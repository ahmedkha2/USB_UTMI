module S_FSM (
input 		S_en, sample,
input 		J, K,
input 		CLK, RST,

output reg	S_det, S_err
);

localparam 	IDLE 	= 4'b0000,
		S_K1 	= 4'b0001,
		S_J1 	= 4'b0010,
		S_K2 	= 4'b0011,
		S_J2 	= 4'b0100,
		S_K3 	= 4'b0101,
		S_J3 	= 4'b0110,
		S_K4	= 4'b0111,
		EN	= 4'b1000;

reg [3:0]	C_S, N_S;


//state transition_seq
always@(posedge CLK or negedge RST) begin
if(!RST) begin
	C_S <= IDLE;
end
else begin
	C_S <= N_S;
end
end

//state transition_comp
always@(*)begin
{S_det, S_err} = 1'b0;
case(C_S) 
	IDLE: begin
		if(S_en) begin
			N_S = EN;
		end
		else begin
			N_S = IDLE;
		end
	end
	EN: begin
		if(sample && K) begin
			N_S = S_K1;
		end
		else if(sample && J) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = EN;
		end
	end
	S_K1: begin
		if(sample && J) begin
			N_S = S_J1;
		end
		else if(sample && K) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_K1;
		end
	end
	S_J1: begin
		if(sample && K) begin
			N_S = S_K2;
		end
		else if(sample && J) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_J1;
		end
	end
	S_K2: begin
		if(sample && J) begin
			N_S = S_J2;
		end
		else if(sample && K) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_K2;
		end
	end
	S_J2: begin
		if(sample && K) begin
			N_S = S_K3;
		end
		else if(sample && J) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_J2;
		end
	end
	S_K3: begin
		if(sample && J) begin
			N_S = S_J3;
		end
		else if(sample && K) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_K3;
		end
	end
	S_J3: begin
		if(sample && K) begin
			N_S = S_K4;
		end
		else if(sample && J) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_J3;
		end
	end
	S_K4: begin
		if(sample && K) begin
			N_S = IDLE;
			S_det = 1'b1;
		end
		else if (sample && J) begin
			N_S = IDLE;
			S_err = 1'b1;
		end
		else begin
			N_S = S_K4;
		end
	end
	default: begin
			N_S = IDLE;
	end


endcase
end 
endmodule //sync detection fsm

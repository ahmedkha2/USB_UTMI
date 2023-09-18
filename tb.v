
`timescale 1ns/1ps

module RX_tb();

//Testbench Signals
reg		CLK,RST;
reg		DP, DM, TX_en, TX_DP, TX_DM;

wire [7:0]	Data_o;
wire		RX_valid, RX_active, RX_error;
wire [1:0]	LineState;

//Parameters
parameter FS_Period = 80;

/////////////////initial////////////////////
initial
begin
// Save Waveformsample
   $dumpfile("RX_tb.vcd") ;
   $dumpvars;

//initial values
    initialize();

//reset
    reset();

//test cases 

/*
DP = 1'b0;
DM = 1'b1;//k

DP = 1'b1;
DM = 1'b0;//j
*/

//FIRST CASE = 01011010_10111111/////////////////////////////////
SYNC();
#FS_Period

//data
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

//EOP
EOP();
#FS_Period

//reset
    reset();

//SECOND CASE = 111111001////////////////////////////////
SYNC();
#FS_Period

//data
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

//EOP
EOP();
#FS_Period

//reset
    reset();

//THIRD CASE = 111111101////////////////////////////////--STUFFING-ERROR
SYNC();
#FS_Period

//data
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//j--
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

//EOP
EOP();
#FS_Period

//reset
    reset();

//FOURTH CASE = 111111101////////////////////////////////--BYTE-ERROR-CASE
SYNC();
#FS_Period

//data
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b1;
DM = 1'b0;//j
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period
DP = 1'b0;
DM = 1'b1;//k
#FS_Period

//EOP
EOP();
#FS_Period

 $stop;
end

/////////////////////////////TASKS/////////////////////
// SYNC PATTERN //
task SYNC;
  begin
	@(negedge CLK)
	DP = 1'b0;
	DM = 1'b1;//k
	#FS_Period
	DP = 1'b1;
	DM = 1'b0;//j
	#FS_Period
	
	DP = 1'b0;
	DM = 1'b1;//k
	#FS_Period
	DP = 1'b1;
	DM = 1'b0;//j
	#FS_Period

	DP = 1'b0;
	DM = 1'b1;//k
	#FS_Period
	DP = 1'b1;
	DM = 1'b0;//j
	#FS_Period
	
	DP = 1'b0;
	DM = 1'b1;//k
	#FS_Period
	DP = 1'b0;
	DM = 1'b1;//k
  end
endtask

//EOP PATTERN //
task EOP;
  begin
	DP = 1'b0;
	DM = 1'b0;//SE0
	#FS_Period
	DP = 1'b0;
	DM = 1'b0;//SE0
	#FS_Period
	DP = 1'b1;
	DM = 1'b0;//j
  end
endtask

//initial values 
task initialize;
  begin
    {DM, CLK, RST, TX_en, TX_DP, TX_DM} = 1'b0;
     DP		   = 1'b1;
  end
endtask

//reset the design
task reset;
  begin
    RST = 1'b1;
    #1
    RST = 1'b0;
    #5
    RST = 1'b1;
  end
endtask


///////////////////////Clock Generation////////////////
always begin
        #10
        CLK = !CLK ;
        #10
        CLK = !CLK ;
       end

//instantiation////////////////////////////////////////
RX_TOP DUT 	(.DP(DP),.DM(DM),.Data_o(Data_o), .TX_en(TX_en),
		.TX_DP(TX_DP), .TX_DM(TX_DM), .RX_valid(RX_valid),
		.RX_active(RX_active), .RX_error(RX_error),
		.LineState(LineState), .CLK(CLK), .RST(RST));

endmodule 
/************************************************************\
 **     Copyright (c) 2012-2024 Anlogic Inc.
 **  All Right Reserved.\
\************************************************************/
/************************************************************\
 ** Log	:	This file is generated by Anlogic IP Generator.
 ** File	:	F:/DJS130/DJS130_final/al_ip/RAM.v
 ** Date	:	2024 11 12
 ** TD version	:	5.6.119222
\************************************************************/

`timescale 1ns / 1ps

module RAM ( doa, dia, addra, cea, ocea, clka, wea, rsta );


	parameter DATA_WIDTH_A = 16; 
	parameter ADDR_WIDTH_A = 15;
	parameter DATA_DEPTH_A = 32768;
	parameter DATA_WIDTH_B = 16;
	parameter ADDR_WIDTH_B = 15;
	parameter DATA_DEPTH_B = 32768;
	parameter REGMODE_A    = "OUTREG";
	parameter WRITEMODE_A  = "NORMAL";

	output [DATA_WIDTH_A-1:0] doa;

	input  [DATA_WIDTH_A-1:0] dia;
	input  [ADDR_WIDTH_A-1:0] addra;
	input  wea;
	input  cea;
	input  ocea;
	input  clka;
	input  rsta;




	EG_LOGIC_BRAM #( .DATA_WIDTH_A(DATA_WIDTH_A),
				.ADDR_WIDTH_A(ADDR_WIDTH_A),
				.DATA_DEPTH_A(DATA_DEPTH_A),
				.DATA_WIDTH_B(DATA_WIDTH_B),
				.ADDR_WIDTH_B(ADDR_WIDTH_B),
				.DATA_DEPTH_B(DATA_DEPTH_B),
				.MODE("SP"),
				.REGMODE_A(REGMODE_A),
				.WRITEMODE_A(WRITEMODE_A),
				.RESETMODE("SYNC"),
				.IMPLEMENT("9K"),
				.DEBUGGABLE("NO"),
				.PACKABLE("NO"),
				.INIT_FILE("NONE"),
				.FILL_ALL("NONE"))
			inst(
				.dia(dia),
				.dib({16{1'b0}}),
				.addra(addra),
				.addrb({15{1'b0}}),
				.cea(cea),
				.ceb(1'b0),
				.ocea(ocea),
				.oceb(1'b0),
				.clka(clka),
				.clkb(1'b0),
				.wea(wea),
				.web(1'b0),
				.bea(1'b0),
				.beb(1'b0),
				.rsta(rsta),
				.rstb(1'b0),
				.doa(doa),
				.dob());


endmodule
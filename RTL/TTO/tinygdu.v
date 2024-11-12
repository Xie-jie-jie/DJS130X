//  TinyGDU-80
//	2024.7.14 H.J.Xie

//--Features:
//----Resolution:
//   VGA  640x480@60Hz (ENABLE_640)
//----VRAM Requirement
//  VRAM should have at least 1 read-only port
//  data width: 16-bit
//	min: 80x64x16bit   = 80Kbit
//	max: 80x64x16bitx2 = 160Kbit
//----Font ROM Requirement
//	min: 128x8x16bit = 16Kbit
//	max: 256x8x16bit = 32Kbit
//----Display Mode
//	mode 0: Color ASCII
//		--Use RGB332 as foreground color
//		--size: 80x32, only display 80x30
//  	--unit: {RGB332[15:8], ascii[7:0]}

//----Color Format----//
//RGB332: R[7:5] G[4:2] B[1:0]
//RGB565: R[15:11] G[10:5] B[4:0]
//RGB888: R[23:16] G[15:8] B[7:0]

/////----- Step1. Configure your clock, and choose your resolution-----/////
// Choose your resolution:
// Default 		clk_pix = 40MHz, 	Resolution: 800x600@60Hz
// ENABLE_640	clk_pix = 25.2MHz,  Resolution: 640x480@60Hz

module tinygdu
#(
    parameter ENABLE_640 = 1'b1,
	parameter INIT_BACKGROUND_COLOR = 24'h000000		//init background color
)
(
	input  wire			clk_pix,		//pixel clock
	input  wire			rst_n,     		//sync reset

	//TinyGDU interface
	input  wire			clk_ram,		//clk for vram, must >= 2*clk_pix, phase need be same as clk_pix

	//VRAM-A interface
	input  wire[15:0] 	vram_a_vrdata,	//VGA port read data
	output wire			vram_a_ven,		//VGA port enable (clock enable)
	output wire			vram_a_vclk,	//VGA port clock
	output wire			vram_a_vwe,		//always set 0
	output wire[12:0] 	vram_a_vaddr,	//VGA port read address

	//Font ROM interface
	input  wire[15:0]	ftrom_data,		//Font ROM read data
	output wire[10:0]	ftrom_addr,		//Font ROM read address

	//VGA(XGA) interface
	output wire			vga_dclk,   	//VGA pixel clock
	output wire			vga_hs,	    	//VGA horizontal sync
	output wire			vga_vs,	    	//VGA vertical sync
	output wire			vga_de,			//VGA display enable
	output wire[23:0]	vga_rgb 		//VGA display data {r[23:16], g[15:8], b[7:0]}
);

////////////////----------------Shared wires&registers----------------////////////////

wire	[23:0]	vga_pixel;      //VGA pixel color
wire	[9:0]	vga_xpos;		//VGA horizontal coordinate
wire	[9:0]	vga_ypos;		//VGA vertical coordinate

wire 	[9:0] 	yin;			//Y after offset
wire	[9:0]	xin;			//X after offset

////////////////----------------Data Transmission----------------////////////////
assign vram_a_vclk = clk_ram;

////////////////----------------Data Display----------------////////////////
/////*Calculate X, Y after offset*//////
assign yin = vga_ypos[9:0];
assign xin = vga_xpos[9:0];

/////*Display*//////
wire [23:0] mode_pixel;        //mode pixel
wire [15:0] vram_vrdata = vram_a_vrdata[15:0];

wire [12:0] mode_vaddr = {1'b0,xin[9:3], yin[8:4]};	//VRAM address

///*Mode 0: Color ASCII*///
wire [7:0] mode0_char = vram_vrdata[7:0];			//vram_a_vrdata[7:0];
wire [7:0] mode0_rgb332 = vram_vrdata[15:8];		//foreground color
wire [10:0] mode0_ftaddr = {mode0_char, xin[2:0]};	//calculate font rom address
wire [7:0] mode0_r = {mode0_rgb332[7:5], mode0_rgb332[7:5], mode0_rgb332[7:6]};
wire [7:0] mode0_g = {mode0_rgb332[4:2], mode0_rgb332[4:2], mode0_rgb332[4:3]};
wire [7:0] mode0_b = {4{mode0_rgb332[1:0]}};
assign mode_pixel = (ftrom_data[yin[3:0]]) ? {mode0_r, mode0_g, mode0_b} : INIT_BACKGROUND_COLOR;	//color in mode0

///*Mode choose & display*///
assign vram_a_ven = clk_ram;
assign vram_a_vwe = 0;
assign ftrom_addr = mode0_ftaddr;
assign vram_a_vaddr = mode_vaddr;
assign vga_pixel = mode_pixel;

////////////////----------------VGA Driver----------------////////////////
/* Resolution Settings
************	clk		 	H_SYNC 		H_BACK 		H_DISP 		H_FRONT 	H_TOTAL 		V_SYNC 		V_BACK 		V_DISP 		V_FRONT 	V_TOTAL
800x600@60Hz	40MHz		128			88 			800 		40 			1056			4			23			600 		1			628		*
640x480@60Hz	25.2MHz		96			48 			640 		16 			800 			2			33			480 		10			525		*
*/	

localparam	H_SYNC =  	ENABLE_640 ? 96 : 128	;
localparam	H_BACK =  	ENABLE_640 ? 48 : 88	;
localparam	H_DISP =  	ENABLE_640 ? 640 : 800	;
localparam	H_FRONT =  	ENABLE_640 ? 16 : 40	;
localparam	H_TOTAL =  	ENABLE_640 ? 800 : 1056;
localparam	V_SYNC =  	ENABLE_640 ? 2 : 4	;
localparam	V_BACK =  	ENABLE_640 ? 33 : 23	;
localparam	V_DISP =  	ENABLE_640 ? 480 : 600	;
localparam	V_FRONT =  	ENABLE_640 ? 10 : 1	;
localparam	V_TOTAL =  	ENABLE_640 ? 525 : 628  ;
localparam	H_AHEAD = 	12'd1;

reg [11:0] hcnt; 
reg [11:0] vcnt;
wire lcd_request;

/*******************************************
		SYNC--BACK--DISP--FRONT
*******************************************/ 
//h_sync counter & generator
always @ (posedge clk_pix or negedge rst_n)
begin
	if (!rst_n)
		hcnt <= 12'd0;
	else
	begin
        if(hcnt < H_TOTAL - 1'b1)		//line over			
            hcnt <= hcnt + 1'b1;
        else
            hcnt <= 12'd0;
	end
end 

assign	vga_hs = (hcnt <= H_SYNC - 1'b1) ? 1'b0 : 1'b1; // line over flag

//v_sync counter & generator
always@(posedge clk_pix or negedge rst_n)
begin
	if (!rst_n)
		vcnt <= 12'b0;
	else if(hcnt == H_TOTAL - 1'b1)	//line over
		begin
		if(vcnt == V_TOTAL - 1'b1)		//frame over
			vcnt <= 12'd0;
		else
			vcnt <= vcnt + 1'b1;
		end
end

assign	vga_vs = (vcnt <= V_SYNC - 1'b1) ? 1'b0 : 1'b1; // frame over flag

// LED clock
assign	vga_dclk = ~clk_pix;

// Control Display
assign	vga_de		=	(hcnt >= H_SYNC + H_BACK  && hcnt < H_SYNC + H_BACK + H_DISP) &&
						(vcnt >= V_SYNC + V_BACK  && vcnt < V_SYNC + V_BACK + V_DISP) 
						? 1'b1 : 1'b0;                   // Display Enable Signal
						
assign	vga_rgb 	= 	vga_de ? vga_pixel : 24'h000000;	

//ahead x clock
assign	lcd_request	=	(hcnt >= H_SYNC + H_BACK - H_AHEAD && hcnt < H_SYNC + H_BACK + H_DISP - H_AHEAD) &&
						(vcnt >= V_SYNC + V_BACK && vcnt < V_SYNC + V_BACK + V_DISP) 
						? 1'b1 : 1'b0;
//lcd xpos & ypos
assign	vga_xpos	= 	lcd_request ? (hcnt - (H_SYNC + H_BACK - H_AHEAD)) : 12'd0;
assign	vga_ypos	= 	lcd_request ? (vcnt - (V_SYNC + V_BACK)) : 12'd0;

endmodule
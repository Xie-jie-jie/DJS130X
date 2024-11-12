module DJS130_gdu(
    input  wire clk_24m,
	input  wire rst_n,

    //DJS130 Device Interface

    input wire       i_DRA,
    input wire       i_KZS,
    input wire       i_KZC,
    input wire[15:0] i_dev_SR,
    output wire o_dev_ZDQQ,
    output wire[1:0] o_dev_ZT,   //{Done, Busy}
    output wire[5:0] o_dev_DMs,
    output wire o_vram_we,

	output wire [7:0] t_A,
    output wire         t_busy,
    output wire         t_done,	
    //VGA Interface
	output wire			vga_dclk,   	//VGA pixel clock
	output wire			vga_hs,	    	//VGA horizontal sync
	output wire			vga_vs,	    	//VGA vertical sync
	output wire			vga_de,			//VGA display enable
	output wire[23:0]	vga_rgb 



);
wire[8:0] i_dev_KZ;
assign i_dev_KZ[0]=i_DRA;
assign i_dev_KZ[6]=i_KZS;
assign i_dev_KZ[7]=i_KZC;





PLL0 u_PLL0(
  .refclk(clk_24m),
  .reset(~rst_n),
  .clk0_out(clk_204m) 
);

reg r_t1;
reg r_t2;
reg r_t3;

always@(posedge clk_204m or negedge rst_n) begin
	if (~rst_n) r_t1 <= 1'b0;
    else r_t1 <= ~r_t1;
end

always@(posedge r_t1 or negedge rst_n) begin
	if (~rst_n) r_t2 <= 1'b0;
    else r_t2 <= ~r_t2;
end

always@(posedge r_t2 or negedge rst_n) begin
	if (~rst_n) r_t3 <= 1'b0;
    else r_t3 <= ~r_t3;
end

wire clk_100m = r_t1;
wire clk_50m4 = r_t2;
wire clk_25m2 = r_t3;

wire[15:0] vram_addr;
wire[15:0] vram_rdata;
wire vram_clk;
wire[4:0] vram_yoffset;

wire tto_vram_we;
wire tto_vram_ce;
wire[15:0] tto_vram_wdata;
wire[11:0] tto_vram_addr;


VRAM_3 u_VRAM_3( 
//tto
.dia   (tto_vram_wdata), 
.addra ({1'b0,tto_vram_addr[11:5],tto_vram_addr[4:0]+vram_yoffset}), 
.cea   (o_vram_we), 
.clka  (clk_24m),
//gdu80ss
.dob   (vram_rdata), 
.addrb ({1'b0,vram_addr[11:5],vram_addr[4:0]+vram_yoffset}), 
.ceb   (1'b1), 
.oceb  (1'b1), 
.clkb  (vram_clk), 
.rstb  (~rst_n)
);

wire[10:0] vram_addr2;
wire[15:0] vram_rdata2;


VRAM_2 u_FROM_2( 
	.doa(vram_rdata2), 
	.dia(16'b0), 
	.addra(vram_addr2), 
	.cea(1'b1), 
	.ocea(1'b1), 
	.clka(vram_clk), 
	.wea(1'b0), 
	.rsta(~rst_n)
);

tinygdu u_tinygdu
(
	.clk_pix(clk_25m2),		//pixel clock
	.rst_n(rst_n),     		//sync reset

	//TinyGDU interface
	.clk_ram(clk_100m),		//clk for vram, must >= 2*clk_pix, phase need be same as clk_pix
	
	//VRAM-A interface
	.vram_a_vrdata(vram_rdata),	//VGA port read data
	.vram_a_vclk(vram_clk),	//VGA port clock
	.vram_a_vaddr(vram_addr),	//VGA port read address

	
	//Font ROM interface
	.ftrom_data(vram_rdata2),		//Font ROM read data
	.ftrom_addr(vram_addr2),		//Font ROM read address

	//VGA(XGA) interface
	.vga_dclk(vga_dclk),   	//VGA pixel clock
	.vga_hs(vga_hs),	    	//VGA horizontal sync
	.vga_vs(vga_vs),	    	//VGA vertical sync
	.vga_de(vga_de),			//VGA display enable
	.vga_rgb(vga_rgb) 		//VGA display data {r[23:16], g[15:8], b[7:0]}
);

DJS130_TTO u_DJS130_TTO(
.i_dev_ZZ0       (~rst_n)   ,
.i_dev_KZ        (i_dev_KZ)   ,
.i_dev_SR        (i_dev_SR)   ,
.o_dev_ZDQQ      (o_dev_ZDQQ)   ,
.o_dev_ZT        (o_dev_ZT)   ,  
.o_dev_DMs       (o_dev_DMs)   ,
.i_vram_clk      (clk_24m)   ,
.o_vram_we       (o_vram_we)   ,
.o_vram_ce       (tto_vram_ce)   ,
.o_vram_data     (tto_vram_wdata)   ,
.o_vram_addr     (tto_vram_addr)   ,
.t_A(t_A),
.t_busy(t_busy),
.t_done(t_done),
.o_vram_yoffset  (vram_yoffset)  
);

endmodule
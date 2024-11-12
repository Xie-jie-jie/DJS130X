module DJS130_top (
    input wire          rst_n,
    input wire          clk, 
    input  wire         spi_mosi,
    input  wire         spi_clk,
    input  wire          i_write,
    input  wire [7:0]    i_data,
    input wire           i_CACHE_FLUSH,
    input   wire        i_spi_miso,
    output  wire        i_spi_sck,
    output  wire        i_spi_ncs,
    output  wire        i_spi_mosi,   
    output wire			vga_dclk,
    output wire			vga_hs,  
    output wire			vga_vs,  
    output wire			vga_de,
    output wire[23:0]	vga_rgb
 
); 
    wire[7:0]     i_cram_rdata;
    wire         o_cram_clk;
    wire         o_cram_ce;
    wire         o_cram_we;
    wire[7:0]    o_cram_wdata;
    wire[11:0]   o_cram_addr;
    wire [15:0]   o_dev_SC;
    wire          o_dev_ZDQQ;
    wire[1:0]     o_dev_ZT;
    wire [4:0]   o_rom_addr;
    wire [14:0]  o_mem_addr;
    wire [15:0]  o_mem_din;
    wire         o_mem_we;
    wire         o_mem_clk;
    wire [15:0]   i_rom_dout;
    wire [15:0]   i_mem_dout;
    wire          i_mem_err = 0;
    wire          i_con_QDZ;
    wire          i_con_TJ;
    wire          i_con_LS;
    wire          i_con_YD;
    wire          i_con_DZL;
    wire [15:0]   i_con_DM;
    wire [5:0]    i_dev7_DMs;
    wire [15:0]   i_dev7_SC;
    wire          i_dev7_ZDQQ;
    wire [1:0]    i_dev7_STDM;
    wire          i_dev7_STDQQ;
    wire [5:0]    i_dev8_DMs;
    wire [15:0]   i_dev8_SC;
    wire          i_dev8_ZDQQ;
    wire [5:0]    i_dev9_DMs;
    wire [15:0]   i_dev9_SC;
    wire          i_dev9_ZDQQ;
    wire [5:0]    i_dev10_DMs;
    wire [15:0]   i_dev10_SC;
    wire          i_dev10_ZDQQ;
    wire [5:0]    i_dev11_DMs;
    wire [15:0]   i_dev11_SC;
    wire          i_dev11_ZDQQ;
    wire [5:0]    i_dev12_DMs;
    wire [15:0]   i_dev12_SC;
    wire          i_dev12_ZDQQ;
    wire [5:0]    i_dev13_DMs;
    wire [15:0]   i_dev13_SC;
    wire          i_dev13_ZDQQ;
    wire [5:0]    i_dev14_DMs;
    wire [15:0]   i_dev14_SC;
    wire          i_dev14_ZDQQ;
    wire [5:0]    i_dev15_DMs;
    wire [15:0]   i_dev15_SC;
    wire          i_dev15_ZDQQ;
    wire [1:0]    i_dev7_ZT;
    wire [1:0]    i_dev8_ZT;
    wire [1:0]    i_dev9_ZT;
    wire [1:0]    i_dev10_ZT;
    wire [1:0]    i_dev11_ZT;
    wire [1:0]    i_dev12_ZT;
    wire [1:0]    i_dev13_ZT;
    wire [1:0]    i_dev14_ZT;
    wire [1:0]    i_dev15_ZT;
    wire          o_con_YX;
    wire          o_con_ZD;
    wire          o_con_QZZT;
    wire          o_con_JZZT;
    wire          o_con_ZXZT;
    wire          o_con_Cjyc;
    wire          o_con_Cj;
    wire [7:0]    o_con_XSZL;
    wire [14:0]   o_con_XSDZ;
    wire [15:0]   o_con_XSSJ;
    wire [15:0]   o_dev_SR;
    wire          o_dev_ZZ0;
    wire [8:0]    o_dev7_KZ;
    wire [3:0]    o_dev7_STDKZ;
    wire [8:0]    o_dev8_KZ;
    wire [8:0]    o_dev9_KZ;
    wire [8:0]    o_dev10_KZ;
    wire [8:0]    o_dev11_KZ;
    wire [8:0]    o_dev12_KZ;
    wire [8:0]    o_dev13_KZ;
    wire [8:0]    o_dev14_KZ;
    wire [8:0]    o_dev15_KZ;
    wire          clk0;
ZZB u_ZZB(
    .rst_n(rst_n),
    .clk(clk),
    .i_rom_dout(i_rom_dout),
    .i_mem_dout(i_mem_dout),
    .i_mem_err(i_mem_err),
    .i_con_QDZ(i_con_QDZ),
    .i_con_TJ(i_con_TJ),
    .i_con_LS(i_con_LS),
    .i_con_YD(i_con_YD),
    .i_con_DZL(i_con_DZL),
    .i_con_DM(i_con_DM),
    .i_dev7_DMs(i_dev7_DMs),
    .i_dev7_SC(i_dev7_SC),
    .i_dev7_ZDQQ(i_dev7_ZDQQ),
    .i_dev7_STDM(i_dev7_STDM),
    .i_dev7_STDQQ(i_dev7_STDQQ),
    .i_dev8_DMs(i_dev8_DMs),
    .i_dev8_SC(i_dev8_SC),
    .i_dev8_ZDQQ(i_dev8_ZDQQ),
    .i_dev9_DMs(i_dev9_DMs),
    .i_dev9_SC(i_dev9_SC),
    .i_dev9_ZDQQ(i_dev9_ZDQQ),
    .i_dev10_DMs(i_dev10_DMs),
    .i_dev10_SC(i_dev10_SC),
    .i_dev10_ZDQQ(i_dev10_ZDQQ),
    .i_dev11_DMs(i_dev11_DMs),
    .i_dev11_SC(i_dev11_SC),
    .i_dev11_ZDQQ(i_dev11_ZDQQ),
    .i_dev12_DMs(i_dev12_DMs),
    .i_dev12_SC(i_dev12_SC),
    .i_dev12_ZDQQ(i_dev12_ZDQQ),
    .i_dev13_DMs(i_dev13_DMs),
    .i_dev13_SC(i_dev13_SC),
    .i_dev13_ZDQQ(i_dev13_ZDQQ),
    .i_dev14_DMs(i_dev14_DMs),
    .i_dev14_SC(i_dev14_SC),
    .i_dev14_ZDQQ(i_dev14_ZDQQ),
    .i_dev15_DMs(i_dev15_DMs),
    .i_dev15_SC(i_dev15_SC),
    .i_dev15_ZDQQ(i_dev15_ZDQQ),
    .i_dev7_ZT(i_dev7_ZT),
    .i_dev8_ZT(i_dev8_ZT),
    .i_dev9_ZT(i_dev9_ZT),
    .i_dev10_ZT(i_dev10_ZT),
    .i_dev11_ZT(i_dev11_ZT),
    .i_dev12_ZT(i_dev12_ZT),
    .i_dev13_ZT(i_dev13_ZT),
    .i_dev14_ZT(i_dev14_ZT),
    .i_dev15_ZT(i_dev15_ZT),
    .o_rom_addr(o_rom_addr),
    .o_mem_addr(o_mem_addr),
    .o_mem_din(o_mem_din),
    .o_mem_we(o_mem_we),
    .o_mem_clk(o_mem_clk),
    .o_con_YX(o_con_YX),
    .o_con_ZD(o_con_ZD),
    .o_con_QZZT(o_con_QZZT),
    .o_con_JZZT(o_con_JZZT),
    .o_con_ZXZT(o_con_ZXZT),
    .o_con_Cjyc(o_con_Cjyc),
    .o_con_Cj(o_con_Cj),
    .o_con_XSZL(o_con_XSZL),
    .o_con_XSDZ(o_con_XSDZ),
    .o_con_XSSJ(o_con_XSSJ),
    .o_dev_SR(o_dev_SR),
    .o_dev_ZZ0(o_dev_ZZ0),
    .o_dev7_KZ(o_dev7_KZ),
    .o_dev7_STDKZ(o_dev7_STDKZ),
    .o_dev8_KZ(o_dev8_KZ),
    .o_dev9_KZ(o_dev9_KZ),
    .o_dev10_KZ(o_dev10_KZ),
    .o_dev11_KZ(o_dev11_KZ),
    .o_dev12_KZ(o_dev12_KZ),
    .o_dev13_KZ(o_dev13_KZ),
    .o_dev14_KZ(o_dev14_KZ),
    .o_dev15_KZ(o_dev15_KZ)
);
TTO_TOP u_TTO_TOP(
    .clk_24m(clk),
    .rst_n(rst_n),
    .spi_mosi(spi_mosi),
    .spi_clk(spi_clk),
    .vga_dclk(vga_dclk),
    .vga_hs(vga_hs),	 
    .vga_vs(vga_vs),	 
    .vga_de(vga_de),
    .vga_rgb(vga_rgb),
    .i_dev_SR(o_dev_SR),
    .i_DRA(o_dev15_KZ[0]),
    .i_KZS(o_dev15_KZ[6]),
    .i_KZC(o_dev15_KZ[7]),
    .o_dev_DMs(i_dev15_DMs)
);
TTI_TOP u_TTI_TOP( 
    .QAS(o_dev14_KZ[0]),           
    .KZS(o_dev14_KZ[6]),           
    .KZC(o_dev14_KZ[7]),           
    .i_write(i_write),       
    .i_data(i_data),        
    .rst_n(rst_n),         
    .o_dev_ZDQQ(o_dev14_ZDQQ),    
    .o_dev_SC(o_dev_SC),
    .o_dev_DMS(i_dev14_DMs)
);
DJS130_RTC u_DJS130_RTC(
    .i_dev_KZ(o_dev13_KZ),
    .i_dev_SR(o_dev_SR),
    .i_dev_ZZ0(o_dev_ZZ0),
    .o_dev_DMs(o_dev13_DMs),
    .o_dev_ZDQQ(o_dev13_ZDQQ),
    .o_dev_ZT(o_dev13_ZT),
    .i_clk(clk0)
);
PLL u_PLL(
  .refclk(clk),
  .reset(rst_n),
  .clk0_out(clk0) 
);
DJS130_DKP u_DJS130_DKP(
    .i_clk(clk),
    .i_CACHE_FLUSH(i_CACHE_FLUSH),
    .i_dev_ZZ0(o_dev_ZZ0),
    .i_dev_KZ(o_dev7_KZ),
    .i_dev_SR(o_dev_SR),
    .o_dev_ZDQQ(i_dev7_ZDQQ),
    .o_dev_ZT(i_dev7_ZT),  
    .o_dev_DMs(i_dev7_DMs),
    .o_dev_SC(i_dev7_SC),
    .i_dev_STDKZ(o_dev7_STDKZ),
    .o_dev_STDQQ(i_dev7_STDQQ),
    .o_dev_STDM(i_dev7_STDM),
    .i_spi_miso(i_spi_miso),
    .i_spi_sck(i_spi_sck),
    .i_spi_ncs(i_spi_ncs),
    .i_spi_mosi(i_spi_mosi),
    .i_cram_rdata(i_cram_rdata),
    .o_cram_clk(o_cram_clk),
    .o_cram_ce(o_cram_ce),
    .o_cram_we(o_cram_we),
    .o_cram_wdata(o_cram_wdata),
    .o_cram_addr(o_cram_addr)
);
ROM u_ROM(
    .rom_addr(o_rom_addr),
    .rom_YD(i_rom_dout)
);
CRAM u_CRAM(
    .doa(i_cram_rdata),
    .dia(o_cram_wdata),
    .addra(o_cram_addr), 
    .cea(o_cram_ce), 
    .ocea(1'b1), 
    .clka(o_cram_clk), 
    .wea(o_cram_we), 
    .rsta(!rst_n)
);
endmodule
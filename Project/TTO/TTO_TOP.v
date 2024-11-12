module TTO_TOP(
    input  wire clk_24m                  ,
    input  wire rst_n                   ,
 
    input  wire spi_mosi                ,
    input  wire spi_clk                 ,
    input  wire [15:0]          i_dev_SR,
    input  wire                 i_DRA,
    input  wire                 i_KZS,
    input  wire                 i_KZC,
    output wire			vga_dclk        ,
    output wire			vga_hs          ,	 
    output wire			vga_vs          ,	 
    output wire			vga_de          ,
    output wire[23:0]	vga_rgb         ,
    output wire[5:0]    o_dev_DMs 

 );
wire o_dev_ZDQQ                  ;
wire[1:0] o_dev_ZT               ;
wire o_vram_we                   ;


DJS130_gdu u_DJS130_gdu(
.clk_24m       (clk_24m)     ,
.rst_n         (rst_n)     ,
.i_DRA         (i_DRA)     ,
.i_KZS         (i_KZS)     ,
.i_KZC         (i_KZC)     ,
.i_dev_SR      (i_dev_SR)     ,
.o_dev_ZDQQ    (o_dev_ZDQQ)     ,
.o_dev_ZT      (o_dev_ZT)     ,                           
.o_dev_DMs     (o_dev_DMs)     ,
.o_vram_we     (o_vram_we)     ,

.vga_dclk      (vga_dclk)     ,                       
.vga_hs        (vga_hs  )     ,	    	                    
.vga_vs        (vga_vs  )     ,	    	                    
.vga_de        (vga_de  )     ,			                    
.vga_rgb       (vga_rgb )     
);


wire         valid          ;

wire [7:0]   result         ;
assign t_result=result;
SPI_read u_SPI_read(
//spi interface
.CS      (1'b1)   ,
.mosi    (spi_mosi)   ,
.clk     (spi_clk)   ,
//device interface
.rst_n   (rst_n)   ,
.valid   (valid )   ,
.result  (result)   
);

endmodule

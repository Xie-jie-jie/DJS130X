//Author: H.J.Xie

module DJS130_DKP
#(
    parameter DEV_DMs = 6'o33
)
(
    input wire          i_clk,
    input wire          i_CACHE_RESET,
    input wire          i_CACHE_FLUSH,
    //DJS130 Normal Device Interface
    input wire          i_dev_ZZ0,
    input wire[8:0]     i_dev_KZ,
    input wire[15:0]    i_dev_SR,
    output wire         o_dev_ZDQQ,     //ok
    output wire[1:0]    o_dev_ZT,       //{Done, Busy}
    output wire[5:0]    o_dev_DMs,      //ok
    output wire[15:0]   o_dev_SC,
    //DJS130 DMA Interface
    input wire[3:0]     i_dev_STDKZ,
    output wire         o_dev_STDQQ,    //ok
    output wire[1:0]    o_dev_STDM,     //ok
    //flash Interface
    input   wire        i_spi_miso,     //ok
    output  wire        i_spi_sck,      //ok
    output  wire        i_spi_ncs,      //ok
    output  wire        i_spi_mosi,     //ok
    //4KB cache Interface
    input wire[7:0]     i_cram_rdata,   //ok
    output wire         o_cram_clk,     //ok
    output wire         o_cram_ce,      //ok
    output wire         o_cram_we,      //ok
    output wire[7:0]    o_cram_wdata,   //ok
    output wire[11:0]   o_cram_addr     //ok
);

localparam STATE_IDLE               = 6'd0;
localparam STATE_START              = 6'd1;
localparam STATE_DONE               = 6'd2;
localparam STATE_READ_START         = 6'd3;
localparam STATE_SPI_READ0_START    = 6'd4;
localparam STATE_SPI_READ0          = 6'd5;
localparam STATE_SPI_READ0_DONE     = 6'd6;
localparam STATE_SPI_READ1_START    = 6'd7;
localparam STATE_SPI_READ1          = 6'd8;
localparam STATE_SPI_READ1_DONE     = 6'd9;
localparam STATE_SPI_READ_DONE          = 6'd10;
localparam STATE_STDR_QQ            = 6'd11;
localparam STATE_STDR_START         = 6'd12;
localparam STATE_STDR_DONE          = 6'd13;
localparam STATE_WRITE_START        = 6'd14;
localparam STATE_CACHE_CHECK        = 6'd15;
localparam STATE_EXCHANGE_START     = 6'd16;
localparam STATE_SPI_WE0_START      = 6'd17;
localparam STATE_SPI_WE0            = 6'd18;
localparam STATE_SPI_WE0_DONE       = 6'd19;
localparam STATE_SPI_ERASE_START    = 6'd20;
localparam STATE_SPI_ERASE          = 6'd21;
localparam STATE_SPI_ERASE_DONE     = 6'd22;
localparam STATE_SPI_WE1_START      = 6'd23;
localparam STATE_SPI_WE1            = 6'd24;
localparam STATE_SPI_WE1_DONE       = 6'd25;
localparam STATE_EXCHANGE_WB        = 6'd26;
localparam STATE_CACHE_READ         = 6'd27;
localparam STATE_SPI_WRITE_START    = 6'd28;
localparam STATE_SPI_WRITE          = 6'd29;
localparam STATE_SPI_WRITE_DONE     = 6'd30;
localparam STATE_EXCHANGE_RD        = 6'd31;
localparam STATE_SPI_READEX_START   = 6'd32;
localparam STATE_SPI_READEX         = 6'd33;
localparam STATE_SPI_READEX_DONE    = 6'd34;
localparam STATE_EXCHANGE_DONE      = 6'd35;
localparam STATE_WRITE_SECT_START   = 6'd36;
localparam STATE_STDC_QQ            = 6'd37;
localparam STATE_STDC_START         = 6'd38;
localparam STATE_STDC_DONE          = 6'd39;
localparam STATE_WCACHE0_START      = 6'd40;
localparam STATE_WCACHE0_A          = 6'd41;
localparam STATE_WCACHE0_B          = 6'd42;
localparam STATE_WCACHE0_DONE       = 6'd43;
localparam STATE_WCACHE1_START      = 6'd44;
localparam STATE_WCACHE1_A          = 6'd45;
localparam STATE_WCACHE1_B          = 6'd46;
localparam STATE_WCACHE1_DONE       = 6'd47;
localparam STATE_WCACHE_DONE        = 6'd48;
localparam STATE_WRITE_SECT_DONE    = 6'd49;
localparam STATE_WRITE_CHECK        = 6'd50;

localparam MODE_READ                = 2'b00;
localparam MODE_WRITE               = 2'b01;
localparam MODE_SEEK                = 2'b10;
localparam MODE_REPOS               = 2'b11;

localparam FLS_READ                 = 3'd4;
localparam FLS_WE                   = 3'd1;
localparam FLS_WRITE                = 3'd3;
localparam FLS_ERASE                = 3'd7;

localparam STDM_SR                  = 2'b10;
localparam STDM_SC                  = 2'b00;

wire    i_DRA       = i_dev_KZ[0];
wire    i_DRB       = i_dev_KZ[1];
wire    i_DRC       = i_dev_KZ[2];
wire    i_QAS       = i_dev_KZ[3];
wire    i_QBS       = i_dev_KZ[4];
wire    i_QCS       = i_dev_KZ[5];
wire    i_KZS       = i_dev_KZ[6];
wire    i_KZC       = i_dev_KZ[7];
wire    i_KZP       = i_dev_KZ[8];
wire    i_STDR      = i_dev_STDKZ[2];
wire    i_STDC      = i_dev_STDKZ[3];
wire    i_QSTDD     = i_dev_STDKZ[1];

///clock associate with DJS130
reg         r_busy;
reg         r_done;
reg[15:0]   r_A;
reg[15:0]   r_B;
reg[15:0]   r_C;
reg         r_STDRCF;
reg         r_STDCCF;
reg[15:0]   r_STD_wdata;              //Update at posedge of STDC

///clock asscociate with i_clk
//flash controller interface
reg         r_fls_start;
reg [7:0]   r_fls_wdata;
reg [2:0]   r_fls_mode;
reg[22:0]   r_fls_addr;
wire [7:0]  t_fls_rdata;
wire        t_fls_busy;

reg[5:0]    r_STATE;
reg         r_flush;

reg         r_rw_done;
reg         r_seek_done;
reg[7:0]    r_cyl;
reg[3:0]    r_surf;
reg[2:0]    r_sect;
reg[4:0]    r_sect_cnt;
reg[8:0]    r_word_cnt;
wire[5:0]   t_sursec = r_surf * 6 + r_sect;
reg[10:0]   r_check_addr;

reg[14:0]   r_nc_addr;                //When QSTDD == 1 , output this
reg[15:0]   r_STD_rdata;              //When STDR == 1 , output this
reg         r_STDQQ;
reg[1:0]    r_STDM;

//Cache Interface
//USE i_CACHE_RESET TO RESET
reg[10:0]   r_cache_addr;
reg[12:0]   r_exchange_cnt;
wire[7:0]   t_cache_rdata;
reg[7:0]    r_cache_wdata;
reg         r_cache_we;

//output/input wire assign
assign o_dev_ZDQQ   = r_done;
assign o_dev_ZT     = {r_done, r_busy};
assign o_dev_DMs    = DEV_DMs;
assign i_cram_rdata = t_cache_rdata;
assign o_cram_clk   = i_clk;
assign o_cram_ce    = 1'b1;
assign o_cram_we    = r_cache_we;
assign o_cram_wdata = r_cache_wdata;
assign o_cram_addr  = r_cache_addr;
assign o_dev_STDQQ  = r_STDQQ;
assign o_dev_STDM   = r_STDM;
assign o_dev_SC     =   (i_QAS) ? {r_rw_done,r_seek_done,14'd0} : 
                        (i_QBS) ? r_nc_addr : 
                         {3'd0, r_surf, r_sect, r_sect_cnt[3:0]};

//Register A
always @(posedge i_DRA or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) r_A <= 16'd0;
    else r_A <= i_dev_SR;
end

//Register B
always @(posedge i_DRB or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) r_B <= 16'd0;
    else r_B <= i_dev_SR;
end

//Register C
always @(posedge i_DRC or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) r_C <= 16'd0;
    else r_C <= i_dev_SR;
end

always @(posedge i_clk or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) begin
        r_STATE     <= STATE_IDLE;
        r_flush     <= 1'd0;
        r_nc_addr   <= 15'd0;
        r_rw_done   <= 1'd0;
        r_seek_done <= 1'd0;
        r_cyl       <= 8'd0;
        r_surf      <= 4'd0;
        r_sect      <= 3'd0;
        r_sect_cnt  <= 5'd0;
        r_word_cnt  <= 9'd0;
        r_check_addr    <= 11'd0;
        //flash reset
        r_fls_start <= 1'd0;
        r_fls_wdata <= 8'd0;
        r_fls_mode  <= 3'd0;
        r_fls_addr  <= 23'd0;
        //STD reset
        r_STD_rdata <= 16'd0;
        r_STDQQ     <= 1'd0;
        r_STDM      <= STDM_SR;
        //
        r_cache_addr    <= 11'd0;
        r_exchange_cnt  <= 13'd0;
        r_cache_wdata   <= 8'd0;
        r_cache_we      <= 1'd0;
    end
    else begin
        case (r_STATE)
            STATE_IDLE: begin
                if ((r_busy == 1) & (r_done == 0)) begin
                    r_nc_addr <= r_B[14:0]; 
                    r_STATE <= STATE_START;
                end
                else if (i_CACHE_FLUSH) begin
                    r_flush <= 1;
                    r_STATE <= STATE_EXCHANGE_START;
                end
                else begin
                    r_flush <= 0;
                    r_STATE <= STATE_IDLE;
                end
            end
            STATE_START: begin
                if (r_A[9:8] == MODE_REPOS) begin
                    r_seek_done <= 1;
                    r_cyl <= 0;
                    r_STATE <= STATE_DONE;
                end
                else if (r_A[9:8] == MODE_SEEK) begin
                    r_seek_done <= 1;
                    r_cyl <= r_A[7:0];
                    r_STATE <= STATE_DONE;
                end
                else if (r_A[9:8] == MODE_READ) begin
                    r_sect_cnt <= {1'b0, r_C[3:0]};
                    r_surf <= r_C[11:8];
                    r_sect <= r_C[7:4];
                    r_word_cnt <= 0;
                    r_rw_done <= 0;
                    r_STATE <= STATE_READ_START;
                end
                else begin
                    r_sect_cnt <= {1'b0, r_C[3:0]};
                    r_surf <= r_C[11:8];
                    r_sect <= r_C[7:4];
                    r_rw_done <= 0;
                    r_STATE <= STATE_WRITE_START;
                end
            end
            STATE_READ_START: begin
                r_fls_addr <= {r_cyl, t_sursec, r_word_cnt, 1'b0};
                r_fls_mode <= FLS_READ;
                r_STATE <= STATE_SPI_READ0_START;
            end
            STATE_SPI_READ0_START: begin
                r_fls_start <= 1;
            end
            STATE_SPI_READ0: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_STATE <= STATE_SPI_READ0_DONE;
                end
                r_STATE <= STATE_SPI_READ0_DONE;
            end
            STATE_SPI_READ0_DONE: begin
                r_STD_rdata[7:0] <= t_fls_rdata;
                r_fls_addr <= {r_cyl, t_sursec, r_word_cnt, 1'b1};
                r_STATE <= STATE_SPI_READ1_START;
            end
            STATE_SPI_READ1_START: begin
                r_fls_start <= 1;
            end
            STATE_SPI_READ1: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_STATE <= STATE_SPI_READ1_DONE;
                end
                r_STATE <= STATE_SPI_READ1_DONE;
            end
            STATE_SPI_READ1_DONE: begin
                r_STD_rdata[15:8] <= t_fls_rdata;
                r_word_cnt = r_word_cnt + 1;
                r_STATE <= STATE_SPI_READ_DONE;
            end
            STATE_SPI_READ_DONE: begin
                r_STDQQ <= 1;
                r_STDM <= STDM_SR;
                r_STATE <= STATE_STDR_QQ;
            end
            STATE_STDR_QQ: begin
                if (i_QSTDD) begin
                    r_STDQQ <= 0;
                    if (r_word_cnt == 9'd256) begin
                        r_sect <= r_sect + 1;
                        r_sect_cnt <= r_sect_cnt + 1;
                    end
                end
                else r_STATE <= STATE_STDR_QQ;
            end
            STATE_STDR_START: begin
                if (i_STDR == 0 & r_STDRCF == 1) begin
                    if (r_sect == 3'd6) r_surf <= r_surf + 1;
                    if (r_word_cnt == 9'd256) r_word_cnt <= 0;
                    r_nc_addr <= r_nc_addr + 1;
                    r_STATE <= STATE_STDR_DONE;
                end
                else r_STATE <= STATE_STDR_START;
            end
            STATE_STDR_DONE: begin
                if (r_sect == 3'd6) r_sect <= 0;
                if (r_sect_cnt == 5'b10000) begin
                    r_rw_done <= 1;
                    r_STATE <= STATE_DONE;
                end
                else r_STATE <= STATE_READ_START;
            end
            STATE_WRITE_START: begin
                r_check_addr <= {r_cyl, t_sursec[5:3]};
                r_STATE <= STATE_CACHE_CHECK;
            end
            STATE_CACHE_CHECK: begin
                if (r_cache_addr == r_check_addr) begin
                    r_word_cnt <= 9'd0;
                    r_STATE <= STATE_WRITE_SECT_START;
                end
                else r_STATE <= STATE_EXCHANGE_START;
            end
            STATE_EXCHANGE_START: begin
                r_fls_mode <= FLS_WE;
                r_STATE <= STATE_SPI_WE0_START;
            end
            STATE_SPI_WE0_START: begin
                r_fls_start <= 1;
                r_STATE <= STATE_SPI_WE0;
            end
            STATE_SPI_WE0: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_STATE <= STATE_SPI_WE0_DONE;
                end
                r_STATE <= STATE_SPI_WE0;
            end
            STATE_SPI_WE0_DONE: begin
                r_fls_mode <= FLS_ERASE;
                r_fls_addr <= {r_cache_addr, 12'd0};
                r_STATE <= STATE_SPI_ERASE_START;
            end
            STATE_SPI_ERASE_START: begin
                r_fls_start <= 1;
                r_STATE <= STATE_SPI_ERASE;
            end
            STATE_SPI_ERASE: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                end
                else r_STATE <= STATE_SPI_ERASE;
            end
            STATE_SPI_ERASE_DONE: begin
                r_fls_mode <= FLS_WE;
                r_exchange_cnt <= 13'd0;
                r_STATE <= STATE_SPI_WE1_START;
            end
            STATE_SPI_WE1_START: begin
                r_fls_start <= 1;
                r_STATE <= STATE_SPI_WE1;
            end
            STATE_SPI_WE1: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_STATE <= STATE_SPI_WE1_DONE;
                end
                r_STATE <= STATE_SPI_WE1;
            end
            STATE_SPI_WE1_DONE: begin
                r_STATE <= STATE_EXCHANGE_WB;
            end
            STATE_CACHE_READ: begin
                r_fls_addr <= {r_cache_addr, r_exchange_cnt};
                r_fls_wdata <= t_cache_rdata;
                r_STATE <= STATE_SPI_WRITE_START;
            end
            STATE_WRITE_START: begin
                r_fls_start <= 1;
                r_STATE <= STATE_SPI_WRITE;
            end
            STATE_SPI_WRITE: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_exchange_cnt <= r_exchange_cnt + 1;
                    r_STATE <= STATE_SPI_WRITE_DONE;
                end
                else r_STATE <= STATE_SPI_WRITE;
            end
            STATE_SPI_WRITE_DONE: begin
                if (r_exchange_cnt == 13'd4096) begin
                    r_exchange_cnt <= 13'd0;
                    r_STATE <= STATE_EXCHANGE_RD;
                end
                else r_STATE <= STATE_SPI_WE1_START;
            end
            STATE_EXCHANGE_RD: begin
                if (r_flush) r_STATE <= STATE_IDLE;
                else begin
                    r_fls_addr <= {r_check_addr, r_exchange_cnt};
                    r_fls_mode <= FLS_READ;
                    r_STATE <= STATE_SPI_READEX_START;
                end
            end
            STATE_SPI_READEX_START: begin
                r_fls_start <= 1;
                r_STATE <= STATE_SPI_READEX;
            end
            STATE_SPI_READEX: begin
                if (t_fls_busy == 0) begin
                    r_fls_start <= 0;
                    r_exchange_cnt <= r_exchange_cnt + 1;
                    r_STATE <= STATE_SPI_READEX_DONE;
                end
                else r_STATE <= STATE_SPI_READEX_DONE;
            end
            STATE_SPI_READEX_DONE: begin
                if (r_exchange_cnt == 13'd4096) begin
                    r_cache_addr <= r_check_addr;
                    r_STATE <= STATE_EXCHANGE_DONE;
                end
                else r_STATE <= STATE_EXCHANGE_RD;
            end
            STATE_EXCHANGE_DONE: begin
                r_STATE <= STATE_WRITE_SECT_START;
            end
            STATE_WRITE_SECT_START: begin
                r_STDQQ <= 1;
                r_STDM <= STDM_SC;
                r_STATE <= STATE_STDC_QQ;
            end
            STATE_STDC_QQ: begin
                if (i_QSTDD) begin
                    r_STDQQ <= 0;
                    r_STATE <= STATE_STDC_START;
                end
                else r_STATE <= STATE_STDC_QQ;
            end
            STATE_STDC_START: begin
                if (r_STDCCF) begin
                    r_nc_addr <= r_nc_addr + 1;
                    r_STATE <= STATE_STDC_DONE;
                end
                else r_STATE <= STATE_STDC_START;
            end
            STATE_STDC_DONE: begin
                r_exchange_cnt <= {t_sursec, r_word_cnt, 1'b0};
                r_cache_wdata <= r_STD_wdata;
                r_STATE <= STATE_WCACHE0_START;
            end
            STATE_WCACHE0_START: begin
                r_cache_we <= 1;
                r_STATE <= STATE_WCACHE0_A;
            end
            STATE_WCACHE0_A: begin
                r_STATE <= STATE_WCACHE0_B;
            end
            STATE_WCACHE0_B: begin
                r_cache_we <= 0;
                r_STATE <= STATE_WCACHE0_DONE;
            end
            STATE_WCACHE0_DONE: begin
                r_exchange_cnt <= {t_sursec, r_word_cnt, 1'b1};
                r_STATE <= STATE_WCACHE1_START;
            end
            STATE_WCACHE1_START: begin
                r_cache_we <= 1;
                r_STATE <= STATE_WCACHE1_A;
            end
            STATE_WCACHE1_A: begin
                r_STATE <= STATE_WCACHE1_B;
            end
            STATE_WCACHE1_B: begin
                r_cache_we <= 0;
                r_STATE <= STATE_WCACHE1_DONE;
            end
            STATE_WCACHE1_DONE: begin
                r_word_cnt <= r_word_cnt + 1;
                r_STATE <= STATE_WCACHE_DONE;
            end
            STATE_WCACHE_DONE: begin
                if (r_word_cnt == 9'd256) begin
                    r_sect <= r_sect + 1;
                    r_sect_cnt <= r_sect_cnt + 1;
                    r_STATE <= STATE_WRITE_SECT_DONE;
                end
                else r_STATE <= STATE_WRITE_SECT_START;
            end
            STATE_WRITE_SECT_DONE: begin
                if (r_sect == 3'd6) r_surf <= r_surf + 1;
                r_word_cnt <= 9'd0;
                r_STATE <= STATE_WRITE_CHECK;
            end
            STATE_WRITE_CHECK: begin
                if (r_sect == 3'd6) r_sect <= 3'd0;
                if (r_sect_cnt == 5'b10000) begin
                    r_rw_done <= 1;
                    r_STATE <= STATE_IDLE;
                end
                else r_STATE <= STATE_WRITE_START;
            end
        endcase
    end
end

SPI_flash u_spi_flash (
.clk(i_clk),
.i_start(r_fls_start),      //启动信号
.fls_sdi(i_spi_miso),       //miso
.fls_write(r_fls_wdata),    //输入数据
.fls_addr({1'd0,r_fls_addr}),
.mod_sel(r_fls_mode),       //模式选择
.fls_sck(i_spi_sck),        //输出flash时钟
.fls_ncs(i_spi_ncs),        //片选信号
.fls_sdo(i_spi_mosi),       //mosi
.fls_read(t_fls_rdata),     //输出数据
.busy(t_fls_busy)           //当前状态
);

endmodule
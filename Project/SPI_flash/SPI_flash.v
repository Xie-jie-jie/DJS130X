module SPI_flash (
    input wire          clk,    
    input wire          i_start,            //启动信号
    input   wire        fls_sdi,            //miso
    input   wire [7:0]  fls_write,          //输入数据
    input   wire [23:0] fls_addr,
    input   wire [2:0]  mod_sel,            //模式选择
    output  wire        fls_sck,            //输出flash时钟
    output  wire        fls_ncs,            //片选信号
    output  wire        fls_sdo,            //mosi
    output  wire [7:0]  fls_read,           //输出数据
    output  wire        busy                //当前状态
);
    reg [7:0]   r_fls_read;
    wire[7:0]   o_fls_read;
    wire i_m_start;
    assign i_m_start = !i_start;
    reg r_start;
    reg r_start_p;
    always @(posedge i_m_start or posedge r_start_p) begin
        if(r_start_p)
            r_start <= 0;
        else
            r_start <= 1;
    end
    always @(posedge clk or negedge r_start) begin
        if(r_start)
            r_start_p <= 1;
        else
            r_start_p <= 0;
    end
    wire start = r_start & !busy;
    always @(negedge busy) begin
        r_fls_read <= o_fls_read;
    end
    assign fls_read = r_fls_read;
flash_dri u_flash_dri(
    .clk(clk),
    .fls_sck(fls_sck),
    .fls_ncs(fls_ncs),
    .fls_sdo(fls_sdo),
    .fls_sdi(fls_sdi),
    .start(start),
    .mod_sel(mod_sel), 
    .fls_addr(fls_addr),
    .fls_write(fls_write),
    .fls_read(o_fls_read),
    .busy(busy)
);
endmodule
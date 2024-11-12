module YXZT (
    input wire          rst_n,
    input wire          i_Z0Jsz,
    input wire          i_Z0Jz,
    input wire          i_Z0Jcx,
    input wire          i_Z0Jd,
    input wire          i_Z0YX,
    input wire          i_DRJsz,           //打入指令计数器
    input wire          i_DRJz,            //打入指令寄存器
    input wire          i_DRJcx,           //打入重写寄存器
    input wire          i_DRJd,            //打入地址寄存器
    input wire          i_DRYX,            //打入运行
    input wire          i_DRZT,            //打入状态
    input wire          i_NC_Jcx,          //内存写入重写寄存器
    input wire          i_CZzd_Jcx,        //只读存贮器写入重写寄存器
    input wire          i_DMkt_Jcx,        //控制台代码写入重写寄存器
    input wire          i_RC_CXD,          //入出写入内存寄存器
    input wire          i_MX_CXD,          //总线写入内存寄存器
    input wire          i_Jsz_CXD,         //指令计数写入内存寄存器
    input wire [15:0]   i_RC,              //输入入出
    input wire [15:0]   i_MX,              //总线输入
    input wire [15:0]   i_NC,              //内存输入
    input wire [15:0]   i_CZzd,            //只读存贮器输入
    input wire [15:0]   i_DMkt,            //写入控制台代码
    input wire          i_1_Jd,            //写入地址寄存器
    input wire          i_1_YX,            //写入运行
    input wire          i_1_QZZT,          //写入取指状态
    input wire          i_1_JZZT,          //写入间址状态
    input wire          i_1_ZXZT,          //写入执行状态
    input wire          i_1_ZDZT,          //写入中断状态
    input wire          i_1_STDZT,         //写入数据通道状态
    input wire          i_1_KTZT,          //写入控制台状态
    input wire          i_1_KTCZZT,        //写入控制台存贮状态
    output wire [15:0]  o_Jsz,             //输出指令计数
    output wire [15:0]  o_Jz,              //输出指令
    output wire [15:0]  o_Jcx,             //输出重写寄存器数据
    output wire [15:0]  o_Jd,              //输出地址寄存器数据
    output wire         o_YX,              //输出运行
    output wire         o_QZZT,            //输出取指状态
    output wire         o_JZZT,            //输出间址状态
    output wire         o_ZXZT,            //输出执行状态
    output wire         o_ZDZT,            //输出中断状态
    output wire         o_STDZT,           //输出数据通道状态
    output wire         o_KTZT,            //输出控制台状态
    output wire         o_KTCZZT           //输出控制台存贮状态
);
    wire [15:0] Jsz = r_Jsz;
    wire [15:0] Jz = r_Jz;
    wire [15:0] Jcx = r_Jcx;
    wire [15:0] Jd = r_Jd;
    wire    YX = r_YX;
    wire    QZZT = r_QZZT;
    wire    JZZT = r_JZZT; 
    wire    ZXZT = r_ZXZT;
    wire    ZDZT = r_ZDZT;
    wire    STDZT = r_STDZT;
    wire    KTZT = r_KTZT;
    wire    KTCZZT = r_KTCZZT;
    wire [15:0] NCD = (({16{i_NC_Jcx}} & i_NC) | ({16{i_CZzd_Jcx}} & i_CZzd) | ({16{i_DMkt_Jcx}} & i_DMkt));
    wire [15:0] RMJ = (({16{i_RC_CXD}} & i_RC) | ({16{i_MX_CXD}} & i_MX) | ({16{i_Jsz_CXD}} & Jsz));
    reg     r_YX;
    reg     r_QZZT;
    reg     r_JZZT;
    reg     r_ZXZT;
    reg     r_ZDZT;
    reg     r_STDZT;
    reg     r_KTZT;
    reg     r_KTCZZT;
    reg [15:0] r_Jcx;
    reg [15:0] r_Jd;
    reg [15:0] r_Jsz;
    reg [15:0] r_Jz;
    assign o_Jsz = Jsz;
    assign o_Jz = Jz;
    assign o_Jcx = Jcx;
    assign o_Jd = Jd;
    assign o_YX = YX;
    assign o_QZZT = QZZT;
    assign o_JZZT = JZZT;
    assign o_ZXZT = ZXZT;
    assign o_ZDZT = ZDZT;
    assign o_STDZT = STDZT;
    assign o_KTZT = KTZT;
    assign o_KTCZZT = KTCZZT;
    wire rst_YX = !rst_n | i_Z0YX;
    always @(posedge i_DRYX or posedge rst_YX) begin
        if(rst_YX)
        r_YX <= 0;
        else
        r_YX <= i_1_YX;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_QZZT <= 0;
        else
        r_QZZT <= i_1_QZZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_JZZT <= 0;
        else
        r_JZZT <= i_1_JZZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_ZXZT <= 0;
        else
        r_ZXZT <= i_1_ZXZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_ZDZT <= 0;
        else
        r_ZDZT <= i_1_ZDZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_STDZT <= 0;
        else
        r_STDZT <= i_1_STDZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_KTZT <= 0;
        else
        r_KTZT <= i_1_KTZT;
    end
    always @(posedge i_DRZT or negedge rst_n) begin
        if(!rst_n)
        r_KTCZZT <= 0;
        else
        r_KTCZZT <= i_1_KTCZZT;
    end
    wire rst_Jcx = i_Z0Jcx | !rst_n;
    always @(posedge i_DRJcx or posedge rst_Jcx) begin
        if(rst_Jcx)
        r_Jcx <= 0;
        else
        r_Jcx <= (NCD | RMJ);
    end
    wire rst_Jd = i_Z0Jd | !rst_n;
    always @(posedge i_DRJd or posedge rst_Jd) begin
        if(rst_Jd)
        r_Jd <= 0;
        else
        r_Jd <= i_1_Jd ? 16'd1 : RMJ;
    end
    wire rst_Jsz = i_Z0Jsz | !rst_n;
    always @(posedge i_DRJsz or posedge rst_Jsz) begin
        if(rst_Jsz)
        r_Jsz <= 0;
        else
        r_Jsz <= i_MX;
    end
    wire rst_Jz = i_Z0Jz | !rst_n;
    always @(posedge i_DRJz or posedge rst_Jz) begin
        if(rst_Jz)
        r_Jz <= 0;
        else
        r_Jz <= Jcx;
    end
endmodule
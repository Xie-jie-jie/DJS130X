module MCQ (
    input wire          rst_n,          //复位
    input wire          i_MF,           //
    input wire          i_1_YCZT,       //输入延长状态
    output wire         o_W0,           //输出节拍电位0
    output wire         o_W1,           //输出节拍电位1
    output wire         o_YCZT,         //输出延长状态
    output wire         o_m_x,
    output wire         o_m_RC,
    output wire         o_m,
    output wire         o_SZMNC,        //输出时钟脉内存
    output wire         o_SZMDL1,       //输出时钟脉DL1
    output wire         o_SZMDL2,       //输出时钟脉DL2
    output wire         o_SZMXT,        //输出时钟脉选通
    output wire         o_SZMXL,        //输出时钟脉写命令
    output wire         o_SZMJG         //输出时钟脉结果
);
    wire MF = i_MF;
    wire Csx1 = r_Csx1;
    wire Csx2 = r_Csx2;
    wire Csx3 = r_Csx3;
    wire Csx4 = r_Csx4;
    wire Csx5 = !r_Csx5;
    wire W0 = !W1;
    wire W1 = r_Cw;
    wire m = Csx4;
    wire SZMnc = Csx5;
    wire m_RC = Csx2 & !Csx4 & !Csx5;
    wire m_x = Csx1 & !Csx2 & !Csx5;
    wire DL1 = Csx1 & !Csx5 & W0;
    wire DL2 = Csx2 & !Csx5 & W0;
    wire XT = Csx3 & !Csx5 & W0;
    wire XL = Csx2 & !Csx5 & W1;
    wire SZMJG = Csx3 & !Csx5;
    wire YCZT = r_YCZT;
    reg r_Csx1;
    reg r_Csx2;
    reg r_Csx3;
    reg r_Csx4;
    reg r_Csx5;
    reg r_YCZT;
    reg r_Cw;
    wire clk = Csx5 | MF;
    wire rst = Csx5 & MF;
    assign o_W0 = W0;
    assign o_W1 = W1;
    assign o_YCZT = YCZT;
    assign o_m_x = m_x;
    assign o_m_RC = m_RC;
    assign o_m = m;
    assign o_SZMNC = SZMnc;
    assign o_SZMDL1 = DL1;
    assign o_SZMDL2 = DL2;
    assign o_SZMXT = XT;
    assign o_SZMXL = XL;
    assign o_SZMJG = SZMJG;
    always @(posedge clk or posedge rst) begin
        if(rst)
        r_Csx1 <= 0;
        else
        r_Csx1 <= 1;
    end
    always @(posedge clk or posedge rst) begin
        if(rst)
        r_Csx2 <= 0;
        else
        r_Csx2 <= Csx1;
    end
    always @(posedge clk or posedge rst) begin
        if(rst)
        r_Csx3 <= 0;
        else
        r_Csx3 <= Csx2;        
    end
    always @(posedge clk or posedge rst) begin
        if(rst)
        r_Csx4 <= 0;
        else
        r_Csx4 <= Csx3;
    end
    always @(posedge !MF or negedge rst_n ) begin
        if(!rst_n)
        r_Csx5 <= 0;
        else
        r_Csx5 <= !Csx4;
    end
    always @(posedge m or negedge rst_n) begin
        if(!rst_n)
        r_YCZT <= 0;
        else
        r_YCZT <= i_1_YCZT;
    end
    always @(negedge m or negedge rst_n) begin
        if(!rst_n)
        r_Cw <= 0;
        else if(!YCZT)
        r_Cw <= W0;
        else
        r_Cw <= r_Cw;
    end
endmodule
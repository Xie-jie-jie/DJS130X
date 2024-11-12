module CCQ (
    input wire          rst_n,
    input wire          clk_mdv,
    input wire          i_CHJ,      //使用乘加器
    input wire          i_DRCCQ,    //打入存储器
    input wire[15:0]    i_L0,       //累加器L0输入
    input wire[15:0]    i_L1,       //累加器L1输入
    input wire[15:0]    i_L2,       //累加器L2输入
    input wire          i_Cj,       //进位
    output wire         o_DD,       //输出等待
    output wire[15:0]   o_L0,       //累加器L0输出
    output wire[15:0]   o_L1,       //累加器L1输出
    output wire         o_Cj        //进位输出
);
    wire clk = clk_mdv;
    reg r_CHJQD;                //启动
    reg r_CHJWC;                //完成
    reg [2:0] r_CHJJS;          //计数
    reg r_CHJQC_x;
    reg r_CHJQC;                //乘加清除
    reg r_CHJGZ;                //乘加工作
    reg r_CHUGZ;                //除工作
    reg r_CHUQC_x;
    reg r_CHUQC;                //除清除
    reg r_ZR;                   //载入
    reg r_ZRWC;                 //载入完成
    reg [4:0] r_CHUJS;
    reg r_CHUWC;
    reg [31:0] r_YUSHU_x;
    reg [31:0] r_YUSHU;         //余数
    reg [31:0] r_CHUSHU;        //除数
    reg [15:0] r_L0JG;          //L0结果寄存器
    reg [15:0] r_L1JG;          //L1结果寄存器
    reg r_CjJG;                 //进位结果
    wire CHJWC = r_CHJWC;       
    wire CHJQC = r_CHJQC;
    wire CHJGZ = r_CHJGZ;
    wire CHUGZ = r_CHUGZ;
    wire CHUQC = r_CHUQC;
    wire CHUWC = r_CHUWC;
    wire CHUWX = !(i_L0 < i_L2);
    wire ZR = r_ZR;
    wire [15:0] CHJ_DW;
    wire [15:0] CHJ_GW;
    wire [31:0] CHJ = (i_L1 * i_L2) + i_L0;
    wire [15:0] CHU_YUSHU_x = r_YUSHU_x[15:0];
    wire [32:0] CHUJ = {1'b0,r_YUSHU} + {1'b0,~(r_CHUSHU)} + 33'd1;
    wire CHUJGF = CHUJ[32];
    wire [31:0] YUSHU_x = !ZR ? CHUJ[31:0] : {i_L0,i_L1};
    wire [31:0] CHUSHU_x;
    wire [15:0] CHU_SHANG;
    wire [15:0] r_L0JG_D = CHUGZ ? (CHUWX ? i_L0 : CHU_YUSHU_x) : CHJ_GW;
    wire [15:0] r_L1JG_D = CHUGZ ? (CHUWX ? i_L1 : CHU_SHANG) : CHJ_DW;
    wire r_CjJG_D = CHUGZ ? CHUWX : i_Cj;
    assign CHJ_DW = CHJ[15:0];
    assign CHJ_GW = CHJ[31:16];
    assign o_DD = CHJGZ | CHUGZ;
    assign o_L0 = r_L0JG;
    assign o_L1 = r_L1JG;
    assign o_Cj = r_CjJG;
    wire rstn_CHJ = rst_n & CHJGZ;
    always @(negedge clk or negedge rstn_CHJ) begin
        if(!rstn_CHJ)
        r_CHJQD <= 0;
        else
        r_CHJQD <= 1;
    end
    always @(negedge clk or negedge rstn_CHJ) begin
        if(!rstn_CHJ)
        r_CHJWC <= 0;
        else
        r_CHJWC <= (r_CHJJS == 3'd3);
    end
    always @(posedge clk or negedge rstn_CHJ) begin
        if(!rstn_CHJ)
        r_CHJJS <= 0;
        else if(r_CHJQD)
        r_CHJJS <= r_CHJJS + 3'd1;
        else
        r_CHJJS <= r_CHJJS;
    end
    always @(posedge clk or negedge rstn_CHJ) begin
        if(!rstn_CHJ)
        r_CHJQC_x <= 0;
        else
        r_CHJQC_x <= CHJWC;
    end
    always @(posedge clk or negedge rstn_CHJ) begin
        if(!rstn_CHJ)
        r_CHJQC <= 0;
        else
        r_CHJQC <= r_CHJQC_x;
    end
    wire rst_CHJGZ = !rst_n | CHJQC;
    always @(posedge (i_DRCCQ & i_CHJ) or posedge rst_CHJGZ) begin
        if(rst_CHJGZ)
        r_CHJGZ <= 0;
        else
        r_CHJGZ <= 1;
    end
    wire rst_CHUGZ = !rst_n | CHUQC;
    always @(posedge (i_DRCCQ & !i_CHJ) or posedge rst_CHUGZ) begin
        if(rst_CHUGZ)
        r_CHUGZ <= 0;
        else
        r_CHUGZ <= 1;
    end
    wire rstn_CHUQC = rst_n & CHUGZ;
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_CHUQC_x <= 0;
        else
        r_CHUQC_x <= CHUWC;
    end
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_CHUQC <= 0;
        else
        r_CHUQC <= r_CHUQC_x;
    end
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_ZR <= 0;
        else
        r_ZR <= !r_ZRWC & CHUGZ;
    end
    always @(negedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_ZRWC <= 0;
        else if(ZR)
        r_ZRWC <= 1;
        else
        r_ZRWC <= r_ZRWC;
    end
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_CHUJS <= 0;
        else if(r_ZRWC)
        r_CHUJS <= r_CHUJS + 5'd1;
        else
        r_CHUJS <= r_CHUJS;
    end
    always @(negedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_CHUWC <= 0;
        else
        r_CHUWC <= ((r_CHUJS == 5'h11) | CHUWX);
    end
    always @(negedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_YUSHU_x <= 0;
        else if(CHUJGF & CHUGZ)
        r_YUSHU_x <= YUSHU_x;
        else
        r_YUSHU_x <= r_YUSHU_x;
    end
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_YUSHU <= 0;
        else
        r_YUSHU <= r_YUSHU_x;
    end
    always @(posedge clk or negedge rstn_CHUQC ) begin
        if(!rstn_CHUQC )
        r_CHUSHU <= 0;
        else
        r_CHUSHU <= CHUSHU_x;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        r_L0JG <= 0;
        else if(CHUWC | CHJWC)
        r_L0JG <= r_L0JG_D;
        else
        r_L0JG <= r_L0JG;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        r_L1JG <= 0;
        else if(CHUWC | CHJWC)
        r_L1JG <= r_L1JG_D;
        else
        r_L1JG <= r_L1JG;
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        r_CjJG <= 0;
        else if(CHUWC | CHJWC)
        r_CjJG <= r_CjJG_D;
        else
        r_CjJG <= r_CjJG;
    end
// shift_right_reg32 connect                
shift_right_reg32 u_CHUSHU_x(               //32位右移移位寄存器
    .d({i_L2,16'b0}),
    .srin(1'b0),
    .we(CHUGZ),
    .sr(!ZR),
    .clk(!clk),
    .rst_n(rst_n & CHUGZ),
    .q(CHUSHU_x)
);
// shift_left_reg16  connect
shift_left_reg16 u_SHANG(                   //16位左移移位寄存器
    .d(16'b0),
    .slin(CHUJGF),
    .we(CHUGZ),
    .sl(!ZR),
    .clk(!clk),
    .rst_n(rst_n & CHUGZ),
    .q(CHU_SHANG)
);
endmodule
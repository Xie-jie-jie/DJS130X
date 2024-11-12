module YSQ (
    input wire          rst_n,
    input wire          clk_mdv,
    input wire          i_DRL0,         //打入L0
    input wire          i_DRL1,         //打入L1
    input wire          i_DRL2,         //打入L2
    input wire          i_DRL3,         //打入L3
    input wire          i_DRCj,         //打入进位
    input wire          i_DRJG,         //打入结果
    input wire          i_DRCCQ,        //打入存储器
    input wire          i_L0_Mcs,       //累加器L0送操作数发送门
    input wire          i_L1_Mcs,       //累加器L1送操作数发送门
    input wire          i_L2_Mcs,       //累加器L2送操作数发送门
    input wire          i_L3_Mcs,       //累加器L3送操作数发送门
    input wire          i_L0n_Mjg,      //累加器L0取反送结果发送门
    input wire          i_L1n_Mjg,      //累加器L1取反送结果发送门
    input wire          i_L2n_Mjg,      //累加器L2取反送结果发送门
    input wire          i_L3n_Mjg,      //累加器L3取反送结果发送门
    input wire          i_Jd_Q,         //送至地址寄存器
    input wire          i_Jcx_Q,        //送至重写寄存器
    input wire          i_Mcs_Q,        //操作累加器发送门
    input wire          i_Mcsn_Q,       //操作累加器取反发送门
    input wire [15:0]   i_Jd,           //输入送至地址寄存器数据
    input wire [15:0]   i_Jcx,          //输入送至重写寄存器数据
    input wire          i_Jsz_Q,        //送至指令计数器
    input wire          i_Jz_Q,         //送至指令计数器所指单元
    input wire          i_McsMjg_Q,     //发送门与结果门逻辑乘
    input wire          i_Mjg_Q,        //结果发送门
    input wire [15:0]   i_Jsz,          //送至指令计数器的指令
    input wire [15:0]   i_Jz,           //送至指令计数器指令所指单元数据
    input wire          i_1_Q,          //进位输入
    input wire          i_JW0,          //进位位基值0
    input wire          i_JWF,          //进位位基值取反
    input wire          i_Q_MX,         //输至总线
    input wire          i_Q_Y_MX,       //右移后输至总线
    input wire          i_Q_Z_MX,       //左移后输至总线
    input wire          i_Q_B_MX,       //高8位低8位换位后输至总线
    input wire          i_CHJ,          //乘加
    input wire          i_CCQ,          //存储
    output wire[15:0]   o_MX,           //输出总线
    output wire         o_DD,           //输出等待
    output wire         o_Cj,           //进位输出
    output wire         o_YIC
);
    wire [15:0] JG_15_0 = r_JG[15:0];
    wire JG_16 = r_JG[16];
    wire DD;
    wire [15:0] CCQ_L0;
    wire [15:0] CCQ_L1;
    wire CCQ_Cj;
    wire [15:0] L0 = r_L0;
    wire [15:0] L0_n = ~L0;
    wire [15:0] L1 = r_L1;
    wire [15:0] L1_n = ~L1;
    wire [15:0] L2 = r_L2;
    wire [15:0] L2_n = ~L2;
    wire [15:0] L3 = r_L3;
    wire [15:0] L3_n = ~L3;
    wire Cj = r_Cj;
    wire [15:0] Mcsn;
    wire [15:0] Mjg;
    wire [15:0] Q1_in1;
    wire [15:0] Q1_in2;
    wire [16:0] Q1;
    wire Q2;
    wire [16:0] Q_MX;
    wire [16:0] Q_Y;
    wire [16:0] Q_Z;
    wire [16:0] Q_B;
    wire [16:0] JG_D;
    wire [15:0] MX;
    wire YIC;
    wire DRJG = i_DRJG;
    assign Mcsn = ~(({16{i_L0_Mcs}} & L0) | ({16{i_L1_Mcs}} & L1) | ({16{i_L2_Mcs}} & L2) | ({16{i_L3_Mcs}} & L3));
    assign Mjg = ~(({16{i_L0n_Mjg}} & L0_n) | ({16{i_L1n_Mjg}} & L1_n) | ({16{i_L2n_Mjg}} & L2_n) | ({16{i_L3n_Mjg}} & L3_n));
    assign Q1_in1 = ({16{i_Jd_Q}} & i_Jd) | ({16{i_Jcx_Q}} & i_Jcx) | ({16{i_Mcs_Q}} & ~Mcsn) | ({16{i_Mcsn_Q}} & Mcsn);
    assign Q1_in2 = (Mjg & {16{i_Mjg_Q}}) | (Mjg & ~Mcsn & {16{i_McsMjg_Q}}) | (i_Jsz & {16{i_Jsz_Q}}) | (i_Jz & {16{i_Jz_Q}});
    assign Q1 = {1'b0,Q1_in1} + {1'b0,Q1_in2} + {16'b0,i_1_Q};
    assign Q2 = i_JWF ? !(i_JW0 ? 0 : Cj) : (i_JW0 ? 0 : Cj); 
    assign Q_MX = {(Q2 ^ Q1[16]),Q1[15:0]};
    assign Q_Y = {Q1[15:0],(Q2 ^ Q1[16])};
    assign Q_Z = {Q1[0],(Q2 ^ Q1[16]),Q1[15:1]};
    assign Q_B = {(Q2 ^ Q1[16]),Q1[7:0],Q1[15:8]};
    assign JG_D = (({17{i_Q_Y_MX}} & Q_Y) | ({17{i_Q_MX}} & Q_MX) | ({17{i_Q_Z_MX}} & Q_Z) | ({17{i_Q_B_MX}} & Q_B));
    assign MX = JG_15_0;
    assign YIC = JG_16;
    assign o_DD = DD;
    assign o_MX = MX;
    assign o_Cj = Cj;
    assign o_YIC = YIC;
    reg [15:0] r_L0;
    reg [15:0] r_L1;
    reg [15:0] r_L2;
    reg [15:0] r_L3;
    reg [16:0] r_JG;
    reg r_Cj;
    always @(posedge i_DRL0 or negedge rst_n) begin
        if(!rst_n)
        r_L0 <= 0;
        else
        r_L0 <= i_CCQ ? CCQ_L0 : JG_15_0;
    end
    always @(posedge i_DRL1 or negedge rst_n) begin
        if(!rst_n)
        r_L1 <= 0;
        else
        r_L1 <= i_CCQ ? CCQ_L1 : JG_15_0;
    end
    always @(posedge i_DRL2 or negedge rst_n) begin
        if(!rst_n)
        r_L2 <= 0;
        else
        r_L2 <= JG_15_0;
    end
    always @(posedge i_DRL3 or negedge rst_n) begin
        if(!rst_n)
        r_L3 <= 0;
        else
        r_L3 <= JG_15_0;
    end
    always @(posedge i_DRCj or negedge rst_n) begin
        if(!rst_n)
        r_Cj <= 0;
        else
        r_Cj <= i_CCQ ? CCQ_Cj : JG_16;
    end
    always @(posedge DRJG or negedge rst_n) begin
        if(!rst_n)
        r_JG <= 0;
        else
        r_JG <= JG_D;
    end
// CCQ connect                      //存储器连接
CCQ u_CCQ(
    .rst_n(rst_n),
    .clk_mdv(clk_mdv),
    .i_CHJ(i_CHJ),
    .i_DRCCQ(i_DRCCQ),
    .i_L0(L0),
    .i_L1(L1),
    .i_L2(L2),
    .i_Cj(Cj),
    .o_DD(DD),
    .o_L0(CCQ_L0),
    .o_L1(CCQ_L1),
    .o_Cj(CCQ_Cj)
);
endmodule
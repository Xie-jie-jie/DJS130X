module ZZB (
    input wire          rst_n,
    input wire          clk,
    input wire [15:0]   i_rom_dout,
    input wire [15:0]   i_mem_dout,
    input wire          i_mem_err,
    input wire          i_con_QDZ,
    input wire          i_con_TJ,
    input wire          i_con_LS,
    input wire          i_con_YD,
    input wire          i_con_DZL,
    input wire [15:0]   i_con_DM,
    input wire [5:0]    i_dev7_DMs,
    input wire [15:0]   i_dev7_SC,
    input wire          i_dev7_ZDQQ,
    input wire [1:0]    i_dev7_STDM,
    input wire          i_dev7_STDQQ,
    input wire [5:0]    i_dev8_DMs,
    input wire [15:0]   i_dev8_SC,
    input wire          i_dev8_ZDQQ,
    input wire [5:0]    i_dev9_DMs,
    input wire [15:0]   i_dev9_SC,
    input wire          i_dev9_ZDQQ,
    input wire [5:0]    i_dev10_DMs,
    input wire [15:0]   i_dev10_SC,
    input wire          i_dev10_ZDQQ,
    input wire [5:0]    i_dev11_DMs,
    input wire [15:0]   i_dev11_SC,
    input wire          i_dev11_ZDQQ,
    input wire [5:0]    i_dev12_DMs,
    input wire [15:0]   i_dev12_SC,
    input wire          i_dev12_ZDQQ,
    input wire [5:0]    i_dev13_DMs,
    input wire [15:0]   i_dev13_SC,
    input wire          i_dev13_ZDQQ,
    input wire [5:0]    i_dev14_DMs,
    input wire [15:0]   i_dev14_SC,
    input wire          i_dev14_ZDQQ,
    input wire [5:0]    i_dev15_DMs,
    input wire [15:0]   i_dev15_SC,
    input wire          i_dev15_ZDQQ,
    input wire [1:0]    i_dev7_ZT,
    input wire [1:0]    i_dev8_ZT,
    input wire [1:0]    i_dev9_ZT,
    input wire [1:0]    i_dev10_ZT,
    input wire [1:0]    i_dev11_ZT,
    input wire [1:0]    i_dev12_ZT,
    input wire [1:0]    i_dev13_ZT,
    input wire [1:0]    i_dev14_ZT,
    input wire [1:0]    i_dev15_ZT,
    output wire [4:0]   o_rom_addr,
    output wire [14:0]  o_mem_addr,
    output wire [15:0]  o_mem_din,
    output wire         o_mem_we,
    output wire         o_mem_clk,
    output wire         o_con_YX,
    output wire         o_con_ZD,
    output wire         o_con_QZZT,
    output wire         o_con_JZZT,
    output wire         o_con_ZXZT,
    output wire         o_con_Cjyc,
    output wire         o_con_Cj,
    output wire [7:0]   o_con_XSZL,
    output wire [14:0]  o_con_XSDZ,
    output wire [15:0]  o_con_XSSJ,
    output wire [15:0]  o_dev_SR,
    output wire         o_dev_ZZ0,
    output wire [8:0]   o_dev7_KZ,
    output wire [3:0]   o_dev7_STDKZ,
    output wire [8:0]   o_dev8_KZ,
    output wire [8:0]   o_dev9_KZ,
    output wire [8:0]   o_dev10_KZ,
    output wire [8:0]   o_dev11_KZ,
    output wire [8:0]   o_dev12_KZ,
    output wire [8:0]   o_dev13_KZ,
    output wire [8:0]   o_dev14_KZ,
    output wire [8:0]   o_dev15_KZ
);
    wire [4:0]   rom_addr;
    wire [14:0]  mem_addr;
    wire [15:0]  mem_din;
    wire         mem_we;
    wire         mem_clk;
    wire         con_YX;
    wire         con_ZD;
    wire         con_QZZT;
    wire         con_JZZT;
    wire         con_ZXZT;
    wire         con_Cjyc;
    wire         con_Cj;
    wire [7:0]   con_XSZL;
    wire [14:0]  con_XSDZ;
    wire [15:0]  con_XSSJ;
    wire [15:0]  dev_SR;
    wire         dev_ZZ0;
    wire [8:0]   dev7_KZ;
    wire [3:0]   dev7_STDKZ;
    wire [8:0]   dev8_KZ;
    wire [8:0]   dev9_KZ;
    wire [8:0]   dev10_KZ;
    wire [8:0]   dev11_KZ;
    wire [8:0]   dev12_KZ;
    wire [8:0]   dev13_KZ;
    wire [8:0]   dev14_KZ;
    wire [8:0]   dev15_KZ;
    assign o_rom_addr = rom_addr;
    assign o_mem_addr = mem_addr;
    assign o_mem_din = mem_din;
    assign o_mem_we = mem_we;
    assign o_mem_clk = mem_clk;
    assign o_con_YX = con_YX;
    assign o_con_ZD = con_ZD;
    assign o_con_QZZT = con_QZZT;
    assign o_con_JZZT = con_JZZT;
    assign o_con_ZXZT = con_ZXZT;
    assign o_con_Cjyc = con_Cjyc;
    assign o_con_Cj = con_Cj;
    assign o_con_XSZL = con_XSZL;
    assign o_con_XSDZ = con_XSDZ;
    assign o_con_XSSJ = con_XSSJ;
    assign o_dev_SR = dev_SR;
    assign o_dev_ZZ0 = dev_ZZ0;
    assign o_dev7_KZ = dev7_KZ;
    assign o_dev7_STDKZ = dev7_STDKZ;
    assign o_dev8_KZ = dev8_KZ;
    assign o_dev9_KZ = dev9_KZ;
    assign o_dev10_KZ = dev10_KZ;
    assign o_dev11_KZ = dev11_KZ;
    assign o_dev12_KZ = dev12_KZ;
    assign o_dev13_KZ = dev13_KZ;
    assign o_dev14_KZ = dev14_KZ;
    assign o_dev15_KZ = dev15_KZ;

// YSQ 信号定义
    wire          DRL0;
    wire          DRL1;
    wire          DRL2;
    wire          DRL3;
    wire          DRCj;
    wire          DRJG;
    wire          DRCCQ;
    wire          L0_Mcs;
    wire          L1_Mcs;
    wire          L2_Mcs;
    wire          L3_Mcs;
    wire          L0n_Mjg;
    wire          L1n_Mjg;
    wire          L2n_Mjg;
    wire          L3n_Mjg;
    wire          Jd_Q;
    wire          Jcx_Q;
    wire          Mcs_Q;
    wire          Mcsn_Q;
    wire [15:0]   Jd;
    wire [15:0]   Jcx;
    wire          Jsz_Q;
    wire          Jz_Q;
    wire          McsMjg_Q;
    wire          Mjg_Q;
    wire [15:0]   Jsz;
    wire [15:0]   ZL;
    wire          JzBM;
    wire          t_1_Q;
    wire          JW0;
    wire          JWF;
    wire          Q_MX;
    wire          Q_Y_MX;
    wire          Q_Z_MX;
    wire          Q_B_MX;
    wire          CHJ;
    wire          CCQ;
    wire[15:0]    MX;
    wire          DD;
    wire          Cj;
    wire          YIC;
// YSQ 下侧
    assign Z0DZL = KTZT | KTCZZT | YX;
    assign Z0LS = KTZT | KTCZZT | YX;
    assign Z0TBtj = !YX;
    assign Z0DP = 1'b0;
    assign Z0DZQ = 1'b0;
    wire [1:0]  dec_SL_YW;
    wire op_CHC;
    wire op_Z0Jsz;
    wire op_1_YCZT;
    wire op_ZZ0RC;
    wire op_Z0Jz;
    wire op_0_Jd;
    wire op_Z0Jd;
    wire op_QD;
    wire op_GCZ;
    wire QSTDD;
    wire op_1_STDZT;
    wire op_RC_Jd;
    wire op_1_ZDZT;
    wire op_1_QZZT;
    wire op_Lcs_Ljg_Q;
    wire op_PT;
    wire op_Z0QSTDD;
    wire [2:0] dec_SL_TIAO;
    wire dec_ZZB;
    wire PT;
    wire SLZL_TIAO;
    wire ZLT_JLT_PT;
    wire PD_Jsz32;
    wire WUZT;
    reg r_DZL;
    reg r_PT;
    assign CHJ = dec_SL_YW[1];
    assign CCQ = op_CHC;
    assign DRCCQ = op_CHC & m_x;
    assign Z0NC = 1'b0;
    assign Z0Jcx = 1'b0;
    assign Z0Jsz = op_Z0Jsz;
    assign t_1_YCZT = op_1_YCZT;
    assign MXcx = Jcx;
    assign ZZ0RC = op_ZZ0RC;
    assign Z0Jz = op_Z0Jz;
    assign DRYX = m & t_1_YX;
    wire SZMJG;
    assign DRJG = SZMJG;
    assign Z0Jd = (op_0_Jd & SZMNC) | op_Z0Jd;
    assign t_1_YX = op_QD | (LS & !(KTZT | KTCZZT)) | (DZL & !(KTZT | KTCZZT));
    wire clk_DZL = DZL & !(KTZT | KTCZZT);
    wire rst_DZL = !rst_n | TBtj;
    always @(posedge clk_DZL or posedge rst_DZL) begin
        if(rst_DZL)
        r_DZL <= 0;
        else
        r_DZL <= 1'b1;
    end
    assign DZL_TJ = r_DZL;
    assign Z0YX = op_GCZ & (!YX | TBtj);
    assign op_1_STDZT = op_GCZ & !(!YX | TBtj) & QSTDD;
    assign op_RC_Jd = op_1_STDZT;
    assign op_0_Jd = op_GCZ & !(!YX | TBtj) & !op_RC_Jd & ZDQQ;
    assign op_1_ZDZT = op_0_Jd;
    assign WUZT = !(QZZT | JZZT | ZXZT | ZDZT | STDZT);
    assign op_1_QZZT = (op_GCZ & !(!YX | TBtj) & !op_RC_Jd & !op_0_Jd) | (WUZT & YX & W1);
    assign SLZL_TIAO = op_Lcs_Ljg_Q & (dec_SL_TIAO[0] ^ t_dec_SL_TIAO[dec_SL_TIAO[2:1]]);
    wire [3:0] t_dec_SL_TIAO;
    assign t_dec_SL_TIAO[0] = 1'b0;
    assign t_dec_SL_TIAO[1] = YIC;
    assign t_dec_SL_TIAO[2] = (MX == 16'b0) ? 1'b1 : 1'b0;
    assign t_dec_SL_TIAO[3] = !(YIC & t_dec_SL_TIAO[2]);
    wire r_PT_D;
    wire t_dec_SL_YW;
    assign r_PT_D = dec_SL_YW[0] ? !t_dec_SL_YW : t_dec_SL_YW;
    assign t_dec_SL_YW = dec_SL_YW[1] ? (dec_ZZB ? 1'b0 : SBZT[1]) : (dec_ZZB ? ZD : SBZT[0]);
    always @(posedge m_RC or negedge ZXZT) begin
        if(!ZXZT)
        r_PT <= 0;
        else if(op_PT)
        r_PT <= r_PT_D;
        else
        r_PT <= r_PT;
    end
    assign PT = r_PT;
    assign ZLT_JLT_PT = (MX == 16'b0) ? 1'b1 : 1'b0;
    assign t_1_QSTDD = STDQQ;
    assign DRQSTDD = m_x & W1;
    assign Z0QSTDD = op_Z0QSTDD;
    assign QSTDD = dev7_STDKZ[1];
    assign PD_Jsz32 = Jsz[5];
// YXZT 信号定义
    wire          Z0Jsz;
    wire          Z0Jz;
    wire          Z0Jcx;
    wire          Z0Jd;
    wire          Z0YX;
    wire          DRJsz;
    wire          DRJz;
    wire          DRJcx;
    wire          DRJd;
    wire          DRYX;
    wire          DRZT;
    wire          NC_Jcx;
    wire          CZzd_Jcx;
    wire          DMkt_Jcx;
    wire          RC_CXD;
    wire          MX_CXD;
    wire          Jsz_CXD;
    wire [15:0]   MXr;
    wire [15:0]   NCSC;
    wire [15:0]   CZzd;
    wire [15:0]   DMkt;
    wire          KTZL;
    wire [7:0]    ZLkt;
    wire          t_1_Jd;
    wire          t_1_YX;
    wire          t_1_QZZT;
    wire          t_1_JZZT;
    wire          t_1_ZXZT;
    wire          t_1_ZDZT;
    wire          t_1_STDZT;
    wire          t_1_KTZT;
    wire          t_1_KTCZZT;
    wire [15:0]   Jz;
    wire          YX;
    wire          QZZT;
    wire          JZZT;
    wire          ZXZT;
    wire          ZDZT;
    wire          STDZT;
    wire          KTZT;
    wire          KTCZZT;
// MCQ 信号定义
    wire          t_1_YCZT;
    wire          W0;
    wire          W1;
    wire          YCZT;
    wire          m_x;
    wire          m_RC;
    wire          m;
    wire          SZMNC;
    wire          SZMDL1;
    wire          SZMDL2;
    wire          SZMXT;
    wire          SZMXL;
    reg     r_MF;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
        r_MF <= 0;
        else if(!DD)
        r_MF <= !r_MF;
        else
        r_MF <= r_MF;
    end
// NC 信号定义             
    wire          Z0NC;                               
    wire          DL1;              
    wire          DL2;              
    wire          XT;               
    wire          XL;               
    wire [15:0]   NCr;     
    wire [15:0]   NCd;                                   
    wire          Cjyc;     
// NC 右侧
    assign CZzd = i_rom_dout;
    assign rom_addr = Jd[4:0];
    assign NCd = Jd;
    assign NCr = Jcx;
// KT 信号定义
    wire          Z0TBtj;            
    wire          Z0DP;              
    wire          Z0DZQ;             
    wire          Z0DZL;             
    wire          Z0LS;              
    wire          Z0KTQQ;                                                    
    wire          ZD;                                                                                                                
    wire          DZL_TJ;
    wire          op_TINJ;                    
    wire          TBtj;              
    wire          DP;                
    wire          DZQ;               
    wire          DZL;               
    wire          LS;               
    wire          KTQQ;              
// RC 信号定义                    
    wire          ZZ0RC;                      
    wire          DRA;                        
    wire          DRB;                        
    wire          DRC;                        
    wire          QAS;                        
    wire          QBS;                        
    wire          QCS;                        
    wire          KZS;                        
    wire          KZC;                        
    wire          KZP;                        
    wire [15:0]   MXcx;                
    wire [5:0]    DMs;                 
    wire          DRZD;                       
    wire          t_1_ZD;                       
    wire          Z0ZD;                       
    wire          DRZDQQ_x;                   
    wire          DRPB;                       
    wire          ZDXW;                       
    wire          t_1_QSTDD;                    
    wire          DRQSTDD;                    
    wire          Z0QSTDD;                                        
    wire          STDR;                       
    wire          STDC;                       
    wire          ZDQQ;                
    wire [1:0]    STDM;                
    wire          STDQQ;  
    wire [1:0]    SBZT;      
// RC 左下侧上
    wire dec_MDV;
    wire dec_SL_BS;
    wire [1:0] dec_SL_JWJZ;
    wire [2:0] dec_SL_GN;
    wire [1:0] dec_SL_Lm;
    wire [1:0] dec_SL_Ly;
    wire dec_SLZL;
    wire dec_FNZL;
    wire dec_RCZL;
    wire dec_SRL;
    wire dec_CZL;
    wire dec_ZHY;
    wire dec_ZHZ;
    wire dec_ZLT_JLT;
    wire dec_YD;
    wire dec_QDZ;
    assign ZL = Jz;
    assign DMs = ZL[5:0];
    assign dec_MDV = DMs[0] & !DMs[1] & !DMs[2] & !DMs[3] & !DMs[4] & !DMs[5];
    assign dec_ZZB = DMs[0] & DMs[1] & DMs[2] & DMs[3] & DMs[4] & DMs[5];
    assign dec_SL_TIAO = ZL[2:0];
    assign dec_SL_BS = ZL[3];
    assign dec_SL_JWJZ = ZL[5:4];
    assign dec_SL_YW = ZL[7:6];
    assign dec_SL_GN = ZL[10:8];
    assign dec_SL_Lm = ZL[12:11];
    assign dec_SL_Ly = ZL[14:13];
    assign dec_SLZL = ZL[15];
    assign dec_SRL = ZL[13] & !ZL[14];
    assign dec_CZL = ZL[14] & !ZL[13];
    assign dec_FNZL = !(ZL[15] | (ZL[13] & ZL[14]));
    assign dec_RCZL = ZL[13] & ZL[14] & !ZL[15];
    assign dec_ZHY = !(ZL[13] | ZL[14] | ZL[12] | ZL[11]);
    assign dec_ZHZ = !(ZL[13] | ZL[14] | ZL[12] | !ZL[11]);
    assign dec_ZLT_JLT = !(ZL[13] | ZL[14] | !ZL[12]);
    assign dec_YD = dec_SL_GN[0] & !dec_SL_GN[1] & dec_SL_GN[2];
    assign dec_QDZ = ZL[15] & !dec_SL_GN[1] & dec_SL_GN[2];
    wire dec_STDC = !(!STDM[0] & STDM[1]); 
    wire dec_STDR = !STDM[0] & STDM[1];
    wire op_STD_Jcx;
    wire op_Jcx_STD;
    assign STDR = op_STD_Jcx;
    assign STDC = op_Jcx_STD & m_RC;
    wire [1:0] t_dec_Mcs;
    assign t_dec_Mcs = op_JdL23_Jz_Q ? dec_FN_L23 : dec_SL_Ly;
    assign L0_Mcs = (t_dec_Mcs == 2'b00) ? 1'b1 : 1'b0;
    assign L1_Mcs = (t_dec_Mcs == 2'b01) ? 1'b1 : 1'b0;
    assign L2_Mcs = (t_dec_Mcs == 2'b10) ? 1'b1 : 1'b0;
    assign L3_Mcs = (t_dec_Mcs == 2'b11) ? 1'b1 : 1'b0;
    wire [1:0] dec_FN_L23;
    wire op_JdL23_Jz_Q;
    assign L0n_Mjg = (dec_SL_Lm == 2'b00) ? 1'b1 : 1'b0;
    assign L1n_Mjg = (dec_SL_Lm == 2'b01) ? 1'b1 : 1'b0;
    assign L2n_Mjg = (dec_SL_Lm == 2'b10) ? 1'b1 : 1'b0;
    assign L3n_Mjg = (dec_SL_Lm == 2'b11) ? 1'b1 : 1'b0;
    wire [1:0] t_dec_MX;
    assign t_dec_MX = dec_SL_YW & {2{op_Lcs_Ljg_Q}};
    assign Q_MX = (t_dec_MX == 2'b00) ? 1'b1 : 1'b0;
    assign Q_Z_MX = (t_dec_MX == 2'b01) ? 1'b1 : 1'b0;
    assign Q_Y_MX = (t_dec_MX == 2'b10) ? 1'b1 : 1'b0;
    assign Q_B_MX = (t_dec_MX == 2'b11) ? 1'b1 : 1'b0;
    wire op_1_JZZT;
    wire op_1_ZXZT;
    wire op_1_KTZT;
    wire op_1_KTCZZT;
    reg [6:0] r_op_1_ZT;
    wire [6:0] t_op_1_ZT;
    assign t_op_1_ZT = {op_1_KTCZZT,op_1_KTZT,op_1_STDZT,op_1_ZDZT,op_1_ZXZT,op_1_JZZT,op_1_QZZT};
    always @(posedge m or negedge rst_n) begin
        if(!rst_n)
        r_op_1_ZT <= 0;
        else
        r_op_1_ZT <= t_op_1_ZT;
    end
    assign t_1_KTCZZT = r_op_1_ZT[6];
    assign t_1_KTZT = r_op_1_ZT[5];
    assign t_1_STDZT = r_op_1_ZT[4];
    assign t_1_ZDZT = r_op_1_ZT[3];
    assign t_1_ZXZT = r_op_1_ZT[2];
    assign t_1_JZZT = r_op_1_ZT[1];
    assign t_1_QZZT = r_op_1_ZT[0];
    reg r_op_DRZT_x;
    wire rst_op_DRZT_x = !rst_n | W0;
    wire t_op_DRZT_x = op_1_KTCZZT | op_1_KTZT | op_1_STDZT | op_1_ZDZT | op_1_ZXZT | op_1_JZZT | op_1_QZZT;
    always @(posedge SZMNC or posedge rst_op_DRZT_x) begin
        if(rst_op_DRZT_x)
        r_op_DRZT_x <= 0;
        else
        r_op_DRZT_x <= t_op_DRZT_x;
    end  
    assign DRZT = !r_op_DRZT_x;
    assign op_1_KTZT = !YX & KTQQ & !KTCZZT;
    assign Z0KTQQ = YX | KTZT;
// RC 左下侧中
    wire op_RC_Jcx;
    wire op_Jcx_RC;
    wire op_Jcx_Cpb;
    wire op_DMs_Jcx;
    wire dec_JIANZHI;
    wire dec_RCC;
    wire dec_RCR;
    wire dec_DKGAN;
    wire dec_ZDXW;
    wire dec_PINB;
    wire dec_RCZQI;
    wire dec_TINJ;
    wire dec_RCTAO;
    wire PD_JIANZHI;
    wire PD_ZDBZ;
    wire op_RCKZ;
    wire op_Z01ZD;
    wire op_Z0ZD;
    assign QAS = op_RC_Jcx & !(dec_SL_GN[2] | dec_SL_GN[1]);
    assign QBS = op_RC_Jcx & dec_SL_GN[1];
    assign QCS = op_RC_Jcx & dec_SL_GN[2];
    assign ZDXW = op_DMs_Jcx;
    assign DRA = m_RC & op_Jcx_RC;
    assign DRB = m_RC & op_Jcx_RC;
    assign DRC = m_RC & op_Jcx_RC;
    assign DRPB = m_RC & op_Jcx_Cpb;
    assign dec_FN_L23 = dec_SL_GN[1:0];
    assign dec_JIANZHI = dec_SL_GN[2];
    assign JzBM = dec_SL_GN[1] | dec_SL_GN[0];
    assign dec_RCC = !dec_SL_GN[0] & (dec_SL_GN[1] | dec_SL_GN[2]);
    assign dec_RCR = dec_SL_GN[0] & !(dec_SL_GN[1] & dec_SL_GN[2]);
    assign dec_DKGAN = dec_SL_GN[0] & !dec_SL_GN[1] & !dec_SL_GN[2];
    assign dec_ZDXW = dec_SL_GN[0] & dec_SL_GN[1] & !dec_SL_GN[2];
    assign dec_PINB = !dec_SL_GN[0] & !dec_SL_GN[1] & dec_SL_GN[2];
    assign dec_RCZQI = dec_SL_GN[0] & !dec_SL_GN[1] & dec_SL_GN[2];
    assign dec_TINJ = !dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2];
    assign dec_RCTAO = dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2];
    assign PD_JIANZHI = Jd[15];
    assign PD_ZDBZ = (Jd[14:4] == 11'd1) ? 1'b1 : 1'b0;
    assign DRZD = !W0;
    assign DRZDQQ_x = m_x;
    assign KZS = op_RCKZ & (dec_SL_YW[0] & !dec_SL_YW[1]);
    assign KZC = op_RCKZ & (!dec_SL_YW[0] & dec_SL_YW[1]);
    assign KZP = op_RCKZ & (dec_SL_YW[0] & dec_SL_YW[1]);
    assign Z0ZD = op_Z0ZD | (op_Z01ZD & (!dec_SL_YW[0] & dec_SL_YW[1]));
    reg r_Z1ZD;
    wire clk_Z1ZD = op_Z01ZD & (dec_SL_YW[0] & !dec_SL_YW[1]);
    wire rst_Z1ZD = ZD | !rst_n;
    always @(posedge clk_Z1ZD or posedge rst_Z1ZD) begin
        if(rst_Z1ZD)
        r_Z1ZD <= 0;
        else
        r_Z1ZD <= 1'b1;
    end
    assign t_1_ZD = r_Z1ZD;
// RC 左下侧下
    wire op_Jsz_JA1_Q;
    wire op_Ljg_Q;
    wire op_Jcx_JJ1_Q;
    wire op_Jcx_Q;
    wire op_Jd_Q;
    wire op_1_Q;
    wire op_Q_Ljg;
    wire op_Q_L3;
    wire op_Jsz_Q;
    wire op_NC_Jcx;
    wire op_Jcx_NC;
    wire op_CZzd_Jcx;
    wire op_ZLkt_Jcx;
    wire op_1_Jd;
    wire op_Jsz_Jcx;
    wire op_DMkt_Jcx;
    wire op_Q_Jcx;
    wire op_Q_Jd;
    wire op_Jsz_Jd;
    wire op_Jcx_Jz;
    wire op_Q_Jsz;
    assign Mcsn_Q = op_Lcs_Ljg_Q & !dec_SL_GN[1];
    assign Mcs_Q = (op_Lcs_Ljg_Q & dec_SL_GN[1] & !(dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2])) | (op_JdL23_Jz_Q & dec_SL_GN[1]);
    assign Mjg_Q = (op_Jcx_JJ1_Q & ((Jcx[3] & JZZT) | (dec_SL_Lm[0] & ZXZT))) | (op_Lcs_Ljg_Q & !(dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2]) & dec_SL_GN[2]) | op_Ljg_Q;
    assign McsMjg_Q = op_Lcs_Ljg_Q & (dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2]);
    assign t_1_Q = (op_Lcs_Ljg_Q & !(dec_SL_GN[0] & dec_SL_GN[1] & dec_SL_GN[2]) & dec_SL_GN[0]) | ((op_Jcx_JJ1_Q) & ((!Jcx[3] & JZZT) | (!dec_SL_Lm[0] & ZXZT))) | (op_Jsz_JA1_Q) | (op_1_Q);
    assign Jd_Q = op_Jd_Q | (op_JdL23_Jz_Q & dec_SL_GN[0] & !dec_SL_GN[1]);
    assign Jcx_Q = op_Jcx_Q | op_Jcx_JJ1_Q;
    assign Jz_Q = op_JdL23_Jz_Q;
    assign JW0 = op_Lcs_Ljg_Q & (dec_SL_JWJZ[1] ^ dec_SL_JWJZ[0]);
    assign JWF = op_Lcs_Ljg_Q & dec_SL_JWJZ[1];
    wire D_DRL0;
    wire D_DRL1;
    wire D_DRL2;
    wire D_DRL3;
    wire D_DRCj;
    reg r_DRL0;
    reg r_DRL1;
    reg r_DRL2;
    reg r_DRL3;
    reg r_DRCj;
    assign D_DRL0 = (op_CHC | (L0n_Mjg & (op_Q_Ljg & !(dec_SL_BS & dec_SLZL))));
    assign D_DRL1 = (op_CHC | (L1n_Mjg & (op_Q_Ljg & !(dec_SL_BS & dec_SLZL))));
    assign D_DRL2 = (L2n_Mjg & (op_Q_Ljg & !(dec_SL_BS & dec_SLZL)));
    assign D_DRL3 = (op_Q_L3 | (L3n_Mjg & (op_Q_Ljg & !(dec_SL_BS & dec_SLZL))));
    assign D_DRCj = (op_CHC | (!dec_SL_BS & op_Q_Ljg & dec_SLZL));
    wire rst_DRL = !rst_n | m_x;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRL0 <= 0;
        else 
        r_DRL0 <= D_DRL0;
    end
    assign DRL0 = r_DRL0;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRL1 <= 0;
        else 
        r_DRL1 <= D_DRL1;
    end
    assign DRL1 = r_DRL1;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRL2 <= 0;
        else 
        r_DRL2 <= D_DRL2;
    end
    assign DRL2 = r_DRL2;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRL3 <= 0;
        else 
        r_DRL3 <= D_DRL3;
    end
    assign DRL3 = r_DRL3;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRCj <= 0;
        else 
        r_DRCj <= D_DRCj;
    end
    assign DRCj = r_DRCj;
    assign Jsz_Q = op_Jsz_Q | op_Jsz_JA1_Q;
    assign DL1 = SZMDL1 & op_NC_Jcx;
    assign DL2 = SZMDL2 & op_NC_Jcx;
    assign XT = SZMXT & op_NC_Jcx;
    assign XL = SZMXL & op_Jcx_NC;
    wire D_DRJcx;
    wire D_DRJz;
    wire D_DRJsz;
    wire D_DRJd;
    reg r_DRJcx;
    reg r_DRJz;
    reg r_DRJsz;
    reg r_DRJd;
    assign D_DRJcx = (((op_DMkt_Jcx | op_ZLkt_Jcx) | op_CZzd_Jcx) | op_Q_Jcx | op_Jsz_Jcx | (op_DMs_Jcx | op_RC_Jcx | op_STD_Jcx) | op_NC_Jcx);
    assign D_DRJz = op_Jcx_Jz;
    assign D_DRJsz = op_Q_Jsz;
    assign D_DRJd = (op_Jsz_Jd | op_Q_Jd | op_RC_Jd | op_1_Jd);
    always @(posedge m or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRJcx <= 0;
        else
        r_DRJcx <= D_DRJcx;
    end
    assign DRJcx = r_DRJcx;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRJz <= 0;
        else
        r_DRJz <= D_DRJz;
    end
    assign DRJz = r_DRJz;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRJsz <= 0;
        else
        r_DRJsz <= D_DRJsz;
    end
    assign DRJsz = r_DRJsz;
    always @(posedge SZMNC or posedge rst_DRL) begin
        if(rst_DRL)
        r_DRJd <= 0;
        else
        r_DRJd <= D_DRJd;
    end
    assign DRJd = r_DRJd;
    assign NC_Jcx = op_NC_Jcx;
    assign Jsz_CXD = !op_RC_Jd & (op_Jsz_Jd | op_Jsz_Jcx);
    assign MX_CXD = !op_RC_Jd & (op_Q_Jd | op_Q_Jcx);
    assign RC_CXD = op_RC_Jd | (op_DMs_Jcx | op_RC_Jcx | op_STD_Jcx);
    assign DMkt_Jcx = op_DMkt_Jcx | op_ZLkt_Jcx;
    assign t_1_Jd = op_1_Jd;
    assign CZzd_Jcx = op_CZzd_Jcx;
    assign KTZL = op_ZLkt_Jcx;
// RC 右下侧
    wire t_W0_op_Jsz_JA1_Q;
    wire t_W0_op_Q_Jsz;
    wire t_W1_op_Jsz_Q;
    wire t_W1_op_DMkt_Jcx;
    wire KTCZZT_YD_W0;

    assign t_W0_op_Jsz_JA1_Q = W0 & !YCZT & QZZT;
    assign t_W0_op_Q_Jsz = t_W0_op_Jsz_JA1_Q;
    assign op_Jcx_Jz = t_W0_op_Jsz_JA1_Q | op_ZLkt_Jcx;
    assign op_Jsz_Q = t_W1_op_Jsz_Q | op_Q_L3;
    assign op_Q_L3 = dec_ZHZ & (dec_FNZL & (W0 & !YCZT & ZXZT));
    assign op_NC_Jcx = (t_W0_op_Jsz_JA1_Q | (W0 & !YCZT & JZZT)) | (dec_STDC & (W0 & !YCZT & STDZT)) | ((dec_ZLT_JLT & (dec_FNZL & (W0 & !YCZT & ZXZT))) | (dec_SRL & (dec_FNZL & (W0 & !YCZT & ZXZT))));
    assign op_RC_Jcx = dec_RCR & !dec_ZZB & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_DMkt_Jcx = t_W1_op_DMkt_Jcx | (dec_ZZB & dec_DKGAN & (dec_RCZL & (W0 & !YCZT & ZXZT)));
    assign op_DMs_Jcx = dec_ZZB & dec_ZDXW & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_Jcx_RC = dec_RCC & !dec_ZZB & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_Jcx_Cpb = dec_PINB & dec_ZZB & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_TINJ = dec_TINJ & dec_ZZB & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_PT = dec_RCTAO & (dec_RCZL & (W0 & !YCZT & ZXZT));
    assign op_CHC = (dec_RCZL & (W0 & !YCZT & ZXZT)) & dec_RCC & dec_MDV;
    assign op_Z0ZD = W0 & !YCZT & ZDZT;
    assign op_Jsz_Jcx = op_Z0ZD;
    assign op_Z0Jz = op_Z0ZD;
    assign op_Z0QSTDD = W0 & !YCZT & STDZT;
    assign op_STD_Jcx = dec_STDR & op_Z0QSTDD;
    assign op_ZLkt_Jcx = W0 & !YCZT & KTZT;
    assign KTCZZT_YD_W0 = dec_YD & (W0 & !YCZT & KTCZZT);
    assign op_CZzd_Jcx = KTCZZT_YD_W0;
    assign op_Q_Jcx = (dec_CZL & (dec_FNZL & (W0 & !YCZT & ZXZT))) | (W0 & YCZT & ZXZT) | (W0 & YCZT & JZZT);
    assign op_Jcx_JJ1_Q = (W0 & YCZT & ZXZT) | (W0 & YCZT & JZZT);
    assign op_Q_Ljg = (dec_SLZL & (W1 & !YCZT & QZZT)) | 
    (((dec_RCZL & (W1 & !YCZT & ZXZT)) & dec_RCR & !dec_ZZB) | ((dec_RCZL & (W1 & !YCZT & ZXZT)) & dec_ZZB & dec_DKGAN) | ((dec_RCZL & (W1 & !YCZT & ZXZT)) & dec_ZZB & dec_ZDXW)) |
    (dec_SRL & (dec_FNZL & (W1 & !YCZT & ZXZT)));
    assign op_Lcs_Ljg_Q = dec_SLZL & (W1 & !YCZT & QZZT);
    assign op_1_YCZT = (PD_ZDBZ & (t_W0_op_Jsz_JA1_Q | (W0 & !YCZT & JZZT))) | (dec_ZLT_JLT & (dec_FNZL & (W0 & !YCZT & ZXZT))) |
    (SLZL_TIAO & op_Lcs_Ljg_Q) | (ZLT_JLT_PT & (dec_ZLT_JLT & (dec_FNZL & (W1 & !YCZT & ZXZT))));
    assign op_GCZ = (!SLZL_TIAO & op_Lcs_Ljg_Q) | ((W1 & !YCZT & JZZT) & !PD_JIANZHI & dec_ZHY) |
    (op_Jd_Q | ((dec_SRL & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (!ZLT_JLT_PT & (dec_ZLT_JLT & (dec_FNZL & (W1 & !YCZT & ZXZT))))) | (dec_CZL & (dec_FNZL & (W1 & !YCZT & ZXZT)))) |
    ((dec_FNZL & (W1 & !YCZT & QZZT)) & !dec_JIANZHI & dec_ZHY) |
    ((t_W1_op_Jsz_Q | op_QD | (PD_Jsz32 & (dec_YD & (W1 & !YCZT & KTCZZT)))) | (op_RCKZ | (W1 & !YCZT & STDZT) | op_Z01ZD)) |
    ((W1 & YCZT & QZZT) | (W1 & YCZT & ZXZT));
    assign op_JdL23_Jz_Q = dec_FNZL & (W1 & !YCZT & QZZT);
    assign op_Ljg_Q = (dec_CZL & (dec_FNZL & (W0 & !YCZT & ZXZT))) | (dec_RCC & dec_RCZL & (W1 & !YCZT & QZZT));
    assign op_1_ZXZT = (op_JdL23_Jz_Q & !dec_JIANZHI & !dec_ZHY) | (!PD_JIANZHI & !dec_ZHY & (W1 & !YCZT & JZZT)) | (dec_RCC & dec_RCZL & (W1 & !YCZT & QZZT));
    assign op_Jcx_Q = op_QD | (W1 & !YCZT & JZZT) | 
    ((!dec_ZZB & dec_RCR & (dec_RCZL & (W1 & !YCZT & ZXZT))) | (dec_ZZB & dec_DKGAN & (dec_RCZL & (W1 & !YCZT & ZXZT))) | (dec_ZZB & dec_ZDXW & (dec_RCZL & (W1 & !YCZT & ZXZT)))) |
    ((dec_ZLT_JLT & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (dec_SRL & (dec_FNZL & (W1 & !YCZT & ZXZT))));
    assign op_1_JZZT = (op_JdL23_Jz_Q & dec_JIANZHI) | op_1_Jd | (PD_JIANZHI & (W1 & !YCZT & JZZT));
    assign op_Jcx_NC = (W1 & !YCZT & JZZT) | (dec_ZLT_JLT & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (dec_YD & (W1 & !YCZT & KTCZZT)) |
    (dec_CZL & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (dec_STDR & (W1 & !YCZT & STDZT));
    assign op_Jd_Q = dec_ZHZ & (dec_FNZL & (W1 & !YCZT & ZXZT));
    assign op_Jsz_Jd = (!SLZL_TIAO & op_Lcs_Ljg_Q) | ((dec_SRL & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (!ZLT_JLT_PT & (dec_ZLT_JLT & (dec_FNZL & (W1 & !YCZT & ZXZT))))) |
    (dec_CZL & (dec_FNZL & (W1 & !YCZT & ZXZT))) | (!PD_Jsz32 & (dec_YD & (W1 & !YCZT & KTCZZT))) |
    (op_RCKZ | op_Z01ZD | (W1 & !YCZT & STDZT));
    assign op_ZZ0RC = (dec_RCZL & (W1 & !YCZT & ZXZT)) & dec_ZZB & dec_RCZQI;
    assign op_1_Q = PT & (dec_RCTAO & (dec_RCZL & (W1 & !YCZT & ZXZT)));
    assign t_W1_op_Jsz_Q = dec_RCTAO & (dec_RCZL & (W1 & !YCZT & ZXZT));
    assign op_RCKZ = (dec_RCZL & (W1 & !YCZT & ZXZT)) & !dec_ZZB & !dec_RCTAO;
    assign op_Z01ZD = (dec_RCZL & (W1 & !YCZT & ZXZT)) & dec_ZZB & !dec_RCTAO;
    assign op_1_Jd = W1 & !YCZT & ZDZT;
    assign op_Jcx_STD = dec_STDC & (W1 & !YCZT & STDZT);
    assign t_W1_op_DMkt_Jcx = W1 & !YCZT & KTZT;
    assign op_QD = dec_QDZ & (W1 & !YCZT & KTZT);
    assign op_Z0Jd = dec_YD & (W1 & !YCZT & KTZT);
    assign op_Z0Jsz = op_Z0Jd;
    assign op_1_KTCZZT = op_Z0Jsz | (!PD_Jsz32 & (dec_YD & (W1 & !YCZT & KTCZZT)));
    assign op_Jsz_JA1_Q = ((W1 & YCZT & QZZT) | (W1 & YCZT & ZXZT)) | KTCZZT_YD_W0 | t_W0_op_Jsz_JA1_Q;
    assign op_Q_Jsz = (op_JdL23_Jz_Q & dec_ZHY) | (dec_ZHY & (W1 & !YCZT & JZZT)) | op_Jd_Q |
    op_QD | ((W1 & YCZT & QZZT) | (W1 & YCZT & ZXZT)) | (dec_RCTAO & (dec_RCZL & (W1 & !YCZT & ZXZT))) | (KTCZZT_YD_W0 | t_W0_op_Q_Jsz);
    assign op_Q_Jd = (op_JdL23_Jz_Q | (dec_RCC & dec_RCZL & (W1 & !YCZT & QZZT))) | (W1 & !YCZT & JZZT) | op_QD |
    (dec_RCTAO & (dec_RCZL & (W1 & !YCZT & ZXZT))) | ((W1 & YCZT & QZZT) | (W1 & YCZT & ZXZT));
// connect
YSQ u_YSQ(
    .rst_n(rst_n),
    .clk_mdv(clk),
    .i_DRL0(DRL0),
    .i_DRL1(DRL1),
    .i_DRL2(DRL2),
    .i_DRL3(DRL3),
    .i_DRCj(DRCj),
    .i_DRJG(DRJG),
    .i_DRCCQ(DRCCQ),
    .i_L0_Mcs(L0_Mcs),
    .i_L1_Mcs(L1_Mcs),
    .i_L2_Mcs(L2_Mcs),
    .i_L3_Mcs(L3_Mcs),
    .i_L0n_Mjg(L0n_Mjg),
    .i_L1n_Mjg(L1n_Mjg),
    .i_L2n_Mjg(L2n_Mjg),
    .i_L3n_Mjg(L3n_Mjg),
    .i_Jd_Q(Jd_Q),
    .i_Jcx_Q(Jcx_Q),
    .i_Mcs_Q(Mcs_Q),
    .i_Mcsn_Q(Mcsn_Q),
    .i_Jd(Jd),
    .i_Jcx(Jcx),
    .i_Jsz_Q(Jsz_Q),
    .i_Jz_Q(Jz_Q),
    .i_McsMjg_Q(McsMjg_Q),
    .i_Mjg_Q(Mjg_Q),
    .i_Jsz(Jsz),
    .i_Jz(JzBM ? {{8{ZL[7]}},ZL[7:0]} : {8'b0,ZL[7:0]}),
    .i_1_Q(t_1_Q),
    .i_JW0(JW0),
    .i_JWF(JWF),
    .i_Q_MX(Q_MX),
    .i_Q_Y_MX(Q_Y_MX),
    .i_Q_Z_MX(Q_Z_MX),
    .i_Q_B_MX(Q_B_MX),
    .i_CHJ(CHJ),
    .i_CCQ(CCQ),
    .o_MX(MX),
    .o_DD(DD),
    .o_Cj(Cj),
    .o_YIC(YIC)
);
YXZT u_YXZT(
    .rst_n(rst_n),
    .i_Z0Jsz(Z0Jsz),
    .i_Z0Jz(Z0Jz),
    .i_Z0Jcx(Z0Jcx),
    .i_Z0Jd(Z0Jd),
    .i_Z0YX(Z0YX),
    .i_DRJsz(DRJsz),
    .i_DRJz(DRJz),
    .i_DRJcx(DRJcx),
    .i_DRJd(DRJd),
    .i_DRYX(DRYX),
    .i_DRZT(DRZT),
    .i_NC_Jcx(NC_Jcx),
    .i_CZzd_Jcx(CZzd_Jcx),
    .i_DMkt_Jcx(DMkt_Jcx),
    .i_RC_CXD(RC_CXD),
    .i_MX_CXD(MX_CXD),
    .i_Jsz_CXD(Jsz_CXD),
    .i_RC(MXr),
    .i_MX(MX),
    .i_NC(NCSC),
    .i_CZzd(CZzd),
    .i_DMkt(KTZL ? {ZLkt,8'b0} : DMkt),
    .i_1_Jd(t_1_Jd),
    .i_1_YX(t_1_YX),
    .i_1_QZZT(t_1_QZZT),
    .i_1_JZZT(t_1_JZZT),
    .i_1_ZXZT(t_1_ZXZT),
    .i_1_ZDZT(t_1_ZDZT),
    .i_1_STDZT(t_1_STDZT),
    .i_1_KTZT(t_1_KTZT),
    .i_1_KTCZZT(t_1_KTCZZT),
    .o_Jsz(Jsz),
    .o_Jz(Jz),
    .o_Jcx(Jcx),
    .o_Jd(Jd),
    .o_YX(YX),
    .o_QZZT(QZZT),
    .o_JZZT(JZZT),
    .o_ZXZT(ZXZT),
    .o_ZDZT(ZDZT),
    .o_STDZT(STDZT),
    .o_KTZT(KTZT),
    .o_KTCZZT(KTCZZT)
);
MCQ u_MCQ(
    .rst_n(rst_n),
    .i_MF(r_MF),
    .i_1_YCZT(t_1_YCZT),
    .o_W0(W0),
    .o_W1(W1),
    .o_YCZT(YCZT),
    .o_m_x(m_x),
    .o_m_RC(m_RC),
    .o_m(m),
    .o_SZMNC(SZMNC),
    .o_SZMDL1(SZMDL1),
    .o_SZMDL2(SZMDL2),
    .o_SZMXT(SZMXT),
    .o_SZMXL(SZMXL),
    .o_SZMJG(SZMJG)
);
NC u_NC(
    .rst_n(rst_n),    
    .i_Z0NC(Z0NC),    
    .i_W1(W1),      
    .i_SZMNC(SZMNC),   
    .i_DL1(DL1),     
    .i_DL2(DL2),     
    .i_XT(XT),      
    .i_XL(XL),      
    .i_NCSR(NCr),    
    .i_NCDZ(NCd),    
    .i_mem_dout(i_mem_dout),
    .i_mem_err(i_mem_err), 
    .o_NCSC(NCSC),    
    .o_Cjyc(Cjyc),    
    .o_mem_addr(mem_addr),
    .o_mem_din(mem_din), 
    .o_mem_we(mem_we),  
    .o_mem_clk(mem_clk) 
);
KT u_KT(
    .rst_n(rst_n),         
    .i_Z0TBtj(Z0TBtj),      
    .i_Z0DP(Z0DP),        
    .i_Z0DZQ(Z0DZQ),       
    .i_Z0DZL(Z0DZL),       
    .i_Z0LS(Z0LS),        
    .i_Z0KTQQ(Z0KTQQ),        
    .i_m_x(m_x),         
    .i_KTZT(KTZT),        
    .i_YX(YX),          
    .i_ZD(ZD),          
    .i_QZZT(QZZT),        
    .i_JZZT(JZZT),        
    .i_ZXZT(ZXZT),        
    .i_Cjyc(Cjyc),        
    .i_Cj(Cj),          
    .i_Jz(Jz),          
    .i_Jd(Jd),          
    .i_Jcx(Jcx),         
    .i_con_QDZ(i_con_QDZ),     
    .i_con_TJ(i_con_TJ | DZL_TJ | op_TINJ),      
    .i_con_LS(i_con_LS),      
    .i_con_YD(i_con_YD),      
    .i_con_DP(1'b0),      
    .i_con_DZQ(1'b0),     
    .i_con_DZL(i_con_DZL),     
    .i_con_CZ(1'b0),      
    .i_con_CZX(1'b0),     
    .i_con_XS(1'b0),      
    .i_con_XSX(1'b0),     
    .i_con_ZRL0(1'b0),    
    .i_con_ZRL1(1'b0),    
    .i_con_ZRL2(1'b0),    
    .i_con_ZRL3(1'b0),    
    .i_con_XSL0(1'b0),    
    .i_con_XSL1(1'b0),    
    .i_con_XSL2(1'b0),    
    .i_con_XSL3(1'b0),    
    .i_con_DM(i_con_DM),      
    .o_TBtj(TBtj),        
    .o_DP(DP),          
    .o_DZQ(DZQ),         
    .o_DZL(DZL),         
    .o_LS(LS),          
    .o_KTQQ(KTQQ),        
    .o_ZLkt(ZLkt),        
    .o_con_YX(con_YX),      
    .o_con_ZD(con_ZD),      
    .o_con_QZZT(con_QZZT),    
    .o_con_JZZT(con_JZZT),    
    .o_con_ZXZT(con_ZXZT),    
    .o_con_Cjyc(con_Cjyc),    
    .o_con_Cj(con_Cj),      
    .o_con_XSZL(con_XSZL),    
    .o_con_XSDZ(con_XSDZ),    
    .o_con_XSSJ(con_XSSJ),    
    .o_DM(DMkt)          
);
RC u_RC(
    .rst_n(rst_n),              
    .i_ZZ0RC(ZZ0RC),            
    .i_DRA(DRA),              
    .i_DRB(DRB),              
    .i_DRC(DRC),              
    .i_QAS(QAS),              
    .i_QBS(QBS),              
    .i_QCS(QCS),              
    .i_KZS(KZS),              
    .i_KZC(KZC),              
    .i_KZP(KZP),              
    .i_MXcx(MXcx),      
    .i_DMs(DMs),       
    .i_DRZD(DRZD),             
    .i_1_ZD(t_1_ZD),             
    .i_Z0ZD(Z0ZD),             
    .i_DRZDQQ_x(DRZDQQ_x),         
    .i_DRPB(DRPB),             
    .i_ZDXW(ZDXW),             
    .i_1_QSTDD(t_1_QSTDD),          
    .i_DRQSTDD(DRQSTDD),          
    .i_Z0QSTDD(Z0QSTDD),                     
    .i_STDR(STDR),             
    .i_STDC(STDC),   
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
    .o_ZDQQ(ZDQQ),          
    .o_STDM(STDM),          
    .o_STDQQ(STDQQ),         
    .o_MXr(MXr), 
    .o_SBZT(SBZT),
    .o_ZD(ZD),          
    .o_dev_SR(dev_SR),        
    .o_dev_ZZ0(dev_ZZ0),       
    .o_dev7_KZ(dev7_KZ),       
    .o_dev7_STDKZ(dev7_STDKZ),    
    .o_dev8_KZ(dev8_KZ),       
    .o_dev9_KZ(dev9_KZ),       
    .o_dev10_KZ(dev10_KZ),      
    .o_dev11_KZ(dev11_KZ),      
    .o_dev12_KZ(dev12_KZ),      
    .o_dev13_KZ(dev13_KZ),      
    .o_dev14_KZ(dev14_KZ),      
    .o_dev15_KZ(dev15_KZ)                
);
endmodule
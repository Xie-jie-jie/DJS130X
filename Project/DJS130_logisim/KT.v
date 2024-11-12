module KT(//
    input  wire            rst_n                  ,                 //复位                                                         
    input  wire            i_Z0TBtj               ,                 //                                         
    input  wire            i_Z0DP                 ,                 //                                             
    input  wire            i_Z0DZQ                ,                 //                                             
    input  wire            i_Z0DZL                ,                 //                                 
    input  wire            i_Z0LS                 ,                 //                                     
    input  wire            i_Z0KTQQ               ,                 //                                         
    input  wire            i_m_x                  ,                 //输入总线                                     
    input  wire            i_KTZT                 ,                 //输入控制台状态                                     
    input  wire            i_YX                   ,                 //输入运行                                     
    input  wire            i_ZD                   ,                 //中断输入                                     
    input  wire            i_QZZT                 ,                 //输入取指状态                                         
    input  wire            i_JZZT                 ,                 //输入间址状态                                     
    input  wire            i_ZXZT                 ,                 //输入执行状态                                         
    input  wire            i_Cjyc                 ,                 //输入校验                                     
    input  wire            i_Cj                   ,                 //输入进位                                     
    input  wire  [15:0]    i_Jz                   ,                 //输入指令寄存器                                             
    input  wire  [15:0]    i_Jd                   ,                 //输入地址寄存器                                             
    input  wire  [15:0]    i_Jcx                  ,                 //输入重写寄存器                                         
    input  wire            i_con_QDZ              ,                 //输入控制台启动指令                                         
    input  wire            i_con_TJ               ,                 //输入停机信号                                         
    input  wire            i_con_LS               ,                 //输入启动信号                                         
    input  wire            i_con_YD               ,                 //输入引导（程序）             
    input  wire            i_con_DP               ,                 //输入单拍                         
    input  wire            i_con_DZQ              ,                 //输入单周期                         
    input  wire            i_con_DZL              ,                 //输入单指令                                                
    input  wire            i_con_CZ               ,                 //存贮                                
    input  wire            i_con_CZX              ,                 //存贮下一条                         
    input  wire            i_con_XS               ,                 //显示                                         
    input  wire            i_con_XSX              ,                 //显示下一条                                        
    input  wire            i_con_ZRL0             ,                 //载入L0                         
    input  wire            i_con_ZRL1             ,                 //载入L1                         
    input  wire            i_con_ZRL2             ,                 //载入L2                         
    input  wire            i_con_ZRL3             ,                 //载入L3                         
    input  wire            i_con_XSL0             ,                 //显示L0                         
    input  wire            i_con_XSL1             ,                 //显示L1                                 
    input  wire            i_con_XSL2             ,                 //显示L2                     
    input  wire            i_con_XSL3             ,                 //显示L3                             
    input  wire  [15:0]    i_con_DM               ,                 //输入代码                                             
    output wire            o_TBtj                 ,                 //同步停机                     
    output wire            o_DP                   ,                 //输出单拍                 
    output wire            o_DZQ                  ,                 //输出单周期                 
    output wire            o_DZL                  ,                 //输出单指令                 
    output wire            o_LS                   ,                 //启动信号                 
    output wire            o_KTQQ                 ,                 //控制台请求信号                 
    output wire  [7:0]     o_ZLkt                 ,                 //控制台指令                        
    output wire            o_con_YX               ,                 //运行状态             
    output wire            o_con_ZD               ,                 //中断                     
    output wire            o_con_QZZT             ,                 //取指状态                              
    output wire            o_con_JZZT             ,                 //间址状态              
    output wire            o_con_ZXZT             ,                 //执行状态                     
    output wire            o_con_Cjyc             ,                 //校验错触发器         
    output wire            o_con_Cj               ,                 //进位                 
    output wire  [7:0]     o_con_XSZL             ,                                      
    output wire  [14:0]    o_con_XSDZ             ,                                      
    output wire  [15:0]    o_con_XSSJ             ,
    output wire  [15:0]    o_DM                                     


);

assign o_con_YX=i_YX;
assign o_con_ZD=i_ZD;
assign o_con_QZZT=i_QZZT;
assign o_con_JZZT=i_JZZT;
assign o_con_ZXZT=i_ZXZT;
assign o_con_Cjyc=i_Cjyc;
assign o_con_Cj=i_Cj;
assign o_con_XSZL=i_Jz[15:8];
assign o_con_XSDZ=i_Jd[14:0];
assign o_con_XSSJ=i_Jcx;
assign o_DM=i_con_DM;

wire t_0=~rst_n|i_YX|i_KTZT;

//r_TBtj
reg r_TBtj;
wire t_rst0=t_0|i_Z0TBtj;
always @(negedge i_m_x or posedge t_rst0) begin
    if (t_rst0)
    r_TBtj<=1'b0;
    else 
    r_TBtj<=i_con_TJ;
end
assign o_TBtj=r_TBtj;

//r_DP
reg r_DP;
wire t_rst1=t_0|i_Z0DP;
always @(negedge i_m_x or posedge t_rst1) begin
    if (t_rst1)
    r_DP<=1'b0;
    else 
    r_DP<=i_con_DP;
end
assign o_DP=r_DP;

//r_DZQ
reg r_DZQ;
wire t_rst2=t_0|i_Z0DZQ;
always @(negedge i_m_x or posedge t_rst2) begin
    if (t_rst2)
    r_DZQ<=1'b0;
    else 
    r_DZQ<=i_con_DZQ;
end
assign o_DZQ=r_DZQ;

//r_DZL
reg r_DZL;
wire t_rst3=t_0|i_Z0DZL;
always @(negedge i_m_x or posedge t_rst3) begin
    if (t_rst3)
    r_DZL<=1'b0;
    else 
    r_DZL<=i_con_DZL;
end
assign o_DZL=r_DZL;

//r_LS
reg r_LS;
wire t_rst4=t_0|i_Z0LS;
always @(negedge i_m_x or posedge t_rst4) begin
    if (t_rst4)
    r_LS<=1'b0;
    else 
    r_LS<=i_con_LS;
end
assign o_LS=r_LS;

//r_KTQQ
reg r_KTQQ;
wire t_d0=(i_con_YD|i_con_XSX|i_con_XS|i_con_CZX)|(i_con_CZ|i_con_QDZ|i_con_XSL3|i_con_XSL2)|(i_con_XSL1|i_con_XSL0|i_con_ZRL3|i_con_ZRL2)|(i_con_ZRL1|i_con_ZRL0);
always @(negedge i_m_x or posedge t_0 ) begin
    if (t_0)
    r_KTQQ<=1'b0;
    else
    r_KTQQ<=t_d0; 
end
assign o_KTQQ=r_KTQQ;

//r_ZLkt
reg [7:0] r_ZLkt;
wire [7:0]t_d1;
assign t_d1[7]=i_con_YD|i_con_XSX|i_con_XS|i_con_CZX|i_con_CZ|i_con_QDZ;
assign t_d1[6]=~(i_con_ZRL3|i_con_ZRL2|i_con_ZRL1|i_con_ZRL0);
assign t_d1[5]=~(i_con_CZX|i_con_CZ);
assign t_d1[4]=~(i_con_XSL1|i_con_XSL0|i_con_ZRL1|i_con_ZRL0);
assign t_d1[3]=~(i_con_XSL2|i_con_XSL0|i_con_ZRL2|i_con_ZRL0);
assign t_d1[2]=~(i_con_XS|i_con_QDZ|i_con_ZRL3|i_con_ZRL2|i_con_ZRL1|i_con_ZRL0);
assign t_d1[1]=~(i_con_YD|i_con_XSX|i_con_XS|i_con_CZX);
assign t_d1[0]=~(i_con_XSX|i_con_XS|i_con_CZX);
always @(posedge i_m_x or negedge rst_n) begin
    if (!rst_n)
    r_ZLkt<=8'd0;
    else if(!r_KTQQ)
    r_ZLkt<=t_d1; 
    else
    r_ZLkt<=r_ZLkt;
end
assign o_ZLkt=r_ZLkt;

endmodule
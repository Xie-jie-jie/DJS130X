module RC(
    input  wire rst_n,                                                                                                   
    input  wire i_ZZ0RC,                                                                           
    input  wire i_DRA,                       //打入寄存器A                                                                            
    input  wire i_DRB,                       //打入寄存器B                                                                                
    input  wire i_DRC,                       //打入寄存器C                                                    
    input  wire i_QAS,                       //取寄存器A数据                                                 
    input  wire i_QBS,                       //取寄存器B数据                                                 
    input  wire i_QCS,                       //取寄存器C数据                                                 
    input  wire i_KZS,                       //控制启动                                                 
    input  wire i_KZC,                       //控制清除                                                    
    input  wire i_KZP,                                                                           
    input  wire [15:0] i_MXcx,               //输出总线重写                                                                               
    input  wire [5:0]  i_DMs,                //输入设备代码                                                                        
    input  wire i_DRZD,                      //打入中断                                         
    input  wire i_1_ZD,                      //中断输入                                                                  
    input  wire i_Z0ZD,                                                                                    
    input  wire i_DRZDQQ_x,                  //打入中断请求                                                                      
    input  wire i_DRPB,                      //打入屏蔽                                                                  
    input  wire i_ZDXW,                      //输入中断询问                                                                  
    input  wire i_1_QSTDD,                   //取数据通道地址                                                                 
    input  wire i_DRQSTDD,                   //打入取数据通道                                                                     
    input  wire i_Z0QSTDD,                                                                                                                       
    input  wire i_STDR,                       //数据通道输入                                                    
    input  wire i_STDC,                       //数据通道输出                                                            
    input  wire [5:0]  i_dev7_DMs,            //输入设备7代码数                                                               
    input  wire [15:0] i_dev7_SC,             //输入设备7输出                                                         
    input  wire        i_dev7_ZDQQ,           //输入设备7中断请求                                   
    input  wire [1:0]  i_dev7_STDM,           //输入设备7数据通道操作码                                                                            
    input  wire        i_dev7_STDQQ,          //输入设备7数据通道请求                                                                                         
    input  wire [5:0]  i_dev8_DMs,            //输入设备8代码数                                                  
    input  wire [15:0] i_dev8_SC,             //输入设备8输出                       
    input  wire        i_dev8_ZDQQ,           //输入设备8中断请求     
    input  wire [5:0]  i_dev9_DMs,            //输入设备9代码数                         
    input  wire [15:0] i_dev9_SC,             //输入设备9输出                                                 
    input  wire        i_dev9_ZDQQ,           //输入设备9中断请求                                                   
    input  wire [5:0]  i_dev10_DMs,           //输入设备10代码数                  
    input  wire [15:0] i_dev10_SC,            //输入设备10输出                                                          
    input  wire        i_dev10_ZDQQ,          //输入设备10中断请求                                                                    
    input  wire [5:0]  i_dev11_DMs,           //输入设备11代码数                                             
    input  wire [15:0] i_dev11_SC,            //输入设备11输出                              
    input  wire        i_dev11_ZDQQ,          //输入设备11中断请求                     
    input  wire [5:0]  i_dev12_DMs,           //输入设备12代码数                             
    input  wire [15:0] i_dev12_SC,            //输入设备12输出                                          
    input  wire        i_dev12_ZDQQ,          //输入设备12中断请求                                
    input  wire [5:0]  i_dev13_DMs,           //输入设备13代码数                      
    input  wire [15:0] i_dev13_SC,            //输入设备13输出                                  
    input  wire        i_dev13_ZDQQ,          //输入设备13中断请求                                    
    input  wire [5:0]  i_dev14_DMs,           //输入设备14代码数                                         
    input  wire [15:0] i_dev14_SC,            //输入设备14输出                                      
    input  wire        i_dev14_ZDQQ,          //输入设备14中断请求                                    
    input  wire [5:0]  i_dev15_DMs,           //输入设备15代码数                                         
    input  wire [15:0] i_dev15_SC,            //输入设备15输出                                                  
    input  wire        i_dev15_ZDQQ,          //输入设备15中断请求

    input  wire [1:0]  i_dev7_ZT,             //输入设备7状态
    input  wire [1:0]  i_dev8_ZT,             //输入设备8状态
    input  wire [1:0]  i_dev9_ZT,             //输入设备9状态
    input  wire [1:0]  i_dev10_ZT,            //输入设备10状态            
    input  wire [1:0]  i_dev11_ZT,            //输入设备11状态
    input  wire [1:0]  i_dev12_ZT,            //输入设备12状态
    input  wire [1:0]  i_dev13_ZT,            //输入设备13状态
    input  wire [1:0]  i_dev14_ZT,            //输入设备14状态
    input  wire [1:0]  i_dev15_ZT,            //输入设备15状态



    output wire        o_ZDQQ,                //输出中断请求                              
    output wire [1:0]  o_STDM,                //输出数据通道操作码                    
    output wire        o_STDQQ,               //输出数据通道请求                               
    output wire [15:0] o_MXr,                 
    output wire [1:0]  o_SBZT,                //输出设备状态
    output wire        o_ZD,                  //输出中断
    output wire [15:0] o_dev_SR,              //输出                                    
    output wire        o_dev_ZZ0,                                                  
    output wire [8:0]  o_dev7_KZ,             //输出设备7控制信号                                         
    output wire [3:0]  o_dev7_STDKZ,          //输出设备7数据通道控制信号                                        
    output wire [8:0]  o_dev8_KZ,             //输出设备8控制信号                                 
    output wire [8:0]  o_dev9_KZ,             //输出设备9控制信号                                 
    output wire [8:0]  o_dev10_KZ,            //输出设备10控制信号                                  
    output wire [8:0]  o_dev11_KZ,            //输出设备11控制信号                              
    output wire [8:0]  o_dev12_KZ,            //输出设备12控制信号
    output wire [8:0]  o_dev13_KZ,            //输出设备13控制信号
    output wire [8:0]  o_dev14_KZ,            //输出设备14控制信号   
    output wire [8:0]  o_dev15_KZ             //输出设备15控制信号          
); 

wire dev7_XZ= (i_DMs==i_dev7_DMs)?1'b1:1'b0;
wire dev8_XZ= (i_DMs==i_dev8_DMs)?1'b1:1'b0;
wire dev9_XZ= (i_DMs==i_dev9_DMs)?1'b1:1'b0;
wire dev10_XZ=(i_DMs==i_dev10_DMs)?1'b1:1'b0;
wire dev11_XZ=(i_DMs==i_dev11_DMs)?1'b1:1'b0;
wire dev12_XZ=(i_DMs==i_dev12_DMs)?1'b1:1'b0;
wire dev13_XZ=(i_DMs==i_dev13_DMs)?1'b1:1'b0;
wire dev14_XZ=(i_DMs==i_dev14_DMs)?1'b1:1'b0;
wire dev15_XZ=(i_DMs==i_dev15_DMs)?1'b1:1'b0;

wire dev7_DRA=i_DRA&dev7_XZ;
wire dev7_DRB=i_DRB&dev7_XZ;
wire dev7_DRC=i_DRC&dev7_XZ;
wire dev7_QAS=i_QAS&dev7_XZ;
wire dev7_QBS=i_QBS&dev7_XZ;
wire dev7_QCS=i_QCS&dev7_XZ;
wire dev7_KZS=i_KZS&dev7_XZ;
wire dev7_KZC=i_KZC&dev7_XZ;
wire dev7_KZP=i_KZP&dev7_XZ;

wire dev8_DRA=i_DRA&dev8_XZ;
wire dev8_DRB=i_DRB&dev8_XZ;
wire dev8_DRC=i_DRC&dev8_XZ;
wire dev8_QAS=i_QAS&dev8_XZ;
wire dev8_QBS=i_QBS&dev8_XZ;
wire dev8_QCS=i_QCS&dev8_XZ;
wire dev8_KZS=i_KZS&dev8_XZ;
wire dev8_KZC=i_KZC&dev8_XZ;
wire dev8_KZP=i_KZP&dev8_XZ;

wire dev9_DRA=i_DRA&dev9_XZ;
wire dev9_DRB=i_DRB&dev9_XZ;
wire dev9_DRC=i_DRC&dev9_XZ;
wire dev9_QAS=i_QAS&dev9_XZ;
wire dev9_QBS=i_QBS&dev9_XZ;
wire dev9_QCS=i_QCS&dev9_XZ;
wire dev9_KZS=i_KZS&dev9_XZ;
wire dev9_KZC=i_KZC&dev9_XZ;
wire dev9_KZP=i_KZP&dev9_XZ;

wire dev10_DRA=i_DRA&dev10_XZ;
wire dev10_DRB=i_DRB&dev10_XZ;
wire dev10_DRC=i_DRC&dev10_XZ;
wire dev10_QAS=i_QAS&dev10_XZ;
wire dev10_QBS=i_QBS&dev10_XZ;
wire dev10_QCS=i_QCS&dev10_XZ;
wire dev10_KZS=i_KZS&dev10_XZ;
wire dev10_KZC=i_KZC&dev10_XZ;
wire dev10_KZP=i_KZP&dev10_XZ;

wire dev11_DRA=i_DRA&dev11_XZ;
wire dev11_DRB=i_DRB&dev11_XZ;
wire dev11_DRC=i_DRC&dev11_XZ;
wire dev11_QAS=i_QAS&dev11_XZ;
wire dev11_QBS=i_QBS&dev11_XZ;
wire dev11_QCS=i_QCS&dev11_XZ;
wire dev11_KZS=i_KZS&dev11_XZ;
wire dev11_KZC=i_KZC&dev11_XZ;
wire dev11_KZP=i_KZP&dev11_XZ;

wire dev12_DRA=i_DRA&dev12_XZ;
wire dev12_DRB=i_DRB&dev12_XZ;
wire dev12_DRC=i_DRC&dev12_XZ;
wire dev12_QAS=i_QAS&dev12_XZ;
wire dev12_QBS=i_QBS&dev12_XZ;
wire dev12_QCS=i_QCS&dev12_XZ;
wire dev12_KZS=i_KZS&dev12_XZ;
wire dev12_KZC=i_KZC&dev12_XZ;
wire dev12_KZP=i_KZP&dev12_XZ;

wire dev13_DRA=i_DRA&dev13_XZ;
wire dev13_DRB=i_DRB&dev13_XZ;
wire dev13_DRC=i_DRC&dev13_XZ;
wire dev13_QAS=i_QAS&dev13_XZ;
wire dev13_QBS=i_QBS&dev13_XZ;
wire dev13_QCS=i_QCS&dev13_XZ;
wire dev13_KZS=i_KZS&dev13_XZ;
wire dev13_KZC=i_KZC&dev13_XZ;
wire dev13_KZP=i_KZP&dev13_XZ;

wire dev14_DRA=i_DRA&dev14_XZ;
wire dev14_DRB=i_DRB&dev14_XZ;
wire dev14_DRC=i_DRC&dev14_XZ;
wire dev14_QAS=i_QAS&dev14_XZ;
wire dev14_QBS=i_QBS&dev14_XZ;
wire dev14_QCS=i_QCS&dev14_XZ;
wire dev14_KZS=i_KZS&dev14_XZ;
wire dev14_KZC=i_KZC&dev14_XZ;
wire dev14_KZP=i_KZP&dev14_XZ;

wire dev15_DRA=i_DRA&dev15_XZ;
wire dev15_DRB=i_DRB&dev15_XZ;
wire dev15_DRC=i_DRC&dev15_XZ;
wire dev15_QAS=i_QAS&dev15_XZ;
wire dev15_QBS=i_QBS&dev15_XZ;
wire dev15_QCS=i_QCS&dev15_XZ;
wire dev15_KZS=i_KZS&dev15_XZ;
wire dev15_KZC=i_KZC&dev15_XZ;
wire dev15_KZP=i_KZP&dev15_XZ;

assign o_dev7_KZ[0]=dev7_DRA; 
assign o_dev7_KZ[1]=dev7_DRB;
assign o_dev7_KZ[2]=dev7_DRC;
assign o_dev7_KZ[3]=dev7_QAS;
assign o_dev7_KZ[4]=dev7_QBS;
assign o_dev7_KZ[5]=dev7_QCS;
assign o_dev7_KZ[6]=dev7_KZS;
assign o_dev7_KZ[7]=dev7_KZC;
assign o_dev7_KZ[8]=dev7_KZP;

assign o_dev8_KZ[0]=dev8_DRA;
assign o_dev8_KZ[1]=dev8_DRB;
assign o_dev8_KZ[2]=dev8_DRC;
assign o_dev8_KZ[3]=dev8_QAS;
assign o_dev8_KZ[4]=dev8_QBS;
assign o_dev8_KZ[5]=dev8_QCS;
assign o_dev8_KZ[6]=dev8_KZS;
assign o_dev8_KZ[7]=dev8_KZC;
assign o_dev8_KZ[8]=dev8_KZP;

assign o_dev9_KZ[0]=dev9_DRA;
assign o_dev9_KZ[1]=dev9_DRB;
assign o_dev9_KZ[2]=dev9_DRC;
assign o_dev9_KZ[3]=dev9_QAS;
assign o_dev9_KZ[4]=dev9_QBS;
assign o_dev9_KZ[5]=dev9_QCS;
assign o_dev9_KZ[6]=dev9_KZS;
assign o_dev9_KZ[7]=dev9_KZC;
assign o_dev9_KZ[8]=dev9_KZP;

assign o_dev10_KZ[0]=dev10_DRA;
assign o_dev10_KZ[1]=dev10_DRB;
assign o_dev10_KZ[2]=dev10_DRC;
assign o_dev10_KZ[3]=dev10_QAS;
assign o_dev10_KZ[4]=dev10_QBS;
assign o_dev10_KZ[5]=dev10_QCS;
assign o_dev10_KZ[6]=dev10_KZS;
assign o_dev10_KZ[7]=dev10_KZC;
assign o_dev10_KZ[8]=dev10_KZP;

assign o_dev11_KZ[0]=dev11_DRA;
assign o_dev11_KZ[1]=dev11_DRB;
assign o_dev11_KZ[2]=dev11_DRC;
assign o_dev11_KZ[3]=dev11_QAS;
assign o_dev11_KZ[4]=dev11_QBS;
assign o_dev11_KZ[5]=dev11_QCS;
assign o_dev11_KZ[6]=dev11_KZS;
assign o_dev11_KZ[7]=dev11_KZC;
assign o_dev11_KZ[8]=dev11_KZP;

assign o_dev12_KZ[0]=dev12_DRA;
assign o_dev12_KZ[1]=dev12_DRB;
assign o_dev12_KZ[2]=dev12_DRC;
assign o_dev12_KZ[3]=dev12_QAS;
assign o_dev12_KZ[4]=dev12_QBS;
assign o_dev12_KZ[5]=dev12_QCS;
assign o_dev12_KZ[6]=dev12_KZS;
assign o_dev12_KZ[7]=dev12_KZC;
assign o_dev12_KZ[8]=dev12_KZP;

assign o_dev13_KZ[0]=dev13_DRA;
assign o_dev13_KZ[1]=dev13_DRB;
assign o_dev13_KZ[2]=dev13_DRC;
assign o_dev13_KZ[3]=dev13_QAS;
assign o_dev13_KZ[4]=dev13_QBS;
assign o_dev13_KZ[5]=dev13_QCS;
assign o_dev13_KZ[6]=dev13_KZS;
assign o_dev13_KZ[7]=dev13_KZC;
assign o_dev13_KZ[8]=dev13_KZP;

assign o_dev14_KZ[0]=dev14_DRA;
assign o_dev14_KZ[1]=dev14_DRB;
assign o_dev14_KZ[2]=dev14_DRC;
assign o_dev14_KZ[3]=dev14_QAS;
assign o_dev14_KZ[4]=dev14_QBS;
assign o_dev14_KZ[5]=dev14_QCS;
assign o_dev14_KZ[6]=dev14_KZS;
assign o_dev14_KZ[7]=dev14_KZC;
assign o_dev14_KZ[8]=dev14_KZP;

assign o_dev15_KZ[0]=dev15_DRA;
assign o_dev15_KZ[1]=dev15_DRB;
assign o_dev15_KZ[2]=dev15_DRC;
assign o_dev15_KZ[3]=dev15_QAS;
assign o_dev15_KZ[4]=dev15_QBS;
assign o_dev15_KZ[5]=dev15_QCS;
assign o_dev15_KZ[6]=dev15_KZS;
assign o_dev15_KZ[7]=dev15_KZC;
assign o_dev15_KZ[8]=dev15_KZP;

//r_QSTDD
reg r_QSTDD;
wire t_rst_QSTDD=~rst_n|i_Z0QSTDD;
always @(posedge i_DRQSTDD or posedge t_rst_QSTDD ) begin
    if (t_rst_QSTDD)
    r_QSTDD<=1'b0;
    else 
    r_QSTDD<=i_1_QSTDD;
end



//r_Cpb
reg [15:0] r_Cpb;
always @(posedge i_DRPB or negedge rst_n ) begin
    if (!rst_n)
    r_Cpb<=16'd0;
    else 
    r_Cpb<=i_MXcx;
end

wire [8:0] dev_ZDY;
assign dev_ZDY[0]=i_dev7_ZDQQ&(~r_Cpb[7]);
assign dev_ZDY[1]=i_dev8_ZDQQ&(~r_Cpb[8]);
assign dev_ZDY[2]=i_dev9_ZDQQ&(~r_Cpb[9]);
assign dev_ZDY[3]=i_dev10_ZDQQ&(~r_Cpb[10]);
assign dev_ZDY[4]=i_dev11_ZDQQ&(~r_Cpb[11]);
assign dev_ZDY[5]=i_dev12_ZDQQ&(~r_Cpb[12]);
assign dev_ZDY[6]=i_dev13_ZDQQ&(~r_Cpb[13]);
assign dev_ZDY[7]=i_dev14_ZDQQ&(~r_Cpb[14]);
assign dev_ZDY[8]=i_dev15_ZDQQ&(~r_Cpb[15]);

wire dev_ZDQQ=dev_ZDY[0]|dev_ZDY[1]|dev_ZDY[2]|dev_ZDY[3]|dev_ZDY[4]|dev_ZDY[5]|dev_ZDY[6]|dev_ZDY[7]|dev_ZDY[8];

//r_ZD
reg r_ZD;
wire t_rst_ZD=i_Z0ZD|(~rst_n);
always @(posedge i_DRZD or posedge t_rst_ZD ) begin
    if (t_rst_ZD)
    r_ZD<=1'b0;
    else 
    r_ZD<=i_1_ZD;
end
assign o_ZD=r_ZD;

//r_ZDQQ_x
reg r_ZDQQ_x;
wire t_rst_ZDQQ=~(rst_n&r_ZD);
always @(posedge i_DRZDQQ_x or posedge t_rst_ZDQQ ) begin
    if (t_rst_ZDQQ)
    r_ZDQQ_x<=1'b0;
    else
    r_ZDQQ_x<=dev_ZDQQ;
end
assign o_ZDQQ=r_ZDQQ;

//r_ZDQQ
reg r_ZDQQ;
always @(negedge i_DRZDQQ_x or posedge t_rst_ZDQQ ) begin
    if (t_rst_ZDQQ)
    r_ZDQQ<=1'b0;
    else
    r_ZDQQ<=r_ZDQQ_x;
end

//r_ZDY
reg [8:0] r_ZDY;
always @(posedge r_ZDQQ_x or negedge rst_n ) begin
    if (!rst_n)
    r_ZDY<=9'd0;
    else
    r_ZDY<=dev_ZDY;
end

wire dev7_QSTDD  =r_QSTDD;
wire dev7_YIC    =1'b0;
wire dev7_STDR   =i_STDR;
wire dev7_STDC   =i_STDC;

assign o_STDQQ  =i_dev7_STDQQ;
assign o_STDM   =i_dev7_STDM;
assign o_dev_SR =i_MXcx;
assign o_dev_ZZ0=i_ZZ0RC;

assign o_dev7_STDKZ[0]=dev7_YIC;
assign o_dev7_STDKZ[1]=dev7_QSTDD;
assign o_dev7_STDKZ[2]=dev7_STDR;
assign o_dev7_STDKZ[3]=dev7_STDC;

wire [5:0] t_0={6{r_ZDY[0]}};
wire [5:0] t_1={6{(~r_ZDY[0])&r_ZDY[1]}};
wire [5:0] t_2={6{(~r_ZDY[0])&(~r_ZDY[1])&r_ZDY[2]}};
wire [5:0] t_3={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&r_ZDY[3]}};
wire [5:0] t_4={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&(~r_ZDY[3])&r_ZDY[4]}};
wire [5:0] t_5={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&(~r_ZDY[3])&(~r_ZDY[4])&r_ZDY[5]}};
wire [5:0] t_6={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&(~r_ZDY[3])&(~r_ZDY[4])&(~r_ZDY[5])&r_ZDY[6]}};
wire [5:0] t_7={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&(~r_ZDY[3])&(~r_ZDY[4])&(~r_ZDY[5])&(~r_ZDY[6])&r_ZDY[7]}};
wire [5:0] t_8={6{(~r_ZDY[0])&(~r_ZDY[1])&(~r_ZDY[2])&(~r_ZDY[3])&(~r_ZDY[4])&(~r_ZDY[5])&(~r_ZDY[6])&(~r_ZDY[7])&r_ZDY[8]}};

wire [5:0] ZDDMs=(t_0&i_dev7_DMs)|(t_1&i_dev8_DMs)|(t_2&i_dev9_DMs)|(t_3&i_dev10_DMs)|(t_4&i_dev11_DMs)|(t_5&i_dev12_DMs)|(t_6&i_dev13_DMs)|(t_7&i_dev14_DMs)|(t_8&i_dev15_DMs);

wire t_abc=i_QAS|i_QBS|i_QCS;
wire [15:0] t_m0={16{(t_abc&dev7_XZ)|(r_QSTDD|i_STDR)}};
wire [15:0] t_m1={16{t_abc&dev8_XZ}};
wire [15:0] t_m2={16{t_abc&dev9_XZ}};
wire [15:0] t_m3={16{t_abc&dev10_XZ}};
wire [15:0] t_m4={16{t_abc&dev11_XZ}};
wire [15:0] t_m5={16{t_abc&dev12_XZ}};
wire [15:0] t_m6={16{t_abc&dev13_XZ}};
wire [15:0] t_m7={16{t_abc&dev14_XZ}};
wire [15:0] t_m8={16{t_abc&dev15_XZ}};
wire [15:0] t_m9={16{i_ZDXW}};

assign o_MXr=(t_m0&i_dev7_SC)|(t_m1&i_dev8_SC)|(t_m2&i_dev9_SC)|(t_m3&i_dev10_SC)|(t_m4&i_dev11_SC)|(t_m5&i_dev12_SC)|(t_m6&i_dev13_SC)|(t_m7&i_dev14_SC)|(t_m8&i_dev15_SC)|(t_m9&{{10{1'b0}},ZDDMs});

wire [1:0] t_s7 =i_dev7_ZT&{2{dev7_XZ}};
wire [1:0] t_s8 =i_dev8_ZT&{2{dev8_XZ}};
wire [1:0] t_s9 =i_dev9_ZT&{2{dev9_XZ}};
wire [1:0] t_s10=i_dev10_ZT&{2{dev10_XZ}};
wire [1:0] t_s11=i_dev11_ZT&{2{dev11_XZ}};
wire [1:0] t_s12=i_dev12_ZT&{2{dev12_XZ}};
wire [1:0] t_s13=i_dev13_ZT&{2{dev13_XZ}};
wire [1:0] t_s14=i_dev14_ZT&{2{dev14_XZ}};
wire [1:0] t_s15=i_dev15_ZT&{2{dev15_XZ}};

assign o_SBZT=t_s7|t_s8|t_s9|t_s10|t_s11|t_s12|t_s13|t_s14|t_s15;

endmodule
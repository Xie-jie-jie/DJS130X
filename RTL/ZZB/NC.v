module NC(
    input  wire        rst_n,                        
    input  wire        i_Z0NC       ,                           
    input  wire        i_W1         ,            //输入脉冲    
    input  wire        i_SZMNC      ,            //输入时钟脉内存    
    input  wire        i_DL1        ,                 
    input  wire        i_DL2        ,                 
    input  wire        i_XT         ,            //输入选通信号    
    input  wire        i_XL         ,            //输入写命令信号    
    input  wire [15:0] i_NCSR       ,            //输入内存输入
    input  wire [15:0] i_NCDZ       ,                 
    input  wire [15:0] i_mem_dout   ,                     
    input  wire        i_mem_err    ,                     
    output wire [15:0] o_NCSC       ,                
    output wire        o_Cjyc       ,            //输出校验结果
    output wire [14:0] o_mem_addr   ,            //输出mem地址    
    output wire [15:0] o_mem_din    ,            //输出mem输入      
    output wire        o_mem_we     ,            //输出mem使能         
    output wire        o_mem_clk                 //输出mem_clk 
                

);

wire        Z0NC      =  i_Z0NC    ;
wire        SZMNC     =  i_SZMNC   ;
wire        DL1       =  i_DL1     ;
wire        DL2       =  i_DL2     ;
wire        XT        =  i_XT      ;
wire        XL        =  i_XL      ;
wire        mem_err   =  i_mem_err ;

assign o_NCSC      =  i_mem_dout    ;
assign o_mem_din   =  i_NCSR        ;
assign o_mem_we    =  i_W1          ;
assign o_mem_addr  =  i_NCDZ[14:0]  ;
//r_mem_clk1
reg r_mem_clk1;
wire t_rst1=~rst_n|DL2|Z0NC;
always @(posedge DL1 or posedge  t_rst1) begin
        if (t_rst1) 
        r_mem_clk1 <= 1'b0;
        else
        r_mem_clk1 <= 1'b1;
end

//r_mem_clk2
reg r_mem_clk2;
wire t_rst2=~rst_n|SZMNC|Z0NC;
wire t_clk2=XT|XL;
always @(posedge t_clk2 or posedge t_rst2) begin
        if (t_rst2) 
        r_mem_clk2 <= 1'b0;
        else
        r_mem_clk2 <= 1'b1;
end
assign o_mem_clk=r_mem_clk1|r_mem_clk2;

//r_Cjyc
reg r_Cjyc;
wire t_rst3=~rst_n|Z0NC;
always @(posedge SZMNC or posedge t_rst3) begin
        if (t_rst3) 
        r_Cjyc <= 1'b0;
        else
        r_Cjyc <= mem_err;
end
assign o_Cjyc=r_Cjyc;

endmodule
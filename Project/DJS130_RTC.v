module DJS130_RTC #(
    parameter SPAN_50Hz = 16'd7500,
    parameter SPAN_10Hz = 16'd37500,
    parameter SPAN_100Hz = 16'd3750,
    parameter SPAN_1000Hz = 16'd375,
    parameter DMs = 6'o14
) (
    input wire [8:0]     i_dev_KZ,                          //控制信号（决定输入/输出/打入信号）
    input wire [15:0]    i_dev_SR,                          //输入数据
    input wire           i_dev_ZZ0,                         //总置0
    output wire[5:0]     o_dev_DMs,                         //设备代码                    
    output wire          o_dev_ZDQQ,                        //中断请求
    output wire[1:0]     o_dev_ZT,                          //状态{忙，完成}
    input wire           i_clk                              //输入时钟
);
    wire [15:0] t_SPAN [3:0];                               //计数器计数个数
    assign t_SPAN[0] = SPAN_50Hz;                           
    assign t_SPAN[1] = SPAN_10Hz;
    assign t_SPAN[2] = SPAN_100Hz;
    assign t_SPAN[3] = SPAN_1000Hz;
    reg r_busy;                                            //状态：忙
    reg r_done;                                            //状态：完成
    reg [15:0]  r_tick;                                    //计数器
    reg [1:0]  r_A;                                        
    reg [15:0]  r_B;
    reg [15:0]  r_C;
    wire t_dev_DRA = i_dev_KZ[0];                          //将输入打入寄存器A
    wire t_dev_DRB = i_dev_KZ[1];                          //将输入打入寄存器B
    wire t_dev_DRC = i_dev_KZ[2];                          //将输入打入寄存器C
    wire t_dev_QAS = i_dev_KZ[3];                          //将寄存器A输出
    wire t_dev_QBS = i_dev_KZ[4];                          //将寄存器B输出
    wire t_dev_QCS = i_dev_KZ[5];                          //将寄存器C输出
    wire t_dev_KZS = i_dev_KZ[6];                          //控制启动
    wire t_dev_KZC = i_dev_KZ[7];                          //控制清除
    wire t_dev_KZP = i_dev_KZ[8];                          
    always @(posedge i_clk or posedge i_dev_ZZ0) begin
        if(i_dev_ZZ0)
        r_A <= 0;
        else if(t_dev_DRA == 1)
        r_A <= i_dev_SR[1:0];
        else
        r_A <= r_A;
    end
    wire [15:0] t_cnt = t_SPAN[r_A];
    wire t_busy_clk = (t_dev_KZS & !r_busy) | (t_complete & r_busy) | (t_dev_KZC & r_busy);       //触发busy信号
    wire t_done_clk1 = (t_dev_KZS & r_done) | (t_complete & !r_done) ;                            //触发done信号1
    wire t_done_clk2 = (t_dev_KZC & r_done) | i_dev_ZZ0;                                          //触发done信号2
    always @(posedge t_busy_clk or posedge i_dev_ZZ0) begin
        if(i_dev_ZZ0) begin
            r_busy <= 0;
        end
        else if(r_busy) begin
            r_busy <= 0;
        end
        else begin
            r_busy <= 1;
        end
    end
    always @(posedge t_done_clk1 or posedge t_done_clk2) begin
        if(t_done_clk2) begin
            r_done <= 0;
        end
        else if(r_done) begin
            r_done <= 0;
        end
        else begin
            r_done <= 1;
        end
    end
    wire t_complete = (r_tick == t_cnt) ? 1'b1 : 1'b0;                  //计数至计数器值时完成置一
    always @(posedge i_clk or posedge i_dev_ZZ0) begin  
        if(i_dev_ZZ0 | t_dev_KZC)
        r_tick <= 0;
        else if(r_busy == 1)                                    
        r_tick <= r_tick + 1;                                           //处于忙状态时计数器计数
        else if(t_complete)
        r_tick <= 0;
        else
        r_tick <= r_tick;
    end
    assign o_dev_DMs = DMs;                                            //输出设备代码
    assign o_dev_ZDQQ = r_done;                                        //完成时发出中断请求
    assign o_dev_ZT = {r_done,r_busy};                                 //输出当前状态
endmodule
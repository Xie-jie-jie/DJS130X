    module SPI_read (
        input wire          CS,             //片选信号 为1时选中设备
        input wire          mosi,           //spi信号 主设备输出从设备输入
        input wire          clk,            //输入时钟
        input wire          rst_n,          //为0时复位
        output wire         valid,          //数据有效
        output wire [7:0]   result          //传输结果
    );
        reg [7:0] t_data;               //8位移位寄存器
        reg [7:0] t_result;             //暂存结果
        reg [2:0] count;                //移位计数
        wire we = !count[0] & !count[1] & !count[2];    //写使能：将移位寄存器中结果存至结果寄存器
        assign valid = !we;                             //没有写使能期间均为数据有效
        always @(posedge clk or negedge rst_n) begin    
            if(!rst_n) begin
                count <= 3'b0;
                t_data <= 7'b0;
            end
            else if(!CS) begin
                t_data <= t_data;
            end
            else begin
                if(count < 3'd7) begin                      //count小于7时增计数
                    count <= count+1'b1;
                    t_data[0] <= mosi;
                    t_data[1] <= t_data[0];
                    t_data[2] <= t_data[1];
                    t_data[3] <= t_data[2];
                    t_data[4] <= t_data[3];
                    t_data[5] <= t_data[4];
                    t_data[6] <= t_data[5];
                    t_data[7] <= t_data[6];
                end
                else if(count == 3'd7) begin                //count等于7时置零  写使能置1
                    count <= 3'b0;
                    t_data[0] <= mosi;
                    t_data[1] <= t_data[0];
                    t_data[2] <= t_data[1];
                    t_data[3] <= t_data[2];
                    t_data[4] <= t_data[3];
                    t_data[5] <= t_data[4];
                    t_data[6] <= t_data[5];
                    t_data[7] <= t_data[6];
                end
            end
        end
        always @(negedge clk or negedge rst_n) begin
            if(!rst_n)
            t_result <= 7'b0;
            else if(!CS)
            t_result <= t_result;
            else if(we == 1'b1)
            t_result <= t_data;
        end
        assign result = t_result;
    endmodule
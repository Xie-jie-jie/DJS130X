module shift_left_reg16(
    input   wire [15:0] d     ,
    input   wire        slin  ,
    input   wire        we    ,
    input   wire        sl    ,
    input   wire        clk   ,
    input   wire        rst_n ,
    output  wire [15:0] q

);
reg r_0 ;
reg r_1 ;
reg r_2 ;
reg r_3 ;
reg r_4 ;
reg r_5 ;
reg r_6 ;
reg r_7 ;
reg r_8 ;
reg r_9 ;
reg r_10;
reg r_11;
reg r_12;
reg r_13;
reg r_14;
reg r_15;

wire t_d0=sl?slin:d[0];
wire t_d1=sl?r_0:d[1];
wire t_d2=sl?r_1:d[2];
wire t_d3=sl?r_2:d[3];
wire t_d4=sl?r_3:d[4];
wire t_d5=sl?r_4:d[5];
wire t_d6=sl?r_5:d[6];
wire t_d7=sl?r_6:d[7];
wire t_d8=sl?r_7:d[8];
wire t_d9=sl?r_8:d[9];
wire t_d10=sl?r_9:d[10];
wire t_d11=sl?r_10:d[11];
wire t_d12=sl?r_11:d[12];
wire t_d13=sl?r_12:d[13];
wire t_d14=sl?r_13:d[14];
wire t_d15=sl?r_14:d[15];



//r_0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_0 <= 1'b0;
    else if(we)
        r_0 <= t_d0;
    else
        r_0 <= r_0;
end
assign q[0]=r_0;

//r_1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_1 <= 1'b0;
    else if(we)
        r_1 <= t_d1;
    else
        r_1 <= r_1;
end
assign q[1]=r_1;

//r_2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_2 <= 1'b0;
    else if(we)
        r_2 <= t_d2;
    else
        r_2 <= r_2;
end
assign q[2]=r_2;

//r_3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_3 <= 1'b0;
    else if(we)
        r_3 <= t_d3;
    else
        r_3 <= r_3;
end
assign q[3]=r_3;

//r_4
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_4 <= 1'b0;
    else if(we)
        r_4 <= t_d4;
    else
        r_4 <= r_4;
end
assign q[4]=r_4;

//r_5
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_5 <= 1'b0;
    else if(we)
        r_5 <= t_d5;
    else
        r_5 <= r_5;
end
assign q[5]=r_5;

//r_6
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_6 <= 1'b0;
    else if(we)
        r_6 <= t_d6;
    else
        r_6 <= r_6;
end
assign q[6]=r_6;

//r_7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_7 <= 1'b0;
    else if(we)
        r_7 <= t_d7;
    else
        r_7 <= r_7;
end
assign q[7]=r_7;

//r_8
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_8 <= 1'b0;
    else if(we)
        r_8 <= t_d8;
    else
        r_8 <= r_8;
end
assign q[8]=r_8;

//r_9
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_9 <= 1'b0;
    else if(we)
        r_9 <= t_d9;
    else
        r_9 <= r_9;
end
assign q[9]=r_9;

//r_10
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_10 <= 1'b0;
    else if(we)
        r_10 <= t_d10;
    else
        r_10 <= r_10;
end
assign q[10]=r_10;

//r_11
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_11 <= 1'b0;
    else if(we)
        r_11 <= t_d11;
    else
        r_11 <= r_11;
end
assign q[11]=r_11;

//r_12
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_12 <= 1'b0;
    else if(we)
        r_12 <= t_d12;
    else
        r_12 <= r_12;
end
assign q[12]=r_12;

//r_13
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_13 <= 1'b0;
    else if(we)
        r_13 <= t_d13;
    else
        r_13 <= r_13;
end
assign q[13]=r_13;

//r_14
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_14 <= 1'b0;
    else if(we)
        r_14 <= t_d14;
    else
        r_14 <= r_14;
end
assign q[14]=r_14;

//r_15
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_15 <= 1'b0;
    else if(we)
        r_15 <= t_d15;
    else
        r_15 <= r_15;
end
assign q[15]=r_15;

endmodule
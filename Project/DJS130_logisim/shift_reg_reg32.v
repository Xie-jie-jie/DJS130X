module shift_right_reg32(
    input  wire [31:0] d     ,
    input  wire        srin  ,
    input  wire        we    ,   
    input  wire        sr    ,   
    input  wire        clk   ,   
    input  wire        rst_n ,   
    output wire [31:0] q     
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
reg r_16;
reg r_17;
reg r_18;
reg r_19;
reg r_20;
reg r_21;
reg r_22;
reg r_23;
reg r_24;
reg r_25;
reg r_26;
reg r_27;
reg r_28;
reg r_29;
reg r_30;
reg r_31;

wire t_d0 =sr?r_1 :d[0 ];
wire t_d1 =sr?r_2 :d[1 ];
wire t_d2 =sr?r_3 :d[2 ];
wire t_d3 =sr?r_4 :d[3 ];
wire t_d4 =sr?r_5 :d[4 ];
wire t_d5 =sr?r_6 :d[5 ];
wire t_d6 =sr?r_7 :d[6 ];
wire t_d7 =sr?r_8 :d[7 ];
wire t_d8 =sr?r_9 :d[8 ];
wire t_d9 =sr?r_10:d[9 ];
wire t_d10=sr?r_11:d[10];
wire t_d11=sr?r_12:d[11];
wire t_d12=sr?r_13:d[12];
wire t_d13=sr?r_14:d[13];
wire t_d14=sr?r_15:d[14];
wire t_d15=sr?r_16:d[15];
wire t_d16=sr?r_17:d[16];
wire t_d17=sr?r_18:d[17];
wire t_d18=sr?r_19:d[18];
wire t_d19=sr?r_20:d[19];
wire t_d20=sr?r_21:d[20];
wire t_d21=sr?r_22:d[21];
wire t_d22=sr?r_23:d[22];
wire t_d23=sr?r_24:d[23];
wire t_d24=sr?r_25:d[24];
wire t_d25=sr?r_26:d[25];
wire t_d26=sr?r_27:d[26];
wire t_d27=sr?r_28:d[27];
wire t_d28=sr?r_29:d[28];
wire t_d29=sr?r_30:d[29];
wire t_d30=sr?r_31:d[30];
wire t_d31=sr?srin:d[31];

//r_0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_0 <= 1'b0;
    else if(we)
        r_0 <= t_d0;
    else
        r_0 <= r_0;
end

//r_1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_1 <= 1'b0;
    else if(we)
        r_1 <= t_d1;
    else
        r_1 <= r_1;
end


//r_2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_2 <= 1'b0;
    else if(we)
        r_2 <= t_d2;
    else
        r_2 <= r_2;
end


//r_3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_3 <= 1'b0;
    else if(we)
        r_3 <= t_d3;
    else
        r_3 <= r_3;
end


//r_4
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_4 <= 1'b0;
    else if(we)
        r_4 <= t_d4;
    else
        r_4 <= r_4;
end


//r_5
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_5 <= 1'b0;
    else if(we)
        r_5 <= t_d5;
    else
        r_5 <= r_5;
end


//r_6
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_6 <= 1'b0;
    else if(we)
        r_6 <= t_d6;
    else
        r_6 <= r_6;
end


//r_7
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_7 <= 1'b0;
    else if(we)
        r_7 <= t_d7;
    else
        r_7 <= r_7;
end


//r_8
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_8 <= 1'b0;
    else if(we)
        r_8 <= t_d8;
    else
        r_8 <= r_8;
end


//r_9
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_9 <= 1'b0;
    else if(we)
        r_9 <= t_d9;
    else
        r_9 <= r_9;
end


//r_10
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_10 <= 1'b0;
    else if(we)
        r_10 <= t_d10;
    else
        r_10 <= r_10;
end


//r_11
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_11 <= 1'b0;
    else if(we)
        r_11 <= t_d11;
    else
        r_11 <= r_11;
end


//r_12
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_12 <= 1'b0;
    else if(we)
        r_12 <= t_d12;
    else
        r_12 <= r_12;
end


//r_13
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_13 <= 1'b0;
    else if(we)
        r_13 <= t_d13;
    else
        r_13 <= r_13;
end


//r_14
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_14 <= 1'b0;
    else if(we)
        r_14 <= t_d14;
    else
        r_14 <= r_14;
end


//r_15
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_15 <= 1'b0;
    else if(we)
        r_15 <= t_d15;
    else
        r_15 <= r_15;
end

//r_16
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_16 <= 1'b0;
    else if(we)
        r_16 <= t_d16;
    else
        r_16 <= r_16;
end

//r_17
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_17 <= 1'b0;
    else if(we)
        r_17 <= t_d17;
    else
        r_17 <= r_17;
end

//r_18
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_18 <= 1'b0;
    else if(we)
        r_18 <= t_d18;
    else
        r_18 <= r_18;
end

//r_19
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_19 <= 1'b0;
    else if(we)
        r_19 <= t_d19;
    else
        r_19 <= r_19;
end

//r_20
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_20 <= 1'b0;
    else if(we)
        r_20 <= t_d20;
    else
        r_20 <= r_20;
end

//r_21
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_21 <= 1'b0;
    else if(we)
        r_21 <= t_d21;
    else
        r_21 <= r_21;
end

//r_22
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_22 <= 1'b0;
    else if(we)
        r_22 <= t_d22;
    else
        r_22 <= r_22;
end

//r_23
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_23 <= 1'b0;
    else if(we)
        r_23 <= t_d23;
    else
        r_23 <= r_23;
end

//r_24
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_24 <= 1'b0;
    else if(we)
        r_24 <= t_d24;
    else
        r_24 <= r_24;
end

//r_25
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_25 <= 1'b0;
    else if(we)
        r_25 <= t_d25;
    else
        r_25 <= r_25;
end

//r_26
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_26 <= 1'b0;
    else if(we)
        r_26 <= t_d26;
    else
        r_26 <= r_26;
end

//r_27
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_27 <= 1'b0;
    else if(we)
        r_27 <= t_d27;
    else
        r_27 <= r_27;
end

//r_28
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_28 <= 1'b0;
    else if(we)
        r_28 <= t_d28;
    else
        r_28 <= r_28;
end

//r_29
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_29 <= 1'b0;
    else if(we)
        r_29 <= t_d29;
    else
        r_29 <= r_29;
end

//r_30
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_30 <= 1'b0;
    else if(we)
        r_30 <= t_d30;
    else
        r_30 <= r_30;
end

//r_31
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        r_31 <= 1'b0;
    else if(we)
        r_31 <= t_d31;
    else
        r_31 <= r_31;
end

assign q[0 ]=r_0 ;
assign q[1 ]=r_1 ;
assign q[2 ]=r_2 ;
assign q[3 ]=r_3 ;
assign q[4 ]=r_4 ;
assign q[5 ]=r_5 ;
assign q[6 ]=r_6 ;
assign q[7 ]=r_7 ;
assign q[8 ]=r_8 ;
assign q[9 ]=r_9 ;
assign q[10]=r_10;
assign q[11]=r_11;
assign q[12]=r_12;
assign q[13]=r_13;
assign q[14]=r_14;
assign q[15]=r_15;
assign q[16]=r_16;
assign q[17]=r_17;
assign q[18]=r_18;
assign q[19]=r_19;
assign q[20]=r_20;
assign q[21]=r_21;
assign q[22]=r_22;
assign q[23]=r_23;
assign q[24]=r_24;
assign q[25]=r_25;
assign q[26]=r_26;
assign q[27]=r_27;
assign q[28]=r_28;
assign q[29]=r_29;
assign q[30]=r_30;
assign q[31]=r_31;

endmodule
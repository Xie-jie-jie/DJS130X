module DJS130_TTI
#(
    parameter DMS= 6'o10

)
(
    input  wire [8:0]  i_dev_KZ         ,
    input  wire        i_write          ,
    input  wire [7:0]  i_data           ,
    input  wire        i_ZZ0            ,//RST
    output wire [1:0]  o_dev_ZT         ,//D[0] B[1]
    output wire        o_dev_ZDQQ       ,
    output wire        o_dev_DMS        ,
    output wire [15:0] o_dev_SC             

);

reg [7:0] r_A;
reg       r_busy;
reg       r_done;

wire QAS=i_dev_KZ[3];
wire KZS=i_dev_KZ[6];
wire KZC=i_dev_KZ[7];

wire rst=KZC|i_ZZ0;
wire work=i_write&r_busy;
//r_A
always @(posedge i_write or posedge i_ZZ0 ) begin
    if (i_ZZ0) begin
       r_A<=8'b0;     
    end    
    else if (i_data==8'd8)begin
    r_A<=8'd127;
    end
    else if (i_data==8'd13)begin
    r_A<=8'd10;
    end
    else r_A<=i_data;
end

//r_busy
wire rst_1=(i_write&r_busy)|rst;
always @(posedge KZS or posedge rst_1 ) begin
    if (rst_1) begin
    r_busy<=1'b0;     
    end    
    else begin
    r_busy<=1'b1;
    end 
end

//r_done
always @(posedge work or posedge rst ) begin
    if (rst) begin
    r_done<=1'b0;     
    end    
    else begin
    r_done<=1'b1;
    end 
end

assign o_dev_SC={8'b0,r_A&{8{QAS}}};
assign o_dev_ZT[1]=r_busy;
assign o_dev_ZT[0]=r_done;
assign o_dev_DMS=DMS;
assign o_dev_ZDQQ=r_done;

endmodule
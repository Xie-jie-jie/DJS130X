module TTI_TOP( 
    input  wire QAS                     ,
    input  wire KZS                     ,
    input  wire KZC                     ,
    input  wire i_write                 ,
    input  wire [7:0]  i_data           ,
    input  wire rst_n                   ,
    output wire o_dev_ZDQQ              ,
    output wire [15:0] o_dev_SC,
    output wire [5:0]  o_dev_DMS
);

wire [8:0] t_KZ={1'b0,~KZC,~KZS,2'b0,~QAS,3'b0};

DJS130_TTI u_DJS130_TTI(
.i_dev_KZ    (t_KZ)             ,
.i_write     (~i_write)          ,
.i_data      (i_data)           ,
.i_ZZ0       (~rst_n)           ,
.o_dev_ZT    ()                 ,
.o_dev_ZDQQ  (o_dev_ZDQQ )      ,
.o_dev_DMS   (o_dev_DMS)                 ,
.o_dev_SC    (o_dev_SC)             
);


endmodule

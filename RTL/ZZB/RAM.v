module RAM (
    input wire          test_rst_n,
    input wire [14:0]   mem_test_addr,
    input wire          mem_test_we,
    input wire [15:0]   mem_test_wdata,
    input wire          test_clk,
    output wire[15:0]   mem_test_rdata,
    output wire[15:0]   mem_data16,
    output wire[15:0]   mem_data17,
    output wire[15:0]   mem_data18,
    output wire[15:0]   mem_data19,
    output wire[15:0]   mem_data20
);
    reg [15:0] mem_test_ram [63:0];
    reg [15:0] rdata;
    always @(posedge test_clk or negedge test_rst_n) begin
        if(!test_rst_n) begin
            mem_test_ram[0] <= 16'h380a;
            mem_test_ram[1] <= 16'h8300;
            mem_test_ram[2] <= 16'hab00;
            mem_test_ram[3] <= 16'ha600;
            mem_test_ram[4] <= 16'h9200;
            mem_test_ram[5] <= 16'ha200;
            mem_test_ram[6] <= 16'hca00;
            mem_test_ram[7] <= 16'h5300;
            mem_test_ram[8] <= 16'hfb00;
            mem_test_ram[9] <= 16'h0003;
            mem_test_ram[10] <= 16'h0010;
        end
        else if(mem_test_we)
        mem_test_ram[mem_test_addr] <= mem_test_wdata;
        else if(!mem_test_we)
        rdata <= mem_test_ram[mem_test_addr];
        else
        mem_test_ram[mem_test_addr] <= mem_test_ram[mem_test_addr];
    end
    wire [15:0] mem_data0;
    wire [15:0] mem_data1;
    wire [15:0] mem_data2;
    wire [15:0] mem_data3;
    wire [15:0] mem_data4;
    wire [15:0] mem_data5;
    wire [15:0] mem_data6;
    wire [15:0] mem_data7;
    wire [15:0] mem_data8;
    wire [15:0] mem_data9;
    wire [15:0] mem_data10;

    assign mem_data0 = mem_test_ram[0];
    assign mem_data1 = mem_test_ram[1]; 
    assign mem_data2 = mem_test_ram[2];
    assign mem_data3 = mem_test_ram[3]; 
    assign mem_data4 = mem_test_ram[4];
    assign mem_data5 = mem_test_ram[5]; 
    assign mem_data6 = mem_test_ram[6];
    assign mem_data7 = mem_test_ram[7]; 
    assign mem_data8 = mem_test_ram[8];
    assign mem_data9 = mem_test_ram[9]; 
    assign mem_data10 = mem_test_ram[10];
    assign mem_data16 = mem_test_ram[16];
    assign mem_data17 = mem_test_ram[17];
    assign mem_data18 = mem_test_ram[18];
    assign mem_data19 = mem_test_ram[19];
    assign mem_data20 = mem_test_ram[20];
    assign mem_test_rdata = rdata;
endmodule
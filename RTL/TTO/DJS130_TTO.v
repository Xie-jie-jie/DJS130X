//Author: H.J.Xie

module DJS130_TTO 
#(
    parameter DEV_DMs = 6'o11,
    parameter TTO_COLOR = 8'hff,
    parameter TTO_LINE_MAX = 7'd80,
    parameter TTO_SPACE = 8'd32,
    parameter TTO_Y = 5'd29
)
(
    //DJS130 Device Interface
    input wire          i_dev_ZZ0,
    input wire[8:0]     i_dev_KZ,
    input wire[15:0]    i_dev_SR,
    output wire         o_dev_ZDQQ,
    output wire[1:0]    o_dev_ZT,   //{Done, Busy}
    output wire[5:0]    o_dev_DMs,
    //VRAM Interface
    input wire          i_vram_clk,
    output wire         o_vram_we,
    output wire         o_vram_ce,      //same with we
    output wire[15:0]   o_vram_data,
    output wire[11:0]   o_vram_addr,
    output wire [7:0]   t_A,
    output wire         t_busy,
    output wire         t_done,

    output wire[4:0]    o_vram_yoffset
);

reg r_busy;     //busy state
assign t_busy=r_busy;
reg r_done;     //done state
assign t_done=r_done;

reg[4:0] r_y_offset;    //register y_offset, control GDU Y-axis offset
reg[6:0] r_line_cnt;    //register for counting number of characters in a line
reg[7:0] r_A;        //register A
assign t_A=r_A;
wire t_DRA = i_dev_KZ[0];
wire t_KZS = i_dev_KZ[6];
wire t_KZC = i_dev_KZ[7];
reg r_WANC;
reg r_SHOW;
reg[7:0] r_CHAR;

assign o_dev_ZDQQ = r_done;
assign o_dev_ZT = {r_done, r_busy};
assign o_dev_DMs = DEV_DMs;

wire t_CHAR_BS = (r_A == 8'd8) | (r_A == 8'd25);
wire t_CHAR_LF = (r_A == 8'd10);
wire t_CHAR_NULL = (r_A == 8'd0) | (r_A == 8'd7) | (r_A == 8'd19) | (r_A == 8'd23) | (r_A == 8'd26);
assign o_vram_ce = r_SHOW;
assign o_vram_we = r_SHOW;
assign o_vram_data = {TTO_COLOR, r_CHAR};
assign o_vram_addr = {r_line_cnt, TTO_Y};
assign o_vram_yoffset = r_y_offset;

reg r_LINE_CLEAN;
reg r_LINE_FEED;
reg[3:0] r_STATE;


localparam  STATE_IDLE             = 4'd0; 
localparam  STATE_START_T1         = 4'd1; 
localparam  STATE_START_T2         = 4'd2; 
localparam  STATE_PUTCHAR_START    = 4'd3; 
localparam  STATE_PUTCHAR_T1       = 4'd4; 
localparam  STATE_PUTCHAR_T2       = 4'd5; 
localparam  STATE_PUTCHAR_T3       = 4'd6; 
localparam  STATE_PUTCHAR_DONE     = 4'd7; 
localparam  STATE_LINEFEED_START   = 4'd8; 
localparam  STATE_LINEFEED_DONE    = 4'd9; 
localparam  STATE_LINECLEAN_START  = 4'd10; 
localparam  STATE_LINECLEAN_DONE   = 4'd11; 
localparam  STATE_DONE             = 4'd12; 

//r_A
always @(posedge i_dev_ZZ0 or posedge t_DRA) begin
    if (i_dev_ZZ0) r_A <= 16'b0;
    else if (t_DRA) r_A <= i_dev_SR[7:0];
    else r_A <= r_A;
end

//r_done
wire t_set_done = (t_KZS & r_done) | (r_WANC & !r_done);
wire t_rst_done = i_dev_ZZ0 | (t_KZC & r_done);
always @(posedge t_rst_done or posedge t_set_done) begin
    if (t_rst_done) r_done <= 1'b0;
    else if (r_done) r_done <= 1'b0;
    else r_done <= 1'b1;
end

//r_busy
wire t_busy_clk = (t_KZS & !r_busy) | (t_KZC & r_busy) | (r_WANC & r_busy);
always @(posedge t_busy_clk or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) r_busy <= 1'b0;
    else if (r_busy) r_busy <= 1'b0;
    else r_busy <= 1'b1;
end 
//state machine
always @(posedge i_vram_clk or posedge i_dev_ZZ0) begin
    if (i_dev_ZZ0) begin
        r_STATE <= STATE_IDLE;
        r_line_cnt <= 5'd0;
        r_LINE_CLEAN <= 0;
        r_LINE_FEED <= 0;
        r_SHOW <= 0;
        r_WANC <= 0;
        r_CHAR <= 8'd0;
        r_y_offset <= 5'd0;
    end
    else begin
        case (r_STATE) 
        STATE_IDLE: 
            if ((r_busy == 1) & (r_done == 0)) r_STATE <= STATE_START_T1;
            else begin
                r_STATE <= STATE_IDLE;
                r_WANC <= 0;
            end
        STATE_START_T1: 
            r_STATE <= STATE_START_T2;
        STATE_START_T2:  begin
                if (t_CHAR_NULL) 
                    r_STATE <= STATE_DONE;
                else if (t_CHAR_BS) begin
                    if (r_line_cnt != 0) r_line_cnt = r_line_cnt - 5'd1;
                    r_STATE <= STATE_DONE;
                end
                else if (r_line_cnt == TTO_LINE_MAX) begin
                    r_LINE_CLEAN <= 1;
                    r_STATE <= STATE_LINECLEAN_START;
                end
                else if (t_CHAR_LF) begin
                    r_LINE_FEED <= 1;
                    r_STATE <= STATE_LINEFEED_START;
                end
                else begin
                    r_CHAR <= r_A;
                    r_STATE <= STATE_PUTCHAR_START;
                end
            end
        STATE_LINECLEAN_START: begin
                r_CHAR <= TTO_SPACE;
                r_y_offset <= r_y_offset + 1;
                r_line_cnt <= 5'd0;
                r_STATE <= STATE_PUTCHAR_START;
            end
        STATE_LINEFEED_START: begin
                r_CHAR <= TTO_SPACE;
                r_STATE <= STATE_PUTCHAR_START;
            end    
        STATE_PUTCHAR_START: begin
            r_STATE <= STATE_PUTCHAR_T1;
            r_SHOW <= 1'b1;
        end
        STATE_PUTCHAR_T1: begin
            r_STATE <= STATE_PUTCHAR_T2;
        end
        STATE_PUTCHAR_T2: begin
            r_STATE <= STATE_PUTCHAR_T3;
        end
        STATE_PUTCHAR_T3: begin
            r_STATE <= STATE_PUTCHAR_DONE;
            r_SHOW <= 1'b0;
        end
        STATE_PUTCHAR_DONE: begin
            r_line_cnt <= r_line_cnt + 1;
            if (r_LINE_FEED) 
                r_STATE <= STATE_LINEFEED_DONE;
            else if (r_LINE_CLEAN)
                r_STATE <= STATE_LINECLEAN_DONE;
            else r_STATE <= STATE_DONE; 
        end
        STATE_LINEFEED_DONE: begin
            if (r_line_cnt == TTO_LINE_MAX) begin
                r_LINE_FEED <= 0;
                r_LINE_CLEAN <= 1;
                r_STATE <= STATE_LINECLEAN_START; 
            end
            else r_STATE <= STATE_PUTCHAR_START;
        end
        STATE_LINECLEAN_DONE: begin
            if (r_line_cnt == TTO_LINE_MAX) begin
                r_line_cnt <= 5'd0;
                r_LINE_CLEAN <= 0;
                r_STATE <= STATE_DONE;
            end
            else r_STATE <= STATE_PUTCHAR_START;
        end
        STATE_DONE: begin
            r_STATE <= STATE_IDLE;
            r_WANC <= 1;
        end
        endcase
    end
end

endmodule
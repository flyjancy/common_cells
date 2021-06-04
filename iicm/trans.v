module trans(
    input           clk,
    input           rstn,
    // control signal
    input           trans_start,
    input           trans_chip,
    input           trans_reg,
    input           trans_data,
    input           trans_stop,
    output reg      finish_start,
    output reg      finish_chip,
    output reg      finish_reg,
    output reg      finish_data,
    output reg      finish_stop,
    // input data and iic signal
    input  [7:0]    data_in,
    output          scl,
    output          sda
);

parameter SCL_CNT_BASE = 5'd20;
parameter SDA_CNT_BASE = 4'd9;

wire [8:0] data = {data_in, 1'b0};

// SCL COUNTER
wire scl_cnt_en = trans_chip | trans_reg | trans_data;
reg  [4:0] scl_cnt;
wire [4:0] scl_cnt_nxt = scl_cnt == 5'b0 ? SCL_CNT_BASE : scl_cnt - 1'b1;
always @ (posedge clk) begin
    if (~rstn) scl_cnt <= SCL_CNT_BASE;
    else if (scl_cnt_en) scl_cnt <= scl_cnt_nxt;
end

// SDA COUNTER
wire sda_cnt_en = scl_cnt_en & (~scl);
reg  [3:0] sda_cnt;
wire [3:0] sda_cnt_nxt = sda_cnt == 4'd0 ? SDA_CNT_BASE : sda_cnt - 1'b1;
always @ (posedge clk) begin
    if (~rstn) sda_cnt <= SDA_CNT_BASE;
    else begin
        if (sda_cnt_en) sda_cnt <= sda_cnt_nxt;
    end
end 

// SCL
reg scl_reg;
assign scl = scl_reg;
always @ (posedge clk) begin
    if (~rstn) scl_reg <= 1'b1;
    else if (trans_chip | trans_reg | trans_data) scl_reg <= scl_cnt[0];
    else scl_reg <= 1'b1;
end

// SDA
reg sda_reg;
assign sda = sda_reg;
always @ (posedge clk) begin
    if (~rstn) sda_reg <= 1'b1;
    else begin
        if (trans_start) sda_reg <= 1'b0;
        else if (trans_chip | trans_reg | trans_data) begin
            if (~scl_cnt[0]) sda_reg <= data[sda_cnt];
        end
        else if (trans_stop) begin
            sda_reg <= scl_reg;
        end
    end
end

always @ (posedge clk) begin
    if (~rstn) begin
        finish_chip  <= 1'b0;
        finish_reg   <= 1'b0;
        finish_data  <= 1'b0;
        finish_start <= 1'b0;
        finish_stop  <= 1'b0;
    end
    else begin
        finish_chip  <= trans_chip  & (sda_cnt == 4'd0);
        finish_reg   <= trans_reg   & (sda_cnt == 4'd0);
        finish_data  <= trans_data  & (sda_cnt == 4'd0);
        finish_start <= trans_start & (~sda_reg);
        finish_stop  <= trans_stop  & (sda_reg);
    end
end
 
// assign finish_chip  = trans_chip  & (sda_cnt == 4'd0);
// assign finish_reg   = trans_reg   & (sda_cnt == 4'd0);
// assign finish_data  = trans_data  & (sda_cnt == 4'd0);
// assign finish_start = trans_start & (~sda_reg);
// assign finish_stop  = trans_stop  & (sda_reg);

endmodule
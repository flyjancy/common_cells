module trans_ctrl(
    input            clk,
    input            rstn,
    input            start_sys,
    input            finish_start,
    input            finish_chip,
    input            finish_reg,
    input            finish_data,
    input            finish_stop,
    output reg [1:0] data_sel,
    output           trans_start,
    output           trans_chip,
    output           trans_reg,
    output           trans_data,
    output           trans_stop
);

parameter IDLE     = 6'b000001;
parameter T_START  = 6'b000010;
parameter T_CHIP   = 6'b000100;
parameter T_REG    = 6'b001000;
parameter T_DATA   = 6'b010000;
parameter T_STOP   = 6'b100000;

reg  [5:0] cur_state, nxt_state;

always @ (*) begin
    case(cur_state)
        IDLE:     nxt_state = start_sys    ? T_START : IDLE;
        T_START:  nxt_state = finish_start ? T_CHIP  : T_START;
        T_CHIP:   nxt_state = finish_chip  ? T_REG   : T_CHIP;
        T_REG:    nxt_state = finish_reg   ? T_DATA  : T_REG;
        T_DATA:   nxt_state = finish_data  ? T_STOP  : T_DATA;
        T_STOP:   nxt_state = finish_stop  ? IDLE    : T_STOP;
    endcase
end

always @ (posedge clk) begin
    if (~rstn) cur_state <= IDLE;
    else cur_state <= nxt_state;
end

// DATA MUX
always @ (*) begin
    if (cur_state == T_CHIP)
        data_sel = 2'b00;
    else if (cur_state == T_REG)
        data_sel = 2'b01;
    else if (cur_state == T_DATA)
        data_sel = 2'b10;
    else 
        data_sel = 2'b11;
end

assign trans_start = cur_state[1] & (~finish_start);
assign trans_chip  = cur_state[2] & (~finish_chip);
assign trans_reg   = cur_state[3] & (~finish_reg);
assign trans_data  = cur_state[4] & (~finish_data);
assign trans_stop  = cur_state[5] & (~finish_stop);

endmodule
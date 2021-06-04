module iicm(
    input           clk,
    input           rstn,
    input  [4:0]    v_in,
    input           start_sys,
    output          sda,
    output          scl
);

parameter CHIP_ADDR = 8'hD0;
parameter REG_ADDR  = 8'h00;

// VOLTAGE DECODER
wire [6:0] v_data;
v_dec voltage_decoder(
     .v_in          (v_in)
    ,.d_o           (v_data)
);

// DATA MUX
reg  [7:0] iic_data;
always @ (*) begin
    case(data_sel)
        2'b00:   iic_data = CHIP_ADDR;
        2'b01:   iic_data = REG_ADDR;
        2'b10:   iic_data = {1'b1, v_data};
        default: iic_data = 8'd0; // TODO: 8'b0 or 8'b1?
    endcase
end

// SYSTEM CONTROL
wire [1:0] data_sel;
wire trans_start, trans_chip, trans_reg, trans_data, trans_stop;
wire finish_start, finish_chip, finish_reg, finish_data, finish_stop;
trans_ctrl iic_trans_control(
     .clk           (clk)
    ,.rstn          (rstn)
    ,.start_sys     (start_sys)
    ,.finish_start  (finish_start)
    ,.finish_chip   (finish_chip)
    ,.finish_reg    (finish_reg)
    ,.finish_data   (finish_data)
    ,.finish_stop   (finish_stop)
    ,.data_sel      (data_sel)
    ,.trans_start   (trans_start)
    ,.trans_chip    (trans_chip)
    ,.trans_reg     (trans_reg)
    ,.trans_data    (trans_data)
    ,.trans_stop    (trans_stop)
);

// DATA TRANSFER
trans iic_data_trans(
     .clk           (clk)
    ,.rstn          (rstn)
    ,.trans_start   (trans_start)
    ,.trans_chip    (trans_chip)
    ,.trans_reg     (trans_reg)
    ,.trans_data    (trans_data)
    ,.trans_stop    (trans_stop)
    ,.finish_start  (finish_start)
    ,.finish_chip   (finish_chip)
    ,.finish_reg    (finish_reg)
    ,.finish_data   (finish_data)
    ,.finish_stop   (finish_stop)
    ,.data_in       (iic_data)
    ,.scl           (scl)
    ,.sda           (sda)
);

endmodule
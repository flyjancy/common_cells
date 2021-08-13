// -----------------------------Details----------------------------------- // 
// File        : iicm.v
// Author      : pastglory
// Date        : 20210813
// Version     : 1.1
// Description : iic master(using for MP8864)
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20210812  pastglory   1.0      Initial Release. 
// 20210813  pastglory   1.1      Update Debug Signal
// ----------------------------------------------------------------------- // 

module iicm #(
    parameter CHIP_ADDR = 8'hD0,
    parameter REG_ADDR  = 8'h00
)(
    input           clk,
    input           rstn,
    input  [7:0]    data,
    input           start_sys,
    input           sda_i,
    output reg      sda_o,
    output reg      scl_o,
    output reg      sda_is_out,
    output          finish
);

parameter CNT_MAX   = 12'd500;

// COUNTER
reg  [11:0] cnt;
wire [11:0] cnt_nxt = (cnt == CNT_MAX) ? 12'b0 : cnt + 1'b1;
reg         cnt_en;
reg  [3:0] stage; // start, chip, reg, data, stop(1, 2, 3, 4, 5)
reg  [3:0] stage_nxt;

always @ (posedge clk or negedge rstn) begin
    if (~rstn) cnt_en <= 1'b0;
    else if (stage != 4'd0) cnt_en <= 1'b1;
    else cnt_en <= 1'b0;
end
always @ (posedge clk or negedge rstn) begin
    if (~rstn) cnt <= 12'b0;
    else if (cnt_en) cnt <= cnt_nxt;
end

wire interrupt = cnt == CNT_MAX;

// JUMP STAGE
reg  [7:0] iic_data;
reg        is_ack;
always @ (posedge clk or negedge rstn) begin
    if (~rstn) begin
        stage <= 4'd0;
    end
    else begin
        case(stage)
        0:  begin
            sda_is_out <= 1'b0;
            stage_nxt <= 4'd0;
            if (start_sys) stage <= 4'd1;
        end
        1:  begin
            sda_is_out <= 1'b1;
            if (interrupt) stage <= 4'd2;
        end
        2:  begin
            iic_data <= CHIP_ADDR;
            stage <= 4'd7;
            stage_nxt <= 4'd3;
        end
        3:  begin
            iic_data <= REG_ADDR;
            stage <= 4'd7;
            stage_nxt <= 4'd4;
        end
        4:  begin
            iic_data <= data;
            stage <= 4'd7;
            stage_nxt <= 4'd5;
        end
        5:  begin // STOP
            sda_is_out <= 1'b1;
            if (interrupt) stage <= 4'd6;
        end
        6: begin
            if (interrupt) stage <= 4'd0;
        end
        7, 8, 9, 10, 11, 12, 13, 14: begin
            sda_is_out <= 1'b1;
            if (interrupt) stage <= stage + 1'b1;
        end
        15: begin 
            sda_is_out <= 1'b0; // wait for acknowledge pulled up 
            if (interrupt) begin
                if (~is_ack) 
                    stage <= stage_nxt;
                else stage <= 4'd1;
            end
        end
        default: stage <= 4'd0;
        endcase
    end
end 

// TRANS
always @ (posedge clk) begin
    case(stage)
    0: begin // IDLE
        sda_o <= 1'b1;
        scl_o <= 1'b1;
        is_ack <= 1'b1;
    end
    1: begin // START
        if (cnt == 12'd0) begin
            scl_o <= 1'b1;
            sda_o <= 1'b1;
        end
        else begin
            if (cnt == 12'd200) 
                sda_o <= 1'b0;
            if (cnt == 12'd400)
                scl_o <= 1'b0;
        end
    end
    5: begin
        if (cnt == 12'd0) begin
            sda_o <= 1'b0;
            scl_o <= 1'b0;
        end
        if (cnt == 12'd200)
            scl_o <= 1'b1;
        if (cnt == 12'd400)
            sda_o <= 1'b1;
    end
    6: begin
        scl_o <= 1'b1;
        sda_o <= 1'b1;
    end
    7, 8, 9, 10, 11, 12, 13, 14: begin
        sda_o <= iic_data[14-stage];
        if (cnt == 12'd0)
            scl_o <= 1'b0;
        if (cnt == 12'd200)
            scl_o <= 1'b1;
        if (cnt == 12'd400)
            scl_o <= 1'b0;
    end
    15: begin
        if (cnt == 12'd200)
            is_ack <= sda_i;
        if (cnt == 12'd0)
            scl_o <= 1'b0;
        if (cnt == 12'd100)
            scl_o <= 1'b1;
        if (cnt == 12'd300)
            scl_o <= 1'b0;
    end
    endcase
end

// DBG
assign finish   = stage == 4'd6;

endmodule
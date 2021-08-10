// -----------------------------Details----------------------------------- // 
// File        : uart_rx.v
// Author      : pastglory
// Date        : 20201203
// Version     : 1.0
// Description : uart module for receiving data
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201203  pastglory   1.0      Initial Release. 
// 20210810  pastglory   1.1      Add rx_done
// ----------------------------------------------------------------------- // 

module uart_rx (
    input               clk,            // FPGA clock
    input               clk_uart,       // UART clock
    input               rst_n,          // reset
    input               rxd,            // rx data
    output [7 : 0]      data,           // received data
    output              rx_done         // receive successfully
);

// using shift reg to change status
reg  [31 : 0] shift_reg;
wire [31 : 0] shift_reg_nxt = {rxd, shift_reg[31 : 1]};
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) shift_reg <= 32'hffffffff;
    else        shift_reg <= shift_reg_nxt;
end
// sample 16 times to start
wire start = shift_reg == 32'h0000ffff; 

// counter
reg  cnt_en;
reg  [3 : 0] cnt;
wire [3 : 0] cnt_nxt = cnt + 1'b1;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) cnt_en <= 1'b0;
    else if (start) cnt_en <= 1'b1;
    else if (cnt == 4'h9) cnt_en <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 4'b0;
    else if (cnt == 4'h9) cnt <= 4'b0;
    else if (clk_uart & cnt_en) cnt <= cnt_nxt;
end

// receive data
reg  [7 : 0] data_reg;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) data_reg <= 8'b0;
    else if (cnt_en & clk_uart & (cnt < 4'h9)) data_reg[cnt-1] <= rxd;  
end
assign data = data_reg;

wire rx_done = cnt == 4'h9;

endmodule
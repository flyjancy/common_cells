// -----------------------------Details----------------------------------- // 
// File        : uart_tx.v
// Author      : pastglory
// Date        : 20201210
// Version     : 1.0
// Description : transfor data
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201210  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module uart_tx (
    input           clk,        // fpga clock
    input           clk_uart,   // UART clock
    input           rst_n,      // reset
    input           start,      // start trans
    input  [7 : 0]  data,       // data for trans
    output reg      txd         // tx data
);

reg  [3 : 0] cnt;
wire [3 : 0] cnt_nxt = cnt + 1'b1;
wire finish; // trans stop
reg  en; // enable

// once start, en = 1 until finish
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) en <= 1'b0;
    else if (start & ~en) en <= 1'b1;
    else if (finish) en <= 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) cnt <= 4'b0;
    else if (en) begin
        if (clk_uart) cnt <= cnt_nxt;
        else if (finish) cnt <= 4'b0;
    end
end

wire [9 : 0] data_comb; // combined data
assign data_comb = {1'b1, data, 1'b0}; // {stop_bit, data, start_bit}

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) txd <= 1'b1;
    else if (en) begin
        if (clk_uart && (cnt <= 4'h9)) txd <= data_comb[cnt];
    end
    else txd <= 1'b1;
end

assign finish = cnt == 4'hb;

endmodule
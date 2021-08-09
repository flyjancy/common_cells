// -----------------------------Details----------------------------------- // 
// File        : clkuart_gen.v
// Author      : pastglory
// Date        : 20210809
// Version     : 1.0
// Description : clkuart generate module
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20210809  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module clkuart_gen # (
    parameter   DIV    = 434 // BPS = 50M/434 = 115200    
)(
    input       clk_in,
    input       rst_n,
    output reg  clk_out
);

// DIV is big -> change width of cnt is important
reg  [20 : 0] cnt;
wire [20 : 0] cnt_nxt = (cnt == DIV-1) ? 21'b0 : cnt + 1'b1;

always @ (posedge clk_in or negedge rst_n) begin
    if (~rst_n) cnt <= 21'b0;
    else cnt <= cnt_nxt;
end

always @ (posedge clk_in or negedge rst_n) begin
    if (~rst_n) clk_out <= 1'b0;
    else if (cnt == (DIV >> 1)) clk_out <= 1'b1;
    else clk_out <= 1'b0;
end

endmodule
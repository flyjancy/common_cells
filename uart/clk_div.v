// -----------------------------Details----------------------------------- // 
// File        : clk_div.v
// Author      : pastglory
// Date        : 20201203
// Version     : 1.0
// Description : clock divide
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201203  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module clk_div # (
    parameter   DIV    = 434 // BPS = 50M/434 = 115200    
)(
    input       clk_in,
    input       rst_n,
    output reg  clk_out
);

reg  [12 : 0] cnt;
wire [12 : 0] cnt_nxt = cnt + 1'b1;

always @ (posedge clk_in or negedge rst_n) begin
    if (~rst_n) cnt <= 13'b0;
    else if (cnt < DIV) cnt <= cnt_nxt;
    else cnt <= 13'b0;
end

always @ (posedge clk_in or negedge rst_n) begin
    if (~rst_n) clk_out <= 1'b0;
    else if (cnt == (DIV >> 1)) clk_out <= 1'b1;
    else clk_out <= 1'b0;
end

endmodule
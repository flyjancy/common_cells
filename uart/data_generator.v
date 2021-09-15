// -----------------------------Details----------------------------------- // 
// File        : data_generator.v
// Author      : flyjancy
// Date        : 20201210
// Version     : 1.0
// Description : generate data for uart testing(just a normal counter)
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201210  flyjancy   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module data_generator(
    input           clk,
    input           rst_n,
    input           start, // generate new data
    output [7 : 0]  data   // generated data
);

reg  [7 : 0] data_reg;
wire [7 : 0] data_reg_nxt = data_reg + 1'b1;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) data_reg <= 8'b0;
    else if (start) data_reg <= data_reg_nxt;
end

assign data = data_reg;

endmodule
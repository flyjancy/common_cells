// -----------------------------Details----------------------------------- // 
// File        : gcd.v
// Author      : flyjancy
// Date        : 20210119
// Version     : 1.0
// Description : Calculate gcd(a, b) -> res
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20210119  flyjancy   1.0      Initial Release. 
// ----------------------------------------------------------------------- //

module gcd(
    input           clk,
    input           rst_n,
    input [7:0]     a,
    input [7:0]     b,
    input           start,      // start calculation
    input           res_fetch,  // result fetched
    output          res_rdy,    // result ready
    output [7:0]    res         // result
);

wire [1:0] sel_a;
wire [1:0] sel_b;
wire       beq0;
wire       agtb;
wire       en_a;
wire       en_b;

datapath dp (
     .clk     (clk)
    ,.rst_n   (rst_n)
    ,.a       (a)
    ,.b       (b)
    ,.sel_a   (sel_a)
    ,.sel_b   (sel_b)
    ,.en_a    (en_a)
    ,.en_b    (en_b)
    ,.beq0    (beq0)
    ,.agtb    (agtb)
    ,.res     (res)
);

control ctrl (
     .clk       (clk)
    ,.rst_n     (rst_n)
    ,.agtb      (agtb)
    ,.beq0      (beq0)
    ,.start     (start)
    ,.res_fetch (res_fetch)
    ,.res_rdy   (res_rdy)
    ,.sel_a     (sel_a)
    ,.sel_b     (sel_b)
    ,.en_a      (en_a)
    ,.en_b      (en_b)
);

endmodule 
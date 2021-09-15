// -----------------------------Details----------------------------------- // 
// File        : gcd_datapath.v
// Author      : flyjancy
// Date        : 20210119
// Version     : 1.0
// Description : GCD data path
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20210119  flyjancy   1.0      Initial Release. 
// ----------------------------------------------------------------------- //

module gcd_datapath(
    input         clk,
    input         rst_n,
    input   [7:0] a,
    input   [7:0] b,        
    input   [1:0] sel_a,    // A MUX sel
    input   [1:0] sel_b,    // B MUX sel
    input         en_a,     // DFF enable
    input         en_b,     // DFF enable
    output        beq0,     // if b = 0, beq0 = 1
    output        agtb,     // if a > b, agtb = 1
    output  [7:0] res       // result
);

wire [7:0] ain, bin;
reg  [7:0] areg, breg;

assign ain = (sel_a == 2'b00) ? a         : (
             (sel_a == 2'b01) ? areg-breg : (
             (sel_a == 2'b10) ? breg      : 8'b0));
assign bin = (sel_b == 2'b00) ? b         : (
             (sel_b == 2'b01) ? areg      : (
             (sel_b == 2'b10) ? breg      : 8'b0));

always @ (posedge clk) begin
    if (~rst_n) begin
        areg <= 8'b0;
        breg <= 8'b0;
    end else begin
        if (en_a) 
            areg <= ain;
        if (en_b) 
            breg <= bin;
    end
end

// result output
reg [7:0] res_reg;
always @ (posedge clk) begin
    if (~rst_n)
        res_reg <= 8'b0;
    else
        res_reg <= areg;
end
assign res = res_reg;

// for control
assign agtb = areg >= breg;
assign beq0 = breg == 8'b0;

endmodule
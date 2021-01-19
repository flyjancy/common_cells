// -----------------------------Details----------------------------------- // 
// File        : gcd_control.v
// Author      : pastglory
// Date        : 20210119
// Version     : 1.0
// Description : GCD control unit
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20210119  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- //

module gcd_control(
    input            clk,
    input            rst_n,
    input            agtb,       // if a > b, agtb = 0
    input            beq0,       // if b = 0, beq0 = 1
    input            start,      // start calculation
    input            res_fetch,  // res fetched
    output           res_rdy,    // result ready
    output     [1:0] sel_a,      // A MUX select
    output     [1:0] sel_b,      // B MUX select
    output           en_a,       // A reg enable
    output           en_b        // B reg enable
);

parameter IDLE   = 3'b001;
parameter CALC   = 3'b010;
parameter FINISH = 3'b100;

reg [2:0] cur_state, nxt_state;

always @ (*) begin
    case(cur_state) 
        IDLE   : nxt_state = start     ? CALC   : IDLE;
        CALC   : nxt_state = beq0      ? FINISH : CALC;
        FINISH : nxt_state = res_fetch ? IDLE   : FINISH;
        default: nxt_state = IDLE;
    endcase
end

always @ (posedge clk) begin
    if (~rst_n)
        cur_state <= IDLE;
    else 
        cur_state <= nxt_state;
end

assign res_rdy = cur_state[2];
assign en_a    = cur_state[1] | cur_state[0];
assign en_b    = cur_state[1] | cur_state[0];
assign sel_a   = cur_state[1] ? (agtb ? 2'b01 : 2'b10) : 2'b00;
assign sel_b   = cur_state[1] ? (agtb ? 2'b10 : 2'b01) : 2'b00;

endmodule
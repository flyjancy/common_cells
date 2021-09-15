// -----------------------------Details----------------------------------- // 
// File        : keyboard.v
// Author      : flyjancy
// Date        : 20201210
// Version     : 1.0
// Description : process keyboard input
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201210  flyjancy   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module keyboard(
    input           clk,
    input           rst_n,
    input  [3 : 0]  col, // column input, 1 enable
    output [3 : 0]  key_pulse // if key pushed, output 1
);

reg  [11 : 0] treg0; // tmp reg
reg  [11 : 0] treg1; // tmp reg
reg  [11 : 0] treg2; // tmp reg
reg  [11 : 0] treg3; // tmp reg
wire [11 : 0] treg0_nxt = treg0 + 1'b1; // tmp reg next val
wire [11 : 0] treg1_nxt = treg1 + 1'b1; // tmp reg next val
wire [11 : 0] treg2_nxt = treg2 + 1'b1; // tmp reg next val
wire [11 : 0] treg3_nxt = treg3 + 1'b1; // tmp reg next val

// when tregx = 12'hffe and tregx_nxt = 12'hfff
// key_pulse will be 1
// then, tregx will be 12'hfff
// when tregx == 12'hfff, it will keep until keyboard not pushed
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        treg0 <= 12'b0;
        treg1 <= 12'b0;
        treg2 <= 12'b0;
        treg3 <= 12'b0;
    end
    else begin
        if (col[0]) begin 
            if (treg0 != 12'hfff) // if treg0 == 12'hfff, it will keep until keyboard not pushed
                treg0 <= treg0_nxt;
        end
        else begin
            treg0 <= 12'b0;
        end

        if (col[1]) begin
            if (treg1 != 12'hfff) // if treg1 == 12'hfff, it will keep until keyboard not pushed
                treg1 <= treg1_nxt;
        end
        else begin   
            treg1 <= 12'b0;
        end

        if (col[2]) begin
            if (treg2 != 12'hfff) // if treg2 == 12'hfff, it will keep until keyboard not pushed
                treg2 <= treg2_nxt;
        end
        else begin
            treg2 <= 12'b0;
        end

        if (col[3]) begin
            if (treg3 != 12'hfff) // if treg3 == 12'hfff, it will keep until keyboard not pushed
                treg3 <= treg3_nxt;
        end
        else begin        
            treg3 <= 12'b0;
        end
    end
end

assign key_pulse[3] = (treg3 != 12'hfff) & (treg3_nxt == 12'hfff); 
assign key_pulse[2] = (treg2 != 12'hfff) & (treg2_nxt == 12'hfff);
assign key_pulse[1] = (treg1 != 12'hfff) & (treg1_nxt == 12'hfff);
assign key_pulse[0] = (treg0 != 12'hfff) & (treg0_nxt == 12'hfff);

endmodule
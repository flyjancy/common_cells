//---------------------------------------------------------------
//  Float Point Multiplication Normalization
//  To Normalize the exponent and mantissa of answer
//  2020.1.27
//---------------------------------------------------------------
module float_mul_normal #(
  parameter E = 8,
  parameter M = 23
)(
  input     [E : 0]           ine,
  input     [2 * M + 1 : 0]   inm,
  output    [E - 1 : 0]       oute,
  output    [M - 1 : 0]       outm 
);

wire        [5 : 0]           pos;
assign      pos               =     inm[47] ? 6'd47 : (
                                    inm[46] ? 6'd46 : (
                                    inm[45] ? 6'd45 : (
                                    inm[44] ? 6'd44 : (
                                    inm[43] ? 6'd43 : (
                                    inm[42] ? 6'd42 : (
                                    inm[41] ? 6'd41 : (
                                    inm[40] ? 6'd40 : (
                                    inm[39] ? 6'd39 : (
                                    inm[38] ? 6'd38 : (
                                    inm[37] ? 6'd37 : (
                                    inm[36] ? 6'd36 : (
                                    inm[35] ? 6'd35 : (
                                    inm[34] ? 6'd34 : (
                                    inm[33] ? 6'd33 : (
                                    inm[32] ? 6'd32 : (
                                    inm[31] ? 6'd31 : (
                                    inm[30] ? 6'd30 : (
                                    inm[29] ? 6'd29 : (
                                    inm[28] ? 6'd28 : (
                                    inm[27] ? 6'd27 : (
                                    inm[26] ? 6'd26 : (
                                    inm[25] ? 6'd25 : (
                                    inm[24] ? 6'd24 : (
                                    inm[23] ? 6'd23 : (
                                    inm[22] ? 6'd22 : (
                                    inm[21] ? 6'd21 : (
                                    inm[20] ? 6'd20 : (
                                    inm[19] ? 6'd19 : (
                                    inm[18] ? 6'd18 : (
                                    inm[17] ? 6'd17 : (
                                    inm[16] ? 6'd16 : (
                                    inm[15] ? 6'd15 : (
                                    inm[14] ? 6'd14 : (
                                    inm[13] ? 6'd13 : (
                                    inm[12] ? 6'd12 : (
                                    inm[11] ? 6'd11 : (
                                    inm[10] ? 6'd10 : (
                                    inm[9]  ? 6'd9  : (
                                    inm[8]  ? 6'd8  : (
                                    inm[7]  ? 6'd7  : (
                                    inm[6]  ? 6'd6  : (
                                    inm[5]  ? 6'd5  : (
                                    inm[4]  ? 6'd4  : (
                                    inm[3]  ? 6'd3  : (
                                    inm[2]  ? 6'd2  : (
                                    inm[1]  ? 6'd1  : (
                                    inm[0]  ? 6'd0  : 6'd46 )))))))))))))))))))))))))))))))))))))))))))))));

wire        [5 : 0]           ShiftDelta;
assign      ShiftDelta        =     (pos > 6'd46) ? 1'b1 : 6'd46 - pos;

wire        [E : 0]           pluse, subse;
assign      pluse             =     ine + ShiftDelta;
assign      subse             =     ine - ShiftDelta;

assign      oute              =     (pos > 6'd46) ? pluse[E - 1 : 0] : subse[E - 1 : 0];

wire        [2 * M + 1 : 0]   leftm, rightm;
assign      leftm             =     inm << ShiftDelta;
assign      rightm            =     inm >> ShiftDelta;

assign      outm              =     (pos > 6'd46) ? rightm[2 * M - 1 : M] : leftm[2 * M - 1 : M];

endmodule